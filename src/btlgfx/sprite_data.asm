.include "src/gfx/map_sprite_gfx.inc"

; ------------------------------------------------------------------------------

; pointers to frame data (+$7e0000)
_c2c3e4:
        .repeat 32, i
        .addr w7ece3f + i * $54
        .endrep

; ------------------------------------------------------------------------------

; pointers to frame data (+$7e0000)
_c2c424:
        .repeat 32, i
        .addr w7ed8bf + i * $54
        .endrep

; ------------------------------------------------------------------------------

; vh flip and pointers to monster sprite data pointers
_c2c464:
@c464:  .word   $0000
        .addr   MonsterSpriteDataPtrs
        .word   $4000
        .addr   MonsterSpriteDataPtrs+12
        .word   $8000
        .addr   MonsterSpriteDataPtrs+24
        .word   $c000
        .addr   MonsterSpriteDataPtrs+36

; ------------------------------------------------------------------------------

; pointers to monster sprite data (4 copies, 6 monsters per copy, +$7e0000)
MonsterSpriteDataPtrs:
        .repeat 24, i
        .addr w7e8259 + i * $44
        .endrep

; ------------------------------------------------------------------------------

; pointers to monster vram map sprite data (+$c20000)
MonsterSpriteMapPtrs:
@c4a4:  .addr   MonsterSpriteMap_00_Slot1
        .addr   MonsterSpriteMap_00_Slot2
        .addr   MonsterSpriteMap_00_Slot3
        .addr   MonsterSpriteMap_00_Slot4
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_01_Slot1
        .addr   MonsterSpriteMap_01_Slot2
        .addr   MonsterSpriteMap_01_Slot3
        .addr   MonsterSpriteMap_01_Slot4
        .addr   MonsterSpriteMap_01_Slot5
        .addr   MonsterSpriteMap_01_Slot6

        .addr   MonsterSpriteMap_02_Slot1
        .addr   MonsterSpriteMap_02_Slot2
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_03_Slot1
        .addr   MonsterSpriteMap_03_Slot2
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_04_Slot1
        .addr   MonsterSpriteMap_04_Slot2
        .addr   MonsterSpriteMap_04_Slot3
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_05_Slot1
        .addr   MonsterSpriteMap_05_Slot2
        .addr   MonsterSpriteMap_05_Slot3
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_06_Slot1
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_07_Slot1
        .addr   MonsterSpriteMap_07_Slot2
        .addr   MonsterSpriteMap_07_Slot3
        .addr   MonsterSpriteMap_07_Slot4
        .addr   MonsterSpriteMap_07_Slot5
        .addr   MonsterSpriteMap_07_Slot6

        .addr   MonsterSpriteMap_08_Slot1
        .addr   MonsterSpriteMap_08_Slot2
        .addr   MonsterSpriteMap_08_Slot3
        .addr   MonsterSpriteMap_08_Slot4
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_09_Slot1
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_0a_Slot1
        .addr   MonsterSpriteMap_0a_Slot2
        .addr   MonsterSpriteMap_0a_Slot3
        .addr   MonsterSpriteMap_0a_Slot4
        .addr   MonsterSpriteMap_0a_Slot5
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_0b_Slot1
        .addr   MonsterSpriteMap_0b_Slot2
        .addr   MonsterSpriteMap_0b_Slot3
        .addr   MonsterSpriteMap_0b_Slot4
        .addr   MonsterSpriteMap_0b_Slot5
        .addr   MonsterSpriteMapUnused

        .addr   MonsterSpriteMap_0c_Slot1
        .addr   MonsterSpriteMap_0c_Slot2
        .addr   MonsterSpriteMap_0c_Slot3
        .addr   MonsterSpriteMap_0c_Slot4
        .addr   MonsterSpriteMap_0c_Slot5
        .addr   MonsterSpriteMap_0c_Slot6

.macro monster_sprite_map x_pos, y_pos, width, height
        ; position and size converted to 32x32 sprites
        .local  x32, y32, height32, width32
        x32 = x_pos / 4
        y32 = y_pos / 4
        width32 = width / 4
        height32 = height / 4
        ; loop over 32x32 sprites
        .byte   x_pos * 8, y_pos * 8
        .repeat height32, _y
        .repeat width32, _x
        .byte   x32 + _x + (y32 + _y) * 4
        .endrep
        .endrep
        ; terminator
        .byte   $ff
.endmac

; sprite data for unused monster in vram map
MonsterSpriteMapUnused:
@c540:  monster_sprite_map 0,0,0,0

; sprite data for vram map $00
MonsterSpriteMap_00_Slot1:              monster_sprite_map 0,0,8,8
MonsterSpriteMap_00_Slot2:              monster_sprite_map 8,0,8,8
MonsterSpriteMap_00_Slot3:              monster_sprite_map 0,8,8,8
MonsterSpriteMap_00_Slot4:              monster_sprite_map 8,8,8,8

; sprite data for vram map $01
MonsterSpriteMap_01_Slot1:              monster_sprite_map 0,0,8,8
MonsterSpriteMap_01_Slot2:              monster_sprite_map 8,0,8,8
MonsterSpriteMap_01_Slot3:              monster_sprite_map 0,8,4,4
MonsterSpriteMap_01_Slot4:              monster_sprite_map 4,8,4,4
MonsterSpriteMap_01_Slot5:              monster_sprite_map 8,8,4,4
MonsterSpriteMap_01_Slot6:              monster_sprite_map 12,8,4,4

