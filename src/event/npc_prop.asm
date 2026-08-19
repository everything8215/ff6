; ------------------------------------------------------------------------------

.include "npc_prop.inc"

; ------------------------------------------------------------------------------

.mac npc_event addr
        _npc_event_addr := (_event_addr addr)
.endmac

.mac _npc_pos x_pos, y_pos
        _npc_pos_x .set x_pos
        _npc_pos_y .set y_pos
.endmac

.mac npc_dir dd
        _npc_dir .set EVENT_DIR::dd
.endmac

.mac npc_speed ss
        _npc_speed .set OBJ_SPEED::ss
.endmac

.mac npc_gfx gfx, pal
        _npc_gfx .set MAP_SPRITE_GFX::gfx
        .ifblank pal
                _npc_pal .set MAP_SPRITE_PAL::gfx << 2
        .else
                _npc_pal .set MAP_SPRITE_PAL::pal << 2
        .endif
.endmac

.mac npc_vehicle vehicle, show_rider
        _npc_vehicle .set EVENT_VEHICLE::vehicle
        .ifnblank show_rider
                _npc_show_rider .set EVENT_VEHICLE::show_rider
        .endif
        .if _npc_show_rider .and (_npc_vehicle = 0)
                .error "Invalid NPC vehicle"
        .endif
.endmac

.define npc_movement(movement_type) _npc_movement .set NPC_MOVEMENT::movement_type
.define npc_layer_priority(priority) _npc_layer_priority .set NPC_LAYER_PRIORITY::priority
.define npc_sprite_priority(priority) _npc_sprite_priority .set NPC_SPRITE_PRIORITY::priority
.define npc_bg2_scroll _npc_scroll .set NPC_SCROLL::BG2
.define npc_no_react _npc_react .set NPC_REACT::NONE

.mac _npc_vram_pos x_pos, y_pos
        _npc_vram_addr .set (x_pos | (y_pos << 4))
.endmac

.define npc_32x32 _npc_is_32x32 .set $04
.define npc_h_flip _npc_h_flip .set $80

.mac npc_master master_id, offset, offset_dir
        _npc_is_slave .set 2
        _npc_master_id .set master_id
        _npc_master_offset .set (offset << 5)
        _npc_master_dir .set NPC_MASTER_OFFSET_DIR::offset_dir
.endmac

.mac reset_npc

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

reset_npc

_npc_seq_id .set 0
_npc_in_progress .set 0
.define _npc_event_addr .ident(.sprintf("NPCEvent%d", _npc_seq_id))

.mac npc_prop xy_pos, switch_id
        .assert _npc_in_progress = 0, error, "Missing end_npc before npc_prop"
        reset_npc
        _npc_seq_id .set _npc_seq_id + 1
        _npc_in_progress .set 1
        _npc_pos xy_pos
        .ifnblank switch_id
                .assert switch_id >= $0300, error, "Invalid NPC switch"
                _npc_switch .set switch_id - $0300
        .endif
.endmac

.mac npc_anim anim_type, anim_frame, anim_speed
        _npc_anim_type .set NPC_ANIM_TYPE::anim_type
        _npc_anim_frame .set NPC_ANIM_FRAME::anim_frame
        .assert _npc_anim_frame <> 0 || _npc_is_special, error, "Invalid animated NPC frame"
        .ifnblank anim_speed
                .assert _npc_is_special = 0, error, "Invalid animation speed"
                _npc_anim_speed .set NPC_ANIM_SPEED::anim_speed
        .endif
.endmac

.mac special_npc_prop xy_pos, switch_id, vram_pos
        .ifnblank(switch_id)
                npc_prop {xy_pos}, switch_id
        .else
                npc_prop {xy_pos}
        .endif
        _npc_vram_pos vram_pos
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
        ptr_tbl NPC_PROP
        end_ptr NPC_PROP

; ------------------------------------------------------------------------------

; c4/1d52
NPCProp:

; ------------------------------------------------------------------------------

