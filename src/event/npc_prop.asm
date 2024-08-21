; ------------------------------------------------------------------------------

.include "event/npc_prop.inc"

; ------------------------------------------------------------------------------

.mac set_npc_event addr
        _npc_event_addr := (_event_addr addr)
.endmac

.mac _set_npc_pos x_pos, y_pos
        _npc_pos_x .set x_pos
        _npc_pos_y .set y_pos
.endmac

.mac set_npc_dir dd
        _npc_dir .set EVENT_DIR::dd
.endmac

.mac set_npc_speed ss
        _npc_speed .set OBJ_SPEED::ss
.endmac

.mac set_npc_gfx gfx, pal
        _npc_gfx .set MAP_SPRITE_GFX::gfx
        .ifblank pal
                _npc_pal .set MAP_SPRITE_PAL::gfx << 2
        .else
                _npc_pal .set MAP_SPRITE_PAL::pal << 2
        .endif
.endmac

.mac set_npc_vehicle vehicle, show_rider
        _npc_vehicle .set EVENT_VEHICLE::vehicle
        .ifnblank show_rider
                _npc_show_rider .set EVENT_VEHICLE::show_rider
        .endif
        .if _npc_show_rider .and (_npc_vehicle = 0)
                .error "Invalid NPC vehicle"
        .endif
.endmac

.define set_npc_movement(movement_type) _npc_movement .set NPC_MOVEMENT::movement_type
.define set_npc_layer_priority(priority) _npc_layer_priority .set NPC_LAYER_PRIORITY::priority
.define set_npc_sprite_priority(priority) _npc_sprite_priority .set NPC_SPRITE_PRIORITY::priority
.define set_npc_bg2_scroll _npc_scroll .set NPC_SCROLL::BG2
.define set_npc_no_react _npc_react .set NPC_REACT::NONE

.mac _set_npc_vram_pos x_pos, y_pos
        _npc_vram_addr .set (x_pos | (y_pos << 4))
.endmac

.define set_npc_32x32 _npc_is_32x32 .set $04
.define set_npc_h_flip _npc_h_flip .set $80

.mac set_npc_master master_id, offset, offset_dir
        _npc_is_slave .set 2
        _npc_master_id .set master_id
        _npc_master_offset .set (offset << 5)
        _npc_master_dir .set NPC_MASTER_OFFSET_DIR::offset_dir
.endmac

.mac reset_npc_prop

; common properties for all npcs
        _npc_scroll .set NPC_SCROLL::BG1  ; bit 2.5
        _npc_pal .set 0  ; bit 2.2, 2.3, 2.4
        _npc_switch .set 0  ; bit 2.6, 2.7, byte 3
        _npc_pos_x .set 0  ; bit 4.0 through 4.6
        _npc_pos_y .set 0  ; bit 5.0 through 5.5
        _npc_speed .set OBJ_SPEED::NORMAL  ; bit 5.6, 5.7
        _npc_gfx .set 0  ; byte 6
        _npc_movement .set NPC_MOVEMENT::NONE  ; bit 7.0 through 7.3
        _npc_sprite_priority .set NPC_SPRITE_PRIORITY::NORMAL  ; bit 7.4, 7.5
        _npc_layer_priority .set NPC_LAYER_PRIORITY::DEFAULT  ; bit 8.3, 8.4

; properties for normal npcs
        _npc_show_rider .set EVENT_VEHICLE::NONE  ; bit 4.7
        _npc_vehicle .set EVENT_VEHICLE::NONE  ; bit 7.6, 7.7
        _npc_dir .set EVENT_DIR::DOWN  ; bit 8.0, 8.1
        _npc_react .set NPC_REACT::FACE_PLAYER  ; bit 8.2

; properties for animated npcs
        _npc_anim_type .set NPC_ANIM_TYPE::ONE_FRAME  ; bit 8.0, 8.1
        _npc_anim_frame .set NPC_ANIM_FRAME::DEFAULT  ; bit 8.5, 8.6, 8.7
        _npc_anim_speed .set NPC_ANIM_SPEED::FASTEST  ; bit 7.6, 7.7

; properties for npcs with special graphics
        _npc_vram_addr .set 0  ; bit 0.0 through 0.6
        _npc_h_flip .set 0  ; bit 0.7
        _npc_master_id .set 0  ; bit 1.0 through 1.4
        _npc_master_offset .set 0  ; bit 1.5 through 1.7
        _npc_master_dir .set NPC_MASTER_OFFSET_DIR::RIGHT  ; bit 2.0
        _npc_is_slave .set 0  ; bit 2.1
        _npc_is_special .set 0  ; bit 4.7, 7.6, 7.7
        _npc_is_32x32 .set 0  ; bit 8.2
.endmac

reset_npc_prop

_npc_seq_id .set 0
_npc_in_progress .set 0
.define _npc_event_addr .ident(.sprintf("NPCEvent%d", _npc_seq_id))

.mac make_npc xy_pos, switch_id
        .assert _npc_in_progress = 0, error, "Missing end_npc before make_npc"
        reset_npc_prop
        _npc_seq_id .set _npc_seq_id + 1
        _npc_in_progress .set 1
        _set_npc_pos xy_pos
        .ifnblank switch_id
                .assert switch_id >= $0300, error, "Invalid NPC switch"
                _npc_switch .set switch_id - $0300
        .endif
.endmac

.mac set_npc_anim anim_type, anim_frame, anim_speed
        _npc_anim_type .set NPC_ANIM_TYPE::anim_type
        _npc_anim_frame .set NPC_ANIM_FRAME::anim_frame
        .assert _npc_anim_frame <> 0 || _npc_is_special, error, "Invalid animated NPC frame"
        .ifnblank anim_speed
                .assert _npc_is_special = 0, error, "Invalid animation speed"
                _npc_anim_speed .set NPC_ANIM_SPEED::anim_speed
        .endif
.endmac

.mac make_special_npc xy_pos, switch_id, vram_pos
        .ifnblank(switch_id)
                make_npc {xy_pos}, switch_id
        .else
                make_npc {xy_pos}
        .endif
        _set_npc_vram_pos vram_pos
        _npc_is_special .set 1
.endmac

.mac end_npc
; bytes 0, 1, 2
        .if _npc_is_special
                .byte _npc_vram_addr | _npc_h_flip
                .byte _npc_master_id | _npc_master_offset
                .byte _npc_master_dir | _npc_is_slave | _npc_pal | ((_npc_switch & 3) << 6) | _npc_scroll
        .else
                .ifndef _npc_event_addr
                        _npc_event_addr := (_event_addr EventReturn)
                .endif
                .word .loword(_npc_event_addr)
                .byte ^(_npc_event_addr) | _npc_pal | ((_npc_switch & 3) << 6) | _npc_scroll
        .endif
; byte 3
        .byte (_npc_switch >> 2)
; byte 4
        .if _npc_is_special
                .byte _npc_pos_x | $80
        .else
                .byte _npc_pos_x | (_npc_show_rider & $80)
        .endif
; byte 5
        .byte _npc_pos_y | (_npc_speed << 6)
; byte 6
        .byte _npc_gfx
; byte 7
        .if _npc_is_special
                .byte _npc_sprite_priority | _npc_movement
        .elseif _npc_anim_frame
                .byte _npc_anim_speed | _npc_sprite_priority | _npc_movement
        .else
                .byte ((_npc_vehicle << 1) & $c0) | _npc_sprite_priority | _npc_movement
        .endif
; byte 8
        .if _npc_is_special
                .byte _npc_anim_type | _npc_is_32x32 | _npc_layer_priority | _npc_anim_frame
        .elseif _npc_anim_frame
                .byte _npc_anim_type | _npc_react | _npc_layer_priority | _npc_anim_frame
        .else
                .byte _npc_dir | _npc_react | _npc_layer_priority
        .endif
        _npc_in_progress .set 0
.endmac

; ------------------------------------------------------------------------------

.segment "npc_prop"

; ------------------------------------------------------------------------------

; c4/1a10
NPCPropPtrs:
        fixed_block $50b0
        ptr_tbl NPCProp
        end_ptr NPCProp

; ------------------------------------------------------------------------------

; c4/1d52
NPCProp:

; ------------------------------------------------------------------------------

; no npcs on world maps
NPCProp::_0:
NPCProp::_1:
NPCProp::_2:

; ------------------------------------------------------------------------------