; sprite data for vram map $02
MonsterSpriteMap_02_Slot1:              monster_sprite_map 0,0,12,8
MonsterSpriteMap_02_Slot2:              monster_sprite_map 0,8,12,8

; sprite data for vram map $03
MonsterSpriteMap_03_Slot1:              monster_sprite_map 0,0,8,16
MonsterSpriteMap_03_Slot2:              monster_sprite_map 8,0,8,16

; sprite data for vram map $04
MonsterSpriteMap_04_Slot1:              monster_sprite_map 0,0,12,8
MonsterSpriteMap_04_Slot2:              monster_sprite_map 0,8,8,8
MonsterSpriteMap_04_Slot3:              monster_sprite_map 8,8,8,8

; sprite data for vram map $05
MonsterSpriteMap_05_Slot1:              monster_sprite_map 0,0,8,16
MonsterSpriteMap_05_Slot2:              monster_sprite_map 8,0,8,8
MonsterSpriteMap_05_Slot3:              monster_sprite_map 8,8,8,8

; sprite data for vram map $06
MonsterSpriteMap_06_Slot1:              monster_sprite_map 0,0,16,16

; sprite data for vram map $07
MonsterSpriteMap_07_Slot1:              monster_sprite_map 0,0,12,12
MonsterSpriteMap_07_Slot2:              monster_sprite_map 12,0,4,12
MonsterSpriteMap_07_Slot3:              monster_sprite_map 0,12,4,4
MonsterSpriteMap_07_Slot4:              monster_sprite_map 4,12,4,4
MonsterSpriteMap_07_Slot5:              monster_sprite_map 8,12,4,4
MonsterSpriteMap_07_Slot6:              monster_sprite_map 12,12,4,4

; sprite data for vram map $08
MonsterSpriteMap_08_Slot1:              monster_sprite_map 0,0,8,8
MonsterSpriteMap_08_Slot2:              monster_sprite_map 0,8,8,8
MonsterSpriteMap_08_Slot3:              monster_sprite_map 8,0,4,8
MonsterSpriteMap_08_Slot4:              monster_sprite_map 8,8,4,8

; sprite data for vram map $09
MonsterSpriteMap_09_Slot1:              monster_sprite_map 0,0,12,16  ; height is 12 in vram map

; sprite data for vram map $0a
MonsterSpriteMap_0a_Slot1:              monster_sprite_map 0,0,8,12
MonsterSpriteMap_0a_Slot2:              monster_sprite_map 8,0,4,8
MonsterSpriteMap_0a_Slot3:              monster_sprite_map 8,8,4,8
MonsterSpriteMap_0a_Slot4:              monster_sprite_map 0,12,4,4
MonsterSpriteMap_0a_Slot5:              monster_sprite_map 4,12,4,4

; sprite data for vram map $0b
MonsterSpriteMap_0b_Slot1:              monster_sprite_map 0,0,4,8
MonsterSpriteMap_0b_Slot2:              monster_sprite_map 4,0,4,8
MonsterSpriteMap_0b_Slot3:              monster_sprite_map 8,0,4,8
MonsterSpriteMap_0b_Slot4:              monster_sprite_map 8,8,4,8
MonsterSpriteMap_0b_Slot5:              monster_sprite_map 0,8,8,8

; sprite data for vram map $0c
MonsterSpriteMap_0c_Slot1:              monster_sprite_map 0,0,8,8
MonsterSpriteMap_0c_Slot2:              monster_sprite_map 8,0,8,8
MonsterSpriteMap_0c_Slot3:              monster_sprite_map 0,8,4,8
MonsterSpriteMap_0c_Slot4:              monster_sprite_map 4,8,4,8
MonsterSpriteMap_0c_Slot5:              monster_sprite_map 8,8,4,8
MonsterSpriteMap_0c_Slot6:              monster_sprite_map 12,8,4,8

; ------------------------------------------------------------------------------

; battle status/cursor/text palette for sprites
; each of these gets copied to the last 4 colors after the 12-color character palettes
; this effectively creates an extra 16-color palette
_c2c689:
@c689:  .word   $1463,$7ffe,$6314,$4e6f
        .word   $1463,$4bf6,$2bff,$26cd
        .word   $1463,$527b,$4615,$41f0
        .word   $43fd,$3ff1,$03e0,$02e0

; ------------------------------------------------------------------------------

.mac char_action f1, f2, f3, f4
        .ifblank f2
                .byte CHAR_FRAME::f1
                .byte CHAR_FRAME::f1
                .byte CHAR_FRAME::f1
                .byte CHAR_FRAME::f1
        .elseif .blank(f3)
                .byte CHAR_FRAME::f1
                .byte CHAR_FRAME::f2
                .byte CHAR_FRAME::f1
                .byte CHAR_FRAME::f2
        .else
                .byte CHAR_FRAME::f1
                .byte CHAR_FRAME::f2
                .byte CHAR_FRAME::f3
                .byte CHAR_FRAME::f4
        .endif
.endmac

; graphic frames for each character graphical action (4 frames each)
_c2c6a9:

; 0: NONE
        char_action BLANK

; 1: DEAD_HORZ
        char_action DEAD_HORZ

; 2: WALKING_DOWN
        char_action WALKING_DOWN_1, WALKING_DOWN_2, WALKING_DOWN_3, WALKING_DOWN_2

; 3: WALKING_BACK
        char_action WALKING_FORWARD_1 + $30, WALKING_FORWARD_2 + $30, WALKING_FORWARD_3 + $30, WALKING_FORWARD_2 + $30

