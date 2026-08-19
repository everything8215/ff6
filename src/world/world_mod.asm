
; ------------------------------------------------------------------------------

.mac world_mode_ptr event_switch, tile_ptr
        .word event_switch
        .addr tile_ptr - WorldMod
.endmac

.mac _world_mod x_pos, y_pos, width, height
        .byte x_pos, y_pos
        .assert width < 16, error, "Width must be < 16"
        .assert height < 16, error, "Height must be < 16"
        .byte (width << 4) | height
.endmac

.mac world_mod xy_pos, size
        _world_mod xy_pos, size
.endmac

.scope WORLD_MOD
        COUNT = 2
.endscope

.scope WORLD_MOD_TILES
        COUNT = 18
.endscope

; ------------------------------------------------------------------------------

; ce/f600
.segment "world_mod"

        fixed_block $0500

WorldMod:

; world of balance map modification data
        array_label WORLD_MOD, 0
        world_mode_ptr $010b, WORLD_MOD_TILES::_0
        world_mode_ptr $010c, WORLD_MOD_TILES::_1
        world_mode_ptr $0044, WORLD_MOD_TILES::_2
        world_mode_ptr $0098, WORLD_MOD_TILES::_3
        world_mode_ptr $009e, WORLD_MOD_TILES::_4
        world_mode_ptr $009e, WORLD_MOD_TILES::_5
        world_mode_ptr $009e, WORLD_MOD_TILES::_6
        world_mode_ptr $009e, WORLD_MOD_TILES::_7
        world_mode_ptr $009e, WORLD_MOD_TILES::_8
        world_mode_ptr $009e, WORLD_MOD_TILES::_9
        world_mode_ptr $009e, WORLD_MOD_TILES::_10
        world_mode_ptr $009e, WORLD_MOD_TILES::_11
        world_mode_ptr $009e, WORLD_MOD_TILES::_12
        world_mode_ptr $009e, WORLD_MOD_TILES::_13
        world_mode_ptr $0279, WORLD_MOD_TILES::_14

; world of ruin map modification data
        array_label WORLD_MOD, 1
        world_mode_ptr $0106, WORLD_MOD_TILES::_15
        world_mode_ptr $00dc, WORLD_MOD_TILES::_16
        world_mode_ptr $019a, WORLD_MOD_TILES::_17

        WORLD_MOD::END := *

; ------------------------------------------------------------------------------

; [ world of balance tile mod data ]

; show figaro castle in figaro desert
        array_label WORLD_MOD_TILES, 0
        world_mod {64, 75}, {2, 2}
        .byte   $37,$38
        .byte   $47,$48

; show figaro castle near kohlingen
        array_label WORLD_MOD_TILES, 1
        world_mod {30, 47}, {2, 2}
        .byte   $37,$38
        .byte   $47,$48

; remove mountains blocking nikeah
        array_label WORLD_MOD_TILES, 2
        world_mod {116, 47}, {5, 5}
        .byte   $18,$42,$42,$42,$42
        .byte   $18,$18,$18,$18,$18
        .byte   $18,$18,$18,$26,$28
        .byte   $18,$18,$18,$19,$06
        .byte   $18,$18,$18,$19,$06

; show esper mountain
        array_label WORLD_MOD_TILES, 3
        world_mod {229, 130}, {1, 2}
        .byte   $41
        .byte   $18

; hide floating continent (part 1)
        array_label WORLD_MOD_TILES, 4
        world_mod {168, 170}, {10, 15}
        .res    10 * 15, 6

; hide floating continent (part 2)
        array_label WORLD_MOD_TILES, 5
        world_mod {168, 185}, {10, 8}
        .res    10 * 8, 6

; hide floating continent (part 3)
        array_label WORLD_MOD_TILES, 6
        world_mod {178, 180}, {8, 13}
        .res    8 * 13, 6

; hide floating continent (part 4)
; this is the part with the bridge
        array_label WORLD_MOD_TILES, 7
        world_mod {166, 193}, {15, 15}
        .byte   $19,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
        .byte   $8d,$8e,$8e,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
        .byte   $19,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
        .byte   $29,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
        .res    15 * 11, 6

; hide floating continent (part 5)
        array_label WORLD_MOD_TILES, 8
        world_mod {166, 208}, {8, 15}
        .res    8 * 15, 6

; hide floating continent (part 6)
        array_label WORLD_MOD_TILES, 9
        world_mod {167, 223}, {6, 4}
        .res    6 * 4, 6

; hide floating continent (part 7)
        array_label WORLD_MOD_TILES, 10
        world_mod {174, 208}, {12, 12}
        .res    12 * 12, 6

; hide floating continent (part 8)
        array_label WORLD_MOD_TILES, 11
        world_mod {181, 193}, {15, 15}
        .res    15 * 15, 6

; hide floating continent (part 9)
        array_label WORLD_MOD_TILES, 12
        world_mod {196, 193}, {1, 4}
        .res    1 * 4, 6

; hide floating continent (part 10)
        array_label WORLD_MOD_TILES, 13
        world_mod {181, 208}, {5, 1}
        .res    5 * 1, 6

; unused WoB entrance to Umaro's cave
        array_label WORLD_MOD_TILES, 14
        world_mod {112, 6}, {1, 2}
        .byte   $41
        .byte   $18

; ------------------------------------------------------------------------------

; [ world of ruin tile mod data ]

; show figaro castle in figaro desert
        array_label WORLD_MOD_TILES, 15
        world_mod {81, 84}, {2, 2}
        .byte   $57,$58
        .byte   $67,$68

; show figaro castle near kohlingen
        array_label WORLD_MOD_TILES, 16
        world_mod {53, 57}, {2, 2}
        .byte   $57,$58
        .byte   $67,$68

; show ebot's rock
        array_label WORLD_MOD_TILES, 17
        world_mod {249, 223}, {1, 2}
        .byte   $41
        .byte   $64

        end_fixed_block

; ------------------------------------------------------------------------------

.delmac world_mode_ptr
.delmac _world_mod
.delmac world_mod

; ------------------------------------------------------------------------------