NPCProp::_3:

        make_special_npc {4, 4}, $03a0, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {6, 4}, $03a0, {2, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {4, 6}, $03a0, {0, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {6, 6}, $03a0, {2, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_4:

        make_npc {8, 11}, $043f
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx CLYDE, LOCKE
                end_npc

        make_npc {8, 6}, $0440
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, EDGAR_SABIN_CELES
                end_npc

        make_npc {8, 15}, $0476
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_5:

        make_npc {0, 0}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_6:

        make_npc {14, 4}, $0459
                set_npc_event _caf47b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SETZER
                end_npc

        make_npc {15, 6}, $045c
                set_npc_event _caa6c0
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx BOOK, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_7:

        make_npc {12, 8}, $0456
                set_npc_event _cb2007
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SETZER
                end_npc

        make_npc {13, 10}, $0457
                set_npc_event _cb2029
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx COIN, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {5, 31}, $045a
                set_npc_event _cb2240
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {15, 31}, $045b
                set_npc_event _cb223d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {53, 9}, $0472
                set_npc_event _cb23d8
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {25, 13}, $0473
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {58, 58}, $0477
                set_npc_event _cb42b4
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {56, 56}, $0478
                set_npc_event _cb42cc
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {53, 59}, $0479
                set_npc_event _cb42e4
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx CYAN
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 56}, $047a
                set_npc_event _cb42fc
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHADOW
                end_npc

        make_npc {48, 56}, $047b
                set_npc_event _cb4314
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                end_npc

        make_npc {47, 57}, $047c
                set_npc_event _cb432c
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SABIN
                end_npc

        make_npc {47, 53}, $047d
                set_npc_event _cb4344
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CELES
                end_npc

        make_npc {51, 56}, $047e
                set_npc_event _cb435c
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                end_npc

        make_npc {52, 57}, $047f
                set_npc_event _cb4374
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RELM
                end_npc

        make_npc {49, 58}, $0480
                set_npc_event _cb438c
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SETZER
                end_npc

        make_npc {50, 55}, $0481
                set_npc_event _cb43a4
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {53, 54}, $0482
                set_npc_event _cb43bc
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GAU
                set_npc_movement RANDOM
                end_npc

        make_npc {54, 55}, $0483
                set_npc_event _cb43d4
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx GOGO, MOG_UMARO
                end_npc

        make_npc {42, 58}, $0484
                set_npc_event _cb43dc
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx UMARO, MOG_UMARO
                set_npc_movement RANDOM
                end_npc

        make_npc {5, 31}, $048c
                set_npc_event _cb224b
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {41, 14}, $04ef
                set_npc_event _cc3510
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx PILOT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_8:

        make_npc {109, 40}, $0458
                set_npc_event _cb1b0e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_9:

        make_npc {5, 8}, $0329
                set_npc_event _ca84ab
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx LOCKE
                end_npc

        make_npc {11, 8}, $032a
                set_npc_event _cb0a1c
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SABIN
                end_npc

        make_npc {8, 10}, $032b
                set_npc_event _cb094e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {7, 11}, $032c
                set_npc_event _cb094e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx TERRA
                end_npc

        make_npc {9, 11}, $032d
                set_npc_event _cb094e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {8, 6}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_10:

        make_special_npc {0, 0}, $0300, {0, 0}
                set_npc_speed FAST
                set_npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {0, 0}, $0300, {0, 0}
                set_npc_speed FAST
                set_npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {0, 0}, $0300, {0, 0}
                set_npc_speed FAST
                set_npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {0, 0}, $0300, {0, 0}
                set_npc_speed FAST
                set_npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {0, 0}, $0300, {0, 0}
                set_npc_speed FAST
                set_npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {0, 4}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {0, 3}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {0, 3}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx CHUPON, MOG_UMARO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, MOG_UMARO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {31, 15}, $0300, {0, 1}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx FALCON_1, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {31, 15}, $0300, {1, 0}
                set_npc_speed SLOWER
                set_npc_gfx FALCON_2, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {31, 15}, $0300, {2, 0}
                set_npc_speed SLOWER
                set_npc_gfx FALCON_3, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_11:

        make_npc {15, 8}, $03f3
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx DARILL, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_12:

        make_npc {21, 49}, $0388
                set_npc_event _ca3f13
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {15, 55}, $0389
                set_npc_event _ca3f1b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {53, 35}, $038b
                set_npc_event _ca3f23
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx CYAN
                end_npc

        make_npc {27, 54}, $038a
                set_npc_event _ca3f2b
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHADOW
                end_npc

        make_npc {23, 56}, $038c
                set_npc_event _ca3f33
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                set_npc_movement RANDOM
                end_npc

        make_npc {21, 54}, $038d
                set_npc_event _ca3f3b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SABIN
                set_npc_movement RANDOM
                end_npc

        make_npc {18, 53}, $038e
                set_npc_event _ca3f43
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CELES
                end_npc

        make_npc {11, 52}, $038f
                set_npc_event _ca3f4b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                set_npc_movement RANDOM
                end_npc

        make_npc {10, 49}, $0390
                set_npc_event _ca3f53
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RELM
                set_npc_movement RANDOM
                end_npc

        make_npc {36, 33}, $0391
                set_npc_event _ca3f5b
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SETZER
                end_npc

        make_npc {13, 49}, $0392
                set_npc_event _ca3f63
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {56, 33}, $0393
                set_npc_event _ca3f6b
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GAU
                set_npc_movement RANDOM
                end_npc

        make_npc {6, 52}, $0394
                set_npc_event _ca3f73
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GOGO
                end_npc

        make_npc {6, 51}, $0395
                set_npc_event _ca3f7b
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx UMARO, MOG_UMARO
                end_npc

        make_npc {20, 45}, $0300
                set_npc_event _cc3510
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_13:

        make_npc {15, 4}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx LOCKE
                end_npc

        make_npc {21, 5}, $0300
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {21, 5}, $03ff
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx CYAN
                end_npc

        make_npc {18, 7}, $037d
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SHADOW
                end_npc

        make_npc {18, 7}, $03ff
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SHADOW
                end_npc

        make_npc {20, 6}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {20, 6}, $03ff
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx EDGAR
                end_npc

        make_npc {12, 7}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

        make_npc {17, 6}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx CELES
                end_npc

        make_npc {18, 5}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx STRAGO
                end_npc

        make_npc {18, 5}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx STRAGO
                end_npc

        make_npc {11, 5}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {14, 6}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_14:

; ------------------------------------------------------------------------------

NPCProp::_15:

        make_npc {85, 42}, $0692
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {85, 44}, $0692
                set_npc_event _cc3304
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {86, 39}, $0692
                set_npc_event _cc338b
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle CHOCOBO
                set_npc_speed SLOWER
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_16:

; ------------------------------------------------------------------------------

NPCProp::_17:

        make_special_npc {1, 9}, $03ff, {0, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx FLYING_TERRA_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {2, 9}, $03ff, {2, 0}
                set_npc_master 0, 1, RIGHT
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx FLYING_TERRA_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {4, 3}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {21, 8}, $03ff
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx ESPER_TERRA, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {8, 8}, $039f, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ENDING_TERRA_3, TERRA
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {8, 7}, $039f, {0, 1}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx ENDING_TERRA_1, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {9, 7}, $039f, {0, 2}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx ENDING_TERRA_2, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {21, 9}, $039f
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {19, 10}, $039f
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {23, 12}, $039f
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {20, 4}, $039f
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {22, 11}, $039f
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 5}, $03ff
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_18:

; ------------------------------------------------------------------------------

NPCProp::_19:

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_20:

        make_npc {23, 30}, $0600
                set_npc_event _ccd1ef
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {43, 34}, $0600
                set_npc_event _ccd1f3
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {37, 15}, $0600
                set_npc_event _ccd1f7
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {37, 37}, $0600
                set_npc_event _ccd1fb
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {42, 25}, $0600
                set_npc_event _ccd1ff
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {43, 25}, $0600
                set_npc_event _ccd203
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {39, 32}, $0601
                set_npc_event _ccd1ef
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {53, 9}, $0608
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {0, 0}, $062c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {0, 0}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {0, 0}, $062c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {0, 0}, $062c
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {0, 0}, $062c
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {38, 16}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {38, 17}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {38, 1}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {38, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {0, 0}, $0629
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {45, 22}, $0600
                set_npc_event _ccd207
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {34, 24}, $0600
                set_npc_event _ccd215
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {46, 36}, $0600
                set_npc_event _ccd223
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {36, 42}, $0600
                set_npc_event _ccd231
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {33, 26}, $0600
                set_npc_event _ccd23f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {37, 47}, $062a
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {39, 47}, $062a
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {49, 32}, $063f
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        make_npc {33, 56}, $06a2
                set_npc_event _cc33b8
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_21:

        make_npc {37, 25}, $063f
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        make_npc {35, 16}, $0600
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx UMARO, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_22:

        make_npc {19, 37}, $0612
                set_npc_event _ccbca0
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {0, 0}, $061b
                set_npc_event _ccc547
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx TERRA
                end_npc

        make_npc {18, 11}, $061b
                set_npc_event _ccc3eb
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx LOCKE
                end_npc

        make_npc {19, 11}, $061b
                set_npc_event _ccc4d3
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx CELES
                end_npc

        make_npc {20, 11}, $061b
                set_npc_event _ccc499
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx CYAN
                end_npc

        make_npc {21, 11}, $061b
                set_npc_event _ccc425
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx EDGAR
                end_npc

        make_npc {22, 11}, $061b
                set_npc_event _ccc45f
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SABIN
                end_npc

        make_npc {23, 11}, $061b
                set_npc_event _ccc50d
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx GAU
                end_npc

        make_npc {20, 7}, $061b
                set_npc_event _ccc605
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {18, 33}, $061d
                set_npc_event _ccc90c
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        make_npc {19, 33}, $061e
                set_npc_event _ccc943
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        make_npc {20, 33}, $061f
                set_npc_event _ccc97a
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        make_npc {21, 33}, $0620
                set_npc_event _ccc9b1
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        make_npc {22, 33}, $0621
                set_npc_event _ccc9e8
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        make_npc {23, 33}, $0622
                set_npc_event _ccca1f
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        make_npc {18, 34}, $0623
                set_npc_event _ccca56
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {19, 34}, $0624
                set_npc_event _ccca6f
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {20, 34}, $0625
                set_npc_event _cccaa6
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {21, 34}, $0626
                set_npc_event _cccadd
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {22, 34}, $0627
                set_npc_event _cccb14
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {23, 34}, $061c
                set_npc_event _cccb4b
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {20, 7}, $0628
                set_npc_event _ccc8e3
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {25, 5}, $0633
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_23:

        make_special_npc {8, 11}, $0613, {0, 0}
                set_npc_32x32
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx TRITOCH, TERRA
                end_npc

        make_npc {9, 14}, $0614
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx ESPER_TERRA, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 7}, $0614
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {25, 27}, $0614
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {17, 20}, $0614
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {18, 20}, $0614
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {19, 20}, $0614
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {20, 20}, $0614
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {21, 20}, $0614
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {22, 20}, $0614
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {14, 20}, $063f
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        make_npc {9, 15}, $0640
                set_npc_event _ccd594
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        make_npc {9, 16}, $0640
                set_npc_event _ccd5df
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

        make_npc {14, 20}, $0641
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_24:

        make_npc {28, 10}, $0600
                set_npc_event _ccd24d
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {43, 50}, $068a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {43, 50}, $06ad
                set_npc_event _cc0b1e
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_25:

        make_npc {6, 7}, $0600
                set_npc_event _ccd262
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_26:

        make_npc {44, 8}, $0600
                set_npc_event _ccd28c
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_27:

        make_npc {64, 7}, $0600
                set_npc_event _ccd277
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_28:

        make_npc {8, 38}, $0600
                set_npc_event _ccd2a7
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_29:

; ------------------------------------------------------------------------------

NPCProp::_30:

        make_npc {64, 29}, $0602
                set_npc_event _ccd1e7
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx ARVIS, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {66, 37}, $0603
                set_npc_event _cca06f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ARVIS, CYAN_SHADOW_SETZER
                end_npc

        make_npc {67, 27}, $0606
                set_npc_event _cca25e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, CYAN_SHADOW_SETZER
                end_npc

        make_npc {55, 35}, $0688
                set_npc_event _cca25e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, CYAN_SHADOW_SETZER
                end_npc

        make_npc {68, 30}, $0607
                set_npc_event _cca25e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SLAVE_CROWN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {108, 16}, $0603
                set_npc_event _cca06f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {107, 16}, $0603
                set_npc_event _cca06f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {109, 16}, $0603
                set_npc_event _cca06f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {105, 17}, $0603
                set_npc_event _cca06f
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {111, 17}, $0603
                set_npc_event _cca06f
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {110, 26}, $0603
                set_npc_event _cca06f
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {108, 16}, $0602
                set_npc_event _ccd1eb
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {63, 29}, $0602
                set_npc_event _ccd1e3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {64, 36}, $0615
                set_npc_event _ccc253
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {65, 36}, $0616
                set_npc_event _ccc25b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {66, 36}, $061a
                set_npc_event _ccc263
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CYAN
                set_npc_movement RANDOM
                end_npc

        make_npc {64, 37}, $0617
                set_npc_event _ccc271
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                set_npc_movement RANDOM
                end_npc

        make_npc {65, 37}, $0618
                set_npc_event _ccc27f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SABIN
                set_npc_movement RANDOM
                end_npc

        make_npc {66, 37}, $0619
                set_npc_event _ccc28d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GAU
                set_npc_movement RANDOM
                end_npc

        make_npc {77, 9}, $063d
                set_npc_event _ccd3ca
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {81, 10}, $063d
                set_npc_event _ccd3c6
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {78, 9}, $063e
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        make_npc {106, 16}, $064e
                set_npc_event _cc72ba
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {108, 16}, $064e
                set_npc_event _cc72be
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {110, 16}, $064e
                set_npc_event _cc72c2
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ARVIS, CYAN_SHADOW_SETZER
                end_npc

        make_npc {87, 45}, $06ad
                set_npc_event _cc0b70
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_31:

; ------------------------------------------------------------------------------

NPCProp::_32:

        make_npc {39, 46}, $068a
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        make_npc {41, 37}, $06c0
                set_npc_event _cc0a9e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {32, 31}, $06c1
                set_npc_event _cc0aae
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {29, 26}, $06c2
                set_npc_event _cc0abe
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {52, 38}, $06c3
                set_npc_event _cc0ace
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {32, 17}, $06c4
                set_npc_event _cc0ade
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {41, 23}, $06c5
                set_npc_event _cc0aee
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_33:

; ------------------------------------------------------------------------------

NPCProp::_34:

        make_npc {25, 5}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {22, 20}, $0695
                set_npc_event _cc36df
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_35:

        make_special_npc {8, 11}, $068c, {0, 0}
                set_npc_32x32
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed FAST
                set_npc_gfx TRITOCH, TERRA
                end_npc

        make_npc {9, 11}, $068a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_36:

; ------------------------------------------------------------------------------

NPCProp::_37:

; ------------------------------------------------------------------------------

NPCProp::_38:

; ------------------------------------------------------------------------------

NPCProp::_39:

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                end_npc

        make_npc {0, 0}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_40:

; ------------------------------------------------------------------------------

NPCProp::_41:

        make_npc {42, 4}, $0604
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx NARSHE_GUARD, EDGAR_SABIN_CELES
                end_npc

        make_npc {33, 22}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_42:

        make_special_npc {86, 7}, $0605, {0, 0}
                set_npc_32x32
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed FAST
                set_npc_gfx TRITOCH, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_43:

; ------------------------------------------------------------------------------

NPCProp::_44:

        make_npc {121, 46}, $068d
                set_npc_event _cc396c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_45:

; ------------------------------------------------------------------------------

NPCProp::_46:

; ------------------------------------------------------------------------------

NPCProp::_47:

        make_npc {52, 42}, $0300
                set_npc_event _ca77d7
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {52, 41}, $0300
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx TREASURE_CHEST, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_48:

; ------------------------------------------------------------------------------

NPCProp::_49:

        make_npc {0, 0}, $0658
                set_npc_event _cce486
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0658
                set_npc_event _cce486
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0658
                set_npc_event _cce486
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0658
                set_npc_event _cce486
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0658
                set_npc_event _cce486
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0658
                set_npc_event _cce486
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0658
                set_npc_event _cce416
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0658
                set_npc_event _cce486
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_50:

        make_npc {58, 17}, $0609
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {58, 18}, $0609
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {49, 11}, $0609
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {49, 12}, $0609
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {66, 41}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_51:

        make_npc {14, 7}, $0609
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

        make_npc {14, 7}, $0609
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

        make_npc {15, 40}, $0631
                set_npc_event _ccada8
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        make_npc {15, 34}, $060a
                set_npc_event _ccaadf
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {15, 35}, $060b
                set_npc_event _ccaaf7
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {15, 36}, $060c
                set_npc_event _ccab0f
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {15, 37}, $060d
                set_npc_event _ccab27
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {15, 38}, $060e
                set_npc_event _ccab3f
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {15, 39}, $060f
                set_npc_event _ccab57
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MONSTER, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {14, 12}, $0631
                set_npc_event _ccaab3
                set_npc_no_react
                set_npc_anim ONE_FRAME, KNOCKED_OUT
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

        make_npc {20, 36}, $0610
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {14, 7}, $0610
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_52:

        make_npc {121, 46}, $0643
                set_npc_event _ccd6e7
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

        make_npc {118, 48}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {119, 48}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {120, 48}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {121, 48}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {122, 48}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {123, 48}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {124, 48}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {115, 55}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {114, 47}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

        make_npc {121, 51}, $0642
                set_npc_event _ccd6e3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_53:

        make_npc {31, 42}, $0399
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_54:

        make_npc {40, 20}, $0300
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {12, 21}, $0300
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {24, 27}, $0300
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx CHANCELLOR, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_55:

        make_npc {29, 40}, $0300
                set_npc_event _ca71af
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {24, 26}, $030e
                set_npc_event _ca7590
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {32, 26}, $030e
                set_npc_event _ca75b4
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {24, 16}, $0315
                set_npc_event _ca5f9f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {28, 57}, $03fe
                set_npc_event _ca6f02
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {27, 58}, $03fe
                set_npc_event _ca6ee6
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {29, 58}, $03fe
                set_npc_event _ca6ef2
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {23, 26}, $030d
                set_npc_event _ca661f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {33, 26}, $030d
                set_npc_event _ca661f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {44, 21}, $030b
                set_npc_event _ca75d8
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {12, 21}, $030b
                set_npc_event _ca75dc
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {28, 15}, $0311
                set_npc_event _ca6f60
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx LOCKE
                end_npc

        make_npc {31, 27}, $03ff
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx CHANCELLOR, TERRA
                end_npc

        make_npc {40, 22}, $03ff
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {18, 22}, $03fe
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO
                set_npc_speed FAST
                set_npc_gfx TERRA
                end_npc

        make_npc {0, 0}, $03fe
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {0, 0}, $03fe
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {33, 41}, $030b
                set_npc_event _ca71af
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {23, 41}, $030b
                set_npc_event _ca71af
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {38, 31}, $030b
                set_npc_event _ca71af
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {18, 31}, $030b
                set_npc_event _ca71af
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {28, 13}, $03ff
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx OLD_WOMAN, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_56:

        make_npc {20, 41}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {18, 39}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {18, 41}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {17, 43}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {17, 38}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 41}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 43}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 39}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {14, 40}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {15, 44}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {13, 39}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 41}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {13, 43}, $0611
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_57:

        make_npc {64, 19}, $030f
                set_npc_event _ca6c76
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {58, 21}, $030f
                set_npc_event _ca6c85
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_WOMAN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {59, 22}, $03fe
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SABIN
                end_npc

        make_npc {62, 15}, $03fe
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_58:

        make_npc {101, 42}, $0308
                set_npc_event _ca6623
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {98, 47}, $0309
                set_npc_event _ca6601
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {106, 47}, $0309
                set_npc_event _ca6601
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {102, 52}, $03ff
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {102, 53}, $03ff
                set_npc_event _ca67e6
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx CHANCELLOR, TERRA
                end_npc

        make_npc {103, 56}, $03ff
                set_npc_event _ca67e6
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_59:

        make_npc {25, 15}, $030e
                set_npc_event _ca6786
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {29, 15}, $030e
                set_npc_event _ca6794
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {28, 20}, $0316
                set_npc_event _ca67e6
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx CHANCELLOR, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {82, 45}, $0313
                set_npc_event _ca700e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx LOCKE
                end_npc

        make_npc {50, 47}, $030f
                set_npc_event _ca6c12
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {52, 46}, $0310
                set_npc_event _ca6c20
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {67, 44}, $0302
                set_npc_event _ca679e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {79, 12}, $0302
                set_npc_event _ca679e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {10, 13}, $0300
                set_npc_event _ca67a2
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {44, 15}, $0300
                set_npc_event _ca67c0
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {12, 49}, $0382
                set_npc_event _ca6a28
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

        make_npc {12, 42}, $0397
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {12, 50}, $0397
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx NOTHING, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_60:

        make_npc {100, 12}, $030f
                set_npc_event _ca6c46
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {104, 16}, $030f
                set_npc_event _ca6c5e
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {103, 26}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx LOCKE
                end_npc

        make_npc {103, 29}, $03fe
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_61:

        make_npc {29, 40}, $0381
                set_npc_event _ca6807
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {26, 38}, $0380
                set_npc_event _ca681f
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 38}, $0380
                set_npc_event _ca6823
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {32, 38}, $0380
                set_npc_event _ca6827
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {35, 39}, $0359
                set_npc_event _ca682b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {6, 33}, $0300
                set_npc_event _ca682f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {28, 41}, $0382
                set_npc_event _ca6a28
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

        make_npc {29, 41}, $0383
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx EDGAR, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_62:

        make_npc {12, 16}, $0382
                set_npc_event _ca6a28
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_63:

        make_npc {53, 10}, $0382
                set_npc_event _ca6a28
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_64:

        make_npc {25, 9}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {27, 8}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {26, 11}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {28, 11}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {26, 13}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {31, 9}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {33, 8}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {32, 11}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {34, 11}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {32, 13}, $03f0
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {29, 16}, $03f1
                set_npc_event _ca6a48
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx EDGAR, LOCKE
                end_npc

        make_npc {29, 8}, $03f2
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {30, 7}, $03f2
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {29, 10}, $03f2
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {29, 11}, $03f2
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_65:

; ------------------------------------------------------------------------------

NPCProp::_66:

; ------------------------------------------------------------------------------

NPCProp::_67:

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_68:

        make_npc {14, 36}, $0398
                set_npc_event _ca7775
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_69:

; ------------------------------------------------------------------------------

NPCProp::_70:

        make_npc {45, 27}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx TURTLE, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_71:

        make_npc {10, 49}, $031d
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {11, 50}, $031d
                set_npc_event _ca8468
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {10, 49}, $0312
                set_npc_event _ca75ee
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {11, 49}, $0312
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO
                set_npc_speed FAST
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_72:

; ------------------------------------------------------------------------------

NPCProp::_73:

        make_npc {45, 27}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx TURTLE, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_74:

        make_npc {29, 21}, $0300
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {29, 22}, $037a
                set_npc_event _ca802e
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {26, 24}, $037a
                set_npc_event _ca8032
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 21}, $0300
                set_npc_event _ca803a
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {20, 20}, $0300
                set_npc_event _ca803a
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {18, 24}, $0300
                set_npc_event _ca803e
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {51, 15}, $037b
                set_npc_event _ca8042
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {52, 15}, $037c
                set_npc_event _ca8053
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {31, 26}, $0300
                set_npc_event _ca806b
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {29, 31}, $0300
                set_npc_event _ca806f
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {31, 45}, $0300
                set_npc_event _ca8073
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {22, 48}, $0300
                set_npc_event _ca8077
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_75:

        make_npc {13, 34}, $0303
                set_npc_event _ca77ad
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 35}, $0303
                set_npc_event _ca77b1
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {29, 32}, $0303
                set_npc_event _ca77b5
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {43, 10}, $0303
                set_npc_event _ca77b9
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {21, 48}, $0303
                set_npc_event _ca77bd
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {4, 31}, $03ff
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SHADOW
                end_npc

        make_npc {48, 44}, $0303
                set_npc_event _ca77c1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {19, 30}, $0303
                set_npc_event _ca77c5
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {37, 48}, $0303
                set_npc_event _ca77d3
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {30, 42}, $030c
                set_npc_event _ca854f
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {14, 24}, $030c
                set_npc_event _ca856f
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {5, 33}, $030c
                set_npc_event _ca85e2
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {19, 51}, $030c
                set_npc_event _ca858f
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {9, 34}, $030c
                set_npc_event _ca85e2
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {29, 21}, $0360
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {15, 20}, $030c
                set_npc_event _ca7e3c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {52, 38}, $030c
                set_npc_event _ca7e2c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {46, 13}, $030c
                set_npc_event _ca7e2c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {15, 27}, $031b
                set_npc_event _ca7e5e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {28, 22}, $030c
                set_npc_event _ca7e46
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {11, 21}, $0318
                set_npc_event _ca7e7b
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {22, 47}, $0319
                set_npc_event _ca7e9a
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {4, 34}, $030c
                set_npc_event _ca85e2
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_76:

        make_npc {87, 10}, $030c
                set_npc_event _ca85e6
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {89, 7}, $0379
                set_npc_event _ca7890
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {51, 9}, $0300
                set_npc_event _ca7878
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {81, 17}, $0300
                set_npc_event _ca7894
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {51, 11}, $0358
                set_npc_event _ca78dc
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {88, 11}, $037e
                set_npc_event _ca808d
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx EDGAR, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {87, 20}, $03ff
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_77:

        make_npc {109, 11}, $030c
                set_npc_event _ca7eef
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {102, 12}, $030c
                set_npc_event _ca7ef9
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {103, 9}, $0300
                set_npc_event _ca7860
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {114, 10}, $0300
                set_npc_event _ca786c
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_78:

        make_npc {36, 40}, $0305
                set_npc_event _ca7c3a
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SHADOW
                end_npc

        make_npc {36, 41}, $0305
                set_npc_event _ca7d01
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {26, 42}, $0379
                set_npc_event _ca7d1d
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {24, 41}, $0303
                set_npc_event _ca7d2b
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {30, 44}, $0303
                set_npc_event _ca7d4d
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {28, 42}, $0303
                set_npc_event _ca7d65
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx HOOKER, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {75, 39}, $0307
                set_npc_event _ca7d7d
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {38, 40}, $0300
                set_npc_event _ca7d13
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {81, 17}, $0303
                set_npc_event _ca7e28
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {30, 42}, $030c
                set_npc_event _ca7ed1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {30, 44}, $030c
                set_npc_event _ca7edb
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {36, 40}, $030c
                set_npc_event _ca7ee5
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {28, 39}, $037a
                set_npc_event _ca8085
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {34, 42}, $037a
                set_npc_event _ca8089
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_79:

; ------------------------------------------------------------------------------

NPCProp::_80:

        make_npc {86, 38}, $0300
                set_npc_event _ca7a8d
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle CHOCOBO
                set_npc_speed SLOWER
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {85, 45}, $0300
                set_npc_event _ca7a36
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_81:

        make_npc {38, 11}, $0304
                set_npc_event _ca79d7
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {51, 10}, $0304
                set_npc_event _ca79f8
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {53, 10}, $0304
                set_npc_event _ca79fc
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {33, 10}, $0303
                set_npc_event _ca7a14
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {16, 11}, $0304
                set_npc_event _ca7a18
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {7, 11}, $030c
                set_npc_event _ca7f11
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {4, 16}, $030c
                set_npc_event _ca7f11
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {51, 11}, $030c
                set_npc_event _ca7f15
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_82:

; ------------------------------------------------------------------------------

NPCProp::_83:

        make_npc {57, 6}, $03fe
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx CELES
                end_npc

        make_npc {59, 9}, $030c
                set_npc_event _ca7f19
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {57, 8}, $03fe
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {57, 6}, $0317
                set_npc_event _ca8837
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx CELES_CHAINS, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_84:

        make_npc {53, 57}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_85:

        make_npc {103, 51}, $030c
                set_npc_event _ca85e6
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {107, 55}, $030c
                set_npc_event _ca7f03
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {106, 52}, $0300
                set_npc_event _ca7884
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_86:

        make_npc {54, 51}, $0300
                set_npc_event _ca7a90
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {28, 17}, $0300
                set_npc_event _ca7b88
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {30, 8}, $0303
                set_npc_event _ca7bc9
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {28, 16}, $030a
                set_npc_event _ca7e06
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {6, 10}, $030c
                set_npc_event _ca7bcd
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_87:

; ------------------------------------------------------------------------------

NPCProp::_88:

        make_npc {11, 34}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_89:

; ------------------------------------------------------------------------------

NPCProp::_90:

        make_npc {45, 27}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx TURTLE, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {47, 32}, $037f
                set_npc_event _ca927e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {46, 31}, $037f
                set_npc_event _ca927e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {46, 32}, $037f
                set_npc_event _ca927e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {49, 31}, $037f
                set_npc_event _ca927e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {47, 35}, $037f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EDGAR, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {48, 34}, $03ff
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_91:

        make_npc {14, 9}, $0300
                set_npc_event _ca77d7
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {15, 12}, $0300
                set_npc_event _ca77d7
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {11, 10}, $03fe
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {11, 11}, $03fe
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {11, 12}, $03fe
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {11, 13}, $03fe
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {13, 11}, $03fe
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx EDGAR, LOCKE
                end_npc

        make_npc {15, 9}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx TREASURE_CHEST, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_92:

; ------------------------------------------------------------------------------

NPCProp::_93:

        make_npc {4, 11}, $0306
                set_npc_event _ca8198
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_94:

; ------------------------------------------------------------------------------

NPCProp::_95:

        make_npc {11, 26}, $031d
                set_npc_event _ca847e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_96:

        make_npc {0, 0}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SABIN, RAINBOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_97:

        make_npc {40, 18}, $032e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SABIN, RAINBOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_98:

        make_npc {23, 32}, $031c
                set_npc_event _ca828f
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx VARGAS, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_99:

; ------------------------------------------------------------------------------

NPCProp::_100:

        make_npc {30, 53}, $0650
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RACHEL, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_101:

        make_npc {10, 49}, $031d
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {11, 50}, $031d
                set_npc_event _ca8473
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_102:

; ------------------------------------------------------------------------------

NPCProp::_103:

        make_npc {57, 8}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_104:

        make_npc {104, 47}, $0690
                set_npc_event _cc339c
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {107, 47}, $0690
                set_npc_event _cc33aa
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {106, 47}, $0690
                set_npc_event _cc33ae
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {94, 47}, $0690
                set_npc_event _cc369e
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {109, 49}, $0691
                set_npc_event _cc36a6
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {98, 47}, $0690
                set_npc_event _cc3403
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_105:

        make_npc {56, 33}, $0690
                set_npc_event _cc3677
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {58, 33}, $0690
                set_npc_event _cc3686
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {59, 32}, $0690
                set_npc_event _cc368a
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {56, 31}, $0690
                set_npc_event _cc368e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {57, 31}, $0690
                set_npc_event _cc3692
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {58, 31}, $0690
                set_npc_event _cc3696
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {55, 32}, $0690
                set_npc_event _cc369a
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {58, 29}, $0690
                set_npc_event _cc36a2
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {54, 30}, $0690
                set_npc_event _cc36b5
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {59, 29}, $0690
                set_npc_event _cc36b9
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_106:

        make_npc {57, 30}, $0690
                set_npc_event _cc3407
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                end_npc

        make_npc {56, 30}, $0690
                set_npc_event _cc340b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                end_npc

        make_npc {55, 30}, $0690
                set_npc_event _cc340f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                end_npc

        make_npc {54, 30}, $0690
                set_npc_event _cc3413
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                end_npc

        make_npc {60, 28}, $0690
                set_npc_event _cc3417
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {59, 32}, $0690
                set_npc_event _cc341b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {61, 31}, $0690
                set_npc_event _cc341f
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                end_npc

        make_npc {54, 33}, $0690
                set_npc_event _cc3423
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, RAINBOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_107:

        make_npc {60, 32}, $0690
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {59, 32}, $0690
                set_npc_event _cc33e1
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {60, 29}, $0690
                set_npc_event _cc33e8
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {56, 29}, $0690
                set_npc_event _cc33ec
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {53, 28}, $0690
                set_npc_event _cc33f0
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {58, 29}, $0690
                set_npc_event _cc33f4
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {55, 31}, $0690
                set_npc_event _cc33fb
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {55, 32}, $0690
                set_npc_event _cc33ff
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {54, 32}, $0690
                set_npc_event _ccd2ee
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_108:

        make_npc {14, 49}, $0421
                set_npc_event _cafab8
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_109:

        make_npc {9, 25}, $0413
                set_npc_event _caf68a
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {11, 15}, $0414
                set_npc_event _caf76e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {27, 25}, $0415
                set_npc_event _caf784
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {26, 28}, $0416
                set_npc_event _caf9af
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

        make_npc {22, 19}, $0417
                set_npc_event _cb0080
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {23, 24}, $0418
                set_npc_event _cb0080
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {26, 25}, $0419
                set_npc_event _cb0080
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {26, 26}, $041a
                set_npc_event _cb0080
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {23, 25}, $041b
                set_npc_event _cb0080
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {9, 29}, $041c
                set_npc_event _cb0080
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {25, 31}, $043a
                set_npc_event _caf64b
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_110:

        make_npc {51, 50}, $041d
                set_npc_event _caf79c
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {44, 14}, $041e
                set_npc_event _caf999
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {52, 48}, $041f
                set_npc_event _caf9a9
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                set_npc_movement RANDOM
                end_npc

        make_npc {27, 48}, $0420
                set_npc_event _caf9cf
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                end_npc

        make_npc {21, 48}, $0423
                set_npc_event _cb0404
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                end_npc

        make_npc {51, 49}, $0424
                set_npc_event _cb03fa
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {50, 54}, $0497
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        make_npc {50, 39}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_111:

        make_npc {43, 55}, $043b
                set_npc_event _caf64e
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_112:

; ------------------------------------------------------------------------------

NPCProp::_113:

        make_npc {122, 24}, $0422
                set_npc_event _cb059f
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx ULTROS, MOG_UMARO
                end_npc

        make_npc {31, 56}, $0428
                set_npc_event _cb059f
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle RAFT
                set_npc_speed FAST
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_114:

        make_npc {20, 26}, $04fc
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle RAFT
                set_npc_speed SLOWER
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {6, 18}, $04fd
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle RAFT
                set_npc_speed SLOWER
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {20, 21}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {6, 13}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_115:

        make_npc {4, 12}, $0426
                set_npc_event _cb0a5f
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHADOW
                end_npc

        make_npc {3, 12}, $0427
                set_npc_event _cb0b10
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {16, 12}, $0434
                set_npc_event _cb0b7e
                set_npc_dir LEFT
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_116:

        make_npc {115, 9}, $0425
                set_npc_event _cb6828
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_117:

        make_npc {32, 11}, $0400
                set_npc_event _cb0d9b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {41, 7}, $0401
                set_npc_event _cb0d9b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {36, 13}, $0402
                set_npc_event _cb0d9b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {44, 28}, $0403
                set_npc_event _cb0f2e
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        make_npc {44, 8}, $0404
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {40, 33}, $0405
                set_npc_event _cb1126
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {29, 29}, $0406
                set_npc_event _cb0d9b
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 30}, $0407
                set_npc_event _cb11e9
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {26, 28}, $0408
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {42, 28}, $0409
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {46, 11}, $040a
                set_npc_event _cb0db3
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx DOG, LOCKE
                end_npc

        make_npc {49, 13}, $040b
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {35, 15}, $040c
                set_npc_event _cb0f2e
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, CYAN_SHADOW_SETZER
                end_npc

        make_npc {45, 5}, $04ee
                set_npc_event _cb0dbe
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_118:

; ------------------------------------------------------------------------------

NPCProp::_119:

        make_npc {12, 8}, $0429
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle MAGITEK
                set_npc_speed SLOW
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {12, 10}, $042a
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle MAGITEK
                set_npc_speed SLOW
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {1, 23}, $042b
                set_npc_event _cb1483
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx CYAN
                end_npc

        make_npc {5, 17}, $042c
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 17}, $042d
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 30}, $042e
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {17, 30}, $042f
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 14}, $0430
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {13, 14}, $0431
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {11, 27}, $0432
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {13, 26}, $0433
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 12}, $0435
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {25, 39}, $0436
                set_npc_event _cb1955
                set_npc_no_react
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {43, 32}, $0437
                set_npc_event _cb19af
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {36, 14}, $0438
                set_npc_event _cb19e6
                set_npc_no_react
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {15, 30}, $0439
                set_npc_event _cb1985
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_120:

        make_npc {33, 59}, $0501
                set_npc_event _cb9eb5
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, CYAN_SHADOW_SETZER
                end_npc

        make_npc {32, 60}, $0501
                set_npc_event _cb9ffb
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {33, 60}, $0501
                set_npc_event _cba007
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {34, 60}, $0501
                set_npc_event _cba013
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {31, 61}, $0501
                set_npc_event _cba01f
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {32, 61}, $0501
                set_npc_event _cba02b
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {33, 61}, $0501
                set_npc_event _cba037
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {34, 61}, $0501
                set_npc_event _cba043
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {35, 61}, $0501
                set_npc_event _cba04f
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {32, 62}, $0501
                set_npc_event _cba05b
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {33, 62}, $0501
                set_npc_event _cba067
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {34, 62}, $0501
                set_npc_event _cba073
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {33, 44}, $0501
                set_npc_event _cb9e98
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {33, 43}, $0501
                set_npc_event _cb9e98
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {39, 41}, $0501
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {25, 42}, $0501
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {31, 40}, $0501
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {36, 40}, $0501
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_121:

        make_npc {28, 19}, $050c
                set_npc_event _cba382
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {28, 41}, $050c
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {41, 42}, $0511
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {33, 35}, $0511
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {34, 35}, $0511
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {39, 26}, $0511
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {16, 29}, $050c
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {10, 32}, $0511
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {27, 50}, $050b
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {17, 29}, $050b
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_122:

; ------------------------------------------------------------------------------

NPCProp::_123:

        make_npc {40, 9}, $0511
                set_npc_event _cba386
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {24, 10}, $0511
                set_npc_event _cba37e
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx KING_DOMA, TERRA
                end_npc

        make_npc {54, 6}, $0511
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        make_npc {6, 10}, $0523
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx CYAN
                end_npc

        make_npc {4, 14}, $05f7
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {4, 14}, $05f7
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {4, 14}, $05f7
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 5}, $0549
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {25, 5}, $0549
                set_npc_event _cb9a7a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {10, 41}, $056a
                set_npc_event _cb9e98
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {10, 51}, $056a
                set_npc_event _cb9e98
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_124:

        make_npc {32, 29}, $0511
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {34, 31}, $0511
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BOY, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_125:

        make_npc {47, 18}, $0546
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BOY, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {47, 20}, $0546
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx CYAN, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {13, 22}, $0546
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx BOY, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {11, 22}, $0546
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx CYAN, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {10, 30}, $0500
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {33, 45}, $0500
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_126:

        make_npc {8, 9}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        make_npc {9, 7}, $0547
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {7, 7}, $0547
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BOY, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {8, 8}, $0548
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {30, 31}, $0546
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx CYAN, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {32, 30}, $0546
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {34, 31}, $0546
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx BOY, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {24, 6}, $0548
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx CYAN
                end_npc

        make_npc {25, 5}, $0548
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx EMPEROR_SERVANT, VEHICLE
                end_npc

        make_npc {24, 9}, $0546
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {26, 9}, $0546
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BOY, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {25, 9}, $0546, {0, 0}
                set_npc_h_flip
                set_npc_master 15, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_anim TWO_FRAMES, DEFAULT
                set_npc_speed NORMAL
                set_npc_gfx LEO_SWORD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {24, 9}, $0546
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {26, 9}, $0546
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 4}, $0546
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 5}, $0549
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_127:

        make_npc {7, 8}, $06ac
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANON, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_128:

        make_npc {80, 31}, $06b5
                set_npc_event _cc0bd4
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANON, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {80, 33}, $06bf
                set_npc_event _cc0f4c
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANON, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_129:

        make_npc {16, 22}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {17, 21}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {18, 20}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {19, 21}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {20, 22}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {11, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {12, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {10, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {11, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_130:

        make_npc {28, 4}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        make_npc {26, 5}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        make_npc {24, 6}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        make_npc {25, 7}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        make_npc {7, 7}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 6}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {9, 8}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_131:

        make_npc {7, 12}, $048e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SPIFFY_GAU, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_132:

; ------------------------------------------------------------------------------

NPCProp::_133:

; ------------------------------------------------------------------------------

NPCProp::_134:

; ------------------------------------------------------------------------------

NPCProp::_135:

; ------------------------------------------------------------------------------

NPCProp::_136:

        make_npc {47, 4}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

        make_npc {48, 3}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

        make_npc {47, 4}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

        make_npc {49, 2}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_137:

        make_npc {4, 11}, $0501
                set_npc_event _cbbe99
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx CYAN
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {15, 11}, $05f7
                set_npc_event _cbbe9f
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_138:

; ------------------------------------------------------------------------------

NPCProp::_139:

        make_npc {49, 9}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        make_npc {64, 12}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 13}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BOY, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 14}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {65, 9}, $0501
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 9}, $0501
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 15}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 16}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 16}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 16}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 16}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 16}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 16}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 16}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 10}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {64, 11}, $0501
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 7}, $05f7
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx SABIN
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {7, 7}, $05f7
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx CYAN
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {7, 7}, $05f7
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx SHADOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_140:

; ------------------------------------------------------------------------------

NPCProp::_141:

; ------------------------------------------------------------------------------

NPCProp::_142:

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {66, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {77, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {77, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {77, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {77, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {77, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {77, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {77, 8}, $0509
                set_npc_event _cbb3e2
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_143:

        make_npc {96, 5}, $0543
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx CYAN, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {101, 5}, $0543
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx GHOST, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {109, 8}, $0500
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {66, 8}, $0500
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {46, 8}, $0500
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {50, 8}, $0500
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_144:

        make_npc {13, 7}, $054a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {14, 7}, $054a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {15, 7}, $054a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_145:

        make_npc {3, 6}, $0509
                set_npc_event _cbb265
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {8, 7}, $0509
                set_npc_event _cbb3b8
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {14, 9}, $0509
                set_npc_event _cbb3c0
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 6}, $0509
                set_npc_event _cbb3c7
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {17, 8}, $0509
                set_npc_event _cbb3ce
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 8}, $0509
                set_npc_event _cbb3d5
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {6, 8}, $0507
                set_npc_event _cbaadd
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 6}, $0507
                set_npc_event _cbaae8
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {8, 9}, $0506
                set_npc_event _cbaaf3
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {14, 10}, $0506
                set_npc_event _cbacfe
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 8}, $0506
                set_npc_event _cbad05
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 8}, $0507
                set_npc_event _cbad13
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 7}, $0506
                set_npc_event _cbad0c
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 8}, $0567
                set_npc_event _cbad44
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_146:

        make_npc {21, 9}, $0501
                set_npc_event _cbaee3
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx TRAIN_CONDUCTOR, CYAN_SHADOW_SETZER
                end_npc

        make_npc {20, 10}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_147:

        make_npc {6, 7}, $0501
                set_npc_event _cbb010
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {6, 8}, $0501
                set_npc_event _cbb010
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {16, 6}, $05f7
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_148:

        make_npc {14, 35}, $066f
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 35}, $066f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 33}, $066f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 34}, $066f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GIRL, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 34}, $066f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 33}, $066f
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_149:

        make_npc {14, 10}, $0501
                set_npc_event _cbab09
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 6}, $0501
                set_npc_event _cbad36
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {5, 9}, $0501
                set_npc_event _cbad3d
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {24, 6}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_150:

        make_npc {36, 55}, $0674
                set_npc_event _cc4c0b
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx TERRA
                end_npc

        make_npc {35, 55}, $0674
                set_npc_event _cc4c13
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {40, 49}, $066e
                set_npc_event _cc4c0f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {40, 49}, $066e
                set_npc_event _cc4c17
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {33, 57}, $0674
                set_npc_event _cc707f
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_151:

        make_npc {14, 8}, $0507
                set_npc_event _cbb90a
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx TRAIN_CONDUCTOR, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {8, 10}, $0506
                set_npc_event _cbab14
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {22, 9}, $0506
                set_npc_event _cbad1a
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {8, 10}, $0507
                set_npc_event _cbad21
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {14, 7}, $0507
                set_npc_event _cbad28
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 11}, $0506
                set_npc_event _cbad2f
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_152:

        make_npc {11, 9}, $0501
                set_npc_event _cbaafe
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_153:

        make_npc {8, 17}, $0502
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

        make_npc {8, 9}, $0517
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_154:

        make_npc {51, 56}, $066f
                set_npc_event _cc44fb
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {50, 44}, $0675
                set_npc_event _cc4565
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

        make_npc {55, 43}, $0670
                set_npc_event _cc4aec
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx TERRA
                end_npc

        make_npc {56, 45}, $0670
                set_npc_event _cc4ae8
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {56, 43}, $0670
                set_npc_event _cc4ae4
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {55, 44}, $0670
                set_npc_event _cc4ae0
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {43, 57}, $0671
                set_npc_event _cc450b
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {44, 57}, $0671
                set_npc_event _cc4515
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {48, 55}, $0671
                set_npc_event _cc451f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {47, 52}, $066f
                set_npc_event _cc4529
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {45, 55}, $066f
                set_npc_event _cc4539
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {43, 52}, $066f
                set_npc_event _cc4543
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 56}, $066f
                set_npc_event _cc454d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {44, 51}, $0672
                set_npc_event _cc455d
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {45, 51}, $0673
                set_npc_event _cc4561
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {56, 43}, $0676
                set_npc_event _cc507a
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {55, 43}, $0676
                set_npc_event _cc507e
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {50, 44}, $0677
                set_npc_event _cc506e
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {56, 45}, $0677
                set_npc_event _cc5076
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {55, 44}, $0677
                set_npc_event _cc5072
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_155:

; ------------------------------------------------------------------------------