; 4: WALKING_FORWARD
        char_action WALKING_FORWARD_1, WALKING_FORWARD_2, WALKING_FORWARD_3, WALKING_FORWARD_2

; 5: WALKING_UP
        char_action WALKING_UP_1, WALKING_UP_2, WALKING_UP_3, WALKING_UP_2

; 6: DEFAULT
        char_action FIGHTING_1

; 7: FIGHTING_BACK_HAND
        char_action FIGHTING_2, WALKING_FORWARD_1

; 8: FIGHTING_FRONT_HAND
        char_action FIGHTING_3, WALKING_FORWARD_3

; 9: CASTING
        char_action CASTING_1, CASTING_2

; 10: NEAR_FATAL
        char_action NEAR_FATAL

; 11: READY
        char_action READY

; 12: HIT
        char_action HIT

; 13: DEAD_VERT
        char_action DEAD_VERT

; 14: BLINKING_DOWN
        char_action WALKING_DOWN_2, EYES_CLOSED_DOWN

; 15: BLINKING_BACK
        char_action WALKING_FORWARD_2 + $30, EYES_CLOSED_FORWARD + $30

; 16: BLINKING_FORWARD
        char_action WALKING_FORWARD_2, EYES_CLOSED_FORWARD

; 17: WINKING_DOWN_ALT
        char_action WALKING_DOWN_2 + $30, WINKING_DOWN + $30

; 18: WINKING_DOWN
        char_action WALKING_DOWN_2, WINKING_DOWN

; 19: JUMPING_DOWN
        char_action WALKING_DOWN_2, WALKING_DOWN_2, JUMPING_DOWN, JUMPING_DOWN

; 20: JUMPING_BACK
        char_action WALKING_FORWARD_2 + $30, WALKING_FORWARD_2 + $30, JUMPING_FORWARD + $30, JUMPING_FORWARD + $30

; 21: JUMPING_FORWARD
        char_action WALKING_FORWARD_2, WALKING_FORWARD_2, JUMPING_FORWARD, JUMPING_FORWARD

; 22: JUMPING_UP
        char_action WALKING_UP_2, WALKING_UP_2, JUMPING_UP, JUMPING_UP

; 23: CHAR_ACTION_23
        char_action DEAD_GESTAHL

; 24: ARMS_RAISED_DOWN
        char_action JUMPING_DOWN

; 25: ARMS_RAISED_BACK
        char_action JUMPING_FORWARD + $30

; 26: ARMS_RAISED_FORWARD
        char_action JUMPING_FORWARD

; 27: ARMS_RAISED_UP
        char_action JUMPING_UP

; 28
        char_action DEAD_HORZ

; 29
        char_action DEAD_HORZ

; 30
        char_action DEAD_HORZ

; 31
        char_action DEAD_HORZ

; 32: WAGGING_FINGER
        char_action WAGGING_FINGER_1, WAGGING_FINGER_2

; 33: WAGGING_FINGER_ALT
        char_action WAGGING_FINGER_1 + $30, WAGGING_FINGER_2 + $30

; 34: SHAKING_HEAD
        char_action HEAD_TURNED, WALKING_DOWN_2, HEAD_TURNED + $30, WALKING_DOWN_2

; 35: LAUGHING
        char_action LAUGHING_1, LAUGHING_2

; 36: CHAR_ACTION_36
        char_action DEAD_HORZ

; 37: SPINNING
        char_action JUMPING_DOWN, JUMPING_FORWARD + $30, JUMPING_UP, JUMPING_FORWARD

; 38: LAUGHING_ALT
        char_action LAUGHING_1 + $30, LAUGHING_1 + $30, JUMPING_FORWARD, LAUGHING_2 + $30

; ------------------------------------------------------------------------------