; no npcs on world maps
        array_label NPC_PROP, 0
        array_label NPC_PROP, 1
        array_label NPC_PROP, 2

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 3

        special_npc_prop {4, 4}, $03a0, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {6, 4}, $03a0, {2, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {4, 6}, $03a0, {0, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {6, 6}, $03a0, {2, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 4

        npc_prop {8, 11}, $043f
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx CLYDE, LOCKE
                end_npc

        npc_prop {8, 6}, $0440
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BANDIT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {8, 15}, $0476
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 5

        npc_prop {0, 0}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 6

        npc_prop {14, 4}, $0459
                npc_event _caf47b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SETZER
                end_npc

        npc_prop {15, 6}, $045c
                npc_event _caa6c0
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx BOOK, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 7

        npc_prop {12, 8}, $0456
                npc_event _cb2007
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SETZER
                end_npc

        npc_prop {13, 10}, $0457
                npc_event _cb2029
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx COIN, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {5, 31}, $045a
                npc_event _cb2240
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {15, 31}, $045b
                npc_event _cb223d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {53, 9}, $0472
                npc_event _cb23d8
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {25, 13}, $0473
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {58, 58}, $0477
                npc_event _cb42b4
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {56, 56}, $0478
                npc_event _cb42cc
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {53, 59}, $0479
                npc_event _cb42e4
                npc_dir UP
                npc_speed SLOW
                npc_gfx CYAN
                npc_movement RANDOM
                end_npc

        npc_prop {41, 56}, $047a
                npc_event _cb42fc
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHADOW
                end_npc

        npc_prop {48, 56}, $047b
                npc_event _cb4314
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx EDGAR
                end_npc

        npc_prop {47, 57}, $047c
                npc_event _cb432c
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SABIN
                end_npc

        npc_prop {47, 53}, $047d
                npc_event _cb4344
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CELES
                end_npc

        npc_prop {51, 56}, $047e
                npc_event _cb435c
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx STRAGO
                end_npc

        npc_prop {52, 57}, $047f
                npc_event _cb4374
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RELM
                end_npc

        npc_prop {49, 58}, $0480
                npc_event _cb438c
                npc_dir UP
                npc_speed SLOW
                npc_gfx SETZER
                end_npc

        npc_prop {50, 55}, $0481
                npc_event _cb43a4
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {53, 54}, $0482
                npc_event _cb43bc
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GAU
                npc_movement RANDOM
                end_npc

        npc_prop {54, 55}, $0483
                npc_event _cb43d4
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx GOGO, MOG_UMARO
                end_npc

        npc_prop {42, 58}, $0484
                npc_event _cb43dc
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx UMARO, MOG_UMARO
                npc_movement RANDOM
                end_npc

        npc_prop {5, 31}, $048c
                npc_event _cb224b
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {41, 14}, $04ef
                npc_event _cc3510
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx PILOT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 8

        npc_prop {109, 40}, $0458
                npc_event _cb1b0e
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 9

        npc_prop {5, 8}, $0329
                npc_event _ca84ab
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx LOCKE
                end_npc

        npc_prop {11, 8}, $032a
                npc_event _cb0a1c
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SABIN
                end_npc

        npc_prop {8, 10}, $032b
                npc_event _cb094e
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {7, 11}, $032c
                npc_event _cb094e
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx TERRA
                end_npc

        npc_prop {9, 11}, $032d
                npc_event _cb094e
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {8, 6}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 10

        special_npc_prop {0, 0}, $0300, {0, 0}
                npc_speed FAST
                npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {0, 0}, $0300, {0, 0}
                npc_speed FAST
                npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {0, 0}, $0300, {0, 0}
                npc_speed FAST
                npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {0, 0}, $0300, {0, 0}
                npc_speed FAST
                npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {0, 0}, $0300, {0, 0}
                npc_speed FAST
                npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {0, 4}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {0, 3}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx AIR_FORCE, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {0, 3}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx CHUPON, MOG_UMARO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ULTROS, MOG_UMARO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {31, 15}, $0300, {0, 1}
                npc_32x32
                npc_speed SLOWER
                npc_gfx FALCON_1, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {31, 15}, $0300, {1, 0}
                npc_speed SLOWER
                npc_gfx FALCON_2, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {31, 15}, $0300, {2, 0}
                npc_speed SLOWER
                npc_gfx FALCON_3, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 11

        npc_prop {15, 8}, $03f3
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx DARILL, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 12

        npc_prop {21, 49}, $0388
                npc_event _ca3f13
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {15, 55}, $0389
                npc_event _ca3f1b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {53, 35}, $038b
                npc_event _ca3f23
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx CYAN
                end_npc

        npc_prop {27, 54}, $038a
                npc_event _ca3f2b
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHADOW
                end_npc

        npc_prop {23, 56}, $038c
                npc_event _ca3f33
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx EDGAR
                npc_movement RANDOM
                end_npc

        npc_prop {21, 54}, $038d
                npc_event _ca3f3b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SABIN
                npc_movement RANDOM
                end_npc

        npc_prop {18, 53}, $038e
                npc_event _ca3f43
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CELES
                end_npc

        npc_prop {11, 52}, $038f
                npc_event _ca3f4b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx STRAGO
                npc_movement RANDOM
                end_npc

        npc_prop {10, 49}, $0390
                npc_event _ca3f53
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RELM
                npc_movement RANDOM
                end_npc

        npc_prop {36, 33}, $0391
                npc_event _ca3f5b
                npc_dir UP
                npc_speed SLOW
                npc_gfx SETZER
                end_npc

        npc_prop {13, 49}, $0392
                npc_event _ca3f63
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {56, 33}, $0393
                npc_event _ca3f6b
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GAU
                npc_movement RANDOM
                end_npc

        npc_prop {6, 52}, $0394
                npc_event _ca3f73
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GOGO
                end_npc

        npc_prop {6, 51}, $0395
                npc_event _ca3f7b
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx UMARO, MOG_UMARO
                end_npc

        npc_prop {20, 45}, $0300
                npc_event _cc3510
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 13

        npc_prop {15, 4}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx LOCKE
                end_npc

        npc_prop {21, 5}, $0300
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {21, 5}, $03ff
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx CYAN
                end_npc

        npc_prop {18, 7}, $037d
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SHADOW
                end_npc

        npc_prop {18, 7}, $03ff
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SHADOW
                end_npc

        npc_prop {20, 6}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {20, 6}, $03ff
                npc_dir UP
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx EDGAR
                end_npc

        npc_prop {12, 7}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

        npc_prop {17, 6}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx CELES
                end_npc

        npc_prop {18, 5}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx STRAGO
                end_npc

        npc_prop {18, 5}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx STRAGO
                end_npc

        npc_prop {11, 5}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {14, 6}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 14

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 15

        npc_prop {85, 42}, $0692
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {85, 44}, $0692
                npc_event _cc3304
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {86, 39}, $0692
                npc_event _cc338b
                npc_no_react
                npc_dir RIGHT
                npc_vehicle CHOCOBO
                npc_speed SLOWER
                npc_gfx SHOPKEEPER, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 16

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 17

        special_npc_prop {1, 9}, $03ff, {0, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx FLYING_TERRA_1, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {2, 9}, $03ff, {2, 0}
                npc_master 0, 1, RIGHT
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx FLYING_TERRA_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {4, 3}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {21, 8}, $03ff
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx ESPER_TERRA, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {8, 8}, $039f, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ENDING_TERRA_3, TERRA
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {8, 7}, $039f, {0, 1}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx ENDING_TERRA_1, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {9, 7}, $039f, {0, 2}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx ENDING_TERRA_2, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {21, 9}, $039f
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {19, 10}, $039f
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {23, 12}, $039f
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {20, 4}, $039f
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {22, 11}, $039f
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 5}, $03ff
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 18

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 19

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 20

        npc_prop {23, 30}, $0600
                npc_event _ccd1ef
                npc_dir UP
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {43, 34}, $0600
                npc_event _ccd1f3
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {37, 15}, $0600
                npc_event _ccd1f7
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {37, 37}, $0600
                npc_event _ccd1fb
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {42, 25}, $0600
                npc_event _ccd1ff
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {43, 25}, $0600
                npc_event _ccd203
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {39, 32}, $0601
                npc_event _ccd1ef
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {53, 9}, $0608
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {0, 0}, $062c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {0, 0}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {0, 0}, $062c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {0, 0}, $062c
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {0, 0}, $062c
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {38, 16}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {38, 17}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {38, 1}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {38, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {0, 0}, $0629
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {45, 22}, $0600
                npc_event _ccd207
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {34, 24}, $0600
                npc_event _ccd215
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {46, 36}, $0600
                npc_event _ccd223
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {36, 42}, $0600
                npc_event _ccd231
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {33, 26}, $0600
                npc_event _ccd23f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {37, 47}, $062a
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {39, 47}, $062a
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {49, 32}, $063f
                npc_dir UP
                npc_speed FAST
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {33, 56}, $06a2
                npc_event _cc33b8
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 21

        npc_prop {37, 25}, $063f
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {35, 16}, $0600
                npc_dir DOWN
                npc_speed FAST
                npc_gfx UMARO, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 22

        npc_prop {19, 37}, $0612
                npc_event _ccbca0
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {0, 0}, $061b
                npc_event _ccc547
                npc_dir DOWN
                npc_speed FAST
                npc_gfx TERRA
                end_npc

        npc_prop {18, 11}, $061b
                npc_event _ccc3eb
                npc_dir DOWN
                npc_speed FAST
                npc_gfx LOCKE
                end_npc

        npc_prop {19, 11}, $061b
                npc_event _ccc4d3
                npc_dir DOWN
                npc_speed FAST
                npc_gfx CELES
                end_npc

        npc_prop {20, 11}, $061b
                npc_event _ccc499
                npc_dir DOWN
                npc_speed FAST
                npc_gfx CYAN
                end_npc

        npc_prop {21, 11}, $061b
                npc_event _ccc425
                npc_dir DOWN
                npc_speed FAST
                npc_gfx EDGAR
                end_npc

        npc_prop {22, 11}, $061b
                npc_event _ccc45f
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SABIN
                end_npc

        npc_prop {23, 11}, $061b
                npc_event _ccc50d
                npc_dir DOWN
                npc_speed FAST
                npc_gfx GAU
                end_npc

        npc_prop {20, 7}, $061b
                npc_event _ccc605
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {18, 33}, $061d
                npc_event _ccc90c
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        npc_prop {19, 33}, $061e
                npc_event _ccc943
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        npc_prop {20, 33}, $061f
                npc_event _ccc97a
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        npc_prop {21, 33}, $0620
                npc_event _ccc9b1
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        npc_prop {22, 33}, $0621
                npc_event _ccc9e8
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        npc_prop {23, 33}, $0622
                npc_event _ccca1f
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        npc_prop {18, 34}, $0623
                npc_event _ccca56
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {19, 34}, $0624
                npc_event _ccca6f
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {20, 34}, $0625
                npc_event _cccaa6
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {21, 34}, $0626
                npc_event _cccadd
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {22, 34}, $0627
                npc_event _cccb14
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {23, 34}, $061c
                npc_event _cccb4b
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {20, 7}, $0628
                npc_event _ccc8e3
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {25, 5}, $0633
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 23

        special_npc_prop {8, 11}, $0613, {0, 0}
                npc_32x32
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx TRITOCH, TERRA
                end_npc

        npc_prop {9, 14}, $0614
                npc_dir UP
                npc_speed NORMAL
                npc_gfx ESPER_TERRA, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 7}, $0614
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {25, 27}, $0614
                npc_dir UP
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {17, 20}, $0614
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {18, 20}, $0614
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {19, 20}, $0614
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {20, 20}, $0614
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {21, 20}, $0614
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {22, 20}, $0614
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {14, 20}, $063f
                npc_dir LEFT
                npc_speed FAST
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {9, 15}, $0640
                npc_event _ccd594
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {9, 16}, $0640
                npc_event _ccd5df
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

        npc_prop {14, 20}, $0641
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 24

        npc_prop {28, 10}, $0600
                npc_event _ccd24d
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {43, 50}, $068a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {43, 50}, $06ad
                npc_event _cc0b1e
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 25

        npc_prop {6, 7}, $0600
                npc_event _ccd262
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 26

        npc_prop {44, 8}, $0600
                npc_event _ccd28c
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 27

        npc_prop {64, 7}, $0600
                npc_event _ccd277
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 28

        npc_prop {8, 38}, $0600
                npc_event _ccd2a7
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 29

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 30

        npc_prop {64, 29}, $0602
                npc_event _ccd1e7
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx ARVIS, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {66, 37}, $0603
                npc_event _cca06f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ARVIS, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {67, 27}, $0606
                npc_event _cca25e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {55, 35}, $0688
                npc_event _cca25e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {68, 30}, $0607
                npc_event _cca25e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx SLAVE_CROWN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {108, 16}, $0603
                npc_event _cca06f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {107, 16}, $0603
                npc_event _cca06f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {109, 16}, $0603
                npc_event _cca06f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {105, 17}, $0603
                npc_event _cca06f
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {111, 17}, $0603
                npc_event _cca06f
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {110, 26}, $0603
                npc_event _cca06f
                npc_dir LEFT
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {108, 16}, $0602
                npc_event _ccd1eb
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {63, 29}, $0602
                npc_event _ccd1e3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {64, 36}, $0615
                npc_event _ccc253
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {65, 36}, $0616
                npc_event _ccc25b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CELES
                npc_movement RANDOM
                end_npc

        npc_prop {66, 36}, $061a
                npc_event _ccc263
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CYAN
                npc_movement RANDOM
                end_npc

        npc_prop {64, 37}, $0617
                npc_event _ccc271
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx EDGAR
                npc_movement RANDOM
                end_npc

        npc_prop {65, 37}, $0618
                npc_event _ccc27f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SABIN
                npc_movement RANDOM
                end_npc

        npc_prop {66, 37}, $0619
                npc_event _ccc28d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GAU
                npc_movement RANDOM
                end_npc

        npc_prop {77, 9}, $063d
                npc_event _ccd3ca
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {81, 10}, $063d
                npc_event _ccd3c6
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {78, 9}, $063e
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {106, 16}, $064e
                npc_event _cc72ba
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {108, 16}, $064e
                npc_event _cc72be
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {110, 16}, $064e
                npc_event _cc72c2
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ARVIS, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {87, 45}, $06ad
                npc_event _cc0b70
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 31

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 32

        npc_prop {39, 46}, $068a
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {41, 37}, $06c0
                npc_event _cc0a9e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {32, 31}, $06c1
                npc_event _cc0aae
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {29, 26}, $06c2
                npc_event _cc0abe
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {52, 38}, $06c3
                npc_event _cc0ace
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {32, 17}, $06c4
                npc_event _cc0ade
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {41, 23}, $06c5
                npc_event _cc0aee
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 33

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 34

        npc_prop {25, 5}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {22, 20}, $0695
                npc_event _cc36df
                npc_dir DOWN
                npc_speed FAST
                npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 35

        special_npc_prop {8, 11}, $068c, {0, 0}
                npc_32x32
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed FAST
                npc_gfx TRITOCH, TERRA
                end_npc

        npc_prop {9, 11}, $068a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 36

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 37

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 38

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 39

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {0, 0}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 40

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 41

        npc_prop {42, 4}, $0604
                npc_dir UP
                npc_speed FAST
                npc_gfx NARSHE_GUARD, EDGAR_SABIN_CELES
                end_npc

        npc_prop {33, 22}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 42

        special_npc_prop {86, 7}, $0605, {0, 0}
                npc_32x32
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed FAST
                npc_gfx TRITOCH, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 43

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 44

        npc_prop {121, 46}, $068d
                npc_event _cc396c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 45

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 46

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 47

        npc_prop {52, 42}, $0300
                npc_event _ca77d7
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {52, 41}, $0300
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx TREASURE_CHEST, RAINBOW
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 48

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 49

        npc_prop {0, 0}, $0658
                npc_event _cce486
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0658
                npc_event _cce486
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0658
                npc_event _cce486
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0658
                npc_event _cce486
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0658
                npc_event _cce486
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0658
                npc_event _cce486
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0658
                npc_event _cce416
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0658
                npc_event _cce486
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 50

        npc_prop {58, 17}, $0609
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {58, 18}, $0609
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {49, 11}, $0609
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {49, 12}, $0609
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {66, 41}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 51

        npc_prop {14, 7}, $0609
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

        npc_prop {14, 7}, $0609
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

        npc_prop {15, 40}, $0631
                npc_event _ccada8
                npc_dir UP
                npc_speed NORMAL
                npc_gfx NARSHE_GUARD, LOCKE
                end_npc

        npc_prop {15, 34}, $060a
                npc_event _ccaadf
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {15, 35}, $060b
                npc_event _ccaaf7
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {15, 36}, $060c
                npc_event _ccab0f
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {15, 37}, $060d
                npc_event _ccab27
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {15, 38}, $060e
                npc_event _ccab3f
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {15, 39}, $060f
                npc_event _ccab57
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx MONSTER, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {14, 12}, $0631
                npc_event _ccaab3
                npc_no_react
                npc_anim ONE_FRAME, KNOCKED_OUT
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

        npc_prop {20, 36}, $0610
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {14, 7}, $0610
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 52

        npc_prop {121, 46}, $0643
                npc_event _ccd6e7
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

        npc_prop {118, 48}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {119, 48}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {120, 48}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {121, 48}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {122, 48}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {123, 48}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {124, 48}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {115, 55}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {114, 47}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

        npc_prop {121, 51}, $0642
                npc_event _ccd6e3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 53

        npc_prop {31, 42}, $0399
                npc_dir UP
                npc_speed FAST
                npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 54

        npc_prop {40, 20}, $0300
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {12, 21}, $0300
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {24, 27}, $0300
                npc_dir UP
                npc_speed FAST
                npc_gfx CHANCELLOR, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 55

        npc_prop {29, 40}, $0300
                npc_event _ca71af
                npc_dir DOWN
                npc_speed FAST
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {24, 26}, $030e
                npc_event _ca7590
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {32, 26}, $030e
                npc_event _ca75b4
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {24, 16}, $0315
                npc_event _ca5f9f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {28, 57}, $03fe
                npc_event _ca6f02
                npc_dir UP
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {27, 58}, $03fe
                npc_event _ca6ee6
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {29, 58}, $03fe
                npc_event _ca6ef2
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {23, 26}, $030d
                npc_event _ca661f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {33, 26}, $030d
                npc_event _ca661f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {44, 21}, $030b
                npc_event _ca75d8
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {12, 21}, $030b
                npc_event _ca75dc
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {28, 15}, $0311
                npc_event _ca6f60
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx LOCKE
                end_npc

        npc_prop {31, 27}, $03ff
                npc_dir LEFT
                npc_speed FAST
                npc_gfx CHANCELLOR, TERRA
                end_npc

        npc_prop {40, 22}, $03ff
                npc_dir DOWN
                npc_speed FAST
                npc_gfx TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {18, 22}, $03fe
                npc_dir DOWN
                npc_vehicle CHOCOBO
                npc_speed FAST
                npc_gfx TERRA
                end_npc

        npc_prop {0, 0}, $03fe
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {0, 0}, $03fe
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {33, 41}, $030b
                npc_event _ca71af
                npc_dir DOWN
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {23, 41}, $030b
                npc_event _ca71af
                npc_dir DOWN
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {38, 31}, $030b
                npc_event _ca71af
                npc_dir DOWN
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {18, 31}, $030b
                npc_event _ca71af
                npc_dir DOWN
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {28, 13}, $03ff
                npc_dir UP
                npc_speed NORMAL
                npc_gfx OLD_WOMAN, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 56

        npc_prop {20, 41}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {18, 39}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {18, 41}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {17, 43}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {17, 38}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 41}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 43}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 39}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {14, 40}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {15, 44}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {13, 39}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 41}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {13, 43}, $0611
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 57

        npc_prop {64, 19}, $030f
                npc_event _ca6c76
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {58, 21}, $030f
                npc_event _ca6c85
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_WOMAN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {59, 22}, $03fe
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SABIN
                end_npc

        npc_prop {62, 15}, $03fe
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 58

        npc_prop {101, 42}, $0308
                npc_event _ca6623
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {98, 47}, $0309
                npc_event _ca6601
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {106, 47}, $0309
                npc_event _ca6601
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {102, 52}, $03ff
                npc_dir UP
                npc_speed FAST
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {102, 53}, $03ff
                npc_event _ca67e6
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx CHANCELLOR, TERRA
                end_npc

        npc_prop {103, 56}, $03ff
                npc_event _ca67e6
                npc_dir UP
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 59

        npc_prop {25, 15}, $030e
                npc_event _ca6786
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {29, 15}, $030e
                npc_event _ca6794
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {28, 20}, $0316
                npc_event _ca67e6
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx CHANCELLOR, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {82, 45}, $0313
                npc_event _ca700e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx LOCKE
                end_npc

        npc_prop {50, 47}, $030f
                npc_event _ca6c12
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {52, 46}, $0310
                npc_event _ca6c20
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {67, 44}, $0302
                npc_event _ca679e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {79, 12}, $0302
                npc_event _ca679e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {10, 13}, $0300
                npc_event _ca67a2
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {44, 15}, $0300
                npc_event _ca67c0
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {12, 49}, $0382
                npc_event _ca6a28
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

        npc_prop {12, 42}, $0397
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {12, 50}, $0397
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx NOTHING, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 60

        npc_prop {100, 12}, $030f
                npc_event _ca6c46
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {104, 16}, $030f
                npc_event _ca6c5e
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {103, 26}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx LOCKE
                end_npc

        npc_prop {103, 29}, $03fe
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 61

        npc_prop {29, 40}, $0381
                npc_event _ca6807
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {26, 38}, $0380
                npc_event _ca681f
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {23, 38}, $0380
                npc_event _ca6823
                npc_dir DOWN
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {32, 38}, $0380
                npc_event _ca6827
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {35, 39}, $0359
                npc_event _ca682b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {6, 33}, $0300
                npc_event _ca682f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {28, 41}, $0382
                npc_event _ca6a28
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

        npc_prop {29, 41}, $0383
                npc_no_react
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx EDGAR, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 62

        npc_prop {12, 16}, $0382
                npc_event _ca6a28
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 63

        npc_prop {53, 10}, $0382
                npc_event _ca6a28
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD_DEAD, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 64

        npc_prop {25, 9}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {27, 8}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {26, 11}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {28, 11}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {26, 13}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {31, 9}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {33, 8}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {32, 11}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {34, 11}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx TENTACLE_2, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {32, 13}, $03f0
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx TENTACLE_1, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {29, 16}, $03f1
                npc_event _ca6a48
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx EDGAR, LOCKE
                end_npc

        npc_prop {29, 8}, $03f2
                npc_dir LEFT
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {30, 7}, $03f2
                npc_dir DOWN
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {29, 10}, $03f2
                npc_dir LEFT
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {29, 11}, $03f2
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 65

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 66

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 67

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 68

        npc_prop {14, 36}, $0398
                npc_event _ca7775
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 69

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 70

        npc_prop {45, 27}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx TURTLE, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 71

        npc_prop {10, 49}, $031d
                npc_no_react
                npc_dir DOWN
                npc_vehicle MAGITEK
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {11, 50}, $031d
                npc_event _ca8468
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {10, 49}, $0312
                npc_event _ca75ee
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {11, 49}, $0312
                npc_no_react
                npc_dir DOWN
                npc_vehicle CHOCOBO
                npc_speed FAST
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 72

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 73

        npc_prop {45, 27}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx TURTLE, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 74

        npc_prop {29, 21}, $0300
                npc_no_react
                npc_dir DOWN
                npc_vehicle MAGITEK
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {29, 22}, $037a
                npc_event _ca802e
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {26, 24}, $037a
                npc_event _ca8032
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {20, 21}, $0300
                npc_event _ca803a
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {20, 20}, $0300
                npc_event _ca803a
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {18, 24}, $0300
                npc_event _ca803e
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {51, 15}, $037b
                npc_event _ca8042
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {52, 15}, $037c
                npc_event _ca8053
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {31, 26}, $0300
                npc_event _ca806b
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {29, 31}, $0300
                npc_event _ca806f
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {31, 45}, $0300
                npc_event _ca8073
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {22, 48}, $0300
                npc_event _ca8077
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 75

        npc_prop {13, 34}, $0303
                npc_event _ca77ad
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {12, 35}, $0303
                npc_event _ca77b1
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {29, 32}, $0303
                npc_event _ca77b5
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {43, 10}, $0303
                npc_event _ca77b9
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {21, 48}, $0303
                npc_event _ca77bd
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {4, 31}, $03ff
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SHADOW
                end_npc

        npc_prop {48, 44}, $0303
                npc_event _ca77c1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {19, 30}, $0303
                npc_event _ca77c5
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {37, 48}, $0303
                npc_event _ca77d3
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {30, 42}, $030c
                npc_event _ca854f
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {14, 24}, $030c
                npc_event _ca856f
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {5, 33}, $030c
                npc_event _ca85e2
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {19, 51}, $030c
                npc_event _ca858f
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {9, 34}, $030c
                npc_event _ca85e2
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {29, 21}, $0360
                npc_no_react
                npc_dir DOWN
                npc_vehicle MAGITEK
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {15, 20}, $030c
                npc_event _ca7e3c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {52, 38}, $030c
                npc_event _ca7e2c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {46, 13}, $030c
                npc_event _ca7e2c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {15, 27}, $031b
                npc_event _ca7e5e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {28, 22}, $030c
                npc_event _ca7e46
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {11, 21}, $0318
                npc_event _ca7e7b
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {22, 47}, $0319
                npc_event _ca7e9a
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {4, 34}, $030c
                npc_event _ca85e2
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 76

        npc_prop {87, 10}, $030c
                npc_event _ca85e6
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {89, 7}, $0379
                npc_event _ca7890
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {51, 9}, $0300
                npc_event _ca7878
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {81, 17}, $0300
                npc_event _ca7894
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {51, 11}, $0358
                npc_event _ca78dc
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {88, 11}, $037e
                npc_event _ca808d
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx EDGAR, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {87, 20}, $03ff
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 77

        npc_prop {109, 11}, $030c
                npc_event _ca7eef
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {102, 12}, $030c
                npc_event _ca7ef9
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {103, 9}, $0300
                npc_event _ca7860
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {114, 10}, $0300
                npc_event _ca786c
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 78

        npc_prop {36, 40}, $0305
                npc_event _ca7c3a
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SHADOW
                end_npc

        npc_prop {36, 41}, $0305
                npc_event _ca7d01
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {26, 42}, $0379
                npc_event _ca7d1d
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {24, 41}, $0303
                npc_event _ca7d2b
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {30, 44}, $0303
                npc_event _ca7d4d
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {28, 42}, $0303
                npc_event _ca7d65
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx HOOKER, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {75, 39}, $0307
                npc_event _ca7d7d
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {38, 40}, $0300
                npc_event _ca7d13
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {81, 17}, $0303
                npc_event _ca7e28
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {30, 42}, $030c
                npc_event _ca7ed1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {30, 44}, $030c
                npc_event _ca7edb
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {36, 40}, $030c
                npc_event _ca7ee5
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {28, 39}, $037a
                npc_event _ca8085
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {34, 42}, $037a
                npc_event _ca8089
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 79

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 80

        npc_prop {86, 38}, $0300
                npc_event _ca7a8d
                npc_no_react
                npc_dir RIGHT
                npc_vehicle CHOCOBO
                npc_speed SLOWER
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {85, 45}, $0300
                npc_event _ca7a36
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 81

        npc_prop {38, 11}, $0304
                npc_event _ca79d7
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {51, 10}, $0304
                npc_event _ca79f8
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {53, 10}, $0304
                npc_event _ca79fc
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {33, 10}, $0303
                npc_event _ca7a14
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {16, 11}, $0304
                npc_event _ca7a18
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {7, 11}, $030c
                npc_event _ca7f11
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {4, 16}, $030c
                npc_event _ca7f11
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {51, 11}, $030c
                npc_event _ca7f15
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 82

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 83

        npc_prop {57, 6}, $03fe
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx CELES
                end_npc

        npc_prop {59, 9}, $030c
                npc_event _ca7f19
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {57, 8}, $03fe
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {57, 6}, $0317
                npc_event _ca8837
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx CELES_CHAINS, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 84

        npc_prop {53, 57}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 85

        npc_prop {103, 51}, $030c
                npc_event _ca85e6
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {107, 55}, $030c
                npc_event _ca7f03
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {106, 52}, $0300
                npc_event _ca7884
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 86

        npc_prop {54, 51}, $0300
                npc_event _ca7a90
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {28, 17}, $0300
                npc_event _ca7b88
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {30, 8}, $0303
                npc_event _ca7bc9
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {28, 16}, $030a
                npc_event _ca7e06
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {6, 10}, $030c
                npc_event _ca7bcd
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 87

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 88

        npc_prop {11, 34}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 89

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 90

        npc_prop {45, 27}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx TURTLE, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {47, 32}, $037f
                npc_event _ca927e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {46, 31}, $037f
                npc_event _ca927e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {46, 32}, $037f
                npc_event _ca927e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {49, 31}, $037f
                npc_event _ca927e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {47, 35}, $037f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EDGAR, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {48, 34}, $03ff
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 91

        npc_prop {14, 9}, $0300
                npc_event _ca77d7
                npc_no_react
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {15, 12}, $0300
                npc_event _ca77d7
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {11, 10}, $03fe
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {11, 11}, $03fe
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {11, 12}, $03fe
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {11, 13}, $03fe
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {13, 11}, $03fe
                npc_no_react
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx EDGAR, LOCKE
                end_npc

        npc_prop {15, 9}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx TREASURE_CHEST, RAINBOW
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 92

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 93

        npc_prop {4, 11}, $0306
                npc_event _ca8198
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 94

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 95

        npc_prop {11, 26}, $031d
                npc_event _ca847e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 96

        npc_prop {0, 0}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SABIN, RAINBOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 97

        npc_prop {40, 18}, $032e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SABIN, RAINBOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 98

        npc_prop {23, 32}, $031c
                npc_event _ca828f
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx VARGAS, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 99

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 100

        npc_prop {30, 53}, $0650
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RACHEL, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 101

        npc_prop {10, 49}, $031d
                npc_no_react
                npc_dir DOWN
                npc_vehicle MAGITEK
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {11, 50}, $031d
                npc_event _ca8473
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 102

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 103

        npc_prop {57, 8}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 104

        npc_prop {104, 47}, $0690
                npc_event _cc339c
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {107, 47}, $0690
                npc_event _cc33aa
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {106, 47}, $0690
                npc_event _cc33ae
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {94, 47}, $0690
                npc_event _cc369e
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {109, 49}, $0691
                npc_event _cc36a6
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {98, 47}, $0690
                npc_event _cc3403
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 105

        npc_prop {56, 33}, $0690
                npc_event _cc3677
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {58, 33}, $0690
                npc_event _cc3686
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {59, 32}, $0690
                npc_event _cc368a
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {56, 31}, $0690
                npc_event _cc368e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {57, 31}, $0690
                npc_event _cc3692
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {58, 31}, $0690
                npc_event _cc3696
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {55, 32}, $0690
                npc_event _cc369a
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {58, 29}, $0690
                npc_event _cc36a2
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {54, 30}, $0690
                npc_event _cc36b5
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {59, 29}, $0690
                npc_event _cc36b9
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 106

        npc_prop {57, 30}, $0690
                npc_event _cc3407
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                end_npc

        npc_prop {56, 30}, $0690
                npc_event _cc340b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                end_npc

        npc_prop {55, 30}, $0690
                npc_event _cc340f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                end_npc

        npc_prop {54, 30}, $0690
                npc_event _cc3413
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                end_npc

        npc_prop {60, 28}, $0690
                npc_event _cc3417
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {59, 32}, $0690
                npc_event _cc341b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {61, 31}, $0690
                npc_event _cc341f
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                end_npc

        npc_prop {54, 33}, $0690
                npc_event _cc3423
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RICH_MAN, RAINBOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 107

        npc_prop {60, 32}, $0690
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {59, 32}, $0690
                npc_event _cc33e1
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {60, 29}, $0690
                npc_event _cc33e8
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {56, 29}, $0690
                npc_event _cc33ec
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {53, 28}, $0690
                npc_event _cc33f0
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {58, 29}, $0690
                npc_event _cc33f4
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {55, 31}, $0690
                npc_event _cc33fb
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {55, 32}, $0690
                npc_event _cc33ff
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {54, 32}, $0690
                npc_event _ccd2ee
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 108

        npc_prop {14, 49}, $0421
                npc_event _cafab8
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 109

        npc_prop {9, 25}, $0413
                npc_event _caf68a
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {11, 15}, $0414
                npc_event _caf76e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {27, 25}, $0415
                npc_event _caf784
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {26, 28}, $0416
                npc_event _caf9af
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

        npc_prop {22, 19}, $0417
                npc_event _cb0080
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {23, 24}, $0418
                npc_event _cb0080
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {26, 25}, $0419
                npc_event _cb0080
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {26, 26}, $041a
                npc_event _cb0080
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {23, 25}, $041b
                npc_event _cb0080
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {9, 29}, $041c
                npc_event _cb0080
                npc_dir UP
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {25, 31}, $043a
                npc_event _caf64b
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 110

        npc_prop {51, 50}, $041d
                npc_event _caf79c
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {44, 14}, $041e
                npc_event _caf999
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {52, 48}, $041f
                npc_event _caf9a9
                npc_dir UP
                npc_speed SLOW
                npc_gfx EDGAR
                npc_movement RANDOM
                end_npc

        npc_prop {27, 48}, $0420
                npc_event _caf9cf
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx LOCKE
                end_npc

        npc_prop {21, 48}, $0423
                npc_event _cb0404
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                end_npc

        npc_prop {51, 49}, $0424
                npc_event _cb03fa
                npc_dir UP
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {50, 54}, $0497
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        npc_prop {50, 39}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 111

        npc_prop {43, 55}, $043b
                npc_event _caf64e
                npc_dir UP
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 112

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 113

        npc_prop {122, 24}, $0422
                npc_event _cb059f
                npc_dir DOWN
                npc_speed FAST
                npc_gfx ULTROS, MOG_UMARO
                end_npc

        npc_prop {31, 56}, $0428
                npc_event _cb059f
                npc_no_react
                npc_dir DOWN
                npc_vehicle RAFT
                npc_speed FAST
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 114

        npc_prop {20, 26}, $04fc
                npc_no_react
                npc_dir DOWN
                npc_vehicle RAFT
                npc_speed SLOWER
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {6, 18}, $04fd
                npc_no_react
                npc_dir DOWN
                npc_vehicle RAFT
                npc_speed SLOWER
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {20, 21}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {6, 13}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 115

        npc_prop {4, 12}, $0426
                npc_event _cb0a5f
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHADOW
                end_npc

        npc_prop {3, 12}, $0427
                npc_event _cb0b10
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {16, 12}, $0434
                npc_event _cb0b7e
                npc_dir LEFT
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 116

        npc_prop {115, 9}, $0425
                npc_event _cb6828
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 117

        npc_prop {32, 11}, $0400
                npc_event _cb0d9b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {41, 7}, $0401
                npc_event _cb0d9b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {36, 13}, $0402
                npc_event _cb0d9b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {44, 28}, $0403
                npc_event _cb0f2e
                npc_no_react
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        npc_prop {44, 8}, $0404
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {40, 33}, $0405
                npc_event _cb1126
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {29, 29}, $0406
                npc_event _cb0d9b
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 30}, $0407
                npc_event _cb11e9
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {26, 28}, $0408
                npc_dir UP
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {42, 28}, $0409
                npc_no_react
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {46, 11}, $040a
                npc_event _cb0db3
                npc_dir LEFT
                npc_speed FAST
                npc_gfx DOG, LOCKE
                end_npc

        npc_prop {49, 13}, $040b
                npc_dir UP
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {35, 15}, $040c
                npc_event _cb0f2e
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {45, 5}, $04ee
                npc_event _cb0dbe
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 118

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 119

        npc_prop {12, 8}, $0429
                npc_no_react
                npc_dir RIGHT
                npc_vehicle MAGITEK
                npc_speed SLOW
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {12, 10}, $042a
                npc_no_react
                npc_dir RIGHT
                npc_vehicle MAGITEK
                npc_speed SLOW
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {1, 23}, $042b
                npc_event _cb1483
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx CYAN
                end_npc

        npc_prop {5, 17}, $042c
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 17}, $042d
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 30}, $042e
                npc_no_react
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {17, 30}, $042f
                npc_no_react
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 14}, $0430
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {13, 14}, $0431
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {11, 27}, $0432
                npc_no_react
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {13, 26}, $0433
                npc_no_react
                npc_dir UP
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 12}, $0435
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {25, 39}, $0436
                npc_event _cb1955
                npc_no_react
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {43, 32}, $0437
                npc_event _cb19af
                npc_no_react
                npc_dir RIGHT
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {36, 14}, $0438
                npc_event _cb19e6
                npc_no_react
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {15, 30}, $0439
                npc_event _cb1985
                npc_no_react
                npc_dir RIGHT
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 120

        npc_prop {33, 59}, $0501
                npc_event _cb9eb5
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {32, 60}, $0501
                npc_event _cb9ffb
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {33, 60}, $0501
                npc_event _cba007
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {34, 60}, $0501
                npc_event _cba013
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {31, 61}, $0501
                npc_event _cba01f
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {32, 61}, $0501
                npc_event _cba02b
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {33, 61}, $0501
                npc_event _cba037
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {34, 61}, $0501
                npc_event _cba043
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {35, 61}, $0501
                npc_event _cba04f
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {32, 62}, $0501
                npc_event _cba05b
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {33, 62}, $0501
                npc_event _cba067
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {34, 62}, $0501
                npc_event _cba073
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {33, 44}, $0501
                npc_event _cb9e98
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {33, 43}, $0501
                npc_event _cb9e98
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {39, 41}, $0501
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {25, 42}, $0501
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {31, 40}, $0501
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {36, 40}, $0501
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 121

        npc_prop {28, 19}, $050c
                npc_event _cba382
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {28, 41}, $050c
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {41, 42}, $0511
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {33, 35}, $0511
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {34, 35}, $0511
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {39, 26}, $0511
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {16, 29}, $050c
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {10, 32}, $0511
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {27, 50}, $050b
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {17, 29}, $050b
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 122

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 123

        npc_prop {40, 9}, $0511
                npc_event _cba386
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {24, 10}, $0511
                npc_event _cba37e
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx KING_DOMA, TERRA
                end_npc

        npc_prop {54, 6}, $0511
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                end_npc

        npc_prop {6, 10}, $0523
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx CYAN
                end_npc

        npc_prop {4, 14}, $05f7
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {4, 14}, $05f7
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {4, 14}, $05f7
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 5}, $0549
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {25, 5}, $0549
                npc_event _cb9a7a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {10, 41}, $056a
                npc_event _cb9e98
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {10, 51}, $056a
                npc_event _cb9e98
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 124

        npc_prop {32, 29}, $0511
                npc_no_react
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {34, 31}, $0511
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BOY, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 125

        npc_prop {47, 18}, $0546
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BOY, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {47, 20}, $0546
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx CYAN, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {13, 22}, $0546
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx BOY, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {11, 22}, $0546
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx CYAN, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {10, 30}, $0500
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {33, 45}, $0500
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 126

        npc_prop {8, 9}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        npc_prop {9, 7}, $0547
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOMAN, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {7, 7}, $0547
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BOY, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {8, 8}, $0548
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {30, 31}, $0546
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx CYAN, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {32, 30}, $0546
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOMAN, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {34, 31}, $0546
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx BOY, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {24, 6}, $0548
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx CYAN
                end_npc

        npc_prop {25, 5}, $0548
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx EMPEROR_SERVANT, VEHICLE
                end_npc

        npc_prop {24, 9}, $0546
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOMAN, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {26, 9}, $0546
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BOY, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {25, 9}, $0546, {0, 0}
                npc_h_flip
                npc_master 15, 0, RIGHT
                _npc_is_slave .set 0
                npc_anim TWO_FRAMES, DEFAULT
                npc_speed NORMAL
                npc_gfx LEO_SWORD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {24, 9}, $0546
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {26, 9}, $0546
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 4}, $0546
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 5}, $0549
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 127

        npc_prop {7, 8}, $06ac
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANON, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 128

        npc_prop {80, 31}, $06b5
                npc_event _cc0bd4
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANON, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {80, 33}, $06bf
                npc_event _cc0f4c
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANON, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 129

        npc_prop {16, 22}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {17, 21}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {18, 20}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {19, 21}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {20, 22}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {11, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {12, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {10, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {11, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 130

        npc_prop {28, 4}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {26, 5}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {24, 6}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {25, 7}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {7, 7}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 6}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {9, 8}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 131

        npc_prop {7, 12}, $048e
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SPIFFY_GAU, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 132

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 133

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 134

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 135

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 136

        npc_prop {47, 4}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {48, 3}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {47, 4}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {49, 2}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_UP, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 137

        npc_prop {4, 11}, $0501
                npc_event _cbbe99
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx CYAN
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {15, 11}, $05f7
                npc_event _cbbe9f
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SHADOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 138

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 139

        npc_prop {49, 9}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        npc_prop {64, 12}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 13}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BOY, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 14}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {65, 9}, $0501
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 9}, $0501
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 15}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 16}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 16}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 16}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 16}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 16}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 16}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 16}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 10}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {64, 11}, $0501
                npc_dir UP
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 7}, $05f7
                npc_dir UP
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx SABIN
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {7, 7}, $05f7
                npc_dir UP
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx CYAN
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {7, 7}, $05f7
                npc_dir UP
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx SHADOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 140

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 141

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 142

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {66, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {77, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {77, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {77, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {77, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {77, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {77, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {77, 8}, $0509
                npc_event _cbb3e2
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 143

        npc_prop {96, 5}, $0543
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx CYAN, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {101, 5}, $0543
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx GHOST, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {109, 8}, $0500
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {66, 8}, $0500
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {46, 8}, $0500
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {50, 8}, $0500
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 144

        npc_prop {13, 7}, $054a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {14, 7}, $054a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {15, 7}, $054a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 145

        npc_prop {3, 6}, $0509
                npc_event _cbb265
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {8, 7}, $0509
                npc_event _cbb3b8
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {14, 9}, $0509
                npc_event _cbb3c0
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {20, 6}, $0509
                npc_event _cbb3c7
                npc_dir UP
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {17, 8}, $0509
                npc_event _cbb3ce
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {12, 8}, $0509
                npc_event _cbb3d5
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {6, 8}, $0507
                npc_event _cbaadd
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {23, 6}, $0507
                npc_event _cbaae8
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {8, 9}, $0506
                npc_event _cbaaf3
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {14, 10}, $0506
                npc_event _cbacfe
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {12, 8}, $0506
                npc_event _cbad05
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {12, 8}, $0507
                npc_event _cbad13
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {23, 7}, $0506
                npc_event _cbad0c
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {16, 8}, $0567
                npc_event _cbad44
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 146

        npc_prop {21, 9}, $0501
                npc_event _cbaee3
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx TRAIN_CONDUCTOR, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {20, 10}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 147

        npc_prop {6, 7}, $0501
                npc_event _cbb010
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {6, 8}, $0501
                npc_event _cbb010
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {16, 6}, $05f7
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 148

        npc_prop {14, 35}, $066f
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 35}, $066f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 33}, $066f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 34}, $066f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GIRL, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 34}, $066f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 33}, $066f
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 149

        npc_prop {14, 10}, $0501
                npc_event _cbab09
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {20, 6}, $0501
                npc_event _cbad36
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {5, 9}, $0501
                npc_event _cbad3d
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {24, 6}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 150

        npc_prop {36, 55}, $0674
                npc_event _cc4c0b
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx TERRA
                end_npc

        npc_prop {35, 55}, $0674
                npc_event _cc4c13
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {40, 49}, $066e
                npc_event _cc4c0f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {40, 49}, $066e
                npc_event _cc4c17
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {33, 57}, $0674
                npc_event _cc707f
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 151

        npc_prop {14, 8}, $0507
                npc_event _cbb90a
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx TRAIN_CONDUCTOR, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {8, 10}, $0506
                npc_event _cbab14
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {22, 9}, $0506
                npc_event _cbad1a
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {8, 10}, $0507
                npc_event _cbad21
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {14, 7}, $0507
                npc_event _cbad28
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {16, 11}, $0506
                npc_event _cbad2f
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 152

        npc_prop {11, 9}, $0501
                npc_event _cbaafe
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 153

        npc_prop {8, 17}, $0502
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {8, 9}, $0517
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 154

        npc_prop {51, 56}, $066f
                npc_event _cc44fb
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {50, 44}, $0675
                npc_event _cc4565
                npc_dir UP
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

        npc_prop {55, 43}, $0670
                npc_event _cc4aec
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx TERRA
                end_npc

        npc_prop {56, 45}, $0670
                npc_event _cc4ae8
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {56, 43}, $0670
                npc_event _cc4ae4
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {55, 44}, $0670
                npc_event _cc4ae0
                npc_dir UP
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {43, 57}, $0671
                npc_event _cc450b
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {44, 57}, $0671
                npc_event _cc4515
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {48, 55}, $0671
                npc_event _cc451f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {47, 52}, $066f
                npc_event _cc4529
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {45, 55}, $066f
                npc_event _cc4539
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {43, 52}, $066f
                npc_event _cc4543
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {41, 56}, $066f
                npc_event _cc454d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {44, 51}, $0672
                npc_event _cc455d
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {45, 51}, $0673
                npc_event _cc4561
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {56, 43}, $0676
                npc_event _cc507a
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {55, 43}, $0676
                npc_event _cc507e
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {50, 44}, $0677
                npc_event _cc506e
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {56, 45}, $0677
                npc_event _cc5076
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {55, 44}, $0677
                npc_event _cc5072
                npc_dir UP
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 155

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 156

        npc_prop {16, 39}, $03fe
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOW
                npc_bg2_scroll
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 11}, $03fe
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {13, 13}, $03fe
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {11, 18}, $03fe
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GIRL, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 157

        npc_prop {20, 40}, $0653
                npc_event _cc669b
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {17, 19}, $0653
                npc_event _cc669f
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {14, 36}, $0653
                npc_event _cc66a3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {5, 12}, $0653
                npc_event _cc66a7
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {12, 35}, $0653
                npc_event _cc66b3
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {20, 26}, $0653
                npc_event _cc66bb
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {5, 36}, $0653
                npc_event _cc66b7
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {22, 17}, $0653
                npc_event _cc66c7
                npc_dir UP
                npc_speed SLOWER
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {2, 22}, $0653
                npc_event _cc66bf
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {9, 20}, $0653
                npc_event _cc66c3
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {10, 20}, $0653
                npc_event _cc6755
                npc_dir LEFT
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {29, 23}, $0653
                npc_event _cc6759
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {17, 14}, $0653
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {5, 6}, $0653
                npc_event _cc66ab
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {18, 19}, $0653
                npc_event _cc6761
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {6, 6}, $0653
                npc_event _cc66af
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {20, 25}, $0653
                npc_event _cc707f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 158

        npc_prop {21, 12}, $066f
                npc_event _cc707f
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {25, 10}, $066f
                npc_event _cc707f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {16, 16}, $066e
                npc_dir DOWN
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {16, 16}, $066e
                npc_dir DOWN
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {16, 16}, $066e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {16, 16}, $066e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {6, 20}, $066e
                npc_dir DOWN
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {6, 20}, $066e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {6, 20}, $066e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx KATARIN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {11, 17}, $066e
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 18}, $066e
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 19}, $066e
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 14}, $066e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ESPER_TERRA, VEHICLE
                end_npc

        npc_prop {6, 19}, $066e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 159

        npc_prop {4, 15}, $050c
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx GAU
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 160

        npc_prop {24, 15}, $0653
                npc_event _cc6653
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 161

        npc_prop {11, 37}, $0653
                npc_event _cc6645
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {22, 37}, $0653
                npc_event _cc664c
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 162

        npc_prop {29, 21}, $0653
                npc_event _cc6694
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 163

        npc_prop {50, 13}, $0653
                npc_event _cc67cf
                npc_dir UP
                npc_speed SLOWER
                npc_gfx RICH_MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 164

        npc_prop {29, 48}, $0653
                npc_event _cc668d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 165

        npc_prop {15, 47}, $0653
                npc_event _cc675d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {15, 14}, $0653
                npc_event _cc6878
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {10, 11}, $0654
                npc_event _cc6768
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 25}, $0674
                npc_event _cc707f
                npc_dir UP
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {14, 16}, $0674
                npc_event _cc4b47
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 166

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 167

        npc_prop {12, 21}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        npc_prop {13, 21}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        npc_prop {12, 21}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        special_npc_prop {25, 18}, $05f7, {0, 0}
                npc_h_flip
                npc_master 15, 1, RIGHT
                _npc_is_slave .set 0
                npc_anim TWO_FRAMES, DEFAULT
                npc_speed NORMAL
                npc_gfx DIVING_HELMET, STRAGO_RELM_GAU_GOGO
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 168

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 169

        npc_prop {24, 39}, $0300
                npc_event _ca8f4a
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {17, 42}, $0300
                npc_event _ca8f23
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {23, 52}, $0300
                npc_event _ca8f2f
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {26, 47}, $0300
                npc_event _ca8f3e
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {19, 43}, $0300
                npc_event _ca8f56
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {22, 57}, $0300
                npc_event _ca8f64
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {9, 47}, $0300
                npc_event _ca8f72
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {15, 46}, $0300
                npc_event _ca8f80
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx WOMAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {21, 51}, $0300
                npc_event _ca8f8e
                npc_dir UP
                npc_speed FAST
                npc_gfx BOY, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {15, 34}, $0300
                npc_event _ca8f9c
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {20, 46}, $0376
                npc_event _ca91da
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EDGAR, LOCKE
                end_npc

        npc_prop {15, 58}, $0375
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {0, 55}, $0375
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {0, 55}, $0375
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {0, 55}, $0375
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 170

        npc_prop {7, 12}, $0300
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx CLYDE, LOCKE
                end_npc

        npc_prop {6, 8}, $0300
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx PILOT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 171

        npc_prop {46, 48}, $0300
                npc_event _ca8ee5
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 172

        npc_prop {29, 30}, $0300
                npc_event _ca8ff7
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {29, 34}, $0373
                npc_event _ca9005
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {27, 31}, $0300
                npc_event _ca9009
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx HOOKER, TERRA
                end_npc

        npc_prop {26, 32}, $0374
                npc_event _ca9189
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {27, 32}, $0374
                npc_event _ca9193
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {27, 34}, $0374
                npc_event _ca919d
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {23, 35}, $0374
                npc_event _ca91a7
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 173

        npc_prop {85, 45}, $0300
                npc_event _ca8fb4
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {88, 39}, $0300
                npc_event _ca7a8d
                npc_no_react
                npc_dir RIGHT
                npc_vehicle CHOCOBO
                npc_speed SLOWER
                npc_gfx SHOPKEEPER, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 174

        npc_prop {23, 7}, $03ff
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx CLYDE, LOCKE
                end_npc

        npc_prop {23, 7}, $03ff
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 175

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 176

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 177

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 178

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 179

        npc_prop {47, 6}, $0686
                npc_event _cc43cd
                npc_dir DOWN
                npc_speed FAST
                npc_gfx DRAGON, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {40, 15}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 180

        npc_prop {39, 53}, $0681
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {40, 53}, $0681
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {41, 53}, $0681
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {38, 55}, $0681
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {40, 55}, $0681
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {41, 55}, $0681
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {37, 56}, $0681
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 56}, $0681
                npc_event _cc42bb
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {44, 55}, $0682
                npc_event _cc3b11
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {42, 54}, $0684
                npc_event _cc42bf
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 181

        npc_prop {13, 10}, $0682
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 9}, $0683
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 10}, $0682
                npc_event _cc3b11
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {9, 11}, $0685
                npc_event _cc4355
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 182

        special_npc_prop {33, 23}, $03a0, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {35, 23}, $03a0, {2, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {33, 25}, $03a0, {0, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {35, 25}, $03a0, {2, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {24, 34}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx CLYDE, LOCKE
                end_npc

        npc_prop {15, 26}, $0300
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx WOMAN, TERRA
                end_npc

        npc_prop {28, 18}, $0300
                npc_no_react
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 183

        npc_prop {50, 45}, $0300
                npc_dir LEFT
                npc_speed FAST
                npc_gfx TERRA
                npc_sprite_priority LOW
                end_npc

        npc_prop {54, 45}, $0300
                npc_dir UP
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {44, 54}, $0300
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {44, 51}, $0300
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {43, 56}, $0300
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {44, 57}, $0300
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {47, 52}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {45, 51}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {46, 51}, $0300
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx KATARIN, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {46, 51}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx BABY, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {52, 60}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 184

        npc_prop {16, 15}, $0300
                npc_dir DOWN
                npc_speed FAST
                npc_gfx TERRA
                npc_sprite_priority LOW
                end_npc

        npc_prop {11, 23}, $03ff
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx ESPER_TERRA, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {9, 20}, $03fe
                npc_dir UP
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {21, 20}, $03fe
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {22, 20}, $03fe
                npc_dir DOWN
                npc_speed FAST
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {23, 20}, $03fe
                npc_dir LEFT
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 185

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 186

        npc_prop {117, 30}, $0500
                npc_event _cb7854
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 187

        npc_prop {17, 15}, $0300
                npc_event _ca8cbb
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {15, 15}, $0377
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {15, 16}, $0377
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {15, 17}, $0377
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {15, 18}, $0377
                npc_event _ca927e
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {17, 16}, $0378
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx EDGAR, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 188

        npc_prop {8, 20}, $064f
                npc_event _cc69fe
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {19, 25}, $064f
                npc_event _cc6a06
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {23, 19}, $064f
                npc_event _cc6a0a
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {17, 16}, $064f
                npc_event _cc6a0e
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {11, 15}, $064f
                npc_event _cc6a12
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {15, 7}, $064f
                npc_event _cc6a21
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {7, 23}, $064f
                npc_event _cc6a25
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {4, 7}, $0650
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {4, 7}, $0650
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx RACHEL, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {9, 20}, $0650
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BANDIT, LOCKE
                end_npc

        npc_prop {9, 14}, $0650
                npc_dir UP
                npc_speed NORMAL
                npc_gfx ESPER_TERRA, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {4, 7}, $0650
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {26, 20}, $064f
                npc_event _cc6a29
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {7, 11}, $064f
                npc_event _cc6d1e
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {26, 30}, $0680
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 31}, $0680
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {26, 31}, $0680
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {27, 31}, $0680
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 32}, $0680
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {28, 32}, $0680
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {24, 33}, $0680
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 189

        npc_prop {22, 21}, $067e
                npc_event _cc3b11
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {18, 25}, $067e
                npc_event _cc3ba2
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {14, 7}, $067e
                npc_event _cc3bc4
                npc_dir UP
                npc_speed SLOWER
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {13, 6}, $067e
                npc_event _cc3bc8
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {6, 23}, $067e
                npc_event _cc3bcc
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {12, 16}, $067e
                npc_event _cc3bda
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {10, 17}, $067e
                npc_event _cc3bde
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {14, 6}, $039d
                npc_event _cabf3e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx PLANT, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {9, 17}, $06b6
                npc_event _cc3510
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 190

        npc_prop {49, 41}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 191

        npc_prop {25, 15}, $0651
                npc_event _cc6f84
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx SHADOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {26, 16}, $0651
                npc_event _cc707f
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 13}, $064f
                npc_event _cc6f07
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                end_npc

        npc_prop {17, 11}, $064f
                npc_event _cc69ca
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {24, 11}, $064f
                npc_event _cc6f29
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {23, 15}, $067f
                npc_event _cc3bf8
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx SETZER
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 192

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 193

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 194

        npc_prop {9, 35}, $064f
                npc_event _cc69a6
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {15, 35}, $064f
                npc_event _cc69b2
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {19, 35}, $064f
                npc_event _cc69be
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 195

        npc_prop {37, 11}, $0650
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RACHEL, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {16, 42}, $0650
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {9, 55}, $068e
                npc_event _cc6d78
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, LOCKE
                end_npc

        npc_prop {8, 57}, $068e
                npc_event _cc6d91
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx RACHEL, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0687
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 55}, $068f
                npc_event _cc3300
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 196

        npc_prop {54, 52}, $067a
                npc_event _cc68e8
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {55, 51}, $067b
                npc_event _cc3d73
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {54, 50}, $06a8
                npc_event _cc3e00
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {53, 51}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {53, 52}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {53, 53}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {54, 54}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {58, 52}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {58, 53}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {59, 51}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {59, 52}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {59, 53}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {61, 51}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {61, 52}, $067b
                npc_event _cc3e41
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 197

        npc_prop {37, 11}, $0650
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RACHEL, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {16, 42}, $0650
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {9, 55}, $064f
                npc_event _cc6d78
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, LOCKE
                end_npc

        npc_prop {8, 57}, $064f
                npc_event _cc6d91
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx RACHEL, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 198

        npc_prop {17, 57}, $0300
                npc_event _cb450c
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {16, 26}, $0300
                npc_event _cb4519
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {8, 45}, $0300
                npc_event _cb4531
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx RICH_MAN, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {25, 29}, $0300
                npc_event _cb453f
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx RICH_MAN, TERRA
                end_npc

        npc_prop {6, 29}, $0300
                npc_event _cb4558
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {21, 31}, $0300
                npc_event _cb4570
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {6, 7}, $0300
                npc_event _cb4592
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {27, 45}, $0300
                npc_event _cb45f3
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {8, 42}, $0486
                npc_event _cb45a4
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {17, 52}, $04b1
                npc_event _cb45a0
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 199

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 200

        npc_prop {15, 20}, $0300
                npc_event _cb45c5
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {11, 18}, $0300
                npc_event _cb45c9
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {10, 20}, $0300
                npc_event _cb45d7
                npc_dir UP
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {13, 18}, $0300
                npc_event _cb45ef
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {14, 14}, $04f9
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {18, 20}, $04fa
                npc_event _cb4e43
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {12, 20}, $0300
                npc_event _cb4e35
                npc_dir UP
                npc_speed SLOW
                npc_gfx WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {17, 14}, $04f7
                npc_dir LEFT
                npc_vehicle CHOCOBO
                npc_speed NORMAL
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

        npc_prop {17, 14}, $04f5
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx BLACKJACK, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {17, 18}, $04f6
                npc_event _cb5ec9
                npc_dir UP
                npc_speed NORMAL
                npc_gfx RICH_MAN, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {16, 18}, $04f6
                npc_event _cb5ed4
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {19, 24}, $0300
                npc_event _cb4e47
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {16, 13}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx HOOKER, TERRA
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {18, 13}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx HOOKER, TERRA
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {17, 15}, $04f4
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx MAGICITE, TERRA
                end_npc

        npc_prop {17, 14}, $04f3
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx IMP, EDGAR_SABIN_CELES
                end_npc

        npc_prop {17, 14}, $04f1
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx ULTROS, TERRA
                end_npc

        npc_prop {17, 14}, $04f0
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx TREASURE_CHEST, VEHICLE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 201

        npc_prop {34, 15}, $0300
                npc_event _cb4460
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {31, 14}, $0499
                npc_dir UP
                npc_speed SLOW
                npc_gfx TERRA
                end_npc

        npc_prop {37, 15}, $049a
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx LOCKE
                end_npc

        npc_prop {35, 15}, $049b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CYAN
                end_npc

        npc_prop {32, 17}, $049c
                npc_dir UP
                npc_speed SLOW
                npc_gfx SHADOW
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {33, 15}, $049d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx EDGAR
                end_npc

        npc_prop {37, 14}, $049e
                npc_dir UP
                npc_speed SLOW
                npc_gfx CELES
                end_npc

        npc_prop {36, 19}, $049f
                npc_dir UP
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {37, 19}, $04a0
                npc_dir UP
                npc_speed SLOW
                npc_gfx RELM
                end_npc

        npc_prop {30, 18}, $04a1
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SETZER
                end_npc

        npc_prop {34, 18}, $04a2
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOW
                npc_gfx GAU_KUNG_FU, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {34, 18}, $04a3
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOW
                npc_gfx GAU_BANDANA, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 202

        npc_prop {54, 16}, $0300
                npc_event _cb4484
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 203

        npc_prop {58, 45}, $0300
                npc_event _cb4478
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 204

        npc_prop {39, 43}, $0300
                npc_event _cb446c
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 205

        npc_prop {86, 38}, $0300
                npc_event _ca7a8d
                npc_no_react
                npc_dir RIGHT
                npc_vehicle CHOCOBO
                npc_speed SLOWER
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {85, 45}, $0300
                npc_event _cb44cd
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 206

        npc_prop {14, 53}, $0300
                npc_event _cb4490
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {12, 55}, $0300
                npc_event _cb45a8
                npc_dir UP
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {17, 41}, $04a4
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx TERRA
                end_npc

        npc_prop {18, 43}, $04a5
                npc_dir UP
                npc_speed SLOW
                npc_gfx LOCKE
                end_npc

        npc_prop {20, 43}, $04a6
                npc_dir UP
                npc_speed SLOW
                npc_gfx CYAN
                end_npc

        npc_prop {15, 45}, $04a7
                npc_dir UP
                npc_speed SLOW
                npc_gfx SHADOW
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {17, 39}, $04a8
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EDGAR
                end_npc

        npc_prop {17, 44}, $04a9
                npc_dir UP
                npc_speed SLOW
                npc_gfx CELES
                end_npc

        npc_prop {17, 46}, $04aa
                npc_dir UP
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {18, 46}, $04ab
                npc_dir UP
                npc_speed SLOW
                npc_gfx RELM
                end_npc

        npc_prop {14, 40}, $04ac
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 207

        npc_prop {81, 49}, $0492
                npc_no_react
                npc_dir UP
                npc_speed SLOWER
                npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                end_npc

        npc_prop {81, 51}, $0493
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        npc_prop {88, 50}, $0494
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {90, 50}, $0495
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {92, 50}, $0496
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {87, 41}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {73, 50}, $04ad
                npc_event _cb4a4e
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx TREASURE_CHEST, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {75, 49}, $04ae
                npc_event _cb4a8e
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx TREASURE_CHEST, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {77, 50}, $04af
                npc_event _cb4acd
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx TREASURE_CHEST, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {79, 49}, $04b0
                npc_event _cb4b0c
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx TREASURE_CHEST, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {107, 51}, $04b2
                npc_event _cb49f3
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 208

        special_npc_prop {74, 8}, $048f, {0, 0}
                npc_32x32
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CHADARNOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {74, 10}, $0490, {2, 0}
                npc_master 1, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CHADARNOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {75, 10}, $0491, {3, 0}
                npc_master 2, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CHADARNOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {75, 11}, $0487
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx RELM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {75, 14}, $0488
                npc_event _cb4cfa
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx OWZER_1, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {76, 14}, $0488
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx OWZER_2, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 209

        npc_prop {117, 19}, $032f
                npc_event _ca9337
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {124, 14}, $0300
                npc_event _ca93ef
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx RICH_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {118, 25}, $0331
                npc_event _ca93fa
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {99, 21}, $0492
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {99, 21}, $04f2
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx ULTROS, MOG_UMARO
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 210

        special_npc_prop {13, 39}, $03a0, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {15, 39}, $03a0, {2, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {13, 41}, $03a0, {0, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {15, 41}, $03a0, {2, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 211

        special_npc_prop {7, 3}, $03a0, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {9, 3}, $03a0, {2, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {7, 5}, $03a0, {0, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {9, 5}, $03a0, {2, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 212

        special_npc_prop {84, 26}, $03a0, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {86, 26}, $03a0, {2, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {84, 28}, $03a0, {0, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {86, 28}, $03a0, {2, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 213

        special_npc_prop {21, 16}, $03a0, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {23, 16}, $03a0, {2, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {21, 18}, $03a0, {0, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {23, 18}, $03a0, {2, 2}
                npc_32x32
                npc_speed SLOWER
                npc_gfx NOTHING, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 214

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 215

        special_npc_prop {4, 4}, $0300, {0, 1}
                npc_32x32
                npc_speed SLOWER
                npc_gfx FALCON_1, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {6, 4}, $0300, {0, 0}
                npc_speed SLOWER
                npc_gfx FALCON_2, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {6, 5}, $0300, {1, 0}
                npc_speed SLOWER
                npc_gfx FALCON_3, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {5, 15}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {4, 15}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {5, 15}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {6, 15}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {2, 9}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {3, 8}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {4, 10}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {13, 2}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {15, 3}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {11, 0}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {10, 1}, $0300, {4, 0}
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx SMALL_BIRD_LEFT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 216

        npc_prop {41, 8}, $0300
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {38, 8}, $0300
                npc_dir DOWN
                npc_speed SLOW
                npc_bg2_scroll
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {41, 8}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx BABY, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {42, 9}, $0300
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx MADUIN, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 217

        npc_prop {32, 11}, $0337
                npc_event _ca9d36
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx YURA, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {32, 11}, $0338
                npc_event _ca9eb2
                npc_no_react
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {34, 26}, $033d
                npc_event _ca9e92
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx WOLF, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {28, 30}, $033d
                npc_event _ca9ea0
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx FAERIE, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {37, 38}, $033d
                npc_event _ca9eae
                npc_dir UP
                npc_speed FAST
                npc_gfx FAERIE, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {23, 24}, $033e
                npc_event _ca9e3e
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx ESPER_ELDER, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {32, 6}, $03ff
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {33, 7}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {33, 7}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {32, 18}, $035c
                npc_event _ca9e42
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx ESPER_ELDER, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 218

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {55, 34}, $0357
                npc_event _ca9fbf
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {55, 35}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx BABY, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {55, 43}, $035d
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {54, 47}, $035d
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {56, 45}, $035d
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        special_npc_prop {53, 29}, $0300, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx GATE_1, VEHICLE
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {56, 29}, $0300, {4, 0}
                npc_h_flip
                npc_32x32
                npc_speed SLOWER
                npc_gfx GATE_1, VEHICLE
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 219

        npc_prop {46, 42}, $0339
                npc_event _ca9f26
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {47, 42}, $035b
                npc_event _ca9fa2
                npc_dir LEFT
                npc_speed FAST
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {47, 45}, $033a
                npc_event _ca9d68
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx FAERIE, TERRA
                end_npc

        npc_prop {40, 50}, $033b
                npc_event _ca9dcf
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx ESPER_ELDER, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {38, 50}, $033c
                npc_event _ca9e46
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx WOLF, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {46, 42}, $035a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx BABY, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 50}, $033c
                npc_event _ca9e68
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx FAERIE, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {8, 47}, $033c
                npc_event _ca9e76
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx WOLF, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {5, 10}, $033c
                npc_event _ca9e84
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 220

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 221

        special_npc_prop {35, 42}, $0300, {1, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {35, 43}, $0300, {2, 0}
                npc_master 0, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {35, 42}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {35, 42}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {35, 42}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {35, 42}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {35, 42}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {57, 41}, $0330
                npc_event _ca950b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {41, 59}, $0300
                npc_event _ca950f
                npc_no_react
                npc_anim ONE_FRAME, KNOCKED_OUT
                npc_speed SLOW
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {43, 29}, $0300
                npc_event _ca9513
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MERCHANT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {23, 37}, $0300
                npc_event _ca957e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {41, 32}, $0300
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx WOMAN, TERRA
                end_npc

        npc_prop {44, 53}, $0300
                npc_no_react
                npc_anim ONE_FRAME, KNOCKED_OUT
                npc_speed NORMAL
                npc_gfx MERCHANT, TERRA
                end_npc

        npc_prop {30, 14}, $034a
                npc_event _ca96a9
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx VARGAS, VEHICLE
                end_npc

        npc_prop {49, 35}, $0356
                npc_event _ca95b4
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {13, 34}, $0300
                npc_event _ca957e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {59, 44}, $0384
                npc_event _ca9542
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {63, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {59, 43}, $0385
                npc_event _cc36a6
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 222

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 223

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 224

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 225

        npc_prop {53, 51}, $0300
                npc_event _ca9586
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {59, 32}, $0300
                npc_event _ca9594
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {54, 31}, $0300
                npc_event _ca9598
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {53, 26}, $0300
                npc_event _ca959c
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {53, 20}, $0300
                npc_event _ca95a0
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {52, 15}, $0300
                npc_event _ca95a4
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {54, 14}, $0300
                npc_event _ca95a8
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {50, 11}, $0300
                npc_event _ca95ac
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {48, 15}, $0300
                npc_event _ca95b0
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {106, 19}, $0300
                npc_event _ca9582
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {11, 38}, $0300
                npc_event _ca957a
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {123, 49}, $0300
                npc_event _ca9576
                npc_dir UP
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 226

        npc_prop {81, 17}, $0314
                npc_event _ca9749
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx ESPER_TERRA, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {84, 17}, $031e
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RAMUH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {84, 17}, $031f
                npc_event _caa7f5
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {82, 11}, $0320
                npc_event _caac91
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {81, 12}, $0321
                npc_event _caaca0
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {83, 12}, $0322
                npc_event _caacaf
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {82, 32}, $0323
                npc_event _caa890
                npc_dir UP
                npc_speed NORMAL
                npc_gfx LOCKE
                end_npc

        npc_prop {83, 33}, $0324
                npc_event _caa890
                npc_dir UP
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {82, 35}, $0325
                npc_event _caa890
                npc_dir UP
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {80, 34}, $0326
                npc_event _caa890
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

        npc_prop {81, 35}, $0327
                npc_event _caa890
                npc_dir UP
                npc_speed NORMAL
                npc_gfx CELES
                end_npc

        npc_prop {82, 36}, $0328
                npc_event _caa890
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GAU
                end_npc

        npc_prop {80, 17}, $0333
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {81, 14}, $0334
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {82, 15}, $0335
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

        npc_prop {79, 18}, $0336
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx GAU
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 227

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 228

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 229

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 230

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 231

        npc_prop {16, 17}, $03f4
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                end_npc

        npc_prop {17, 17}, $03f4
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, TERRA
                end_npc

        npc_prop {16, 19}, $0347
                npc_dir UP
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {14, 21}, $0347
                npc_dir LEFT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx MERCHANT, TERRA
                end_npc

        npc_prop {17, 22}, $0347
                npc_dir RIGHT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx MERCHANT, TERRA
                end_npc

        npc_prop {13, 21}, $0347
                npc_dir RIGHT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        npc_prop {18, 22}, $0347
                npc_dir LEFT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        npc_prop {17, 46}, $0351
                npc_event _cab714
                npc_dir UP
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {18, 46}, $0352
                npc_event _cab718
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

        npc_prop {19, 46}, $0353
                npc_event _cab71c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {20, 46}, $0354
                npc_event _cab720
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GAU
                end_npc

        npc_prop {13, 20}, $0348
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {14, 20}, $0348
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {18, 20}, $0348
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {19, 20}, $0348
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {16, 22}, $0346
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {17, 22}, $0346
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {15, 46}, $03f4
                npc_event _cab724
                npc_dir UP
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {17, 17}, $03ff
                npc_dir DOWN
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {17, 7}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ULTROS, MOG_UMARO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 20}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        npc_prop {14, 11}, $03ff
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx SETZER
                end_npc

        npc_prop {16, 18}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx CELES_CHAINS, EDGAR_SABIN_CELES
                end_npc

        npc_prop {16, 45}, $036f
                npc_event _caae11
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {16, 16}, $0387
                npc_event _ca9e84
                npc_dir DOWN
                npc_speed SLOW
                npc_bg2_scroll
                npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 232

        npc_prop {117, 4}, $0355
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {118, 29}, $0300
                npc_event _cab455
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 233

        npc_prop {16, 17}, $03f4
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                end_npc

        npc_prop {17, 17}, $03f4
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, TERRA
                end_npc

        npc_prop {16, 19}, $0347
                npc_dir UP
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {14, 21}, $0347
                npc_dir LEFT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx MERCHANT, TERRA
                end_npc

        npc_prop {17, 22}, $0347
                npc_dir RIGHT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx MERCHANT, TERRA
                end_npc

        npc_prop {13, 21}, $0347
                npc_dir RIGHT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        npc_prop {18, 22}, $0347
                npc_dir LEFT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                end_npc

        npc_prop {17, 46}, $0351
                npc_event _cab714
                npc_dir UP
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {18, 46}, $0352
                npc_event _cab718
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

        npc_prop {19, 46}, $0353
                npc_event _cab71c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {20, 46}, $0354
                npc_event _cab720
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GAU
                end_npc

        npc_prop {13, 20}, $0348
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {14, 20}, $0348
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {18, 20}, $0348
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {19, 20}, $0348
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {16, 22}, $0346
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {17, 22}, $0346
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {15, 46}, $03f4
                npc_event _cab724
                npc_dir UP
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {17, 17}, $03ff
                npc_dir DOWN
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {17, 7}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ULTROS, MOG_UMARO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 20}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        npc_prop {14, 11}, $03ff
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx SETZER
                end_npc

        npc_prop {16, 18}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx CELES_CHAINS, EDGAR_SABIN_CELES
                end_npc

        npc_prop {16, 45}, $036f
                npc_event _caae11
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {16, 16}, $0387
                npc_event _ca9e84
                npc_dir DOWN
                npc_speed SLOW
                npc_bg2_scroll
                npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 234

        npc_prop {15, 46}, $0300
                npc_event _cab724
                npc_dir UP
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {16, 23}, $03ff
                npc_dir DOWN
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                npc_sprite_priority LOW
                end_npc

        npc_prop {25, 23}, $0343
                npc_dir DOWN
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                npc_sprite_priority LOW
                end_npc

        npc_prop {23, 24}, $03ff
                npc_dir LEFT
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                npc_sprite_priority LOW
                end_npc

        npc_prop {23, 25}, $03ff
                npc_dir LEFT
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                npc_sprite_priority LOW
                end_npc

        npc_prop {23, 26}, $03ff
                npc_dir LEFT
                npc_vehicle CHOCOBO, SHOW_RIDER
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                npc_sprite_priority LOW
                end_npc

        npc_prop {16, 22}, $0344
                npc_dir DOWN
                npc_speed SLOWER
                npc_bg2_scroll
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                npc_sprite_priority LOW
                end_npc

        npc_prop {17, 46}, $0351
                npc_event _cab714
                npc_dir UP
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {18, 46}, $0352
                npc_event _cab718
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SABIN
                end_npc

        npc_prop {19, 46}, $0353
                npc_event _cab71c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx CYAN
                end_npc

        npc_prop {20, 46}, $0354
                npc_event _cab720
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GAU
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 235

        npc_prop {16, 17}, $0349
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx CELES_DRESS, EDGAR_SABIN_CELES
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {17, 21}, $0349
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx RICH_MAN, TERRA
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {16, 21}, $0349
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {14, 22}, $0349
                npc_dir LEFT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx MERCHANT, TERRA
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {17, 23}, $0349
                npc_dir RIGHT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx MERCHANT, TERRA
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {13, 22}, $0349
                npc_dir RIGHT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {18, 23}, $0349
                npc_dir LEFT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx FIGARO_GUARD, LOCKE
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {15, 7}, $034b
                npc_event _cabf4b
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ULTROS, MOG_UMARO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 11}, $034c
                npc_event _cac368
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 15}, $034d
                npc_event _cac37b
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {18, 14}, $034e
                npc_event _cac38e
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {21, 7}, $034f
                npc_event _cac3a1
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 12}, $0350
                npc_event _cac3b4
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx RAT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {16, 7}, $0300
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {16, 16}, $0387
                npc_event _ca9e84
                npc_dir DOWN
                npc_speed SLOW
                npc_bg2_scroll
                npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 236

        npc_prop {12, 19}, $03ff
                npc_event _cabf27
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx FLOWERS, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 0}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, SLOW
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 15}, $03ff
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx CHANCELLOR, TERRA
                end_npc

        npc_prop {12, 14}, $0300
                npc_event _cabd35
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx DRACO, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 237

        npc_prop {117, 4}, $0355
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {118, 29}, $0300
                npc_event _cab455
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {60, 48}, $0340
                npc_event _caae15
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {59, 44}, $0332
                npc_event _caae0d
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx IMPRESARIO, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {60, 48}, $0341
                npc_event _caadf1
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {77, 39}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {71, 32}, $0342
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx ULTROS, MOG_UMARO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {72, 34}, $0366
                npc_event _cabf3e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {54, 39}, $0300
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {66, 39}, $0300
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {60, 41}, $0386
                npc_event _caadff
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 238

        npc_prop {99, 20}, $0345
                npc_event _cabf31
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {117, 4}, $0355
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {118, 29}, $0300
                npc_event _cab455
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 239

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 240

        npc_prop {53, 13}, $06a3
                npc_dir RIGHT
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {64, 12}, $06a3, {2, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_1, RAINBOW
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {64, 13}, $06a3, {3, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_3, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {65, 12}, $06a3, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_2, RAINBOW
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {65, 13}, $06a3, {5, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_4, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {0, 0}, $0644
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {0, 0}, $0644
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {0, 0}, $0644
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {50, 50}, $0644
                npc_dir UP
                npc_speed FAST
                npc_gfx SETZER
                end_npc

        npc_prop {58, 7}, $06ae
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 241

        special_npc_prop {16, 5}, $0644, {2, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx CRANE_1, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {16, 6}, $0644, {0, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {17, 6}, $0644, {1, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_3, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {16, 7}, $0644, {0, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {19, 5}, $0644, {4, 0}
                npc_h_flip
                npc_32x32
                npc_speed SLOWER
                npc_gfx CRANE_1, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {20, 6}, $0644, {6, 0}
                npc_h_flip
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {19, 6}, $0644, {7, 0}
                npc_h_flip
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_3, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {20, 7}, $0644, {6, 0}
                npc_h_flip
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {16, 5}, $0644, {0, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {20, 5}, $0644, {6, 0}
                npc_h_flip
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {16, 6}, $0644, {0, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {20, 6}, $0644, {6, 0}
                npc_h_flip
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {16, 7}, $0644, {0, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {20, 7}, $0644, {6, 0}
                npc_h_flip
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx CRANE_2, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 242

        npc_prop {45, 39}, $063b
                npc_event _cc9627
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {54, 39}, $062b
                npc_event _cc93ce
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {55, 40}, $062b
                npc_event _cc93ce
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        npc_prop {54, 41}, $062b
                npc_event _cc93ce
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {37, 48}, $062b
                npc_event _cc936d
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {29, 15}, $062b
                npc_event _cc93e8
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {20, 39}, $062b
                npc_event _cc93e4
                npc_dir UP
                npc_speed NORMAL
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {34, 28}, $062b
                npc_event _cc9443
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {18, 37}, $062b
                npc_event _cc942f
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {15, 45}, $062b
                npc_event _cc9447
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {24, 6}, $062b
                npc_event _cc941e
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {34, 6}, $062b
                npc_event _cc941e
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {24, 14}, $062b
                npc_event _cc941e
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {34, 14}, $062b
                npc_event _cc941e
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {22, 21}, $062b
                npc_event _cc93e8
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {14, 29}, $062b
                npc_event _cc93e8
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        special_npc_prop {31, 57}, $064c, {0, 0}
                npc_speed SLOWER
                npc_gfx GUARDIAN_1, RAINBOW
                end_npc

        special_npc_prop {31, 58}, $064c, {1, 0}
                npc_master 16, 1, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_2, RAINBOW
                end_npc

        special_npc_prop {31, 59}, $064c, {2, 0}
                npc_master 16, 2, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_3, RAINBOW
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {32, 57}, $064c, {0, 1}
                npc_speed SLOWER
                npc_gfx GUARDIAN_4, RAINBOW
                end_npc

        special_npc_prop {32, 58}, $064c, {1, 1}
                npc_master 19, 1, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_5, RAINBOW
                end_npc

        special_npc_prop {32, 59}, $064c, {2, 1}
                npc_master 19, 2, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_6, RAINBOW
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {33, 57}, $064c, {3, 1}
                npc_h_flip
                npc_speed SLOWER
                npc_gfx GUARDIAN_1, RAINBOW
                end_npc

        special_npc_prop {33, 58}, $064c, {4, 1}
                npc_h_flip
                npc_master 22, 1, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_2, RAINBOW
                end_npc

        special_npc_prop {33, 59}, $064c, {5, 1}
                npc_h_flip
                npc_master 22, 2, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_3, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {57, 3}, $064d
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {58, 3}, $064d
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {59, 3}, $064d
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 243

        npc_prop {0, 21}, $062c
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {18, 13}, $062c
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {15, 13}, $062c
                npc_dir DOWN
                npc_speed FAST
                npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        npc_prop {12, 14}, $062b
                npc_event _cc873b
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {18, 14}, $062b
                npc_event _cc8782
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 13}, $062c
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {8, 18}, $0634
                npc_event _cc8796
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 14}, $0634
                npc_event _cc873b
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {18, 14}, $0634
                npc_event _cc8782
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 244

        npc_prop {18, 13}, $062a
                npc_dir UP
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {18, 17}, $062c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {17, 14}, $062c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        npc_prop {19, 14}, $062c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx CELES
                end_npc

        npc_prop {20, 13}, $062c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

        npc_prop {21, 14}, $062c
                npc_dir DOWN
                npc_vehicle MAGITEK
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {19, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {20, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {21, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {22, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {23, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {24, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {25, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {11, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {13, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {14, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {15, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {17, 23}, $062c
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {11, 23}, $062f
                npc_event _cc86eb
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {25, 23}, $062f
                npc_event _cc86ff
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 14}, $062f
                npc_event _cc8713
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {20, 14}, $062f
                npc_event _cc8727
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {10, 17}, $0634
                npc_event _cc87a6
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {18, 24}, $0636
                npc_event _cc92b1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 245

        npc_prop {16, 50}, $062b
                npc_event _cc9455
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {17, 50}, $062b
                npc_event _cc9459
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {7, 53}, $062b
                npc_event _cc945d
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 246

        npc_prop {29, 10}, $063c
                npc_event _ccd2a1
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 247

        npc_prop {51, 13}, $062b
                npc_event _cc95f3
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {43, 14}, $062b
                npc_event _cc95ff
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {45, 11}, $062b
                npc_event _cc95f7
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {48, 10}, $062b
                npc_event _cc95fb
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {41, 13}, $0637
                npc_event _cc929f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GAU
                end_npc

        npc_prop {45, 13}, $0638
                npc_event _cc92a8
                npc_dir UP
                npc_speed SLOW
                npc_gfx MOG
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 248

        npc_prop {8, 10}, $063c
                npc_event _ccd2a4
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 249

        npc_prop {20, 29}, $063c
                npc_event _cc9371
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {18, 30}, $062b
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {22, 30}, $062b
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 250

        npc_prop {21, 24}, $062f
                npc_event _cc8637
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {25, 24}, $062f
                npc_event _cc864b
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {21, 18}, $062f
                npc_event _cc865f
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {25, 18}, $062f
                npc_event _cc8673
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {23, 31}, $062d
                npc_event _cc83c6
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        npc_prop {54, 15}, $062e
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {53, 9}, $062c
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {52, 13}, $062f
                npc_event _cc83ca
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        npc_prop {56, 13}, $062f
                npc_event _cc83d4
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                end_npc

        npc_prop {98, 51}, $062f
                npc_event _cc86d7
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {76, 49}, $062f
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {16, 30}, $0630
                npc_event _cc83c6
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {30, 30}, $0630
                npc_event _cc83c6
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {112, 52}, $062c
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx TERRA
                end_npc

        npc_prop {51, 50}, $0634
                npc_event _cc87b6
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {9, 49}, $0634
                npc_event _cc87f9
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {110, 51}, $0634
                npc_event _cc8809
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {120, 13}, $0634
                npc_event _cc884c
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {115, 16}, $0634
                npc_event _cc885c
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {20, 19}, $0636
                npc_event _cc9284
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EDGAR
                npc_movement RANDOM
                end_npc

        npc_prop {82, 57}, $0636
                npc_event _cc9296
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx CYAN
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 251

        npc_prop {80, 16}, $062c
                npc_event _cc8a3f
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {71, 16}, $0635
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        npc_prop {76, 16}, $062c
                npc_event _cc8a47
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {78, 16}, $062c
                npc_event _cc8a47
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {82, 16}, $062c
                npc_event _cc8a47
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {84, 16}, $062c
                npc_event _cc8a47
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EMPEROR_SERVANT, TERRA
                npc_layer_priority TOP_SPRITE_ONLY
                end_npc

        npc_prop {71, 20}, $062c
                npc_event _cc8a43
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {72, 22}, $062c
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {80, 27}, $062c
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {81, 27}, $062c
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {79, 27}, $062c
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 252

        npc_prop {40, 56}, $062f
                npc_event _cc8687
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {42, 52}, $062f
                npc_event _cc869b
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {42, 56}, $062f
                npc_event _cc86af
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {37, 57}, $062f
                npc_event _cc86c3
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {42, 57}, $0634
                npc_event _cc886c
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {40, 54}, $0634
                npc_event _cc88af
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 253

        npc_prop {22, 6}, $0636
                npc_event _cc928d
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SABIN
                npc_movement RANDOM
                end_npc

        npc_prop {33, 5}, $0652
                npc_event _cc92b5
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANON, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {25, 6}, $0652
                npc_event _cc92c3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx ARVIS, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {29, 5}, $0652
                npc_event _cc92d1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {23, 20}, $0652
                npc_event _cc92d1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {20, 43}, $0652
                npc_event _cc92d1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {19, 48}, $0652
                npc_event _cc92d1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {35, 52}, $0652
                npc_event _cc92d1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {0, 0}, $0652
                npc_event _cc92d1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx PILOT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {21, 23}, $0652
                npc_event _cc92df
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {21, 29}, $0652
                npc_event _cc92df
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {19, 39}, $0652
                npc_event _cc92df
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {18, 37}, $0652
                npc_event _cc92df
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {25, 50}, $0652
                npc_event _cc92df
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {19, 29}, $0652
                npc_event _cc92df
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx NARSHE_GUARD, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 254

        special_npc_prop {39, 9}, $0300, {3, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {67, 0}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {67, 1}, $0300, {0, 0}
                npc_master 1, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {67, 2}, $0300, {0, 0}
                npc_master 1, 2, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {67, 3}, $0300, {0, 0}
                npc_master 1, 3, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {67, 4}, $0300, {0, 0}
                npc_master 1, 4, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {67, 5}, $0300, {1, 0}
                npc_master 1, 5, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {67, 6}, $0300, {2, 0}
                npc_master 1, 6, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {81, 5}, $0300, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx BIG_SWITCH, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {83, 6}, $0300, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx BIG_SWITCH, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {84, 6}, $0300, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx BIG_SWITCH, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {86, 6}, $0300, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx BIG_SWITCH, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {87, 6}, $0300, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx BIG_SWITCH, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {89, 5}, $0300, {4, 0}
                npc_master 0, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx BIG_SWITCH, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx EYES, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 255

        npc_prop {12, 14}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {6, 10}, $03ff
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {6, 10}, $03ff
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {6, 10}, $03ff
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {6, 10}, $03ff
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 256

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 257

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 258

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 259

        special_npc_prop {12, 7}, $0300, {0, 1}
                npc_32x32
                npc_speed SLOWER
                npc_gfx FALCON_1, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {14, 7}, $0300, {1, 0}
                npc_speed SLOWER
                npc_gfx FALCON_2, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {14, 8}, $0300, {2, 0}
                npc_speed SLOWER
                npc_gfx FALCON_3, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 260

        npc_prop {5, 8}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx BANDANA, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 8}, $0300
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx ESPER_TERRA, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 261

        special_npc_prop {16, 27}, $0300, {0, 2}
                npc_master 10, 4, DOWN
                _npc_is_slave .set 0
                npc_speed FAST
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {15, 28}, $0300, {0, 2}
                npc_master 10, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed FAST
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {16, 28}, $0300, {0, 2}
                npc_master 10, 5, DOWN
                _npc_is_slave .set 0
                npc_speed FAST
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {17, 28}, $0300, {0, 2}
                npc_master 10, 0, RIGHT
                _npc_is_slave .set 0
                npc_speed FAST
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {57, 45}, $0300
                npc_no_react
                npc_dir UP
                npc_speed FAST
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        special_npc_prop {14, 6}, $0300, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {14, 7}, $0300, {0, 0}
                npc_master 5, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {14, 8}, $0300, {0, 0}
                npc_master 5, 2, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {14, 9}, $0300, {0, 0}
                npc_master 5, 3, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {14, 10}, $0300, {0, 0}
                npc_master 5, 4, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {14, 11}, $0300, {1, 0}
                npc_master 5, 5, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {14, 12}, $0300, {2, 0}
                npc_master 5, 6, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 262

        special_npc_prop {24, 25}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {24, 28}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {24, 31}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {24, 34}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {5, 16}, $0644, {0, 2}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 17}, $0644, {0, 2}
                npc_master 4, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 18}, $0644, {0, 2}
                npc_master 4, 2, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 19}, $0644, {0, 2}
                npc_master 4, 3, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 20}, $0644, {1, 2}
                npc_master 4, 4, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 21}, $0644, {2, 2}
                npc_master 4, 5, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {6, 31}, $0644, {4, 0}
                npc_h_flip
                npc_32x32
                npc_speed SLOW
                npc_gfx ELEVATOR, RAINBOW
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {9, 54}, $0644, {4, 0}
                npc_32x32
                npc_speed SLOW
                npc_gfx ELEVATOR, RAINBOW
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 263

        special_npc_prop {25, 22}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                npc_layer_priority BACKGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {30, 27}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {28, 27}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {26, 27}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {24, 29}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {22, 31}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        special_npc_prop {32, 27}, $0644, {0, 0}
                npc_32x32
                npc_speed SLOWER
                npc_gfx MAGITEK_MACHINE, VEHICLE
                end_npc

        npc_prop {40, 39}, $0645
                npc_dir UP
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {36, 41}, $0645
                npc_event _cc7937
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx IFRIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {37, 40}, $0645
                npc_event _cc7992
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx SHIVA, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {17, 26}, $0644, {2, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {17, 28}, $0644, {2, 1}
                npc_master 10, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {42, 41}, $0644, {4, 0}
                npc_h_flip
                npc_32x32
                npc_speed SLOW
                npc_gfx ELEVATOR, RAINBOW
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 264

        special_npc_prop {6, 1}, $0644, {2, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {6, 2}, $0644, {2, 0}
                npc_master 0, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {6, 3}, $0644, {3, 0}
                npc_master 0, 2, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {6, 4}, $0644, {2, 1}
                npc_master 0, 3, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {3, 8}, $0646
                npc_event _cc7937
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOW
                npc_gfx IFRIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {9, 6}, $0646
                npc_event _cc7992
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOW
                npc_gfx SHIVA, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {3, 8}, $0647
                npc_event _cc79cd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {9, 6}, $0648
                npc_event _cc79dd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 265

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 266

        npc_prop {8, 0}, $0644
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        special_npc_prop {7, 0}, $0644, {4, 0}
                npc_h_flip
                npc_32x32
                npc_speed NORMAL
                npc_gfx ELEVATOR, RAINBOW
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 267

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 268

        npc_prop {31, 27}, $0300
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx ESPER_TERRA, RAINBOW
                end_npc

        npc_prop {18, 32}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 269

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 270

        npc_prop {25, 10}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 271

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 272

        npc_prop {9, 51}, $0644
                npc_event _cc8022
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        special_npc_prop {8, 50}, $0644, {0, 0}
                npc_h_flip
                npc_32x32
                npc_speed SLOW
                npc_gfx ELEVATOR, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {3, 55}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {11, 52}, $0644, {2, 0}
                npc_master 3, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_1, VEHICLE
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {11, 53}, $0644, {3, 0}
                npc_master 3, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_3, VEHICLE
                npc_sprite_priority HIGH
                end_npc

        special_npc_prop {12, 52}, $0644, {4, 0}
                npc_master 5, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_2, VEHICLE
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {12, 53}, $0644, {5, 0}
                npc_master 5, 4, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx MAGITEK_TRAIN_4, VEHICLE
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 273

        npc_prop {25, 51}, $0649
                npc_event _cc79ed
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOW
                npc_gfx NUMBER_024, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 274

        npc_prop {4, 7}, $064a
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx PHANTOM, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {4, 14}, $064a
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx UNICORN, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {4, 21}, $064a
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx BISMARK, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {15, 7}, $064a
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx CARBUNKL, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {15, 14}, $064a
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx SHOAT, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {15, 21}, $064a
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx MADUIN, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {4, 7}, $0645
                npc_event _cc79cd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {4, 14}, $0645
                npc_event _cc79cd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {4, 21}, $0645
                npc_event _cc79cd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {15, 7}, $0645
                npc_event _cc79cd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {15, 14}, $0645
                npc_event _cc79cd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {15, 21}, $0645
                npc_event _cc79cd
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {20, 17}, $0644
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {10, 23}, $0645
                npc_dir UP
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {9, 23}, $0645
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, TERRA
                end_npc

        npc_prop {11, 23}, $0645
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, TERRA
                end_npc

        npc_prop {10, 25}, $064b
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        special_npc_prop {10, 8}, $0644, {2, 0}
                npc_master 0, 0, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx BIG_SWITCH, RAINBOW
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {20, 17}, $0644, {4, 0}
                npc_h_flip
                npc_32x32
                npc_speed SLOW
                npc_gfx ELEVATOR, RAINBOW
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 275

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 276

        npc_prop {38, 30}, $0500
                npc_event _cb8251
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx TRAIN_CONDUCTOR, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {32, 32}, $0500
                npc_event _cb8251
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx TRAIN_CONDUCTOR, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {45, 30}, $0500
                npc_event _cb8251
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx TRAIN_CONDUCTOR, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 277

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 278

        npc_prop {8, 5}, $054b
                npc_event _cb81c6
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 279

        npc_prop {24, 4}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 280

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 281

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 282

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 283

        npc_prop {57, 15}, $0659
                npc_event _ccd6eb
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx SKULL_STATUE, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {59, 13}, $065b
                npc_event _ccd793
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx UMARO, MOG_UMARO
                end_npc

        npc_prop {57, 15}, $065a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 284

        npc_prop {26, 21}, $0656
                npc_event _cc64ae
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {27, 21}, $065c
                npc_event _cc64c6
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {14, 9}, $0656
                npc_event _cc64fa
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {20, 14}, $065c
                npc_event _cc707f
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {23, 14}, $065c
                npc_event _cc707f
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {21, 12}, $065c
                npc_event _cc64ce
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {19, 13}, $065c
                npc_event _cc64d2
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {22, 16}, $065c
                npc_event _cc64d6
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {22, 12}, $065c
                npc_event _cc64da
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {23, 12}, $065c
                npc_event _cc64de
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {8, 21}, $0656
                npc_event _cc64e2
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {16, 20}, $0656
                npc_event _cc6526
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx HOOKER, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {8, 14}, $0656
                npc_event _cc650e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {26, 8}, $0656
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {19, 15}, $065c
                npc_event _cc64ca
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {21, 16}, $065c
                npc_event _cc6551
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {21, 15}, $065d
                npc_event _cc6555
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {23, 9}, $067c
                npc_event _cc3f12
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {23, 8}, $0657
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {29, 6}, $069a
                npc_event _cc656b
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {7, 24}, $069a
                npc_event _cc6563
                npc_dir UP
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 285

        npc_prop {33, 48}, $0512
                npc_event _cba3c0
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {32, 47}, $0512
                npc_event _cba3c0
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {34, 47}, $0512
                npc_event _cba3c0
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 286

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 287

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 288

        npc_prop {46, 48}, $0656
                npc_event _cc6587
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {57, 38}, $069a
                npc_event _cc6567
                npc_dir LEFT
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 289

        npc_prop {54, 16}, $0656
                npc_event _cc656f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 290

        npc_prop {44, 8}, $0656
                npc_event _cc657b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 291

        special_npc_prop {11, 10}, $06bb, {0, 0}
                npc_speed SLOWER
                npc_gfx GUARDIAN_1, VEHICLE
                end_npc

        special_npc_prop {0, 0}, $06bb, {1, 0}
                npc_master 0, 1, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_2, VEHICLE
                end_npc

        special_npc_prop {0, 0}, $06bb, {2, 0}
                npc_master 0, 2, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_3, VEHICLE
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {12, 10}, $06bb, {0, 1}
                npc_master 3, 0, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GUARDIAN_4, VEHICLE
                end_npc

        special_npc_prop {0, 0}, $06bb, {1, 1}
                npc_master 3, 1, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_5, VEHICLE
                end_npc

        special_npc_prop {0, 0}, $06bb, {2, 1}
                npc_master 3, 2, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_6, VEHICLE
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {13, 10}, $06bb, {3, 1}
                npc_h_flip
                npc_master 6, 0, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GUARDIAN_1, VEHICLE
                end_npc

        special_npc_prop {0, 0}, $06bb, {4, 1}
                npc_h_flip
                npc_master 6, 1, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_2, VEHICLE
                end_npc

        special_npc_prop {0, 0}, $06bb, {5, 1}
                npc_h_flip
                npc_master 6, 2, DOWN
                npc_speed SLOWER
                npc_gfx GUARDIAN_3, VEHICLE
                npc_sprite_priority LOW
                end_npc

        npc_prop {12, 12}, $06ba
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 292

        special_npc_prop {87, 12}, $06a4, {4, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 293

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 294

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 295

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 296

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 297

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 298

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 299

        npc_prop {100, 13}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {56, 19}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx TURTLE, VEHICLE
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 300

        npc_prop {72, 12}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx TURTLE, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {76, 16}, $0396
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {122, 14}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 301

        npc_prop {20, 5}, $03ff
                npc_dir LEFT
                npc_speed FAST
                npc_gfx DARILL, TERRA
                end_npc

        npc_prop {18, 5}, $03ff
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx SETZER
                end_npc

        npc_prop {7, 19}, $03ff
                npc_dir UP
                npc_speed FAST
                npc_gfx DARILL, TERRA
                end_npc

        npc_prop {7, 17}, $03ff
                npc_dir DOWN
                npc_speed FAST
                npc_gfx SETZER
                end_npc

        npc_prop {28, 6}, $0300
                npc_event _ca43d9
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 302

        npc_prop {11, 30}, $0300
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {23, 29}, $0300
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {23, 37}, $0300
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {38, 22}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {27, 18}, $0300
                npc_dir UP
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {37, 16}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {43, 21}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {22, 20}, $0300
                npc_no_react
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {19, 22}, $0300
                npc_no_react
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {44, 13}, $0300
                npc_dir LEFT
                npc_speed FAST
                npc_gfx GIRL, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {41, 16}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 21}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 20}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MERCHANT, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 303

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 304

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 305

        npc_prop {29, 3}, $0666
                npc_event _cc5ddd
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {15, 8}, $066c
                npc_event _cc5976
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SABIN
                end_npc

        npc_prop {18, 9}, $066a
                npc_event _cc5ac9
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {19, 10}, $0668
                npc_event _cc5add
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {19, 11}, $066a
                npc_event _cc5acd
                npc_dir UP
                npc_speed FAST
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {24, 21}, $0668
                npc_event _cc5ae1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {19, 10}, $066a
                npc_event _cc5ad1
                npc_dir LEFT
                npc_speed FAST
                npc_gfx SHOPKEEPER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {17, 22}, $0668
                npc_event _cc5ae5
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {18, 13}, $066a
                npc_event _cc5ad5
                npc_dir LEFT
                npc_speed FAST
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {26, 24}, $0668
                npc_event _cc5ae9
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {18, 14}, $066a
                npc_event _cc5ad9
                npc_dir UP
                npc_speed FAST
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {20, 27}, $0668
                npc_event _cc5aed
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {27, 10}, $0668
                npc_event _cc5af1
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {6, 12}, $0668
                npc_event _cc5af5
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {7, 29}, $0668
                npc_event _cc5af9
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx HOOKER, TERRA
                end_npc

        npc_prop {19, 11}, $0668
                npc_event _cc5afd
                npc_dir UP
                npc_speed SLOW
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {23, 18}, $0664
                npc_dir DOWN
                npc_speed FAST
                npc_gfx MAN, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 306

        npc_prop {17, 22}, $0662
                npc_event _cc5d89
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {19, 8}, $0662
                npc_event _cc5d93
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {14, 21}, $0662
                npc_event _cc5d9d
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {20, 15}, $0662
                npc_event _cc5da7
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {16, 9}, $0662
                npc_event _cc5dbb
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {13, 22}, $0662
                npc_event _cc5db1
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {29, 3}, $0666
                npc_event _cc5ddd
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {20, 28}, $0663
                npc_event _cc5e2b
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {25, 28}, $0663
                npc_event _cc5e2f
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {18, 13}, $0663
                npc_event _cc5e33
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {11, 27}, $0663
                npc_event _cc5e37
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {27, 10}, $0663
                npc_event _cc5e3b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 307

        npc_prop {34, 15}, $0662
                npc_event _cc5c81
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 308

        npc_prop {14, 53}, $0662
                npc_event _cc5c8d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 309

        npc_prop {38, 43}, $0662
                npc_event _cc5ce2
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 310

        npc_prop {58, 45}, $0662
                npc_event _cc5cee
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 311

        npc_prop {124, 54}, $0667
                npc_event _ccd3ca
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {117, 10}, $066d
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BOY, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 312

        npc_prop {80, 16}, $0662
                npc_event _cc5cfa
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 313

        npc_prop {6, 48}, $0698
                npc_dir UP
                npc_speed NORMAL
                npc_gfx LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {6, 49}, $0687
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 47}, $0693
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, MOG_UMARO
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 314

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 315

        npc_prop {20, 46}, $069c
                npc_event _cc2048
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx DRAGON, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {37, 28}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 316

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 317

        npc_prop {17, 46}, $0524
                npc_event _cb866f
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

        npc_prop {17, 46}, $0525
                npc_event _cb86a0
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx LOCKE
                end_npc

        npc_prop {17, 46}, $0526
                npc_event _cb86d1
                npc_no_react
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SHADOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {17, 46}, $0527
                npc_event _cb8702
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {17, 46}, $0528
                npc_event _cb8733
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SABIN
                end_npc

        npc_prop {17, 46}, $0529
                npc_event _cb8764
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx CELES
                end_npc

        npc_prop {17, 46}, $052a
                npc_event _cb8795
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {17, 46}, $052b
                npc_event _cb87c6
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {17, 46}, $052c
                npc_event _cb87f7
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SETZER
                end_npc

        npc_prop {17, 46}, $052d
                npc_event _cb8828
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

        npc_prop {17, 46}, $052e
                npc_event _cb8859
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GAU
                end_npc

        npc_prop {17, 46}, $052f
                npc_event _cb888a
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GOGO, MOG_UMARO
                end_npc

        npc_prop {17, 46}, $0530
                npc_event _cb88bb
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx UMARO, MOG_UMARO
                end_npc

        npc_prop {27, 52}, $0531
                npc_event _cb88ec
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

        npc_prop {27, 52}, $0532
                npc_event _cb891d
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx LOCKE
                end_npc

        npc_prop {27, 52}, $0533
                npc_event _cb894e
                npc_no_react
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SHADOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {27, 52}, $0534
                npc_event _cb897f
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx EDGAR
                end_npc

        npc_prop {27, 52}, $0535
                npc_event _cb89b0
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SABIN
                end_npc

        npc_prop {27, 52}, $0536
                npc_event _cb89e1
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx CELES
                end_npc

        npc_prop {27, 52}, $0537
                npc_event _cb8a12
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {27, 52}, $0538
                npc_event _cb8a43
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {27, 52}, $0539
                npc_event _cb8a74
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SETZER
                end_npc

        npc_prop {27, 52}, $053a
                npc_event _cb8aa5
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx MOG
                end_npc

        npc_prop {27, 52}, $053b
                npc_event _cb8ad6
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GAU
                end_npc

        npc_prop {27, 52}, $053c
                npc_event _cb8b07
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx GOGO, MOG_UMARO
                end_npc

        npc_prop {27, 52}, $053d
                npc_event _cb8b38
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx UMARO, MOG_UMARO
                end_npc

        npc_prop {46, 55}, $0540
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {18, 45}, $053f
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {28, 52}, $053e
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {23, 53}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 318

        special_npc_prop {4, 0}, $0693, {0, 0}
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 17}, $0693, {0, 0}
                npc_master 0, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 18}, $0693, {0, 0}
                npc_master 0, 2, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 20}, $0693, {1, 0}
                npc_master 0, 3, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {5, 21}, $0693, {2, 0}
                npc_master 0, 4, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 319

        npc_prop {20, 25}, $0545
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx CYAN, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {17, 25}, $0545
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 320

        npc_prop {6, 8}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        npc_prop {6, 22}, $0544
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx CYAN, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {5, 8}, $0544
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {6, 8}, $0544
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, RAINBOW
                npc_sprite_priority LOW
                end_npc

        npc_prop {7, 8}, $0544
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, RAINBOW
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 321

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 322

        npc_prop {28, 5}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 323

        npc_prop {3, 18}, $065f
                npc_event _cc601f
                npc_dir LEFT
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {3, 15}, $065f
                npc_event _cc6029
                npc_dir LEFT
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {42, 21}, $065f
                npc_event _cc603d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {46, 21}, $065f
                npc_event _cc6033
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {16, 11}, $065f
                npc_event _cc6047
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {44, 26}, $0661
                npc_event _cc601b
                npc_dir UP
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {8, 16}, $065e
                npc_event _cc5fbd
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {14, 13}, $065e
                npc_event _cc5fcd
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {16, 12}, $065e
                npc_event _cc5fdd
                npc_dir UP
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {31, 11}, $065e
                npc_event _cc5fed
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx HOOKER, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {36, 20}, $065e
                npc_event _cc5ff1
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {50, 13}, $065e
                npc_event _cc5fff
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {49, 15}, $0660
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 324

        npc_prop {26, 20}, $0665
                npc_event _cc5bca
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {6, 15}, $0665
                npc_event _cc5bd9
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {8, 17}, $0665
                npc_event _cc5bdd
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {27, 20}, $0665
                npc_event _cc5be1
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {25, 20}, $0665
                npc_event _cc5be5
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {10, 9}, $0665
                npc_event _cc5be9
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx RICH_MAN, LOCKE
                end_npc

        npc_prop {16, 11}, $0665
                npc_event _cc5bed
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SHOPKEEPER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {35, 20}, $0665
                npc_event _cc5bf1
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {46, 3}, $0665
                npc_event _cc5bf5
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {54, 15}, $0665
                npc_event _cc5bf9
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {18, 20}, $0665
                npc_event _cc5bfd
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                end_npc

        npc_prop {50, 13}, $0665
                npc_event _cc5c01
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 325

        npc_prop {56, 51}, $065e
                npc_event _cc614a
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 326

        npc_prop {3, 51}, $065e
                npc_event _cc60a2
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {9, 51}, $065e
                npc_event _cc5c05
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx RICH_MAN, LOCKE
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 327

        npc_prop {102, 18}, $065e
                npc_event _cc60c6
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {84, 8}, $065e
                npc_event _cc5faf
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 328

        npc_prop {37, 47}, $065e
                npc_event _cc60ba
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 329

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 330

        npc_prop {37, 25}, $065e
                npc_event _cc60ae
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {14, 20}, $065e
                npc_event _cc607a
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {8, 10}, $0661
                npc_event _cc608e
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 10}, $0661
                npc_event _cc608e
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 10}, $0661
                npc_event _cc608e
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 10}, $0661
                npc_event _cc608e
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {19, 11}, $0661
                npc_event _cc6033
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 18}, $0661
                npc_event _cc6076
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx MAN, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {15, 10}, $0661
                npc_event _cc6065
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx HOOKER, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {10, 11}, $0661
                npc_event _cc6069
                npc_dir UP
                npc_speed SLOW
                npc_gfx HOOKER, TERRA
                end_npc

        npc_prop {10, 12}, $0661
                npc_event _cc606d
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx HOOKER, TERRA
                npc_movement RANDOM
                end_npc

        npc_prop {18, 12}, $0661
                npc_event _cc6071
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx HOOKER, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 7}, $0661
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx HOOKER, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {11, 7}, $0661
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx HOOKER, TERRA
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 331

        npc_prop {76, 51}, $06bd
                npc_event _cc18b4
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx ATMA, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {76, 51}, $06be
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 332

        npc_prop {14, 12}, $0542
                npc_event _cbcc50
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {23, 4}, $0542
                npc_event _cbcc5e
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {9, 23}, $0542
                npc_event _cbcc5a
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {12, 15}, $0542
                npc_event _cbcc84
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        npc_prop {14, 6}, $0522
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx CELES
                end_npc

        npc_prop {15, 6}, $0522
                npc_event _cbce26
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {16, 6}, $0511
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {19, 22}, $0513
                npc_event _cbce2a
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {20, 23}, $0513
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 15}, $0542
                npc_event _cbcc4c
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {22, 16}, $0542
                npc_event _cbcc48
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {8, 16}, $0506
                npc_dir UP
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

        npc_prop {8, 14}, $0506
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        npc_prop {9, 16}, $0506
                npc_event _cbd209
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {17, 12}, $0508
                npc_event _cbce2a
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {17, 12}, $0507
                npc_event _cbcc72
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {18, 16}, $0507
                npc_event _cbcc68
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {8, 13}, $0507
                npc_event _cbcefc
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        npc_prop {12, 14}, $0565
                npc_event _cbd1f3
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 333

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 334

        special_npc_prop {29, 13}, $06b2, {4, 0}
                npc_32x32
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx POLTERGEIST_1, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {29, 15}, $06b2, {6, 0}
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_2, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {30, 15}, $06b2, {7, 0}
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_3, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {69, 10}, $06a4, {0, 0}
                npc_master 3, 0, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {69, 11}, $06a4, {0, 0}
                npc_master 3, 1, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {69, 12}, $06a4, {0, 0}
                npc_master 3, 2, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {69, 13}, $06a4, {0, 0}
                npc_master 3, 3, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {69, 14}, $06a4, {0, 0}
                npc_master 3, 4, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {69, 15}, $06a4, {0, 0}
                npc_master 3, 5, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_3, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {69, 16}, $06a4, {1, 0}
                npc_master 3, 6, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_2, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {69, 17}, $06a4, {2, 0}
                npc_master 3, 7, DOWN
                npc_speed SLOW
                npc_gfx CRANE_HOOK_1, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {33, 53}, $06af
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, MOG_UMARO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 335

        npc_prop {82, 33}, $06b3
                npc_event _cc18d9
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx DRAGON, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 336

        npc_prop {15, 13}, $039a
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {14, 12}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {16, 12}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 11}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {17, 11}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 337

        special_npc_prop {4, 12}, $06a4, {7, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {12, 12}, $06a4, {7, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {4, 7}, $06a5
                npc_event _cc14f4
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 7}, $06a7
                npc_event _cc1548
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {4, 12}, $06aa
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 12}, $06ab
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx WEIGHT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 11}, $06a6
                npc_event _cc14f0
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        special_npc_prop {8, 6}, $06a4, {7, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 338

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 339

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 340

        npc_prop {22, 29}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                end_npc

        npc_prop {55, 20}, $0520
                npc_dir UP
                npc_speed SLOWER
                npc_gfx CELES
                end_npc

        npc_prop {45, 22}, $0520
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_sprite_priority LOW
                end_npc

        npc_prop {14, 28}, $0520
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SETZER
                end_npc

        npc_prop {12, 28}, $0520
                npc_dir UP
                npc_speed SLOWER
                npc_gfx SABIN
                end_npc

        npc_prop {12, 27}, $0520
                npc_dir UP
                npc_speed SLOWER
                npc_gfx CYAN
                end_npc

        npc_prop {12, 29}, $0520
                npc_dir UP
                npc_speed SLOW
                npc_gfx EDGAR
                end_npc

        special_npc_prop {54, 14}, $0500, {0, 0}
                npc_h_flip
                npc_master 15, 0, RIGHT
                _npc_is_slave .set 0
                npc_anim TWO_FRAMES, DEFAULT
                npc_speed NORMAL
                npc_gfx LEO_SWORD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {41, 19}, $0500
                npc_event _cb755e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {18, 21}, $0559
                npc_event _cc0983
                npc_dir UP
                npc_speed SLOWER
                npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {41, 24}, $0559
                npc_event _cc098d
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {30, 29}, $0559
                npc_event _cc0997
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {18, 18}, $055a
                npc_event _cb77c8
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, LOCKE
                end_npc

        npc_prop {23, 39}, $05f7
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {23, 39}, $05f7
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {26, 20}, $0560
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RELM
                end_npc

        npc_prop {29, 14}, $0560
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, LOCKE
                end_npc

        npc_prop {33, 19}, $0561
                npc_event _cb73fe
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {10, 21}, $0564
                npc_event _cb756e
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                end_npc

        npc_prop {48, 18}, $0568
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 341

        npc_prop {26, 28}, $051f
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx LEO, EDGAR_SABIN_CELES
                end_npc

        npc_prop {28, 28}, $0501
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx CELES
                end_npc

        npc_prop {25, 14}, $05f7
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                npc_sprite_priority HIGH
                end_npc

        npc_prop {22, 28}, $051f
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx YURA, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {21, 27}, $051f
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx FAERIE, TERRA
                end_npc

        npc_prop {21, 29}, $051f
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {26, 8}, $051d
                npc_event _cc0942
                npc_no_react
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {26, 6}, $051d
                npc_event _cc094c
                npc_no_react
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {26, 4}, $051d
                npc_event _cc0956
                npc_no_react
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {30, 27}, $0501
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {30, 29}, $0501
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {22, 21}, $05f7
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {23, 28}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {24, 29}, $051e
                npc_no_react
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx TERRA
                end_npc

        npc_prop {27, 29}, $051e
                npc_no_react
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx LOCKE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {23, 32}, $051e
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {31, 33}, $051e
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {24, 18}, $051d
                npc_event _cbfff4
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {24, 18}, $05f7
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {24, 18}, $05f7
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {24, 18}, $05f7
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {24, 18}, $05f7
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {32, 16}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {32, 24}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 26}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 19}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {24, 18}, $05f7
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {14, 13}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {24, 18}, $05f7
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {23, 6}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 342

        npc_prop {8, 20}, $0474
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx CLYDE, LOCKE
                end_npc

        npc_prop {8, 15}, $0475
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BANDIT, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 343

        npc_prop {23, 28}, $0518
                npc_event _cbd7e5
                npc_dir UP
                npc_speed SLOW
                npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {16, 40}, $0501
                npc_event _cbd81f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx WOMAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {11, 24}, $0518
                npc_event _cbd833
                npc_dir UP
                npc_speed SLOW
                npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {41, 21}, $0501
                npc_event _cbd853
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {39, 24}, $0508
                npc_event _cbde30
                npc_dir UP
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {43, 9}, $0506
                npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {43, 11}, $0506
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {30, 3}, $0506
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {28, 4}, $0506
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GIRL, LOCKE
                end_npc

        npc_prop {29, 2}, $0506
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx EXCLAMATION_POINT, RAINBOW
                end_npc

        npc_prop {29, 24}, $0507
                npc_event _cbd805
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx OLD_MAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {28, 22}, $0507
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {39, 22}, $0507
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 17}, $0507
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 22}, $0507
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 17}, $0507
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 17}, $0507
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 17}, $0507
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 17}, $0507
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 17}, $0507
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {39, 22}, $0507
                npc_anim TWO_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {44, 25}, $0509
                npc_event _cbd7e5
                npc_dir UP
                npc_speed SLOW
                npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {28, 20}, $0509
                npc_event _cbd7e5
                npc_dir UP
                npc_speed SLOW
                npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {26, 19}, $051a
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {25, 18}, $051a
                npc_event _cb6abf
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {29, 13}, $05f7
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {28, 19}, $0569
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx CLYDE, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 344

        special_npc_prop {54, 14}, $0500, {0, 0}
                npc_h_flip
                npc_master 15, 0, RIGHT
                _npc_is_slave .set 0
                npc_anim TWO_FRAMES, DEFAULT
                npc_speed NORMAL
                npc_gfx LEO_SWORD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {41, 19}, $0500
                npc_event _cb755e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {30, 29}, $0559
                npc_event _cc0983
                npc_dir UP
                npc_speed SLOWER
                npc_gfx MAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {41, 24}, $0559
                npc_event _cc098d
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx BOY, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {18, 21}, $0559
                npc_event _cc0997
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOMAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {33, 19}, $0561
                npc_event _cb73fe
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_MAN, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {10, 21}, $0564
                npc_event _cb756e
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                end_npc

        npc_prop {23, 39}, $05f7
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {23, 39}, $05f7
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {21, 17}, $0570
                npc_event _cb6abf
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 345

        npc_prop {11, 37}, $0500
                npc_event _cbd712
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {22, 37}, $0500
                npc_event _cbd721
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 346

        npc_prop {24, 15}, $0500
                npc_event _cbd73f
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {23, 19}, $0507
                npc_event _cbdcb3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {13, 16}, $0507
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 347

        npc_prop {36, 39}, $0500
                npc_event _cbd730
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {42, 41}, $051b
                npc_event _cbd88b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 348

        npc_prop {61, 34}, $051b
                npc_event _cbd805
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {61, 34}, $0559
                npc_event _cc09a1
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 349

        npc_prop {37, 18}, $0516
                npc_event _cbd982
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx STRAGO
                end_npc

        npc_prop {36, 13}, $0516
                npc_event _cbdcbb
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {39, 19}, $0563
                npc_event _cbdcb3
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx STRAGO
                npc_movement RANDOM
                end_npc

        npc_prop {47, 20}, $0563
                npc_event _cbdcb7
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                npc_movement RANDOM
                end_npc

        npc_prop {36, 20}, $0503
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {63, 12}, $0519
                npc_event _cbdcc3
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx RELM
                npc_movement RANDOM
                end_npc

        npc_prop {59, 13}, $050a
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {59, 15}, $050a
                npc_event _cb6abf
                npc_dir UP
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {40, 20}, $0557
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {42, 19}, $0557
                npc_dir UP
                npc_speed SLOW
                npc_gfx RELM
                end_npc

        npc_prop {43, 19}, $0557
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx STRAGO
                end_npc

        npc_prop {65, 13}, $055c
                npc_event _cb7414
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx OLD_MAN, LOCKE
                end_npc

        npc_prop {62, 12}, $05f7
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RELM
                end_npc

        npc_prop {64, 13}, $05f7
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx STRAGO
                end_npc

        npc_prop {39, 10}, $05f7
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx STRAGO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {39, 10}, $05f6
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RELM
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {62, 20}, $055f
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx STRAGO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {61, 20}, $055f
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx RELM
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {43, 21}, $055f
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_MAN, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {45, 21}, $055f
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx STRAGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {61, 13}, $0556
                npc_event _cb7d08
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {61, 13}, $0566
                npc_event _cb7d1c
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {60, 15}, $055b
                npc_event _cb6abf
                npc_dir UP
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 350

        npc_prop {43, 8}, $0500
                npc_event _cbd79d
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 351

        npc_prop {2, 29}, $0501
                npc_event _cbe6cb
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {17, 34}, $0501
                npc_event _cbe6d8
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {22, 25}, $0501
                npc_event _cbe6e5
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {21, 21}, $050a
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {21, 21}, $050a
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {21, 21}, $050a
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {21, 21}, $050a
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {42, 25}, $0501
                npc_event _cbe6f2
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {46, 49}, $0501
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {5, 31}, $0501
                npc_event _cbe6ff
                npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {17, 27}, $0501
                npc_event _cbe70c
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {46, 42}, $0501
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {47, 43}, $0501
                npc_event _cb6abf
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {42, 35}, $0562
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {24, 8}, $0501
                npc_event _cbe719
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {29, 7}, $0501
                npc_event _cbe726
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {19, 6}, $0501
                npc_event _cbe733
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {23, 35}, $0501
                npc_event _cbe740
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {41, 24}, $0501
                npc_event _cbe74d
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

        npc_prop {4, 35}, $0501
                npc_event _cbe75a
                npc_anim FOUR_FRAMES, SPECIAL, FAST
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 352

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 353

        npc_prop {57, 44}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {35, 48}, $054c
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {56, 24}, $0552
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx SHADOW
                end_npc

        npc_prop {56, 24}, $0553
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {58, 27}, $0555
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx MONSTER, TERRA
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {55, 25}, $0554
                npc_event _cb6abf
                npc_dir UP
                npc_speed SLOWER
                npc_gfx DOG, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {27, 26}, $0500
                npc_event _cc5bca
                npc_anim FOUR_FRAMES, SPECIAL, MEDIUM
                npc_speed SLOW
                npc_gfx FLAME, RAINBOW
                end_npc

        npc_prop {27, 25}, $0500
                npc_event _cb7cf8
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                end_npc

        npc_prop {26, 26}, $0500
                npc_event _cb7cfc
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                end_npc

        npc_prop {28, 26}, $0500
                npc_event _cb7d00
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                end_npc

        npc_prop {29, 27}, $0500
                npc_event _cb7d04
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 354

        special_npc_prop {11, 29}, $06b1, {0, 0}
                npc_32x32
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_1, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {11, 31}, $06b1, {2, 0}
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_2, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {12, 31}, $06b1, {4, 0}
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_3, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {12, 31}, $06b9
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {82, 33}, $06b4
                npc_event _cc1906
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx DRAGON, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 355

        special_npc_prop {35, 6}, $06a4, {4, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {39, 9}, $06a4, {4, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {43, 6}, $06a4, {4, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {63, 9}, $06b0, {0, 0}
                npc_32x32
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_1, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {64, 11}, $06b0, {2, 0}
                npc_h_flip
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_2, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {63, 11}, $06b0, {2, 1}
                npc_h_flip
                npc_master 0, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_3, VEHICLE
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        npc_prop {64, 11}, $06b8
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 356

        npc_prop {15, 14}, $039a
                npc_event GameEnding
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {19, 13}, $03ff
                npc_no_react
                npc_dir DOWN
                npc_speed FAST
                npc_gfx ESPER_TERRA, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {15, 22}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {12, 12}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {18, 12}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed FAST
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $039e
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx MULTI_SPARKLES, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $039e
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 357

        npc_prop {15, 13}, $039a
                npc_event GameEnding
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {14, 12}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {16, 12}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 11}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {17, 11}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 358

        npc_prop {8, 10}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 359

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 360

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 361

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 362

        npc_prop {5, 11}, $0678
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {6, 11}, $0678
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 11}, $0678
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 11}, $0679
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx STRAGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {9, 11}, $0678
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 11}, $0678
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {1, 5}, $0678
                npc_event _cc51f7
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 2}, $0678
                npc_event _cc51fb
                npc_no_react
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {2, 4}, $0678
                npc_event _cc51ff
                npc_no_react
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {3, 5}, $0678
                npc_event _cc522a
                npc_no_react
                npc_dir LEFT
                npc_speed SLOWER
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 363

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 364

        npc_prop {7, 15}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 15}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 16}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 17}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 18}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 19}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 20}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 21}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 22}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 23}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 24}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 25}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 26}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 27}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 28}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 29}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 30}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx EMPEROR_SERVANT, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 15}, $0699
                npc_no_react
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx GHOST, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 6}, $0699
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 365

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 366

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 367

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 368

        npc_prop {5, 9}, $0694
                npc_event _cc558b
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx DRAGON, TERRA
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 369

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 370

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 371

        npc_prop {15, 14}, $0521
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ULTROS, MOG_UMARO
                end_npc

        npc_prop {19, 14}, $0521
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

        npc_prop {15, 15}, $0501
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx SMALL_STATUE, STRAGO_RELM_GAU_GOGO
                npc_sprite_priority LOW
                end_npc

        npc_prop {16, 16}, $0501
                npc_event _cbf29a
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx SMALL_STATUE, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {14, 16}, $0501
                npc_event _cbf296
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx SMALL_STATUE, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {15, 15}, $0501
                npc_event _cbf29e
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 372

        npc_prop {50, 19}, $0521
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx ULTROS, MOG_UMARO
                end_npc

        npc_prop {51, 18}, $0521
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 373

        npc_prop {16, 23}, $0521
                npc_dir LEFT
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 374

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 375

        npc_prop {8, 44}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {12, 30}, $051b
                npc_dir UP
                npc_speed SLOWER
                npc_gfx YURA, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {17, 23}, $051b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx FAERIE, TERRA
                end_npc

        npc_prop {24, 22}, $051b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOLF, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {19, 26}, $051b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx DRAGON, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 26}, $051b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx DRAGON, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {16, 27}, $051b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {18, 26}, $051b
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOLF, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 26}, $05f7
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx FAERIE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {16, 27}, $05f7
                npc_dir UP
                npc_speed SLOWER
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 14}, $05f7
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx DRAGON, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 13}, $05f7
                npc_dir DOWN
                npc_speed SLOWER
                npc_gfx WOLF, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {48, 10}, $0521
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx RELM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 376

        special_npc_prop {60, 3}, $0300, {0, 0}
                npc_32x32
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_1, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {60, 5}, $0300, {6, 0}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_2, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {61, 5}, $0300, {7, 0}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_3, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {59, 6}, $0300, {2, 0}
                npc_32x32
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_1, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {60, 8}, $0300, {6, 1}
                npc_h_flip
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_2, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {59, 8}, $0300, {7, 1}
                npc_h_flip
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_3, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {60, 7}, $0300, {4, 0}
                npc_32x32
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx POLTERGEIST_1, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {60, 9}, $0300, {6, 1}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_2, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {61, 9}, $0300, {7, 1}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_3, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {60, 6}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {60, 6}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {32, 9}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 377

        npc_prop {15, 9}, $045e
                npc_event _cb2599
                npc_dir DOWN
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {8, 13}, $045f
                npc_event _cb2583
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {11, 21}, $0460
                npc_event _cb258e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {15, 21}, $0461
                npc_event _cb2583
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {17, 12}, $0462
                npc_event _cb258e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {12, 25}, $0463
                npc_event _cb2583
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {3, 18}, $0464
                npc_event _cb258e
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {3, 5}, $0465
                npc_event _cb2583
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {15, 2}, $0466
                npc_event _cb2583
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {26, 3}, $0467
                npc_event _cb258e
                npc_dir UP
                npc_speed SLOW
                npc_gfx SOLDIER, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 378

        npc_prop {53, 40}, $045d
                npc_event _cb2562
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx NOTHING, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 379

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 380

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 381

        npc_prop {38, 22}, $0300
                npc_no_react
                npc_dir RIGHT
                npc_speed FAST
                npc_gfx BOY, EDGAR_SABIN_CELES
                end_npc

        npc_prop {46, 18}, $0300
                npc_dir LEFT
                npc_speed FAST
                npc_gfx IMP, EDGAR_SABIN_CELES
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 382

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 383

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 384

        npc_prop {10, 27}, $0471
                npc_event _cb3dcb
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        npc_prop {11, 27}, $0471
                npc_event _cb3dcb
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        npc_prop {9, 27}, $0471
                npc_event _cb3dcb
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        npc_prop {65, 4}, $0485
                npc_event _cb307e
                npc_dir DOWN
                npc_speed FAST
                npc_gfx BANDIT, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 385

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 386

        npc_prop {74, 53}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 387

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 388

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 389

        npc_prop {2, 8}, $0300
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {6, 11}, $0300
                npc_dir RIGHT
                npc_speed FAST
                npc_bg2_scroll
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {7, 9}, $0300
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {6, 4}, $0300
                npc_dir RIGHT
                npc_vehicle MAGITEK, SHOW_RIDER
                npc_speed FAST
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {4, 12}, $0300
                npc_dir RIGHT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {14, 8}, $0300
                npc_dir LEFT
                npc_speed FAST
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {12, 12}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {10, 5}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx MERCHANT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 390

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed FAST
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 391

        special_npc_prop {7, 5}, $0468, {0, 0}
                npc_32x32
                npc_master 0, 6, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx GATE_1, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {8, 5}, $0468, {2, 0}
                npc_h_flip
                npc_32x32
                npc_master 1, 6, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx GATE_1, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {7, 7}, $0468, {4, 0}
                npc_master 2, 6, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx GATE_2, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {8, 7}, $0468, {5, 0}
                npc_master 3, 6, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx GATE_3, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {9, 7}, $0468, {6, 0}
                npc_h_flip
                npc_master 4, 6, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx GATE_2, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        special_npc_prop {8, 7}, $0468, {7, 0}
                npc_h_flip
                npc_master 5, 6, DOWN
                _npc_is_slave .set 0
                npc_speed SLOW
                npc_gfx GATE_3, VEHICLE
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {8, 19}, $046e
                npc_event _cb39ca
                npc_no_react
                npc_dir UP
                npc_speed SLOW
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {7, 18}, $046f
                npc_event _cb39ca
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {9, 18}, $0470
                npc_event _cb39ca
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx SOLDIER, LOCKE
                end_npc

        npc_prop {8, 16}, $03ff
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {4, 0}, $04fe, {0, 2}
                npc_master 10, 0, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {5, 0}, $04fe, {1, 2}
                npc_master 11, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {6, 0}, $04fe, {2, 2}
                npc_master 12, 3, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {7, 0}, $04fe, {3, 2}
                npc_master 13, 0, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {9, 0}, $04fe, {4, 2}
                npc_master 14, 4, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {10, 0}, $04fe, {5, 2}
                npc_master 15, 4, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {11, 0}, $04fe, {6, 2}
                npc_master 16, 0, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {12, 0}, $04fe, {7, 2}
                npc_master 17, 4, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {2, 0}, $04fe, {0, 3}
                npc_master 18, 4, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {3, 0}, $04fe, {1, 3}
                npc_master 19, 3, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {13, 0}, $04fe, {2, 3}
                npc_master 20, 4, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {14, 0}, $04fe, {3, 3}
                npc_master 21, 6, RIGHT
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {0, 0}, $04fe, {4, 3}
                npc_master 22, 5, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx ROCK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 9}, $04fb
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx COIN, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 392

        npc_prop {13, 35}, $0300
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx GIRL, EDGAR_SABIN_CELES
                end_npc

        npc_prop {8, 42}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MAN, LOCKE
                end_npc

        npc_prop {21, 39}, $0300
                npc_dir UP
                npc_speed FAST
                npc_gfx WOMAN, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 393

        npc_prop {108, 15}, $0361
                npc_event _cada48
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {124, 13}, $0300
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx BLACKJACK, CYAN_SHADOW_SETZER
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 394

        npc_prop {60, 15}, $035f
                npc_event _cada30
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx ATMA, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {59, 8}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx KEFKA, STRAGO_RELM_GAU_GOGO
                end_npc

        special_npc_prop {59, 1}, $0300, {0, 0}
                npc_32x32
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_1, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {59, 3}, $0300, {6, 0}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_2, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {60, 3}, $0300, {7, 0}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx GODDESS_3, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {57, 3}, $0300, {2, 0}
                npc_32x32
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_1, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {58, 5}, $0300, {6, 1}
                npc_h_flip
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_2, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {57, 5}, $0300, {7, 1}
                npc_h_flip
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_3, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {61, 3}, $0300, {4, 0}
                npc_32x32
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx POLTERGEIST_1, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {61, 5}, $0300, {6, 1}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_2, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        special_npc_prop {62, 5}, $0300, {7, 1}
                npc_master 0, 2, RIGHT
                _npc_is_slave .set 0
                npc_speed SLOWER
                npc_gfx DOOM_3, VEHICLE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 16}, $035e
                npc_event _cad9a7
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx SHADOW
                end_npc

        npc_prop {60, 7}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GESTAHL, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {0, 0}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed NORMAL
                npc_gfx BIG_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {7, 12}, $0632
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {70, 35}, $0300
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx BLACKJACK, CYAN_SHADOW_SETZER
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 395

        npc_prop {9, 6}, $0300
                npc_dir DOWN
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx OLD_WOMAN, STRAGO_RELM_GAU_GOGO
                npc_layer_priority BACKGROUND
                end_npc

        npc_prop {10, 5}, $0300
                npc_dir LEFT
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx WOMAN, LOCKE
                end_npc

        npc_prop {4, 9}, $0300
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 11}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BOY, TERRA
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {12, 9}, $0300
                npc_dir UP
                npc_speed NORMAL
                npc_bg2_scroll
                npc_gfx MERCHANT, LOCKE
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 396

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 397

        npc_prop {100, 38}, $0367
                npc_event _ca5370
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {99, 40}, $036e
                npc_event _ca5370
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

        npc_prop {94, 39}, $0368
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOW
                npc_gfx NOTHING, LOCKE
                end_npc

        npc_prop {85, 51}, $036d
                npc_event _ca55fe
                npc_dir DOWN
                npc_vehicle RAFT
                npc_speed SLOWER
                npc_gfx SOLDIER, VEHICLE
                end_npc

        npc_prop {100, 39}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {100, 39}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {101, 39}, $0372
                npc_event _ca55e5
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx ENVELOPE, STRAGO_RELM_GAU_GOGO
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 398

        npc_prop {8, 8}, $0371
                npc_event _ca536b
                npc_dir UP
                npc_speed SLOW
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {12, 11}, $0369
                npc_event _ca5762
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx FISH, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 13}, $036a
                npc_event _ca5769
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx FISH, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 13}, $036b
                npc_event _ca5770
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx FISH, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {14, 11}, $036c
                npc_event _ca5777
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx FISH, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {13, 6}, $039b
                npc_event _ca55e9
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx MAGICITE, TERRA
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 399

        npc_prop {10, 9}, $0370
                npc_event _ca54ba
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx BIRD, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {5, 11}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {5, 11}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {4, 13}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {4, 13}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 400

        npc_prop {7, 10}, $03ff
                npc_dir DOWN
                npc_vehicle RAFT
                npc_speed SLOWER
                npc_gfx SOLDIER, VEHICLE
                end_npc

        npc_prop {6, 2}, $03ff
                npc_no_react
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CID, STRAGO_RELM_GAU_GOGO
                end_npc

        npc_prop {16, 5}, $03ff
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_1, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {8, 9}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx BIRD_BANDANA, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {16, 13}, $0300
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL, FAST
                npc_speed FAST
                npc_gfx FLYING_BIRD_2, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {10, 8}, $03ff
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx QUESTION_MARK, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 401

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 402

        npc_prop {22, 51}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 403

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 404

        npc_prop {15, 15}, $0500
                npc_event _cb7446
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {5, 27}, $0500
                npc_event _cb7459
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {22, 28}, $0500
                npc_event _cb746c
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {26, 6}, $0500
                npc_event _cb747f
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

        npc_prop {5, 7}, $0500
                npc_event _cb7492
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 405

        npc_prop {23, 17}, $055d
                npc_event _cb70c7
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed NORMAL
                npc_gfx NOTHING, MOG_UMARO
                npc_sprite_priority LOW
                end_npc

        npc_prop {23, 18}, $05f7
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed SLOWER
                npc_gfx TREASURE_CHEST, VEHICLE
                end_npc

        npc_prop {7, 5}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {23, 5}, $055e
                npc_event _cb71d2
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx CHUPON, EDGAR_SABIN_CELES
                end_npc

        npc_prop {23, 6}, $055f
                npc_dir UP
                npc_speed SLOWER
                npc_gfx STRAGO
                npc_layer_priority BACKGROUND
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 406

        npc_prop {52, 42}, $069b
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx CHANCELLOR, TERRA
                end_npc

        npc_prop {52, 45}, $069b
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {51, 46}, $069b
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        special_npc_prop {33, 10}, $0696, {0, 0}
                npc_h_flip
                npc_32x32
                npc_speed FAST
                npc_gfx ODIN, RAINBOW
                npc_sprite_priority HIGH
                end_npc

        npc_prop {33, 14}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                npc_sprite_priority HIGH
                end_npc

        npc_prop {33, 14}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {34, 14}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                npc_sprite_priority HIGH
                end_npc

        npc_prop {34, 14}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {33, 15}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                npc_sprite_priority HIGH
                end_npc

        npc_prop {33, 15}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {33, 16}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                npc_sprite_priority HIGH
                end_npc

        npc_prop {33, 16}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {34, 16}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                npc_sprite_priority HIGH
                end_npc

        npc_prop {34, 16}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {34, 17}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_1, CYAN_SHADOW_SETZER
                npc_sprite_priority HIGH
                end_npc

        npc_prop {34, 17}, $069b
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx MAGI_WARRIOR_2, CYAN_SHADOW_SETZER
                end_npc

        npc_prop {33, 22}, $069b
                npc_no_react
                npc_dir UP
                npc_speed NORMAL
                npc_gfx GHOST, EDGAR_SABIN_CELES
                end_npc

        npc_prop {33, 11}, $0696
                npc_event _cc1ea5
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

        npc_prop {34, 11}, $0696
                npc_event _cc1ea5
                npc_no_react
                npc_anim ONE_FRAME, SPECIAL
                npc_speed SLOWER
                npc_gfx NOTHING, EDGAR_SABIN_CELES
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 407

        npc_prop {15, 10}, $069b
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {15, 9}, $069b
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {15, 8}, $069b
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

        npc_prop {7, 9}, $069b
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {7, 10}, $069b
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {7, 11}, $069b
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {6, 9}, $069b
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {6, 11}, $069b
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx EXPLOSION, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {15, 10}, $069b
                npc_no_react
                npc_dir RIGHT
                npc_speed NORMAL
                npc_gfx MERCHANT, LOCKE
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 408

        npc_prop {52, 41}, $069b
                npc_event _cc1ede
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOW
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                npc_sprite_priority HIGH
                end_npc

        npc_prop {52, 41}, $0697
                npc_event _cc1f49
                npc_no_react
                npc_dir DOWN
                npc_speed NORMAL
                npc_gfx CELES_DRESS, VEHICLE
                end_npc

        npc_prop {28, 43}, $06a0
                npc_event _cc1ede
                npc_no_react
                npc_anim TWO_FRAMES, SPECIAL
                npc_speed SLOWER
                npc_gfx SMALL_SPARKLE, RAINBOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {52, 49}, $06a1
                npc_event _cc205b
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx DRAGON, STRAGO_RELM_GAU_GOGO
                npc_movement RANDOM
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 409

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 410

        npc_prop {30, 11}, $06bc
                npc_no_react
                npc_anim ONE_FRAME, NONE
                npc_speed NORMAL
                npc_gfx NUMBER_128, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {37, 17}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 411

        special_npc_prop {103, 43}, $06a4, {7, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {109, 40}, $06a4, {7, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

        special_npc_prop {115, 42}, $06a4, {7, 0}
                npc_master 0, 2, DOWN
                _npc_is_slave .set 0
                npc_speed NORMAL
                npc_gfx FLOOR_SWITCH, CYAN_SHADOW_SETZER
                npc_layer_priority FOREGROUND
                npc_sprite_priority LOW
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 412

        npc_prop {82, 47}, $0632
                npc_no_react
                npc_anim FOUR_FRAMES, SPECIAL
                npc_speed NORMAL
                npc_gfx SAVE_POINT, RAINBOW
                npc_sprite_priority HIGH
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 413

        npc_prop {19, 5}, $068b
                npc_event _cc3af8
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SOLDIER, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {27, 10}, $0558
                npc_event _cb797a
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx ULTROS, MOG_UMARO
                npc_movement RANDOM
                end_npc

        npc_prop {52, 16}, $0558
                npc_event _cb7864
                npc_dir DOWN
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {39, 11}, $0558
                npc_event _cb78a5
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx SHOPKEEPER, LOCKE
                end_npc

        npc_prop {39, 16}, $0558
                npc_event _cb78a9
                npc_dir RIGHT
                npc_speed SLOW
                npc_gfx BANDIT, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {41, 16}, $0558
                npc_event _cb78ad
                npc_dir LEFT
                npc_speed SLOW
                npc_gfx BANDIT, LOCKE
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {5, 7}, $0558
                npc_event _cb797e
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx SIEGFRIED, CYAN_SHADOW_SETZER
                npc_movement RANDOM
                end_npc

        npc_prop {25, 5}, $0558
                npc_event _cb78bb
                npc_dir UP
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {42, 7}, $0558
                npc_event _cb7858
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx OLD_MAN, EDGAR_SABIN_CELES
                npc_movement RANDOM
                end_npc

        npc_prop {23, 4}, $0558
                npc_event _cb78c3
                npc_dir DOWN
                npc_speed FAST
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {19, 13}, $0558
                npc_event _cb78b7
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx BANDIT, LOCKE
                npc_movement RANDOM
                end_npc

        npc_prop {22, 5}, $05f7
                npc_dir RIGHT
                npc_speed SLOWER
                npc_gfx SHADOW
                npc_layer_priority FOREGROUND
                end_npc

        npc_prop {25, 12}, $0558
                npc_event _cb78bf
                npc_dir DOWN
                npc_speed FAST
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

        npc_prop {21, 12}, $0558
                npc_event _cb78bf
                npc_dir DOWN
                npc_speed FAST
                npc_gfx FIGARO_GUARD, TERRA
                end_npc

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 414

; ------------------------------------------------------------------------------

        array_label NPC_PROP, 415

; ------------------------------------------------------------------------------

        NPC_PROP::END := *
        end_fixed_block

; ------------------------------------------------------------------------------