NPCProp::_156:

        make_npc {16, 39}, $03fe
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_bg2_scroll
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 11}, $03fe
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {13, 13}, $03fe
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {11, 18}, $03fe
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GIRL, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_157:

        make_npc {20, 40}, $0653
                set_npc_event _cc669b
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {17, 19}, $0653
                set_npc_event _cc669f
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {14, 36}, $0653
                set_npc_event _cc66a3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {5, 12}, $0653
                set_npc_event _cc66a7
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 35}, $0653
                set_npc_event _cc66b3
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 26}, $0653
                set_npc_event _cc66bb
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {5, 36}, $0653
                set_npc_event _cc66b7
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {22, 17}, $0653
                set_npc_event _cc66c7
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {2, 22}, $0653
                set_npc_event _cc66bf
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {9, 20}, $0653
                set_npc_event _cc66c3
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {10, 20}, $0653
                set_npc_event _cc6755
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {29, 23}, $0653
                set_npc_event _cc6759
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {17, 14}, $0653
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {5, 6}, $0653
                set_npc_event _cc66ab
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {18, 19}, $0653
                set_npc_event _cc6761
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {6, 6}, $0653
                set_npc_event _cc66af
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {20, 25}, $0653
                set_npc_event _cc707f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_158:

        make_npc {21, 12}, $066f
                set_npc_event _cc707f
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {25, 10}, $066f
                set_npc_event _cc707f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {16, 16}, $066e
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {16, 16}, $066e
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {16, 16}, $066e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {16, 16}, $066e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {6, 20}, $066e
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {6, 20}, $066e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {6, 20}, $066e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {11, 17}, $066e
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 18}, $066e
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 19}, $066e
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 14}, $066e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ESPER_TERRA, VEHICLE
                end_npc

        make_npc {6, 19}, $066e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_159:

        make_npc {4, 15}, $050c
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx GAU
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_160:

        make_npc {24, 15}, $0653
                set_npc_event _cc6653
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_161:

        make_npc {11, 37}, $0653
                set_npc_event _cc6645
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {22, 37}, $0653
                set_npc_event _cc664c
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_162:

        make_npc {29, 21}, $0653
                set_npc_event _cc6694
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_163:

        make_npc {50, 13}, $0653
                set_npc_event _cc67cf
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_164:

        make_npc {29, 48}, $0653
                set_npc_event _cc668d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_165:

        make_npc {15, 47}, $0653
                set_npc_event _cc675d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {15, 14}, $0653
                set_npc_event _cc6878
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {10, 11}, $0654
                set_npc_event _cc6768
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 25}, $0674
                set_npc_event _cc707f
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {14, 16}, $0674
                set_npc_event _cc4b47
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_166:

; ------------------------------------------------------------------------------

NPCProp::_167:

        make_npc {12, 21}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        make_npc {13, 21}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        make_npc {12, 21}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        make_special_npc {25, 18}, $05f7, {0, 0}
                set_npc_h_flip
                set_npc_master 15, 1, RIGHT
                _npc_is_slave .set 0
                set_npc_anim TWO_FRAMES, DEFAULT
                set_npc_speed NORMAL
                set_npc_gfx DIVING_HELMET, STRAGO_RELM_GAU_GOGO
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_168:

; ------------------------------------------------------------------------------

NPCProp::_169:

        make_npc {24, 39}, $0300
                set_npc_event _ca8f4a
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {17, 42}, $0300
                set_npc_event _ca8f23
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {23, 52}, $0300
                set_npc_event _ca8f2f
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {26, 47}, $0300
                set_npc_event _ca8f3e
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {19, 43}, $0300
                set_npc_event _ca8f56
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {22, 57}, $0300
                set_npc_event _ca8f64
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {9, 47}, $0300
                set_npc_event _ca8f72
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {15, 46}, $0300
                set_npc_event _ca8f80
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {21, 51}, $0300
                set_npc_event _ca8f8e
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx BOY, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {15, 34}, $0300
                set_npc_event _ca8f9c
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 46}, $0376
                set_npc_event _ca91da
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EDGAR, LOCKE
                end_npc

        make_npc {15, 58}, $0375
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {0, 55}, $0375
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {0, 55}, $0375
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {0, 55}, $0375
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_170:

        make_npc {7, 12}, $0300
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx CLYDE, LOCKE
                end_npc

        make_npc {6, 8}, $0300
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx PILOT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_171:

        make_npc {46, 48}, $0300
                set_npc_event _ca8ee5
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_172:

        make_npc {29, 30}, $0300
                set_npc_event _ca8ff7
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {29, 34}, $0373
                set_npc_event _ca9005
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {27, 31}, $0300
                set_npc_event _ca9009
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx HOOKER, TERRA
                end_npc

        make_npc {26, 32}, $0374
                set_npc_event _ca9189
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {27, 32}, $0374
                set_npc_event _ca9193
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {27, 34}, $0374
                set_npc_event _ca919d
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 35}, $0374
                set_npc_event _ca91a7
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_173:

        make_npc {85, 45}, $0300
                set_npc_event _ca8fb4
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {88, 39}, $0300
                set_npc_event _ca7a8d
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle CHOCOBO
                set_npc_speed SLOWER
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_174:

        make_npc {23, 7}, $03ff
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx CLYDE, LOCKE
                end_npc

        make_npc {23, 7}, $03ff
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_175:

; ------------------------------------------------------------------------------

NPCProp::_176:

; ------------------------------------------------------------------------------

NPCProp::_177:

; ------------------------------------------------------------------------------

NPCProp::_178:

; ------------------------------------------------------------------------------

NPCProp::_179:

        make_npc {47, 6}, $0686
                set_npc_event _cc43cd
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx DRAGON, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {40, 15}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_180:

        make_npc {39, 53}, $0681
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {40, 53}, $0681
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {41, 53}, $0681
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {38, 55}, $0681
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {40, 55}, $0681
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {41, 55}, $0681
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {37, 56}, $0681
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 56}, $0681
                set_npc_event _cc42bb
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {44, 55}, $0682
                set_npc_event _cc3b11
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {42, 54}, $0684
                set_npc_event _cc42bf
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_181:

        make_npc {13, 10}, $0682
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 9}, $0683
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 10}, $0682
                set_npc_event _cc3b11
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {9, 11}, $0685
                set_npc_event _cc4355
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_182:

        make_special_npc {33, 23}, $03a0, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {35, 23}, $03a0, {2, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {33, 25}, $03a0, {0, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {35, 25}, $03a0, {2, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {24, 34}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx CLYDE, LOCKE
                end_npc

        make_npc {15, 26}, $0300
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx WOMAN, TERRA
                end_npc

        make_npc {28, 18}, $0300
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_183:

        make_npc {50, 45}, $0300
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx TERRA
                set_npc_sprite_priority LOW
                end_npc

        make_npc {54, 45}, $0300
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {44, 54}, $0300
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {44, 51}, $0300
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {43, 56}, $0300
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {44, 57}, $0300
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {47, 52}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {45, 51}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {46, 51}, $0300
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx KATARIN, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {46, 51}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx BABY, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {52, 60}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_184:

        make_npc {16, 15}, $0300
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx TERRA
                set_npc_sprite_priority LOW
                end_npc

        make_npc {11, 23}, $03ff
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx ESPER_TERRA, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {9, 20}, $03fe
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {21, 20}, $03fe
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {22, 20}, $03fe
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {23, 20}, $03fe
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_185:

; ------------------------------------------------------------------------------

NPCProp::_186:

        make_npc {117, 30}, $0500
                set_npc_event _cb7854
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_187:

        make_npc {17, 15}, $0300
                set_npc_event _ca8cbb
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {15, 15}, $0377
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {15, 16}, $0377
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {15, 17}, $0377
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {15, 18}, $0377
                set_npc_event _ca927e
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {17, 16}, $0378
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx EDGAR, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_188:

        make_npc {8, 20}, $064f
                set_npc_event _cc69fe
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {19, 25}, $064f
                set_npc_event _cc6a06
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 19}, $064f
                set_npc_event _cc6a0a
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {17, 16}, $064f
                set_npc_event _cc6a0e
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {11, 15}, $064f
                set_npc_event _cc6a12
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {15, 7}, $064f
                set_npc_event _cc6a21
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {7, 23}, $064f
                set_npc_event _cc6a25
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {4, 7}, $0650
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {4, 7}, $0650
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx RACHEL, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {9, 20}, $0650
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, LOCKE
                end_npc

        make_npc {9, 14}, $0650
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx ESPER_TERRA, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {4, 7}, $0650
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {26, 20}, $064f
                set_npc_event _cc6a29
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {7, 11}, $064f
                set_npc_event _cc6d1e
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {26, 30}, $0680
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 31}, $0680
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {26, 31}, $0680
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {27, 31}, $0680
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 32}, $0680
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {28, 32}, $0680
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {24, 33}, $0680
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_189:

        make_npc {22, 21}, $067e
                set_npc_event _cc3b11
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {18, 25}, $067e
                set_npc_event _cc3ba2
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {14, 7}, $067e
                set_npc_event _cc3bc4
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {13, 6}, $067e
                set_npc_event _cc3bc8
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {6, 23}, $067e
                set_npc_event _cc3bcc
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 16}, $067e
                set_npc_event _cc3bda
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {10, 17}, $067e
                set_npc_event _cc3bde
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {14, 6}, $039d
                set_npc_event _cabf3e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx PLANT, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {9, 17}, $06b6
                set_npc_event _cc3510
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_190:

        make_npc {49, 41}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_191:

        make_npc {25, 15}, $0651
                set_npc_event _cc6f84
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {26, 16}, $0651
                set_npc_event _cc707f
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 13}, $064f
                set_npc_event _cc6f07
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                end_npc

        make_npc {17, 11}, $064f
                set_npc_event _cc69ca
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {24, 11}, $064f
                set_npc_event _cc6f29
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {23, 15}, $067f
                set_npc_event _cc3bf8
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_192:

; ------------------------------------------------------------------------------

NPCProp::_193:

; ------------------------------------------------------------------------------

NPCProp::_194:

        make_npc {9, 35}, $064f
                set_npc_event _cc69a6
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {15, 35}, $064f
                set_npc_event _cc69b2
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {19, 35}, $064f
                set_npc_event _cc69be
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_195:

        make_npc {37, 11}, $0650
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RACHEL, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {16, 42}, $0650
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {9, 55}, $068e
                set_npc_event _cc6d78
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, LOCKE
                end_npc

        make_npc {8, 57}, $068e
                set_npc_event _cc6d91
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx RACHEL, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0687
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 55}, $068f
                set_npc_event _cc3300
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_196:

        make_npc {54, 52}, $067a
                set_npc_event _cc68e8
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {55, 51}, $067b
                set_npc_event _cc3d73
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {54, 50}, $06a8
                set_npc_event _cc3e00
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {53, 51}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {53, 52}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {53, 53}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {54, 54}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {58, 52}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {58, 53}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {59, 51}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {59, 52}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {59, 53}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {61, 51}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {61, 52}, $067b
                set_npc_event _cc3e41
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_197:

        make_npc {37, 11}, $0650
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RACHEL, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {16, 42}, $0650
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {9, 55}, $064f
                set_npc_event _cc6d78
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, LOCKE
                end_npc

        make_npc {8, 57}, $064f
                set_npc_event _cc6d91
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx RACHEL, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_198:

        make_npc {17, 57}, $0300
                set_npc_event _cb450c
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 26}, $0300
                set_npc_event _cb4519
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {8, 45}, $0300
                set_npc_event _cb4531
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {25, 29}, $0300
                set_npc_event _cb453f
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, TERRA
                end_npc

        make_npc {6, 29}, $0300
                set_npc_event _cb4558
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {21, 31}, $0300
                set_npc_event _cb4570
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {6, 7}, $0300
                set_npc_event _cb4592
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {27, 45}, $0300
                set_npc_event _cb45f3
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {8, 42}, $0486
                set_npc_event _cb45a4
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {17, 52}, $04b1
                set_npc_event _cb45a0
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_199:

; ------------------------------------------------------------------------------