; character graphic frame tile offsets (32 items, 6 values per action)
_c2c745:
@c745:  .word   $0ae0,$0b00,$0b40,$0b60,$0b20,$ffff,$0b80,$ffff  ;  0: DEAD_HORZ
        .word   $ffff,$ffff,$0000,$0020,$0040,$0060,$0080,$00a0  ;  1: WALKING_DOWN_1
        .word   $ffff,$ffff,$0000,$0020,$00c0,$00e0,$0100,$0120  ;  2: WALKING_DOWN_2
        .word   $ffff,$ffff,$0000,$0020,$0140,$0160,$00a0,$0080  ;  3: WALKING_DOWN_3
        .word   $ffff,$ffff,$0300,$0320,$0340,$0360,$0380,$03a0  ;  4: WALKING_FORWARD_1
        .word   $ffff,$ffff,$03c0,$03e0,$0400,$0420,$0440,$0460  ;  5: WALKING_FORWARD_2
        .word   $ffff,$ffff,$0300,$0320,$0480,$04a0,$04c0,$04e0  ;  6: WALKING_FORWARD_3
        .word   $ffff,$ffff,$03c0,$0660,$0680,$06a0,$06c0,$06e0  ;  7: JUMPING_FORWARD
        .word   $ffff,$ffff,$0940,$0960,$0980,$09a0,$09c0,$09e0  ;  8: CASTING_1
        .word   $ffff,$ffff,$0940,$0960,$0a00,$09a0,$09c0,$09e0  ;  9: CASTING_2
        .word   $ffff,$ffff,$0a20,$0a40,$0a60,$0a80,$0aa0,$0ac0  ; 10: DEAD_VERT
        .word   $ffff,$ffff,$0000,$0020,$0ba0,$0bc0,$0100,$0120  ; 11: EYES_CLOSED_DOWN
        .word   $ffff,$ffff,$0000,$0020,$00c0,$0be0,$0100,$0120  ; 12: WINKING_DOWN
        .word   $ffff,$ffff,$12c0,$03e0,$12e0,$0420,$0440,$0460  ; 13: EYES_CLOSED_FORWARD
        .word   $ffff,$ffff,$0180,$01a0,$01c0,$01e0,$0200,$0220  ; 14: WALKING_UP_1
        .word   $ffff,$ffff,$0180,$01a0,$0240,$0260,$0280,$02a0  ; 15: WALKING_UP_2
        .word   $ffff,$ffff,$0180,$01a0,$02c0,$02e0,$0220,$0200  ; 16: WALKING_UP_3
        .word   $ffff,$ffff,$03c0,$03e0,$0500,$0520,$0540,$0560  ; 17: FIGHTING_1
        .word   $ffff,$ffff,$0300,$0320,$0580,$0360,$05a0,$03a0  ; 18: FIGHTING_2
        .word   $ffff,$ffff,$0300,$05c0,$05e0,$0600,$0620,$0640  ; 19: FIGHTING_3
        .word   $ffff,$ffff,$0700,$0720,$0740,$0760,$0780,$07a0  ; 20: NEAR_FATAL
        .word   $ffff,$ffff,$07c0,$07e0,$0800,$0820,$0840,$0860  ; 21: READY
        .word   $ffff,$ffff,$0880,$08a0,$08c0,$08e0,$0900,$0920  ; 22: HIT
        .word   $ffff,$ffff,$0d40,$0d60,$0d80,$0da0,$0dc0,$0de0  ; 23: JUMPING_DOWN
        .word   $ffff,$ffff,$0e00,$0e20,$0e40,$0e60,$0e80,$0ea0  ; 24: JUMPING_UP
        .word   $ffff,$ffff,$0620,$0640,$0660,$0680,$06a0,$06c0  ; 25: DEAD_GESTAHL
        .word   $ffff,$ffff,$0c00,$0c20,$0c40,$0c60,$0c80,$0ca0  ; 26: LAUGHING_1
        .word   $ffff,$ffff,$0cc0,$0ce0,$0d00,$0d20,$0c80,$0ca0  ; 27: LAUGHING_2
        .word   $ffff,$ffff,$0f80,$0fa0,$0fc0,$0fe0,$1000,$1020  ; 28: SURPRISED
        .word   $ffff,$ffff,$1240,$1260,$1280,$12a0,$0100,$0120  ; 29: HEAD_TURNED
        .word   $ffff,$ffff,$1460,$1480,$1300,$1320,$1340,$1360  ; 30: WAGGING_FINGER_1
        .word   $ffff,$ffff,$1460,$1480,$1380,$1320,$1340,$1360  ; 31: WAGGING_FINGER_2

; ------------------------------------------------------------------------------

; inverse tangent table for positive x and y (32 * 32 bytes)
; up to rounding errors these values are equal to arctan(y / x) * 128 / pi
; for (x,y) from (0,0) up to (31,31)
ArcTanTbl:
        .byte   $40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $40,$20,$12,$0d,$0a,$08,$06,$06,$05,$04,$04,$04,$03,$03,$03,$02
        .byte   $02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $40,$2d,$20,$17,$12,$0f,$0d,$0b,$0a,$09,$08,$07,$06,$06,$06,$05
        .byte   $05,$04,$04,$04,$04,$04,$04,$03,$03,$03,$03,$03,$03,$02,$02,$02
        .byte   $40,$32,$28,$20,$1a,$15,$12,$10,$0e,$0d,$0b,$0b,$0a,$09,$09,$08
        .byte   $07,$07,$06,$06,$06,$06,$05,$05,$05,$04,$04,$04,$04,$04,$04,$04
        .byte   $40,$35,$2d,$26,$20,$1b,$17,$15,$12,$10,$0f,$0e,$0d,$0c,$0b,$0a
        .byte   $0a,$09,$09,$08,$08,$07,$07,$06,$06,$06,$06,$06,$06,$05,$05,$05
        .byte   $40,$37,$30,$2a,$24,$20,$1c,$19,$17,$15,$12,$11,$10,$0f,$0e,$0d
        .byte   $0c,$0b,$0b,$0a,$0a,$09,$09,$09,$08,$08,$07,$07,$07,$06,$06,$06
        .byte   $40,$39,$32,$2d,$28,$24,$20,$1c,$1a,$17,$15,$14,$12,$11,$10,$0f
        .byte   $0e,$0e,$0d,$0c,$0b,$0b,$0b,$0a,$0a,$09,$09,$09,$09,$08,$08,$07
        .byte   $40,$3a,$35,$2f,$2b,$26,$23,$20,$1d,$1a,$18,$17,$15,$14,$12,$12
        .byte   $10,$10,$0f,$0e,$0e,$0d,$0c,$0b,$0b,$0b,$0b,$0a,$0a,$09,$09,$09
        .byte   $40,$3a,$35,$31,$2d,$29,$26,$22,$20,$1d,$1b,$1a,$17,$16,$15,$14
        .byte   $12,$12,$10,$10,$0f,$0e,$0e,$0e,$0d,$0c,$0c,$0b,$0b,$0b,$0a,$0a
        .byte   $40,$3b,$37,$32,$2f,$2b,$28,$25,$22,$20,$1d,$1c,$1a,$18,$17,$15
        .byte   $15,$13,$12,$12,$11,$10,$10,$0f,$0e,$0e,$0e,$0d,$0c,$0c,$0b,$0b
        .byte   $40,$3c,$37,$34,$30,$2d,$2a,$27,$24,$22,$20,$1e,$1c,$1a,$19,$17
        .byte   $17,$15,$15,$13,$12,$12,$11,$10,$10,$0f,$0f,$0e,$0e,$0e,$0d,$0c
        .byte   $40,$3c,$38,$35,$32,$2e,$2b,$29,$26,$24,$21,$20,$1e,$1c,$1b,$1a
        .byte   $18,$17,$16,$15,$14,$13,$12,$12,$11,$10,$10,$10,$0f,$0e,$0e,$0e
        .byte   $40,$3c,$39,$35,$32,$30,$2d,$2a,$28,$26,$24,$21,$20,$1e,$1c,$1b
        .byte   $1a,$19,$17,$17,$15,$15,$14,$13,$12,$12,$11,$10,$10,$10,$0f,$0f
        .byte   $40,$3c,$3a,$37,$33,$30,$2e,$2b,$29,$27,$25,$23,$21,$20,$1e,$1c
        .byte   $1c,$1a,$19,$18,$17,$16,$15,$15,$14,$13,$12,$12,$11,$11,$10,$10
        .byte   $40,$3c,$3a,$37,$35,$32,$2f,$2d,$2b,$29,$26,$24,$23,$21,$20,$1f
        .byte   $1d,$1c,$1a,$1a,$18,$17,$17,$16,$15,$15,$14,$13,$12,$12,$12,$11
        .byte   $40,$3d,$3a,$37,$35,$32,$30,$2e,$2b,$2a,$28,$26,$24,$23,$21,$20
        .byte   $1f,$1d,$1c,$1b,$1a,$19,$18,$17,$17,$15,$15,$15,$14,$13,$12,$12
        .byte   $40,$3d,$3a,$38,$35,$33,$31,$2f,$2d,$2b,$29,$27,$26,$24,$22,$21
        .byte   $20,$1f,$1d,$1c,$1b,$1a,$1a,$18,$17,$17,$16,$15,$15,$14,$14,$13
        .byte   $40,$3d,$3b,$38,$36,$34,$32,$30,$2e,$2c,$2a,$29,$26,$25,$24,$22
        .byte   $21,$20,$1f,$1d,$1c,$1b,$1a,$1a,$19,$18,$17,$17,$16,$15,$15,$14
        .byte   $40,$3d,$3b,$39,$37,$35,$32,$30,$2f,$2d,$2b,$29,$28,$26,$25,$24
        .byte   $22,$21,$20,$1f,$1d,$1c,$1c,$1b,$1a,$19,$18,$17,$17,$16,$15,$15
        .byte   $40,$3d,$3b,$3a,$37,$35,$33,$31,$30,$2e,$2c,$2a,$29,$27,$26,$24
        .byte   $23,$22,$21,$20,$1f,$1e,$1c,$1c,$1b,$1a,$1a,$19,$18,$17,$17,$16
        .byte   $40,$3e,$3c,$3a,$37,$35,$34,$32,$30,$2e,$2d,$2b,$2a,$28,$27,$26
        .byte   $24,$23,$22,$21,$20,$1f,$1e,$1d,$1c,$1b,$1a,$1a,$19,$18,$17,$17
        .byte   $40,$3e,$3c,$3a,$38,$36,$35,$32,$31,$2f,$2e,$2c,$2b,$29,$28,$26
        .byte   $25,$24,$23,$21,$21,$20,$1f,$1e,$1d,$1c,$1b,$1a,$1a,$19,$18,$18
        .byte   $40,$3e,$3c,$3a,$38,$37,$35,$33,$32,$30,$2e,$2d,$2b,$2a,$29,$27
        .byte   $26,$25,$24,$23,$21,$21,$20,$1f,$1e,$1d,$1c,$1c,$1b,$1a,$1a,$19
        .byte   $40,$3e,$3c,$3a,$39,$37,$35,$34,$32,$30,$2f,$2e,$2c,$2b,$29,$28
        .byte   $27,$26,$24,$24,$22,$21,$21,$20,$1f,$1e,$1d,$1c,$1c,$1b,$1a,$1a
        .byte   $40,$3e,$3c,$3a,$39,$37,$35,$34,$32,$31,$30,$2e,$2d,$2b,$2a,$29
        .byte   $28,$26,$26,$24,$24,$22,$21,$21,$20,$1f,$1e,$1d,$1c,$1c,$1b,$1a
        .byte   $40,$3e,$3c,$3b,$39,$37,$36,$35,$33,$32,$30,$2f,$2e,$2c,$2b,$2a
        .byte   $29,$27,$26,$25,$24,$23,$22,$21,$21,$20,$1f,$1e,$1d,$1c,$1c,$1b
        .byte   $40,$3e,$3c,$3b,$3a,$38,$37,$35,$33,$32,$30,$30,$2e,$2d,$2b,$2b
        .byte   $29,$28,$27,$26,$25,$24,$23,$22,$21,$21,$20,$1f,$1e,$1d,$1c,$1c
        .byte   $40,$3e,$3c,$3b,$3a,$38,$37,$35,$34,$32,$31,$30,$2f,$2e,$2c,$2b
        .byte   $2a,$29,$28,$26,$26,$25,$24,$23,$22,$21,$21,$20,$1f,$1e,$1d,$1d
        .byte   $40,$3e,$3c,$3b,$3a,$38,$37,$35,$35,$33,$32,$30,$2f,$2e,$2d,$2b
        .byte   $2b,$29,$29,$27,$26,$26,$24,$24,$23,$22,$21,$21,$20,$1f,$1f,$1e
        .byte   $40,$3f,$3d,$3c,$3a,$39,$37,$36,$35,$33,$32,$31,$30,$2e,$2e,$2c
        .byte   $2b,$2a,$29,$28,$27,$26,$25,$24,$24,$23,$22,$21,$21,$20,$1f,$1f
        .byte   $40,$3f,$3d,$3c,$3a,$39,$37,$36,$35,$34,$32,$31,$30,$2f,$2e,$2d
        .byte   $2b,$2b,$2a,$29,$28,$27,$26,$25,$24,$24,$23,$22,$21,$20,$20,$1f
        .byte   $40,$3f,$3d,$3c,$3a,$39,$38,$37,$35,$34,$33,$32,$30,$30,$2e,$2e
        .byte   $2c,$2b,$2a,$29,$29,$27,$26,$26,$25,$24,$24,$22,$21,$21,$20,$20