NPCProp::_200:

        make_npc {15, 20}, $0300
                set_npc_event _cb45c5
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {11, 18}, $0300
                set_npc_event _cb45c9
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {10, 20}, $0300
                set_npc_event _cb45d7
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {13, 18}, $0300
                set_npc_event _cb45ef
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {14, 14}, $04f9
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {18, 20}, $04fa
                set_npc_event _cb4e43
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {12, 20}, $0300
                set_npc_event _cb4e35
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {17, 14}, $04f7
                set_npc_dir LEFT
                set_npc_vehicle CHOCOBO
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        make_npc {17, 14}, $04f5
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx BLACKJACK, CYAN_SHADOW_SETZER
                end_npc

        make_npc {17, 18}, $04f6
                set_npc_event _cb5ec9
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx RICH_MAN, CYAN_SHADOW_SETZER
                end_npc

        make_npc {16, 18}, $04f6
                set_npc_event _cb5ed4
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {19, 24}, $0300
                set_npc_event _cb4e47
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {16, 13}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx HOOKER, TERRA
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {18, 13}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx HOOKER, TERRA
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {17, 15}, $04f4
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx MAGICITE, TERRA
                end_npc

        make_npc {17, 14}, $04f3
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx IMP, EDGAR_SABIN_CELES
                end_npc

        make_npc {17, 14}, $04f1
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, TERRA
                end_npc

        make_npc {17, 14}, $04f0
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx TREASURE_CHEST, VEHICLE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_201:

        make_npc {34, 15}, $0300
                set_npc_event _cb4460
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {31, 14}, $0499
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx TERRA
                end_npc

        make_npc {37, 15}, $049a
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                end_npc

        make_npc {35, 15}, $049b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CYAN
                end_npc

        make_npc {32, 17}, $049c
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SHADOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {33, 15}, $049d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                end_npc

        make_npc {37, 14}, $049e
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx CELES
                end_npc

        make_npc {36, 19}, $049f
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {37, 19}, $04a0
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RELM
                end_npc

        make_npc {30, 18}, $04a1
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SETZER
                end_npc

        make_npc {34, 18}, $04a2
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOW
                set_npc_gfx GAU_KUNG_FU, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {34, 18}, $04a3
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOW
                set_npc_gfx GAU_BANDANA, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_202:

        make_npc {54, 16}, $0300
                set_npc_event _cb4484
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_203:

        make_npc {58, 45}, $0300
                set_npc_event _cb4478
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_204:

        make_npc {39, 43}, $0300
                set_npc_event _cb446c
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_205:

        make_npc {86, 38}, $0300
                set_npc_event _ca7a8d
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_vehicle CHOCOBO
                set_npc_speed SLOWER
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {85, 45}, $0300
                set_npc_event _cb44cd
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_206:

        make_npc {14, 53}, $0300
                set_npc_event _cb4490
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {12, 55}, $0300
                set_npc_event _cb45a8
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {17, 41}, $04a4
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx TERRA
                end_npc

        make_npc {18, 43}, $04a5
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                end_npc

        make_npc {20, 43}, $04a6
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx CYAN
                end_npc

        make_npc {15, 45}, $04a7
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SHADOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {17, 39}, $04a8
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                end_npc

        make_npc {17, 44}, $04a9
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx CELES
                end_npc

        make_npc {17, 46}, $04aa
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {18, 46}, $04ab
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RELM
                end_npc

        make_npc {14, 40}, $04ac
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_207:

        make_npc {81, 49}, $0492
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                end_npc

        make_npc {81, 51}, $0493
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        make_npc {88, 50}, $0494
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {90, 50}, $0495
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {92, 50}, $0496
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {87, 41}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {73, 50}, $04ad
                set_npc_event _cb4a4e
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx TREASURE_CHEST, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {75, 49}, $04ae
                set_npc_event _cb4a8e
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx TREASURE_CHEST, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {77, 50}, $04af
                set_npc_event _cb4acd
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx TREASURE_CHEST, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {79, 49}, $04b0
                set_npc_event _cb4b0c
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx TREASURE_CHEST, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {107, 51}, $04b2
                set_npc_event _cb49f3
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_208:

        make_special_npc {74, 8}, $048f, {0, 0}
                set_npc_32x32
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CHADARNOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {74, 10}, $0490, {2, 0}
                set_npc_master 1, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CHADARNOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {75, 10}, $0491, {3, 0}
                set_npc_master 2, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CHADARNOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {75, 11}, $0487
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx RELM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {75, 14}, $0488
                set_npc_event _cb4cfa
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx OWZER_1, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {76, 14}, $0488
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx OWZER_2, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_209:

        make_npc {117, 19}, $032f
                set_npc_event _ca9337
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {124, 14}, $0300
                set_npc_event _ca93ef
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx RICH_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {118, 25}, $0331
                set_npc_event _ca93fa
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {99, 21}, $0492
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {99, 21}, $04f2
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx ULTROS, MOG_UMARO
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_210:

        make_special_npc {13, 39}, $03a0, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {15, 39}, $03a0, {2, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {13, 41}, $03a0, {0, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {15, 41}, $03a0, {2, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_211:

        make_special_npc {7, 3}, $03a0, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {9, 3}, $03a0, {2, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {7, 5}, $03a0, {0, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {9, 5}, $03a0, {2, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_212:

        make_special_npc {84, 26}, $03a0, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {86, 26}, $03a0, {2, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {84, 28}, $03a0, {0, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {86, 28}, $03a0, {2, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_213:

        make_special_npc {21, 16}, $03a0, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {23, 16}, $03a0, {2, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {21, 18}, $03a0, {0, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {23, 18}, $03a0, {2, 2}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_214:

; ------------------------------------------------------------------------------

NPCProp::_215:

        make_special_npc {4, 4}, $0300, {0, 1}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx FALCON_1, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {6, 4}, $0300, {0, 0}
                set_npc_speed SLOWER
                set_npc_gfx FALCON_2, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {6, 5}, $0300, {1, 0}
                set_npc_speed SLOWER
                set_npc_gfx FALCON_3, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {5, 15}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {4, 15}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {5, 15}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {6, 15}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {2, 9}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {3, 8}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {4, 10}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {13, 2}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {15, 3}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {11, 0}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {10, 1}, $0300, {4, 0}
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_216:

        make_npc {41, 8}, $0300
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {38, 8}, $0300
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_bg2_scroll
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {41, 8}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx BABY, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {42, 9}, $0300
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx MADUIN, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_217:

        make_npc {32, 11}, $0337
                set_npc_event _ca9d36
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx YURA, CYAN_SHADOW_SETZER
                end_npc

        make_npc {32, 11}, $0338
                set_npc_event _ca9eb2
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {34, 26}, $033d
                set_npc_event _ca9e92
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx WOLF, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {28, 30}, $033d
                set_npc_event _ca9ea0
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx FAERIE, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {37, 38}, $033d
                set_npc_event _ca9eae
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx FAERIE, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 24}, $033e
                set_npc_event _ca9e3e
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx ESPER_ELDER, CYAN_SHADOW_SETZER
                end_npc

        make_npc {32, 6}, $03ff
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {33, 7}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {33, 7}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {32, 18}, $035c
                set_npc_event _ca9e42
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx ESPER_ELDER, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_218:

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {55, 34}, $0357
                set_npc_event _ca9fbf
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {55, 35}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx BABY, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {55, 43}, $035d
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {54, 47}, $035d
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {56, 45}, $035d
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_special_npc {53, 29}, $0300, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx GATE_1, VEHICLE
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {56, 29}, $0300, {4, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx GATE_1, VEHICLE
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_219:

        make_npc {46, 42}, $0339
                set_npc_event _ca9f26
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {47, 42}, $035b
                set_npc_event _ca9fa2
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {47, 45}, $033a
                set_npc_event _ca9d68
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx FAERIE, TERRA
                end_npc

        make_npc {40, 50}, $033b
                set_npc_event _ca9dcf
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx ESPER_ELDER, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {38, 50}, $033c
                set_npc_event _ca9e46
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx WOLF, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {46, 42}, $035a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx BABY, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 50}, $033c
                set_npc_event _ca9e68
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx FAERIE, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {8, 47}, $033c
                set_npc_event _ca9e76
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx WOLF, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {5, 10}, $033c
                set_npc_event _ca9e84
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_220:

; ------------------------------------------------------------------------------

NPCProp::_221:

        make_special_npc {35, 42}, $0300, {1, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {35, 43}, $0300, {2, 0}
                set_npc_master 0, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {35, 42}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {35, 42}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {35, 42}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {35, 42}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {35, 42}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {57, 41}, $0330
                set_npc_event _ca950b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 59}, $0300
                set_npc_event _ca950f
                set_npc_no_react
                set_npc_anim ONE_FRAME, KNOCKED_OUT
                set_npc_speed SLOW
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {43, 29}, $0300
                set_npc_event _ca9513
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MERCHANT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 37}, $0300
                set_npc_event _ca957e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {41, 32}, $0300
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx WOMAN, TERRA
                end_npc

        make_npc {44, 53}, $0300
                set_npc_no_react
                set_npc_anim ONE_FRAME, KNOCKED_OUT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, TERRA
                end_npc

        make_npc {30, 14}, $034a
                set_npc_event _ca96a9
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx VARGAS, VEHICLE
                end_npc

        make_npc {49, 35}, $0356
                set_npc_event _ca95b4
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {13, 34}, $0300
                set_npc_event _ca957e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {59, 44}, $0384
                set_npc_event _ca9542
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                end_npc

        make_npc {63, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {59, 43}, $0385
                set_npc_event _cc36a6
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_222:

; ------------------------------------------------------------------------------

NPCProp::_223:

; ------------------------------------------------------------------------------

NPCProp::_224:

; ------------------------------------------------------------------------------

NPCProp::_225:

        make_npc {53, 51}, $0300
                set_npc_event _ca9586
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {59, 32}, $0300
                set_npc_event _ca9594
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {54, 31}, $0300
                set_npc_event _ca9598
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {53, 26}, $0300
                set_npc_event _ca959c
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {53, 20}, $0300
                set_npc_event _ca95a0
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {52, 15}, $0300
                set_npc_event _ca95a4
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {54, 14}, $0300
                set_npc_event _ca95a8
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {50, 11}, $0300
                set_npc_event _ca95ac
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {48, 15}, $0300
                set_npc_event _ca95b0
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {106, 19}, $0300
                set_npc_event _ca9582
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {11, 38}, $0300
                set_npc_event _ca957a
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {123, 49}, $0300
                set_npc_event _ca9576
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_226:

        make_npc {81, 17}, $0314
                set_npc_event _ca9749
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx ESPER_TERRA, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {84, 17}, $031e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RAMUH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {84, 17}, $031f
                set_npc_event _caa7f5
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {82, 11}, $0320
                set_npc_event _caac91
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {81, 12}, $0321
                set_npc_event _caaca0
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {83, 12}, $0322
                set_npc_event _caacaf
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {82, 32}, $0323
                set_npc_event _caa890
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx LOCKE
                end_npc

        make_npc {83, 33}, $0324
                set_npc_event _caa890
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {82, 35}, $0325
                set_npc_event _caa890
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {80, 34}, $0326
                set_npc_event _caa890
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

        make_npc {81, 35}, $0327
                set_npc_event _caa890
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx CELES
                end_npc

        make_npc {82, 36}, $0328
                set_npc_event _caa890
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GAU
                end_npc

        make_npc {80, 17}, $0333
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {81, 14}, $0334
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {82, 15}, $0335
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

        make_npc {79, 18}, $0336
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx GAU
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_227:

; ------------------------------------------------------------------------------

NPCProp::_228:

; ------------------------------------------------------------------------------

NPCProp::_229:

; ------------------------------------------------------------------------------

NPCProp::_230:

; ------------------------------------------------------------------------------

NPCProp::_231:

        make_npc {16, 17}, $03f4
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                end_npc

        make_npc {17, 17}, $03f4
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, TERRA
                end_npc

        make_npc {16, 19}, $0347
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {14, 21}, $0347
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, TERRA
                end_npc

        make_npc {17, 22}, $0347
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, TERRA
                end_npc

        make_npc {13, 21}, $0347
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        make_npc {18, 22}, $0347
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        make_npc {17, 46}, $0351
                set_npc_event _cab714
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {18, 46}, $0352
                set_npc_event _cab718
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

        make_npc {19, 46}, $0353
                set_npc_event _cab71c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {20, 46}, $0354
                set_npc_event _cab720
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GAU
                end_npc

        make_npc {13, 20}, $0348
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {14, 20}, $0348
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {18, 20}, $0348
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {19, 20}, $0348
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {16, 22}, $0346
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {17, 22}, $0346
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {15, 46}, $03f4
                set_npc_event _cab724
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {17, 17}, $03ff
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {17, 7}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, MOG_UMARO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 20}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        make_npc {14, 11}, $03ff
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx SETZER
                end_npc

        make_npc {16, 18}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx CELES_CHAINS, EDGAR_SABIN_CELES
                end_npc

        make_npc {16, 45}, $036f
                set_npc_event _caae11
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 16}, $0387
                set_npc_event _ca9e84
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_bg2_scroll
                set_npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_232:

        make_npc {117, 4}, $0355
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {118, 29}, $0300
                set_npc_event _cab455
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_233:

        make_npc {16, 17}, $03f4
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                end_npc

        make_npc {17, 17}, $03f4
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, TERRA
                end_npc

        make_npc {16, 19}, $0347
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {14, 21}, $0347
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, TERRA
                end_npc

        make_npc {17, 22}, $0347
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, TERRA
                end_npc

        make_npc {13, 21}, $0347
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        make_npc {18, 22}, $0347
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        make_npc {17, 46}, $0351
                set_npc_event _cab714
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {18, 46}, $0352
                set_npc_event _cab718
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

        make_npc {19, 46}, $0353
                set_npc_event _cab71c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {20, 46}, $0354
                set_npc_event _cab720
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GAU
                end_npc

        make_npc {13, 20}, $0348
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {14, 20}, $0348
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {18, 20}, $0348
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {19, 20}, $0348
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {16, 22}, $0346
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {17, 22}, $0346
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {15, 46}, $03f4
                set_npc_event _cab724
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {17, 17}, $03ff
                set_npc_dir DOWN
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {17, 7}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, MOG_UMARO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 20}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        make_npc {14, 11}, $03ff
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx SETZER
                end_npc

        make_npc {16, 18}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx CELES_CHAINS, EDGAR_SABIN_CELES
                end_npc

        make_npc {16, 45}, $036f
                set_npc_event _caae11
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 16}, $0387
                set_npc_event _ca9e84
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_bg2_scroll
                set_npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_234:

        make_npc {15, 46}, $0300
                set_npc_event _cab724
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {16, 23}, $03ff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                set_npc_sprite_priority LOW
                end_npc

        make_npc {25, 23}, $0343
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                set_npc_sprite_priority LOW
                end_npc

        make_npc {23, 24}, $03ff
                set_npc_dir LEFT
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {23, 25}, $03ff
                set_npc_dir LEFT
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {23, 26}, $03ff
                set_npc_dir LEFT
                set_npc_vehicle CHOCOBO, SHOW_RIDER
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {16, 22}, $0344
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_bg2_scroll
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                set_npc_sprite_priority LOW
                end_npc

        make_npc {17, 46}, $0351
                set_npc_event _cab714
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {18, 46}, $0352
                set_npc_event _cab718
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SABIN
                end_npc

        make_npc {19, 46}, $0353
                set_npc_event _cab71c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx CYAN
                end_npc

        make_npc {20, 46}, $0354
                set_npc_event _cab720
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GAU
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_235:

        make_npc {16, 17}, $0349
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {17, 21}, $0349
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx RICH_MAN, TERRA
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {16, 21}, $0349
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {14, 22}, $0349
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, TERRA
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {17, 23}, $0349
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, TERRA
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {13, 22}, $0349
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {18, 23}, $0349
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx FIGARO_GUARD, LOCKE
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {15, 7}, $034b
                set_npc_event _cabf4b
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, MOG_UMARO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 11}, $034c
                set_npc_event _cac368
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 15}, $034d
                set_npc_event _cac37b
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {18, 14}, $034e
                set_npc_event _cac38e
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {21, 7}, $034f
                set_npc_event _cac3a1
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 12}, $0350
                set_npc_event _cac3b4
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {16, 7}, $0300
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {16, 16}, $0387
                set_npc_event _ca9e84
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_bg2_scroll
                set_npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_236:

        make_npc {12, 19}, $03ff
                set_npc_event _cabf27
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 0}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, SLOW
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 15}, $03ff
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx CHANCELLOR, TERRA
                end_npc

        make_npc {12, 14}, $0300
                set_npc_event _cabd35
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_237:

        make_npc {117, 4}, $0355
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {118, 29}, $0300
                set_npc_event _cab455
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {60, 48}, $0340
                set_npc_event _caae15
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {59, 44}, $0332
                set_npc_event _caae0d
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        make_npc {60, 48}, $0341
                set_npc_event _caadf1
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {77, 39}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {71, 32}, $0342
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, MOG_UMARO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {72, 34}, $0366
                set_npc_event _cabf3e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {54, 39}, $0300
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {66, 39}, $0300
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {60, 41}, $0386
                set_npc_event _caadff
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_238:

        make_npc {99, 20}, $0345
                set_npc_event _cabf31
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {117, 4}, $0355
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {118, 29}, $0300
                set_npc_event _cab455
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_239:

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_240:

        make_npc {53, 13}, $06a3
                set_npc_dir RIGHT
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {64, 12}, $06a3, {2, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_1, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {64, 13}, $06a3, {3, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_3, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {65, 12}, $06a3, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_2, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {65, 13}, $06a3, {5, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_4, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {0, 0}, $0644
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {0, 0}, $0644
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {0, 0}, $0644
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {50, 50}, $0644
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx SETZER
                end_npc

        make_npc {58, 7}, $06ae
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_241:

        make_special_npc {16, 5}, $0644, {2, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx CRANE_1, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {16, 6}, $0644, {0, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {17, 6}, $0644, {1, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_3, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {16, 7}, $0644, {0, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {19, 5}, $0644, {4, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx CRANE_1, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {20, 6}, $0644, {6, 0}
                set_npc_h_flip
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {19, 6}, $0644, {7, 0}
                set_npc_h_flip
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_3, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {20, 7}, $0644, {6, 0}
                set_npc_h_flip
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {16, 5}, $0644, {0, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {20, 5}, $0644, {6, 0}
                set_npc_h_flip
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {16, 6}, $0644, {0, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {20, 6}, $0644, {6, 0}
                set_npc_h_flip
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {16, 7}, $0644, {0, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {20, 7}, $0644, {6, 0}
                set_npc_h_flip
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx CRANE_2, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_242:

        make_npc {45, 39}, $063b
                set_npc_event _cc9627
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {54, 39}, $062b
                set_npc_event _cc93ce
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {55, 40}, $062b
                set_npc_event _cc93ce
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        make_npc {54, 41}, $062b
                set_npc_event _cc93ce
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {37, 48}, $062b
                set_npc_event _cc936d
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {29, 15}, $062b
                set_npc_event _cc93e8
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 39}, $062b
                set_npc_event _cc93e4
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {34, 28}, $062b
                set_npc_event _cc9443
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {18, 37}, $062b
                set_npc_event _cc942f
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {15, 45}, $062b
                set_npc_event _cc9447
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {24, 6}, $062b
                set_npc_event _cc941e
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {34, 6}, $062b
                set_npc_event _cc941e
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {24, 14}, $062b
                set_npc_event _cc941e
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {34, 14}, $062b
                set_npc_event _cc941e
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {22, 21}, $062b
                set_npc_event _cc93e8
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {14, 29}, $062b
                set_npc_event _cc93e8
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_special_npc {31, 57}, $064c, {0, 0}
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_1, RAINBOW
                end_npc

        make_special_npc {31, 58}, $064c, {1, 0}
                set_npc_master 16, 1, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_2, RAINBOW
                end_npc

        make_special_npc {31, 59}, $064c, {2, 0}
                set_npc_master 16, 2, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_3, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {32, 57}, $064c, {0, 1}
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_4, RAINBOW
                end_npc

        make_special_npc {32, 58}, $064c, {1, 1}
                set_npc_master 19, 1, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_5, RAINBOW
                end_npc

        make_special_npc {32, 59}, $064c, {2, 1}
                set_npc_master 19, 2, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_6, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {33, 57}, $064c, {3, 1}
                set_npc_h_flip
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_1, RAINBOW
                end_npc

        make_special_npc {33, 58}, $064c, {4, 1}
                set_npc_h_flip
                set_npc_master 22, 1, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_2, RAINBOW
                end_npc

        make_special_npc {33, 59}, $064c, {5, 1}
                set_npc_h_flip
                set_npc_master 22, 2, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_3, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {57, 3}, $064d
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {58, 3}, $064d
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {59, 3}, $064d
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_243:

        make_npc {0, 21}, $062c
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {18, 13}, $062c
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {15, 13}, $062c
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        make_npc {12, 14}, $062b
                set_npc_event _cc873b
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {18, 14}, $062b
                set_npc_event _cc8782
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 13}, $062c
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {8, 18}, $0634
                set_npc_event _cc8796
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 14}, $0634
                set_npc_event _cc873b
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {18, 14}, $0634
                set_npc_event _cc8782
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_244:

        make_npc {18, 13}, $062a
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {18, 17}, $062c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {17, 14}, $062c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        make_npc {19, 14}, $062c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx CELES
                end_npc

        make_npc {20, 13}, $062c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

        make_npc {21, 14}, $062c
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {19, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {20, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {21, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {22, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {23, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {24, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {25, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {11, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {13, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {14, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {15, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {17, 23}, $062c
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {11, 23}, $062f
                set_npc_event _cc86eb
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {25, 23}, $062f
                set_npc_event _cc86ff
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 14}, $062f
                set_npc_event _cc8713
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {20, 14}, $062f
                set_npc_event _cc8727
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {10, 17}, $0634
                set_npc_event _cc87a6
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {18, 24}, $0636
                set_npc_event _cc92b1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_245:

        make_npc {16, 50}, $062b
                set_npc_event _cc9455
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {17, 50}, $062b
                set_npc_event _cc9459
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {7, 53}, $062b
                set_npc_event _cc945d
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_246:

        make_npc {29, 10}, $063c
                set_npc_event _ccd2a1
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_247:

        make_npc {51, 13}, $062b
                set_npc_event _cc95f3
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {43, 14}, $062b
                set_npc_event _cc95ff
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {45, 11}, $062b
                set_npc_event _cc95f7
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {48, 10}, $062b
                set_npc_event _cc95fb
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 13}, $0637
                set_npc_event _cc929f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GAU
                end_npc

        make_npc {45, 13}, $0638
                set_npc_event _cc92a8
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MOG
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_248:

        make_npc {8, 10}, $063c
                set_npc_event _ccd2a4
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_249:

        make_npc {20, 29}, $063c
                set_npc_event _cc9371
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {18, 30}, $062b
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {22, 30}, $062b
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_250:

        make_npc {21, 24}, $062f
                set_npc_event _cc8637
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {25, 24}, $062f
                set_npc_event _cc864b
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {21, 18}, $062f
                set_npc_event _cc865f
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {25, 18}, $062f
                set_npc_event _cc8673
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {23, 31}, $062d
                set_npc_event _cc83c6
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        make_npc {54, 15}, $062e
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {53, 9}, $062c
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {52, 13}, $062f
                set_npc_event _cc83ca
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        make_npc {56, 13}, $062f
                set_npc_event _cc83d4
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        make_npc {98, 51}, $062f
                set_npc_event _cc86d7
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {76, 49}, $062f
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {16, 30}, $0630
                set_npc_event _cc83c6
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {30, 30}, $0630
                set_npc_event _cc83c6
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {112, 52}, $062c
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx TERRA
                end_npc

        make_npc {51, 50}, $0634
                set_npc_event _cc87b6
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {9, 49}, $0634
                set_npc_event _cc87f9
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {110, 51}, $0634
                set_npc_event _cc8809
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {120, 13}, $0634
                set_npc_event _cc884c
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {115, 16}, $0634
                set_npc_event _cc885c
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 19}, $0636
                set_npc_event _cc9284
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                set_npc_movement RANDOM
                end_npc

        make_npc {82, 57}, $0636
                set_npc_event _cc9296
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx CYAN
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_251:

        make_npc {80, 16}, $062c
                set_npc_event _cc8a3f
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {71, 16}, $0635
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        make_npc {76, 16}, $062c
                set_npc_event _cc8a47
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {78, 16}, $062c
                set_npc_event _cc8a47
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {82, 16}, $062c
                set_npc_event _cc8a47
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {84, 16}, $062c
                set_npc_event _cc8a47
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EMPEROR_SERVANT, TERRA
                set_npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        make_npc {71, 20}, $062c
                set_npc_event _cc8a43
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {72, 22}, $062c
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {80, 27}, $062c
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {81, 27}, $062c
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {79, 27}, $062c
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_252:

        make_npc {40, 56}, $062f
                set_npc_event _cc8687
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {42, 52}, $062f
                set_npc_event _cc869b
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {42, 56}, $062f
                set_npc_event _cc86af
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {37, 57}, $062f
                set_npc_event _cc86c3
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {42, 57}, $0634
                set_npc_event _cc886c
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {40, 54}, $0634
                set_npc_event _cc88af
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_253:

        make_npc {22, 6}, $0636
                set_npc_event _cc928d
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SABIN
                set_npc_movement RANDOM
                end_npc

        make_npc {33, 5}, $0652
                set_npc_event _cc92b5
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {25, 6}, $0652
                set_npc_event _cc92c3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx ARVIS, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {29, 5}, $0652
                set_npc_event _cc92d1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 20}, $0652
                set_npc_event _cc92d1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 43}, $0652
                set_npc_event _cc92d1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {19, 48}, $0652
                set_npc_event _cc92d1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {35, 52}, $0652
                set_npc_event _cc92d1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {0, 0}, $0652
                set_npc_event _cc92d1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx PILOT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {21, 23}, $0652
                set_npc_event _cc92df
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {21, 29}, $0652
                set_npc_event _cc92df
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {19, 39}, $0652
                set_npc_event _cc92df
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {18, 37}, $0652
                set_npc_event _cc92df
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {25, 50}, $0652
                set_npc_event _cc92df
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {19, 29}, $0652
                set_npc_event _cc92df
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx NARSHE_GUARD, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_254:

        make_special_npc {39, 9}, $0300, {3, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {67, 0}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {67, 1}, $0300, {0, 0}
                set_npc_master 1, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {67, 2}, $0300, {0, 0}
                set_npc_master 1, 2, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {67, 3}, $0300, {0, 0}
                set_npc_master 1, 3, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {67, 4}, $0300, {0, 0}
                set_npc_master 1, 4, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {67, 5}, $0300, {1, 0}
                set_npc_master 1, 5, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {67, 6}, $0300, {2, 0}
                set_npc_master 1, 6, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {81, 5}, $0300, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx BIG_SWITCH, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {83, 6}, $0300, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx BIG_SWITCH, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {84, 6}, $0300, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx BIG_SWITCH, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {86, 6}, $0300, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx BIG_SWITCH, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {87, 6}, $0300, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx BIG_SWITCH, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {89, 5}, $0300, {4, 0}
                set_npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx BIG_SWITCH, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EYES, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_255:

        make_npc {12, 14}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {6, 10}, $03ff
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {6, 10}, $03ff
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {6, 10}, $03ff
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {6, 10}, $03ff
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_256:

; ------------------------------------------------------------------------------

NPCProp::_257:

; ------------------------------------------------------------------------------

NPCProp::_258:

; ------------------------------------------------------------------------------

NPCProp::_259:

        make_special_npc {12, 7}, $0300, {0, 1}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx FALCON_1, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {14, 7}, $0300, {1, 0}
                set_npc_speed SLOWER
                set_npc_gfx FALCON_2, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {14, 8}, $0300, {2, 0}
                set_npc_speed SLOWER
                set_npc_gfx FALCON_3, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_260:

        make_npc {5, 8}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx BANDANA, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 8}, $0300
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx ESPER_TERRA, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_261:

        make_special_npc {16, 27}, $0300, {0, 2}
                set_npc_master 10, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed FAST
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {15, 28}, $0300, {0, 2}
                set_npc_master 10, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed FAST
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {16, 28}, $0300, {0, 2}
                set_npc_master 10, 5, DOWN
                _npc_is_slave .set 0
                set_npc_speed FAST
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {17, 28}, $0300, {0, 2}
                set_npc_master 10, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_speed FAST
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {57, 45}, $0300
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_special_npc {14, 6}, $0300, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {14, 7}, $0300, {0, 0}
                set_npc_master 5, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {14, 8}, $0300, {0, 0}
                set_npc_master 5, 2, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {14, 9}, $0300, {0, 0}
                set_npc_master 5, 3, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {14, 10}, $0300, {0, 0}
                set_npc_master 5, 4, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {14, 11}, $0300, {1, 0}
                set_npc_master 5, 5, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {14, 12}, $0300, {2, 0}
                set_npc_master 5, 6, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_262:

        make_special_npc {24, 25}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {24, 28}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {24, 31}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {24, 34}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {5, 16}, $0644, {0, 2}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 17}, $0644, {0, 2}
                set_npc_master 4, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 18}, $0644, {0, 2}
                set_npc_master 4, 2, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 19}, $0644, {0, 2}
                set_npc_master 4, 3, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 20}, $0644, {1, 2}
                set_npc_master 4, 4, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 21}, $0644, {2, 2}
                set_npc_master 4, 5, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {6, 31}, $0644, {4, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed SLOW
                set_npc_gfx ELEVATOR, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {9, 54}, $0644, {4, 0}
                set_npc_32x32
                set_npc_speed SLOW
                set_npc_gfx ELEVATOR, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_263:

        make_special_npc {25, 22}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                set_npc_layer_priority BACKGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {30, 27}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {28, 27}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {26, 27}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {24, 29}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {22, 31}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_special_npc {32, 27}, $0644, {0, 0}
                set_npc_32x32
                set_npc_speed SLOWER
                set_npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        make_npc {40, 39}, $0645
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {36, 41}, $0645
                set_npc_event _cc7937
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx IFRIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {37, 40}, $0645
                set_npc_event _cc7992
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx SHIVA, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {17, 26}, $0644, {2, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {17, 28}, $0644, {2, 1}
                set_npc_master 10, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {42, 41}, $0644, {4, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed SLOW
                set_npc_gfx ELEVATOR, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_264:

        make_special_npc {6, 1}, $0644, {2, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {6, 2}, $0644, {2, 0}
                set_npc_master 0, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {6, 3}, $0644, {3, 0}
                set_npc_master 0, 2, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {6, 4}, $0644, {2, 1}
                set_npc_master 0, 3, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {3, 8}, $0646
                set_npc_event _cc7937
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOW
                set_npc_gfx IFRIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {9, 6}, $0646
                set_npc_event _cc7992
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOW
                set_npc_gfx SHIVA, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {3, 8}, $0647
                set_npc_event _cc79cd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {9, 6}, $0648
                set_npc_event _cc79dd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_265:

; ------------------------------------------------------------------------------

NPCProp::_266:

        make_npc {8, 0}, $0644
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        make_special_npc {7, 0}, $0644, {4, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed NORMAL
                set_npc_gfx ELEVATOR, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_267:

; ------------------------------------------------------------------------------

NPCProp::_268:

        make_npc {31, 27}, $0300
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx ESPER_TERRA, RAINBOW
                end_npc

        make_npc {18, 32}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_269:

; ------------------------------------------------------------------------------

NPCProp::_270:

        make_npc {25, 10}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_271:

; ------------------------------------------------------------------------------

NPCProp::_272:

        make_npc {9, 51}, $0644
                set_npc_event _cc8022
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        make_special_npc {8, 50}, $0644, {0, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed SLOW
                set_npc_gfx ELEVATOR, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {3, 55}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {11, 52}, $0644, {2, 0}
                set_npc_master 3, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_1, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {11, 53}, $0644, {3, 0}
                set_npc_master 3, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_3, VEHICLE
                set_npc_sprite_priority HIGH
                end_npc

        make_special_npc {12, 52}, $0644, {4, 0}
                set_npc_master 5, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_2, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {12, 53}, $0644, {5, 0}
                set_npc_master 5, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx MAGITEK_TRAIN_4, VEHICLE
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_273:

        make_npc {25, 51}, $0649
                set_npc_event _cc79ed
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOW
                set_npc_gfx NUMBER_024, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_274:

        make_npc {4, 7}, $064a
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx PHANTOM, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {4, 14}, $064a
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx UNICORN, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {4, 21}, $064a
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx BISMARK, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {15, 7}, $064a
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx CARBUNCL, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {15, 14}, $064a
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx SHOAT, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {15, 21}, $064a
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx MADUIN, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {4, 7}, $0645
                set_npc_event _cc79cd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {4, 14}, $0645
                set_npc_event _cc79cd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {4, 21}, $0645
                set_npc_event _cc79cd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {15, 7}, $0645
                set_npc_event _cc79cd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {15, 14}, $0645
                set_npc_event _cc79cd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {15, 21}, $0645
                set_npc_event _cc79cd
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {20, 17}, $0644
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {10, 23}, $0645
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {9, 23}, $0645
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, TERRA
                end_npc

        make_npc {11, 23}, $0645
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, TERRA
                end_npc

        make_npc {10, 25}, $064b
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        make_special_npc {10, 8}, $0644, {2, 0}
                set_npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx BIG_SWITCH, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {20, 17}, $0644, {4, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed SLOW
                set_npc_gfx ELEVATOR, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_275:

; ------------------------------------------------------------------------------

NPCProp::_276:

        make_npc {38, 30}, $0500
                set_npc_event _cb8251
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx TRAIN_CONDUCTOR, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {32, 32}, $0500
                set_npc_event _cb8251
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx TRAIN_CONDUCTOR, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {45, 30}, $0500
                set_npc_event _cb8251
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx TRAIN_CONDUCTOR, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_277:

; ------------------------------------------------------------------------------

NPCProp::_278:

        make_npc {8, 5}, $054b
                set_npc_event _cb81c6
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_279:

        make_npc {24, 4}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_280:

; ------------------------------------------------------------------------------

NPCProp::_281:

; ------------------------------------------------------------------------------

NPCProp::_282:

; ------------------------------------------------------------------------------

NPCProp::_283:

        make_npc {57, 15}, $0659
                set_npc_event _ccd6eb
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx SKULL_STATUE, CYAN_SHADOW_SETZER
                end_npc

        make_npc {59, 13}, $065b
                set_npc_event _ccd793
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx UMARO, MOG_UMARO
                end_npc

        make_npc {57, 15}, $065a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_284:

        make_npc {26, 21}, $0656
                set_npc_event _cc64ae
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {27, 21}, $065c
                set_npc_event _cc64c6
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {14, 9}, $0656
                set_npc_event _cc64fa
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {20, 14}, $065c
                set_npc_event _cc707f
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {23, 14}, $065c
                set_npc_event _cc707f
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {21, 12}, $065c
                set_npc_event _cc64ce
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {19, 13}, $065c
                set_npc_event _cc64d2
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {22, 16}, $065c
                set_npc_event _cc64d6
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {22, 12}, $065c
                set_npc_event _cc64da
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {23, 12}, $065c
                set_npc_event _cc64de
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {8, 21}, $0656
                set_npc_event _cc64e2
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 20}, $0656
                set_npc_event _cc6526
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx HOOKER, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {8, 14}, $0656
                set_npc_event _cc650e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {26, 8}, $0656
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {19, 15}, $065c
                set_npc_event _cc64ca
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {21, 16}, $065c
                set_npc_event _cc6551
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {21, 15}, $065d
                set_npc_event _cc6555
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 9}, $067c
                set_npc_event _cc3f12
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {23, 8}, $0657
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {29, 6}, $069a
                set_npc_event _cc656b
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {7, 24}, $069a
                set_npc_event _cc6563
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_285:

        make_npc {33, 48}, $0512
                set_npc_event _cba3c0
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {32, 47}, $0512
                set_npc_event _cba3c0
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {34, 47}, $0512
                set_npc_event _cba3c0
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_286:

; ------------------------------------------------------------------------------

NPCProp::_287:

; ------------------------------------------------------------------------------

NPCProp::_288:

        make_npc {46, 48}, $0656
                set_npc_event _cc6587
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {57, 38}, $069a
                set_npc_event _cc6567
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_289:

        make_npc {54, 16}, $0656
                set_npc_event _cc656f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_290:

        make_npc {44, 8}, $0656
                set_npc_event _cc657b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_291:

        make_special_npc {11, 10}, $06bb, {0, 0}
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_1, VEHICLE
                end_npc

        make_special_npc {0, 0}, $06bb, {1, 0}
                set_npc_master 0, 1, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_2, VEHICLE
                end_npc

        make_special_npc {0, 0}, $06bb, {2, 0}
                set_npc_master 0, 2, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_3, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {12, 10}, $06bb, {0, 1}
                set_npc_master 3, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_4, VEHICLE
                end_npc

        make_special_npc {0, 0}, $06bb, {1, 1}
                set_npc_master 3, 1, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_5, VEHICLE
                end_npc

        make_special_npc {0, 0}, $06bb, {2, 1}
                set_npc_master 3, 2, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_6, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {13, 10}, $06bb, {3, 1}
                set_npc_h_flip
                set_npc_master 6, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_1, VEHICLE
                end_npc

        make_special_npc {0, 0}, $06bb, {4, 1}
                set_npc_h_flip
                set_npc_master 6, 1, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_2, VEHICLE
                end_npc

        make_special_npc {0, 0}, $06bb, {5, 1}
                set_npc_h_flip
                set_npc_master 6, 2, DOWN
                set_npc_speed SLOWER
                set_npc_gfx GUARDIAN_3, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

        make_npc {12, 12}, $06ba
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_292:

        make_special_npc {87, 12}, $06a4, {4, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_293:

; ------------------------------------------------------------------------------

NPCProp::_294:

; ------------------------------------------------------------------------------

NPCProp::_295:

; ------------------------------------------------------------------------------

NPCProp::_296:

; ------------------------------------------------------------------------------

NPCProp::_297:

; ------------------------------------------------------------------------------

NPCProp::_298:

; ------------------------------------------------------------------------------

NPCProp::_299:

        make_npc {100, 13}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {56, 19}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx TURTLE, VEHICLE
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_300:

        make_npc {72, 12}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx TURTLE, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {76, 16}, $0396
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {122, 14}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_301:

        make_npc {20, 5}, $03ff
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx DARILL, TERRA
                end_npc

        make_npc {18, 5}, $03ff
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx SETZER
                end_npc

        make_npc {7, 19}, $03ff
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx DARILL, TERRA
                end_npc

        make_npc {7, 17}, $03ff
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx SETZER
                end_npc

        make_npc {28, 6}, $0300
                set_npc_event _ca43d9
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_302:

        make_npc {11, 30}, $0300
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {23, 29}, $0300
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {23, 37}, $0300
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {38, 22}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {27, 18}, $0300
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {37, 16}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {43, 21}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {22, 20}, $0300
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {19, 22}, $0300
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {44, 13}, $0300
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx GIRL, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {41, 16}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 21}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 20}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_303:

; ------------------------------------------------------------------------------

NPCProp::_304:

; ------------------------------------------------------------------------------

NPCProp::_305:

        make_npc {29, 3}, $0666
                set_npc_event _cc5ddd
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {15, 8}, $066c
                set_npc_event _cc5976
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SABIN
                end_npc

        make_npc {18, 9}, $066a
                set_npc_event _cc5ac9
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {19, 10}, $0668
                set_npc_event _cc5add
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {19, 11}, $066a
                set_npc_event _cc5acd
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {24, 21}, $0668
                set_npc_event _cc5ae1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {19, 10}, $066a
                set_npc_event _cc5ad1
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {17, 22}, $0668
                set_npc_event _cc5ae5
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {18, 13}, $066a
                set_npc_event _cc5ad5
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {26, 24}, $0668
                set_npc_event _cc5ae9
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {18, 14}, $066a
                set_npc_event _cc5ad9
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 27}, $0668
                set_npc_event _cc5aed
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {27, 10}, $0668
                set_npc_event _cc5af1
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {6, 12}, $0668
                set_npc_event _cc5af5
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {7, 29}, $0668
                set_npc_event _cc5af9
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx HOOKER, TERRA
                end_npc

        make_npc {19, 11}, $0668
                set_npc_event _cc5afd
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {23, 18}, $0664
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_306:

        make_npc {17, 22}, $0662
                set_npc_event _cc5d89
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {19, 8}, $0662
                set_npc_event _cc5d93
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {14, 21}, $0662
                set_npc_event _cc5d9d
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {20, 15}, $0662
                set_npc_event _cc5da7
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 9}, $0662
                set_npc_event _cc5dbb
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {13, 22}, $0662
                set_npc_event _cc5db1
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {29, 3}, $0666
                set_npc_event _cc5ddd
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {20, 28}, $0663
                set_npc_event _cc5e2b
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {25, 28}, $0663
                set_npc_event _cc5e2f
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {18, 13}, $0663
                set_npc_event _cc5e33
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {11, 27}, $0663
                set_npc_event _cc5e37
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {27, 10}, $0663
                set_npc_event _cc5e3b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_307:

        make_npc {34, 15}, $0662
                set_npc_event _cc5c81
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_308:

        make_npc {14, 53}, $0662
                set_npc_event _cc5c8d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_309:

        make_npc {38, 43}, $0662
                set_npc_event _cc5ce2
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_310:

        make_npc {58, 45}, $0662
                set_npc_event _cc5cee
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_311:

        make_npc {124, 54}, $0667
                set_npc_event _ccd3ca
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {117, 10}, $066d
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_312:

        make_npc {80, 16}, $0662
                set_npc_event _cc5cfa
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_313:

        make_npc {6, 48}, $0698
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {6, 49}, $0687
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 47}, $0693
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, MOG_UMARO
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_314:

; ------------------------------------------------------------------------------

NPCProp::_315:

        make_npc {20, 46}, $069c
                set_npc_event _cc2048
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx DRAGON, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {37, 28}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_316:

; ------------------------------------------------------------------------------

NPCProp::_317:

        make_npc {17, 46}, $0524
                set_npc_event _cb866f
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

        make_npc {17, 46}, $0525
                set_npc_event _cb86a0
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                end_npc

        make_npc {17, 46}, $0526
                set_npc_event _cb86d1
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {17, 46}, $0527
                set_npc_event _cb8702
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {17, 46}, $0528
                set_npc_event _cb8733
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SABIN
                end_npc

        make_npc {17, 46}, $0529
                set_npc_event _cb8764
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx CELES
                end_npc

        make_npc {17, 46}, $052a
                set_npc_event _cb8795
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {17, 46}, $052b
                set_npc_event _cb87c6
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {17, 46}, $052c
                set_npc_event _cb87f7
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SETZER
                end_npc

        make_npc {17, 46}, $052d
                set_npc_event _cb8828
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

        make_npc {17, 46}, $052e
                set_npc_event _cb8859
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GAU
                end_npc

        make_npc {17, 46}, $052f
                set_npc_event _cb888a
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GOGO, MOG_UMARO
                end_npc

        make_npc {17, 46}, $0530
                set_npc_event _cb88bb
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx UMARO, MOG_UMARO
                end_npc

        make_npc {27, 52}, $0531
                set_npc_event _cb88ec
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

        make_npc {27, 52}, $0532
                set_npc_event _cb891d
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                end_npc

        make_npc {27, 52}, $0533
                set_npc_event _cb894e
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {27, 52}, $0534
                set_npc_event _cb897f
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx EDGAR
                end_npc

        make_npc {27, 52}, $0535
                set_npc_event _cb89b0
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SABIN
                end_npc

        make_npc {27, 52}, $0536
                set_npc_event _cb89e1
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx CELES
                end_npc

        make_npc {27, 52}, $0537
                set_npc_event _cb8a12
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {27, 52}, $0538
                set_npc_event _cb8a43
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {27, 52}, $0539
                set_npc_event _cb8a74
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SETZER
                end_npc

        make_npc {27, 52}, $053a
                set_npc_event _cb8aa5
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx MOG
                end_npc

        make_npc {27, 52}, $053b
                set_npc_event _cb8ad6
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GAU
                end_npc

        make_npc {27, 52}, $053c
                set_npc_event _cb8b07
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx GOGO, MOG_UMARO
                end_npc

        make_npc {27, 52}, $053d
                set_npc_event _cb8b38
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx UMARO, MOG_UMARO
                end_npc

        make_npc {46, 55}, $0540
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {18, 45}, $053f
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {28, 52}, $053e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {23, 53}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_318:

        make_special_npc {4, 0}, $0693, {0, 0}
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 17}, $0693, {0, 0}
                set_npc_master 0, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 18}, $0693, {0, 0}
                set_npc_master 0, 2, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 20}, $0693, {1, 0}
                set_npc_master 0, 3, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {5, 21}, $0693, {2, 0}
                set_npc_master 0, 4, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_319:

        make_npc {20, 25}, $0545
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx CYAN, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {17, 25}, $0545
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_320:

        make_npc {6, 8}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        make_npc {6, 22}, $0544
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx CYAN, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {5, 8}, $0544
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {6, 8}, $0544
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

        make_npc {7, 8}, $0544
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, RAINBOW
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_321:

; ------------------------------------------------------------------------------

NPCProp::_322:

        make_npc {28, 5}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_323:

        make_npc {3, 18}, $065f
                set_npc_event _cc601f
                set_npc_dir LEFT
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {3, 15}, $065f
                set_npc_event _cc6029
                set_npc_dir LEFT
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {42, 21}, $065f
                set_npc_event _cc603d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {46, 21}, $065f
                set_npc_event _cc6033
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {16, 11}, $065f
                set_npc_event _cc6047
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {44, 26}, $0661
                set_npc_event _cc601b
                set_npc_dir UP
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {8, 16}, $065e
                set_npc_event _cc5fbd
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {14, 13}, $065e
                set_npc_event _cc5fcd
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 12}, $065e
                set_npc_event _cc5fdd
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {31, 11}, $065e
                set_npc_event _cc5fed
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx HOOKER, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {36, 20}, $065e
                set_npc_event _cc5ff1
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {50, 13}, $065e
                set_npc_event _cc5fff
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {49, 15}, $0660
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_324:

        make_npc {26, 20}, $0665
                set_npc_event _cc5bca
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {6, 15}, $0665
                set_npc_event _cc5bd9
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {8, 17}, $0665
                set_npc_event _cc5bdd
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {27, 20}, $0665
                set_npc_event _cc5be1
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {25, 20}, $0665
                set_npc_event _cc5be5
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {10, 9}, $0665
                set_npc_event _cc5be9
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx RICH_MAN, LOCKE
                end_npc

        make_npc {16, 11}, $0665
                set_npc_event _cc5bed
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SHOPKEEPER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {35, 20}, $0665
                set_npc_event _cc5bf1
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {46, 3}, $0665
                set_npc_event _cc5bf5
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {54, 15}, $0665
                set_npc_event _cc5bf9
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {18, 20}, $0665
                set_npc_event _cc5bfd
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        make_npc {50, 13}, $0665
                set_npc_event _cc5c01
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_325:

        make_npc {56, 51}, $065e
                set_npc_event _cc614a
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_326:

        make_npc {3, 51}, $065e
                set_npc_event _cc60a2
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {9, 51}, $065e
                set_npc_event _cc5c05
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx RICH_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_327:

        make_npc {102, 18}, $065e
                set_npc_event _cc60c6
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {84, 8}, $065e
                set_npc_event _cc5faf
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_328:

        make_npc {37, 47}, $065e
                set_npc_event _cc60ba
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_329:

; ------------------------------------------------------------------------------

NPCProp::_330:

        make_npc {37, 25}, $065e
                set_npc_event _cc60ae
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {14, 20}, $065e
                set_npc_event _cc607a
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {8, 10}, $0661
                set_npc_event _cc608e
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 10}, $0661
                set_npc_event _cc608e
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 10}, $0661
                set_npc_event _cc608e
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 10}, $0661
                set_npc_event _cc608e
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {19, 11}, $0661
                set_npc_event _cc6033
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 18}, $0661
                set_npc_event _cc6076
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx MAN, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {15, 10}, $0661
                set_npc_event _cc6065
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx HOOKER, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {10, 11}, $0661
                set_npc_event _cc6069
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx HOOKER, TERRA
                end_npc

        make_npc {10, 12}, $0661
                set_npc_event _cc606d
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx HOOKER, TERRA
                set_npc_movement RANDOM
                end_npc

        make_npc {18, 12}, $0661
                set_npc_event _cc6071
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx HOOKER, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 7}, $0661
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx HOOKER, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {11, 7}, $0661
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx HOOKER, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_331:

        make_npc {76, 51}, $06bd
                set_npc_event _cc18b4
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx ATMA, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {76, 51}, $06be
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_332:

        make_npc {14, 12}, $0542
                set_npc_event _cbcc50
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {23, 4}, $0542
                set_npc_event _cbcc5e
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {9, 23}, $0542
                set_npc_event _cbcc5a
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {12, 15}, $0542
                set_npc_event _cbcc84
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        make_npc {14, 6}, $0522
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx CELES
                end_npc

        make_npc {15, 6}, $0522
                set_npc_event _cbce26
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {16, 6}, $0511
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {19, 22}, $0513
                set_npc_event _cbce2a
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {20, 23}, $0513
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 15}, $0542
                set_npc_event _cbcc4c
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {22, 16}, $0542
                set_npc_event _cbcc48
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {8, 16}, $0506
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

        make_npc {8, 14}, $0506
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        make_npc {9, 16}, $0506
                set_npc_event _cbd209
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {17, 12}, $0508
                set_npc_event _cbce2a
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {17, 12}, $0507
                set_npc_event _cbcc72
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {18, 16}, $0507
                set_npc_event _cbcc68
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {8, 13}, $0507
                set_npc_event _cbcefc
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        make_npc {12, 14}, $0565
                set_npc_event _cbd1f3
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_333:

; ------------------------------------------------------------------------------

NPCProp::_334:

        make_special_npc {29, 13}, $06b2, {4, 0}
                set_npc_32x32
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx POLTERGEIST_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {29, 15}, $06b2, {6, 0}
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {30, 15}, $06b2, {7, 0}
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {69, 10}, $06a4, {0, 0}
                set_npc_master 3, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {69, 11}, $06a4, {0, 0}
                set_npc_master 3, 1, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {69, 12}, $06a4, {0, 0}
                set_npc_master 3, 2, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {69, 13}, $06a4, {0, 0}
                set_npc_master 3, 3, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {69, 14}, $06a4, {0, 0}
                set_npc_master 3, 4, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {69, 15}, $06a4, {0, 0}
                set_npc_master 3, 5, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_3, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {69, 16}, $06a4, {1, 0}
                set_npc_master 3, 6, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_2, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {69, 17}, $06a4, {2, 0}
                set_npc_master 3, 7, DOWN
                set_npc_speed SLOW
                set_npc_gfx CRANE_HOOK_1, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {33, 53}, $06af
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, MOG_UMARO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_335:

        make_npc {82, 33}, $06b3
                set_npc_event _cc18d9
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_336:

        make_npc {15, 13}, $039a
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {14, 12}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {16, 12}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 11}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {17, 11}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_337:

        make_special_npc {4, 12}, $06a4, {7, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {12, 12}, $06a4, {7, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {4, 7}, $06a5
                set_npc_event _cc14f4
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 7}, $06a7
                set_npc_event _cc1548
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {4, 12}, $06aa
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 12}, $06ab
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 11}, $06a6
                set_npc_event _cc14f0
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_special_npc {8, 6}, $06a4, {7, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_338:

; ------------------------------------------------------------------------------

NPCProp::_339:

; ------------------------------------------------------------------------------

NPCProp::_340:

        make_npc {22, 29}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        make_npc {55, 20}, $0520
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx CELES
                end_npc

        make_npc {45, 22}, $0520
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_sprite_priority LOW
                end_npc

        make_npc {14, 28}, $0520
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SETZER
                end_npc

        make_npc {12, 28}, $0520
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx SABIN
                end_npc

        make_npc {12, 27}, $0520
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx CYAN
                end_npc

        make_npc {12, 29}, $0520
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx EDGAR
                end_npc

        make_special_npc {54, 14}, $0500, {0, 0}
                set_npc_h_flip
                set_npc_master 15, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_anim TWO_FRAMES, DEFAULT
                set_npc_speed NORMAL
                set_npc_gfx LEO_SWORD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {41, 19}, $0500
                set_npc_event _cb755e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {18, 21}, $0559
                set_npc_event _cc0983
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 24}, $0559
                set_npc_event _cc098d
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {30, 29}, $0559
                set_npc_event _cc0997
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {18, 18}, $055a
                set_npc_event _cb77c8
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, LOCKE
                end_npc

        make_npc {23, 39}, $05f7
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {23, 39}, $05f7
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {26, 20}, $0560
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RELM
                end_npc

        make_npc {29, 14}, $0560
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, LOCKE
                end_npc

        make_npc {33, 19}, $0561
                set_npc_event _cb73fe
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {10, 21}, $0564
                set_npc_event _cb756e
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                end_npc

        make_npc {48, 18}, $0568
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_341:

        make_npc {26, 28}, $051f
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        make_npc {28, 28}, $0501
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx CELES
                end_npc

        make_npc {25, 14}, $05f7
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {22, 28}, $051f
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx YURA, CYAN_SHADOW_SETZER
                end_npc

        make_npc {21, 27}, $051f
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx FAERIE, TERRA
                end_npc

        make_npc {21, 29}, $051f
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {26, 8}, $051d
                set_npc_event _cc0942
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {26, 6}, $051d
                set_npc_event _cc094c
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {26, 4}, $051d
                set_npc_event _cc0956
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {30, 27}, $0501
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {30, 29}, $0501
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {22, 21}, $05f7
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {23, 28}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {24, 29}, $051e
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx TERRA
                end_npc

        make_npc {27, 29}, $051e
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {23, 32}, $051e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {31, 33}, $051e
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {24, 18}, $051d
                set_npc_event _cbfff4
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {24, 18}, $05f7
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {24, 18}, $05f7
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {24, 18}, $05f7
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {24, 18}, $05f7
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {32, 16}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {32, 24}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 26}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 19}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {24, 18}, $05f7
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {14, 13}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {24, 18}, $05f7
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {23, 6}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_342:

        make_npc {8, 20}, $0474
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx CLYDE, LOCKE
                end_npc

        make_npc {8, 15}, $0475
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_343:

        make_npc {23, 28}, $0518
                set_npc_event _cbd7e5
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {16, 40}, $0501
                set_npc_event _cbd81f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx WOMAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {11, 24}, $0518
                set_npc_event _cbd833
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 21}, $0501
                set_npc_event _cbd853
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {39, 24}, $0508
                set_npc_event _cbde30
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {43, 9}, $0506
                set_npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {43, 11}, $0506
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {30, 3}, $0506
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {28, 4}, $0506
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GIRL, LOCKE
                end_npc

        make_npc {29, 2}, $0506
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        make_npc {29, 24}, $0507
                set_npc_event _cbd805
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx OLD_MAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {28, 22}, $0507
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {39, 22}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 17}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 22}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 17}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 17}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 17}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 17}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 17}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {39, 22}, $0507
                set_npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {44, 25}, $0509
                set_npc_event _cbd7e5
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {28, 20}, $0509
                set_npc_event _cbd7e5
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {26, 19}, $051a
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {25, 18}, $051a
                set_npc_event _cb6abf
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {29, 13}, $05f7
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {28, 19}, $0569
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx CLYDE, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_344:

        make_special_npc {54, 14}, $0500, {0, 0}
                set_npc_h_flip
                set_npc_master 15, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_anim TWO_FRAMES, DEFAULT
                set_npc_speed NORMAL
                set_npc_gfx LEO_SWORD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {41, 19}, $0500
                set_npc_event _cb755e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {30, 29}, $0559
                set_npc_event _cc0983
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 24}, $0559
                set_npc_event _cc098d
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {18, 21}, $0559
                set_npc_event _cc0997
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOMAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {33, 19}, $0561
                set_npc_event _cb73fe
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {10, 21}, $0564
                set_npc_event _cb756e
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                end_npc

        make_npc {23, 39}, $05f7
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {23, 39}, $05f7
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {21, 17}, $0570
                set_npc_event _cb6abf
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_345:

        make_npc {11, 37}, $0500
                set_npc_event _cbd712
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {22, 37}, $0500
                set_npc_event _cbd721
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_346:

        make_npc {24, 15}, $0500
                set_npc_event _cbd73f
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {23, 19}, $0507
                set_npc_event _cbdcb3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {13, 16}, $0507
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_347:

        make_npc {36, 39}, $0500
                set_npc_event _cbd730
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {42, 41}, $051b
                set_npc_event _cbd88b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_348:

        make_npc {61, 34}, $051b
                set_npc_event _cbd805
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {61, 34}, $0559
                set_npc_event _cc09a1
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_349:

        make_npc {37, 18}, $0516
                set_npc_event _cbd982
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx STRAGO
                end_npc

        make_npc {36, 13}, $0516
                set_npc_event _cbdcbb
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {39, 19}, $0563
                set_npc_event _cbdcb3
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                set_npc_movement RANDOM
                end_npc

        make_npc {47, 20}, $0563
                set_npc_event _cbdcb7
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                set_npc_movement RANDOM
                end_npc

        make_npc {36, 20}, $0503
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {63, 12}, $0519
                set_npc_event _cbdcc3
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx RELM
                set_npc_movement RANDOM
                end_npc

        make_npc {59, 13}, $050a
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {59, 15}, $050a
                set_npc_event _cb6abf
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {40, 20}, $0557
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {42, 19}, $0557
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx RELM
                end_npc

        make_npc {43, 19}, $0557
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                end_npc

        make_npc {65, 13}, $055c
                set_npc_event _cb7414
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, LOCKE
                end_npc

        make_npc {62, 12}, $05f7
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RELM
                end_npc

        make_npc {64, 13}, $05f7
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                end_npc

        make_npc {39, 10}, $05f7
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {39, 10}, $05f6
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RELM
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {62, 20}, $055f
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {61, 20}, $055f
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx RELM
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {43, 21}, $055f
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {45, 21}, $055f
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {61, 13}, $0556
                set_npc_event _cb7d08
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {61, 13}, $0566
                set_npc_event _cb7d1c
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {60, 15}, $055b
                set_npc_event _cb6abf
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_350:

        make_npc {43, 8}, $0500
                set_npc_event _cbd79d
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_351:

        make_npc {2, 29}, $0501
                set_npc_event _cbe6cb
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {17, 34}, $0501
                set_npc_event _cbe6d8
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {22, 25}, $0501
                set_npc_event _cbe6e5
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {21, 21}, $050a
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {21, 21}, $050a
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {21, 21}, $050a
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {21, 21}, $050a
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {42, 25}, $0501
                set_npc_event _cbe6f2
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {46, 49}, $0501
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {5, 31}, $0501
                set_npc_event _cbe6ff
                set_npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {17, 27}, $0501
                set_npc_event _cbe70c
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {46, 42}, $0501
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {47, 43}, $0501
                set_npc_event _cb6abf
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {42, 35}, $0562
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {24, 8}, $0501
                set_npc_event _cbe719
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {29, 7}, $0501
                set_npc_event _cbe726
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {19, 6}, $0501
                set_npc_event _cbe733
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 35}, $0501
                set_npc_event _cbe740
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {41, 24}, $0501
                set_npc_event _cbe74d
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

        make_npc {4, 35}, $0501
                set_npc_event _cbe75a
                set_npc_anim FOUR_FRAMES, SPECIAL, FAST
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_352:

; ------------------------------------------------------------------------------

NPCProp::_353:

        make_npc {57, 44}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {35, 48}, $054c
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {56, 24}, $0552
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                end_npc

        make_npc {56, 24}, $0553
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {58, 27}, $0555
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx MONSTER, TERRA
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {55, 25}, $0554
                set_npc_event _cb6abf
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        make_npc {27, 26}, $0500
                set_npc_event _cc5bca
                set_npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                set_npc_speed SLOW
                set_npc_gfx FLAME, RAINBOW
                end_npc

        make_npc {27, 25}, $0500
                set_npc_event _cb7cf8
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                end_npc

        make_npc {26, 26}, $0500
                set_npc_event _cb7cfc
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                end_npc

        make_npc {28, 26}, $0500
                set_npc_event _cb7d00
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                end_npc

        make_npc {29, 27}, $0500
                set_npc_event _cb7d04
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_354:

        make_special_npc {11, 29}, $06b1, {0, 0}
                set_npc_32x32
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {11, 31}, $06b1, {2, 0}
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {12, 31}, $06b1, {4, 0}
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {12, 31}, $06b9
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {82, 33}, $06b4
                set_npc_event _cc1906
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx DRAGON, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_355:

        make_special_npc {35, 6}, $06a4, {4, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {39, 9}, $06a4, {4, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {43, 6}, $06a4, {4, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {63, 9}, $06b0, {0, 0}
                set_npc_32x32
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {64, 11}, $06b0, {2, 0}
                set_npc_h_flip
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {63, 11}, $06b0, {2, 1}
                set_npc_h_flip
                set_npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_npc {64, 11}, $06b8
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_356:

        make_npc {15, 14}, $039a
                set_npc_event GameEnding
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {19, 13}, $03ff
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx ESPER_TERRA, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {15, 22}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {12, 12}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {18, 12}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed FAST
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $039e
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx MULTI_SPARKLES, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $039e
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_357:

        make_npc {15, 13}, $039a
                set_npc_event GameEnding
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {14, 12}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {16, 12}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 11}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {17, 11}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_358:

        make_npc {8, 10}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_359:

; ------------------------------------------------------------------------------

NPCProp::_360:

; ------------------------------------------------------------------------------

NPCProp::_361:

; ------------------------------------------------------------------------------

NPCProp::_362:

        make_npc {5, 11}, $0678
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {6, 11}, $0678
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 11}, $0678
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 11}, $0679
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {9, 11}, $0678
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 11}, $0678
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {1, 5}, $0678
                set_npc_event _cc51f7
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 2}, $0678
                set_npc_event _cc51fb
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {2, 4}, $0678
                set_npc_event _cc51ff
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {3, 5}, $0678
                set_npc_event _cc522a
                set_npc_no_react
                set_npc_dir LEFT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_363:

; ------------------------------------------------------------------------------

NPCProp::_364:

        make_npc {7, 15}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 15}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 16}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 17}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 18}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 19}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 20}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 21}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 22}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 23}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 24}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 25}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 26}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 27}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 28}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 29}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 30}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 15}, $0699
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 6}, $0699
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_365:

; ------------------------------------------------------------------------------

NPCProp::_366:

; ------------------------------------------------------------------------------

NPCProp::_367:

; ------------------------------------------------------------------------------

NPCProp::_368:

        make_npc {5, 9}, $0694
                set_npc_event _cc558b
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx DRAGON, TERRA
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_369:

; ------------------------------------------------------------------------------

NPCProp::_370:

; ------------------------------------------------------------------------------

NPCProp::_371:

        make_npc {15, 14}, $0521
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, MOG_UMARO
                end_npc

        make_npc {19, 14}, $0521
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

        make_npc {15, 15}, $0501
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SMALL_STATUE, STRAGO_RELM_GAU_GOGO
                set_npc_sprite_priority LOW
                end_npc

        make_npc {16, 16}, $0501
                set_npc_event _cbf29a
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SMALL_STATUE, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {14, 16}, $0501
                set_npc_event _cbf296
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SMALL_STATUE, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {15, 15}, $0501
                set_npc_event _cbf29e
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_372:

        make_npc {50, 19}, $0521
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx ULTROS, MOG_UMARO
                end_npc

        make_npc {51, 18}, $0521
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_373:

        make_npc {16, 23}, $0521
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_374:

; ------------------------------------------------------------------------------

NPCProp::_375:

        make_npc {8, 44}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {12, 30}, $051b
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx YURA, CYAN_SHADOW_SETZER
                end_npc

        make_npc {17, 23}, $051b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx FAERIE, TERRA
                end_npc

        make_npc {24, 22}, $051b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOLF, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {19, 26}, $051b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx DRAGON, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 26}, $051b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx DRAGON, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {16, 27}, $051b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {18, 26}, $051b
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOLF, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 26}, $05f7
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx FAERIE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {16, 27}, $05f7
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 14}, $05f7
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx DRAGON, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 13}, $05f7
                set_npc_dir DOWN
                set_npc_speed SLOWER
                set_npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        make_npc {48, 10}, $0521
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx RELM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_376:

        make_special_npc {60, 3}, $0300, {0, 0}
                set_npc_32x32
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {60, 5}, $0300, {6, 0}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {61, 5}, $0300, {7, 0}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {59, 6}, $0300, {2, 0}
                set_npc_32x32
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {60, 8}, $0300, {6, 1}
                set_npc_h_flip
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {59, 8}, $0300, {7, 1}
                set_npc_h_flip
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {60, 7}, $0300, {4, 0}
                set_npc_32x32
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx POLTERGEIST_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {60, 9}, $0300, {6, 1}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {61, 9}, $0300, {7, 1}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {60, 6}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {60, 6}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {32, 9}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_377:

        make_npc {15, 9}, $045e
                set_npc_event _cb2599
                set_npc_dir DOWN
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {8, 13}, $045f
                set_npc_event _cb2583
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {11, 21}, $0460
                set_npc_event _cb258e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {15, 21}, $0461
                set_npc_event _cb2583
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {17, 12}, $0462
                set_npc_event _cb258e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 25}, $0463
                set_npc_event _cb2583
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {3, 18}, $0464
                set_npc_event _cb258e
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {3, 5}, $0465
                set_npc_event _cb2583
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {15, 2}, $0466
                set_npc_event _cb2583
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {26, 3}, $0467
                set_npc_event _cb258e
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_378:

        make_npc {53, 40}, $045d
                set_npc_event _cb2562
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx NOTHING, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_379:

; ------------------------------------------------------------------------------

NPCProp::_380:

; ------------------------------------------------------------------------------

NPCProp::_381:

        make_npc {38, 22}, $0300
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        make_npc {46, 18}, $0300
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx IMP, EDGAR_SABIN_CELES
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_382:

; ------------------------------------------------------------------------------

NPCProp::_383:

; ------------------------------------------------------------------------------

NPCProp::_384:

        make_npc {10, 27}, $0471
                set_npc_event _cb3dcb
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        make_npc {11, 27}, $0471
                set_npc_event _cb3dcb
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        make_npc {9, 27}, $0471
                set_npc_event _cb3dcb
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        make_npc {65, 4}, $0485
                set_npc_event _cb307e
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_385:

; ------------------------------------------------------------------------------

NPCProp::_386:

        make_npc {74, 53}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_387:

; ------------------------------------------------------------------------------

NPCProp::_388:

; ------------------------------------------------------------------------------

NPCProp::_389:

        make_npc {2, 8}, $0300
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {6, 11}, $0300
                set_npc_dir RIGHT
                set_npc_speed FAST
                set_npc_bg2_scroll
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {7, 9}, $0300
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {6, 4}, $0300
                set_npc_dir RIGHT
                set_npc_vehicle MAGITEK, SHOW_RIDER
                set_npc_speed FAST
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {4, 12}, $0300
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {14, 8}, $0300
                set_npc_dir LEFT
                set_npc_speed FAST
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {12, 12}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {10, 5}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_390:

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed FAST
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_391:

        make_special_npc {7, 5}, $0468, {0, 0}
                set_npc_32x32
                set_npc_master 0, 6, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx GATE_1, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {8, 5}, $0468, {2, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_master 1, 6, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx GATE_1, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {7, 7}, $0468, {4, 0}
                set_npc_master 2, 6, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx GATE_2, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {8, 7}, $0468, {5, 0}
                set_npc_master 3, 6, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx GATE_3, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {9, 7}, $0468, {6, 0}
                set_npc_h_flip
                set_npc_master 4, 6, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx GATE_2, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_special_npc {8, 7}, $0468, {7, 0}
                set_npc_h_flip
                set_npc_master 5, 6, DOWN
                _npc_is_slave .set 0
                set_npc_speed SLOW
                set_npc_gfx GATE_3, VEHICLE
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {8, 19}, $046e
                set_npc_event _cb39ca
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {7, 18}, $046f
                set_npc_event _cb39ca
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {9, 18}, $0470
                set_npc_event _cb39ca
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx SOLDIER, LOCKE
                end_npc

        make_npc {8, 16}, $03ff
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {4, 0}, $04fe, {0, 2}
                set_npc_master 10, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {5, 0}, $04fe, {1, 2}
                set_npc_master 11, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {6, 0}, $04fe, {2, 2}
                set_npc_master 12, 3, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {7, 0}, $04fe, {3, 2}
                set_npc_master 13, 0, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {9, 0}, $04fe, {4, 2}
                set_npc_master 14, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {10, 0}, $04fe, {5, 2}
                set_npc_master 15, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {11, 0}, $04fe, {6, 2}
                set_npc_master 16, 0, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {12, 0}, $04fe, {7, 2}
                set_npc_master 17, 4, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {2, 0}, $04fe, {0, 3}
                set_npc_master 18, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {3, 0}, $04fe, {1, 3}
                set_npc_master 19, 3, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {13, 0}, $04fe, {2, 3}
                set_npc_master 20, 4, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {14, 0}, $04fe, {3, 3}
                set_npc_master 21, 6, RIGHT
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {0, 0}, $04fe, {4, 3}
                set_npc_master 22, 5, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx ROCK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 9}, $04fb
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx COIN, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_392:

        make_npc {13, 35}, $0300
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx GIRL, EDGAR_SABIN_CELES
                end_npc

        make_npc {8, 42}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MAN, LOCKE
                end_npc

        make_npc {21, 39}, $0300
                set_npc_dir UP
                set_npc_speed FAST
                set_npc_gfx WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_393:

        make_npc {108, 15}, $0361
                set_npc_event _cada48
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {124, 13}, $0300
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx BLACKJACK, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_394:

        make_npc {60, 15}, $035f
                set_npc_event _cada30
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx ATMA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {59, 8}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        make_special_npc {59, 1}, $0300, {0, 0}
                set_npc_32x32
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {59, 3}, $0300, {6, 0}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {60, 3}, $0300, {7, 0}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx GODDESS_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {57, 3}, $0300, {2, 0}
                set_npc_32x32
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {58, 5}, $0300, {6, 1}
                set_npc_h_flip
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {57, 5}, $0300, {7, 1}
                set_npc_h_flip
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {61, 3}, $0300, {4, 0}
                set_npc_32x32
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx POLTERGEIST_1, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {61, 5}, $0300, {6, 1}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_2, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_special_npc {62, 5}, $0300, {7, 1}
                set_npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                set_npc_speed SLOWER
                set_npc_gfx DOOM_3, VEHICLE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 16}, $035e
                set_npc_event _cad9a7
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx SHADOW
                end_npc

        make_npc {60, 7}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {0, 0}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed NORMAL
                set_npc_gfx BIG_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {7, 12}, $0632
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {70, 35}, $0300
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx BLACKJACK, CYAN_SHADOW_SETZER
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_395:

        make_npc {9, 6}, $0300
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority BACKGROUND
                end_npc

        make_npc {10, 5}, $0300
                set_npc_dir LEFT
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx WOMAN, LOCKE
                end_npc

        make_npc {4, 9}, $0300
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 11}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BOY, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {12, 9}, $0300
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_bg2_scroll
                set_npc_gfx MERCHANT, LOCKE
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_396:

; ------------------------------------------------------------------------------

NPCProp::_397:

        make_npc {100, 38}, $0367
                set_npc_event _ca5370
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {99, 40}, $036e
                set_npc_event _ca5370
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

        make_npc {94, 39}, $0368
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx NOTHING, LOCKE
                end_npc

        make_npc {85, 51}, $036d
                set_npc_event _ca55fe
                set_npc_dir DOWN
                set_npc_vehicle RAFT
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, VEHICLE
                end_npc

        make_npc {100, 39}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {100, 39}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {101, 39}, $0372
                set_npc_event _ca55e5
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_398:

        make_npc {8, 8}, $0371
                set_npc_event _ca536b
                set_npc_dir UP
                set_npc_speed SLOW
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {12, 11}, $0369
                set_npc_event _ca5762
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx FISH, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 13}, $036a
                set_npc_event _ca5769
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx FISH, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 13}, $036b
                set_npc_event _ca5770
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx FISH, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {14, 11}, $036c
                set_npc_event _ca5777
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx FISH, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {13, 6}, $039b
                set_npc_event _ca55e9
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx MAGICITE, TERRA
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_399:

        make_npc {10, 9}, $0370
                set_npc_event _ca54ba
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx BIRD, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {5, 11}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {5, 11}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {4, 13}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {4, 13}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_400:

        make_npc {7, 10}, $03ff
                set_npc_dir DOWN
                set_npc_vehicle RAFT
                set_npc_speed SLOWER
                set_npc_gfx SOLDIER, VEHICLE
                end_npc

        make_npc {6, 2}, $03ff
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        make_npc {16, 5}, $03ff
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {8, 9}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx BIRD_BANDANA, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {16, 13}, $0300
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL, FAST
                set_npc_speed FAST
                set_npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {10, 8}, $03ff
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx QUESTION_MARK, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_401:

; ------------------------------------------------------------------------------

NPCProp::_402:

        make_npc {22, 51}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_403:

; ------------------------------------------------------------------------------

NPCProp::_404:

        make_npc {15, 15}, $0500
                set_npc_event _cb7446
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {5, 27}, $0500
                set_npc_event _cb7459
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {22, 28}, $0500
                set_npc_event _cb746c
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {26, 6}, $0500
                set_npc_event _cb747f
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

        make_npc {5, 7}, $0500
                set_npc_event _cb7492
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_405:

        make_npc {23, 17}, $055d
                set_npc_event _cb70c7
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx NOTHING, MOG_UMARO
                set_npc_sprite_priority LOW
                end_npc

        make_npc {23, 18}, $05f7
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed SLOWER
                set_npc_gfx TREASURE_CHEST, VEHICLE
                end_npc

        make_npc {7, 5}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {23, 5}, $055e
                set_npc_event _cb71d2
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx CHUPON, EDGAR_SABIN_CELES
                end_npc

        make_npc {23, 6}, $055f
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx STRAGO
                set_npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_406:

        make_npc {52, 42}, $069b
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx CHANCELLOR, TERRA
                end_npc

        make_npc {52, 45}, $069b
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {51, 46}, $069b
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_special_npc {33, 10}, $0696, {0, 0}
                set_npc_h_flip
                set_npc_32x32
                set_npc_speed FAST
                set_npc_gfx ODIN, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {33, 14}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {33, 14}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        make_npc {34, 14}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {34, 14}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        make_npc {33, 15}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {33, 15}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        make_npc {33, 16}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {33, 16}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        make_npc {34, 16}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {34, 16}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        make_npc {34, 17}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {34, 17}, $069b
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        make_npc {33, 22}, $069b
                set_npc_no_react
                set_npc_dir UP
                set_npc_speed NORMAL
                set_npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        make_npc {33, 11}, $0696
                set_npc_event _cc1ea5
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        make_npc {34, 11}, $0696
                set_npc_event _cc1ea5
                set_npc_no_react
                set_npc_anim ONE_FRAME, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_407:

        make_npc {15, 10}, $069b
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {15, 9}, $069b
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {15, 8}, $069b
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

        make_npc {7, 9}, $069b
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {7, 10}, $069b
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {7, 11}, $069b
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {6, 9}, $069b
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {6, 11}, $069b
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx EXPLOSION, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {15, 10}, $069b
                set_npc_no_react
                set_npc_dir RIGHT
                set_npc_speed NORMAL
                set_npc_gfx MERCHANT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_408:

        make_npc {52, 41}, $069b
                set_npc_event _cc1ede
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOW
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority HIGH
                end_npc

        make_npc {52, 41}, $0697
                set_npc_event _cc1f49
                set_npc_no_react
                set_npc_dir DOWN
                set_npc_speed NORMAL
                set_npc_gfx CELES_DRESS, VEHICLE
                end_npc

        make_npc {28, 43}, $06a0
                set_npc_event _cc1ede
                set_npc_no_react
                set_npc_anim TWO_FRAMES, SPECIAL
                set_npc_speed SLOWER
                set_npc_gfx SMALL_SPARKLE, RAINBOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {52, 49}, $06a1
                set_npc_event _cc205b
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                set_npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_409:

; ------------------------------------------------------------------------------

NPCProp::_410:

        make_npc {30, 11}, $06bc
                set_npc_no_react
                set_npc_anim ONE_FRAME, NONE
                set_npc_speed NORMAL
                set_npc_gfx NUMBER_128, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {37, 17}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_411:

        make_special_npc {103, 43}, $06a4, {7, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {109, 40}, $06a4, {7, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

        make_special_npc {115, 42}, $06a4, {7, 0}
                set_npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                set_npc_speed NORMAL
                set_npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                set_npc_layer_priority FOREGROUND
                set_npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_412:

        make_npc {82, 47}, $0632
                set_npc_no_react
                set_npc_anim FOUR_FRAMES, SPECIAL
                set_npc_speed NORMAL
                set_npc_gfx SAVE_POINT, RAINBOW
                set_npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_413:

        make_npc {19, 5}, $068b
                set_npc_event _cc3af8
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SOLDIER, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {27, 10}, $0558
                set_npc_event _cb797a
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx ULTROS, MOG_UMARO
                set_npc_movement RANDOM
                end_npc

        make_npc {52, 16}, $0558
                set_npc_event _cb7864
                set_npc_dir DOWN
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {39, 11}, $0558
                set_npc_event _cb78a5
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx SHOPKEEPER, LOCKE
                end_npc

        make_npc {39, 16}, $0558
                set_npc_event _cb78a9
                set_npc_dir RIGHT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {41, 16}, $0558
                set_npc_event _cb78ad
                set_npc_dir LEFT
                set_npc_speed SLOW
                set_npc_gfx BANDIT, LOCKE
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {5, 7}, $0558
                set_npc_event _cb797e
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                set_npc_movement RANDOM
                end_npc

        make_npc {25, 5}, $0558
                set_npc_event _cb78bb
                set_npc_dir UP
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {42, 7}, $0558
                set_npc_event _cb7858
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                set_npc_movement RANDOM
                end_npc

        make_npc {23, 4}, $0558
                set_npc_event _cb78c3
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {19, 13}, $0558
                set_npc_event _cb78b7
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx BANDIT, LOCKE
                set_npc_movement RANDOM
                end_npc

        make_npc {22, 5}, $05f7
                set_npc_dir RIGHT
                set_npc_speed SLOWER
                set_npc_gfx SHADOW
                set_npc_layer_priority FOREGROUND
                end_npc

        make_npc {25, 12}, $0558
                set_npc_event _cb78bf
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

        make_npc {21, 12}, $0558
                set_npc_event _cb78bf
                set_npc_dir DOWN
                set_npc_speed FAST
                set_npc_gfx FIGARO_GUARD, TERRA
                end_npc

; ------------------------------------------------------------------------------

NPCProp::_414:

; ------------------------------------------------------------------------------

NPCProp::_415:

; ------------------------------------------------------------------------------

NPCProp::End:
        end_fixed_block

; ------------------------------------------------------------------------------