; ------------------------------------------------------------------------------

; hypotenuse data (compressed, $400 bytes decompressed)
HypotenuseDataLz:
        .byte   $e6,$00,$bb,$00,$08,$df,$e7,$03,$07,$07,$df,$cf,$10,$77,$02,$05
        .byte   $06,$00,$c8,$18,$01,$04,$20,$08,$8e,$00,$b0,$20,$01,$03,$40,$00
        .byte   $42,$10,$01,$90,$28,$cf,$01,$02,$04,$05,$62,$28,$01,$80,$30,$01
        .byte   $11,$02,$60,$00,$83,$30,$00,$70,$38,$9f,$08,$81,$10,$a6,$30,$46
        .byte   $01,$50,$40,$00,$9f,$18,$c5,$50,$00,$40,$48,$df,$10,$84,$e3,$20
        .byte   $e9,$80,$50,$df,$08,$c1,$28,$e8,$50,$00,$18,$58,$10,$df,$00,$01
        .byte   $41,$2c,$59,$00,$00,$60,$3f,$11,$43,$41,$4d,$61,$39,$68,$5f,$29
        .byte   $66,$a1,$70,$00,$01,$80,$71,$e9,$48,$49,$78,$9f,$51,$ab,$79,$80
        .byte   $9f,$21,$c5,$a9,$88,$9f,$11,$88,$82,$19,$c8,$49,$a6,$28,$90,$ff
        .byte   $29,$c5,$29,$0e,$62,$98,$88,$9f,$01,$e1,$31,$2a,$82,$a0,$3f,$1a
        .byte   $44,$92,$42,$08,$a8,$64,$5f,$82,$71,$4a,$b0,$5f,$3a,$88,$8a,$06
        .byte   $b8,$5f,$22,$4c,$44,$2a,$8c,$6a,$c0,$00,$9f,$92,$0e,$32,$c8,$df
        .byte   $6a,$92,$ee,$62,$d0,$df,$2a,$06,$a3,$d8,$1f,$b3,$27,$19,$e0,$44
        .byte   $1f,$53,$4b,$7b,$e8,$df,$12,$23,$5b,$ee,$4a,$f0,$7f,$5b,$02,$4b
        .byte   $73,$f8,$9f,$8b,$50,$43

; The data above decompresses to the data below (32 * 32 bytes). This data
; gets expanded to a 32 * 32 table of 16-bit values in RAM to calculate
; 8 * sqrt(x^2 + y^2) for (x,y) from (0, 0) up to (31, 31). The first value
; in each row is simply copied. The remaining 31 values in each row are
; generated by adding the data value to the previous value.

; $00,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
; $08,3,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
; $10,2,5,6,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
; $18,1,4,5,6,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
; $20,1,3,4,5,6,6,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
; $28,1,2,4,5,5,6,6,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
; $30,1,2,3,4,5,5,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
; $38,1,2,3,4,4,5,5,6,6,6,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8
; $40,0,1,2,3,4,5,5,5,6,6,6,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8
; $48,0,1,2,3,4,4,5,5,5,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8
; $50,0,1,2,3,3,4,4,5,5,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8
; $58,0,1,2,2,3,4,4,5,5,5,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8
; $60,0,1,2,2,3,3,4,4,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7
; $68,0,1,2,2,3,3,4,4,4,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7
; $70,0,1,1,2,2,3,3,4,4,4,5,5,5,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7
; $78,0,1,1,2,2,3,3,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7
; $80,0,1,1,2,2,3,3,3,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7
; $88,0,1,1,2,2,2,3,3,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7
; $90,0,1,1,2,2,2,3,3,3,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7
; $98,0,1,1,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7
; $a0,0,1,1,1,2,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,6,6,7,7,7
; $a8,0,1,1,1,2,2,2,3,3,3,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,7,7
; $b0,0,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6
; $b8,0,1,1,1,2,2,2,2,3,3,3,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6
; $c0,0,0,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6
; $c8,0,0,1,1,1,2,2,2,3,3,3,3,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,6,6
; $d0,0,0,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,6
; $d8,0,0,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6
; $e0,0,0,1,1,1,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6
; $e8,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6
; $f0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6
; $f8,0,0,1,1,1,1,2,2,2,2,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6

; ------------------------------------------------------------------------------

; palette numbers for each character
CharPalTbl:
@ce2b:  .byte   BATTLE_CHAR_PAL::TERRA
        .byte   BATTLE_CHAR_PAL::LOCKE
        .byte   BATTLE_CHAR_PAL::CYAN
        .byte   BATTLE_CHAR_PAL::SHADOW
        .byte   BATTLE_CHAR_PAL::EDGAR
        .byte   BATTLE_CHAR_PAL::SABIN
        .byte   BATTLE_CHAR_PAL::CELES
        .byte   BATTLE_CHAR_PAL::STRAGO
        .byte   BATTLE_CHAR_PAL::RELM
        .byte   BATTLE_CHAR_PAL::SETZER
        .byte   BATTLE_CHAR_PAL::MOG
        .byte   BATTLE_CHAR_PAL::GAU
        .byte   BATTLE_CHAR_PAL::GOGO
        .byte   BATTLE_CHAR_PAL::UMARO
        .byte   BATTLE_CHAR_PAL::BROWN_SOLDIER
        .byte   BATTLE_CHAR_PAL::IMP
        .byte   BATTLE_CHAR_PAL::LEO
        .byte   BATTLE_CHAR_PAL::BANON
        .byte   BATTLE_CHAR_PAL::ESPER_TERRA
        .byte   BATTLE_CHAR_PAL::MERCHANT
        .byte   BATTLE_CHAR_PAL::GHOST
        .byte   BATTLE_CHAR_PAL::KEFKA
        .byte   BATTLE_CHAR_PAL::GESTAHL
        .byte   BATTLE_CHAR_PAL::GREEN_SOLDIER

; ------------------------------------------------------------------------------

; pointers to character sprite graphics
CharGfxPtrs:
        .repeat 23, i
        .faraddr array_item MapSpriteGfx, i
        .endrep
        .faraddr array_item MapSpriteGfx, MAP_SPRITE_GFX::SOLDIER

; ------------------------------------------------------------------------------

; pointers to animation thread data (characters, monsters, extra, +$7e64de)
_c2ce8b:
get_main_work_poi:
@ce8b:  .word   $0000,$0080,$0100,$0180

_c2ce93:
@ce93:  .word   $0200,$0280,$0300,$0380,$0400,$0480
        .word   $0500,$0580

; ------------------------------------------------------------------------------

; character sprite data (top/bottom sprite, then left/right sprite for dead characters)
CharSpriteData:
@cea3:  .byte   $00,$f8,$00,$00
        .byte   $00,$08,$02,$00
        .byte   $fc,$08,$00,$00
        .byte   $0c,$08,$02,$00

; character sprite data, h flip
@ceb3:  .byte   $00,$f8,$00,$40
        .byte   $00,$08,$02,$40
        .byte   $04,$08,$00,$40
        .byte   $f4,$08,$02,$40

; character sprite data, v flip
@cec3:  .byte   $00,$00,$02,$80
        .byte   $00,$10,$00,$80
        .byte   $fc,$08,$00,$80
        .byte   $0c,$08,$02,$80

; character sprite data, h & v flip
@ced3:  .byte   $00,$00,$02,$c0
        .byte   $00,$10,$00,$c0
        .byte   $04,$08,$00,$c0
        .byte   $f4,$08,$02,$c0

; ------------------------------------------------------------------------------

; Character x positions lie along a diagonal line from an imaginary point
; $68 pixels above top center point of the screen. The angle convention is
;   $0080 = 45 degrees to the left
;   $0100 = vertical
;   $0180 = 45 degrees to the right

; character back row xy angle offsets (normal, back, pincer, side)
CharRowOffsetTbl:
@cee3:  .addr   12,12,12,12
        .addr   -12,-12,-12,-12
        .addr   0,0,0,0
        .addr   12,12,-12,-12

; battle type character y-offsets (normal, back, pincer, side, magitek train bg)
CharYOffsetTbl:
@cf03:  .byte   68, 86, 104, 122
        .byte   68, 86, 104, 122
        .byte   68, 86, 104, 122
        .byte   78, 122, 78, 122
        .byte   80, 94, 108, 122

; battle type character xy angles (normal, back, pincer, side)
CharXAngleTbl:
@cf17:  .word   $0170,$0170,$0170,$0170
        .word   $0090,$0090,$0090,$0090
        .word   $0100,$0100,$0100,$0100
        .word   $0170,$0170,$0090,$0090

; ------------------------------------------------------------------------------

; magitek graphics vram pointers (4 per character slot)
MagitekGfxVRAMTbl:
@cf37:  .word   $30c0,$31c0,$32c0,$33c0
        .word   $34c0,$35c0,$36c0,$37c0
        .word   $38c0,$39c0,$3ac0,$3bc0
        .word   $3cc0,$3dc0,$3ec0,$3fc0

; ------------------------------------------------------------------------------

; character sprite graphics offsets
_c2cf57:
@cf57:  .byte   $00,$04,$08,$0c

; pointers to character graphics data (+$7e2eae)
CharGfxDataBufPtrs:
        .byte   array_offset wCharGfxDataBuf, 0
        .byte   array_offset wCharGfxDataBuf, 1
        .byte   array_offset wCharGfxDataBuf, 2
        .byte   array_offset wCharGfxDataBuf, 3

; ------------------------------------------------------------------------------

; pointers to magitek armor graphics (4 frames, then unknown japanese text)
MagitekGfxPtrs:
@cf5f:  .dword  VehicleGfx+$1500
        .dword  VehicleGfx+$1800
        .dword  VehicleGfx+$1900
        .dword  VehicleGfx+$1c00
        .dword  VehicleGfx+$1d00

; magitek animation data (4 items, 4 bytes each)
_c2cf73:
@cf73:  .byte   $00,$00,$00,$00
        .byte   $00,$01,$00,$02
        .byte   $03,$03,$03,$03
        .byte   $04,$04,$04,$04

; (4 items, 4 bytes each)
_c2cf83:
@cf83:  .byte   $f7,$fc,$0c,$01
        .byte   $f7,$fc,$4c,$01
        .byte   $f7,$fc,$8c,$01
        .byte   $f7,$fc,$cc,$01

; ------------------------------------------------------------------------------

; y offsets for bouncing damage numerals
DmgNumBounceTbl:
@cf93:  .byte   3,6,8,10,11,13,14,15,15,16,16,16,16,16,15,15
        .byte   14,13,11,10,8,6,3,0,3,4,5,6,7,7,8,8
        .byte   7,7,6,5,4,3,0,0,0,0,0,0,0,0,0,0
        .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .byte   0

; ------------------------------------------------------------------------------

; magitek color palette (12 colors)
MagitekPal:
@cfd4:  .word   $00bf,$0c63,$196c,$2e10,$42f7,$110e,$2ebc,$4b9f
        .word   $41ad,$6739,$7fff,$2192

; petrify status color palette (11 colors used)
PetrifyPal:
@cfec:  .word   $0842,$6b5a,$18c6,$4210,$294a,$6b5a,$4e73,$6318
        .word   $3def,$4e73,$294a,$0000

; frozen status color palette (11 colors)
FrozenPal:
@d004:  .word   $44c6,$7fff,$3c60,$7ef7,$7dad,$7fff,$7f18,$7e52
        .word   $7d8c,$7e52,$7d29

; ------------------------------------------------------------------------------

; pointers to monster vram maps

.enum MONSTER_VRAM_MAP
        COUNT = 13
.endenum

MonsterVRAMMapPtrs:
        COUNT = 13
        ptr_tbl MONSTER_VRAM_MAP

.macro monster_vram_map x_pos, y_pos, width, height
        .word   x_pos * $20 + y_pos * $200
        .byte   width, height
.endmac

; monster vram map $00 (vram destination, width, height)
        array_label MONSTER_VRAM_MAP, 0
        monster_vram_map 0,0,8,8
        monster_vram_map 8,0,8,8
        monster_vram_map 0,8,8,8
        monster_vram_map 8,8,8,8

; monster vram map $01
        array_label MONSTER_VRAM_MAP, 1
        monster_vram_map 0,0,8,8
        monster_vram_map 8,0,8,8
        monster_vram_map 0,8,4,4
        monster_vram_map 4,8,4,4
        monster_vram_map 8,8,4,4
        monster_vram_map 12,8,4,4

; monster vram map $02
        array_label MONSTER_VRAM_MAP, 2
        monster_vram_map 0,0,12,8
        monster_vram_map 0,8,12,8

; monster vram map $03
        array_label MONSTER_VRAM_MAP, 3
        monster_vram_map 0,0,8,16
        monster_vram_map 8,0,8,16

; monster vram map $04
        array_label MONSTER_VRAM_MAP, 4
        monster_vram_map 0,0,12,8
        monster_vram_map 0,8,8,8
        monster_vram_map 8,8,8,8

; monster vram map $05
        array_label MONSTER_VRAM_MAP, 5
        monster_vram_map 0,0,8,16
        monster_vram_map 8,0,8,8
        monster_vram_map 8,8,8,8

; monster vram map $06
        array_label MONSTER_VRAM_MAP, 6
        monster_vram_map 0,0,16,16

; monster vram map $07
        array_label MONSTER_VRAM_MAP, 7
        monster_vram_map 0,0,12,12
        monster_vram_map 12,0,4,12
        monster_vram_map 0,12,4,4
        monster_vram_map 4,12,4,4
        monster_vram_map 8,12,4,4
        monster_vram_map 12,12,4,4

; monster vram map $08
        array_label MONSTER_VRAM_MAP, 8
        monster_vram_map 0,0,8,8
        monster_vram_map 0,8,8,8
        monster_vram_map 8,0,4,8
        monster_vram_map 8,8,4,8

; monster vram map $09
        array_label MONSTER_VRAM_MAP, 9
        monster_vram_map 0,0,12,12  ; height is 16 in sprite map

; monster vram map $0a
        array_label MONSTER_VRAM_MAP, 10
        monster_vram_map 0,0,8,12
        monster_vram_map 8,0,4,8
        monster_vram_map 8,8,4,8
        monster_vram_map 0,12,4,4
        monster_vram_map 4,12,4,4

; monster vram map $0b
        array_label MONSTER_VRAM_MAP, 11
        monster_vram_map 0,0,4,8
        monster_vram_map 4,0,4,8
        monster_vram_map 8,0,4,8
        monster_vram_map 8,8,4,8
        monster_vram_map 0,8,8,8

; monster vram map $0c
        array_label MONSTER_VRAM_MAP, 12
        monster_vram_map 0,0,8,8
        monster_vram_map 8,0,8,8
        monster_vram_map 0,8,4,8
        monster_vram_map 4,8,4,8
        monster_vram_map 8,8,4,8
        monster_vram_map 12,8,4,8

; ------------------------------------------------------------------------------
