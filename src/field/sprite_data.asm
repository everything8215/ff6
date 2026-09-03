; ------------------------------------------------------------------------------

.include "src/gfx/map_sprite_gfx.inc"

; ------------------------------------------------------------------------------

; horizontal flip flag for object graphics positions (upper sprite)
TopSpriteHFlip:
@cd3a:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

; horizontal flip flag for object graphics positions (lower sprite)
BtmSpriteHFlip:
@cdba:  .byte   $00,$00,$40,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $40,$40,$40,$00,$40,$00,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

; object spriteheet
MapSpriteTileOffsets:
@ce3a:  .word   $0000,$0020,$0040,$0060,$0080,$00a0  ; $00: WALKING_DOWN_1
        .word   $0000,$0020,$00c0,$00e0,$0100,$0120  ; $01: WALKING_DOWN_2
        .word   $0000,$0020,$0140,$0160,$0080,$00a0  ; $02: WALKING_DOWN_3
        .word   $0180,$01a0,$01c0,$01e0,$0200,$0220  ; $03: WALKING_UP_1
        .word   $0180,$01a0,$0240,$0260,$0280,$02a0  ; $04: WALKING_UP_2
        .word   $0180,$01a0,$02c0,$02e0,$0200,$0220  ; $05: WALKING_UP_3
        .word   $0300,$0320,$0340,$0360,$0380,$03a0  ; $06: WALKING_LEFT_1
        .word   $03c0,$03e0,$0400,$0420,$0440,$0460  ; $07: WALKING_LEFT_2
        .word   $0300,$0320,$0480,$04a0,$04c0,$04e0  ; $08: WALKING_LEFT_3
        .word   $0700,$0720,$0740,$0760,$0780,$07a0  ; $09: NEAR_FATAL
        .word   $07c0,$07e0,$0800,$0820,$0840,$0860  ; $0a: READY
        .word   $0880,$08a0,$08c0,$08e0,$0900,$0920  ; $0b: HIT
        .word   $03c0,$03e0,$0500,$0520,$0540,$0560  ; $0c: ATTACKING_1
        .word   $0300,$0320,$0580,$0360,$05a0,$03a0  ; $0d: ATTACKING_2
        .word   $0300,$05c0,$05e0,$0600,$0620,$0640  ; $0e: ATTACKING_3
        .word   $03c0,$0660,$0680,$06a0,$06c0,$06e0  ; $0f: JUMPING
        .word   $0940,$0960,$0980,$09a0,$09c0,$09e0  ; $10: CASTING_1
        .word   $0940,$0960,$0a00,$09a0,$09c0,$09e0  ; $11: CASTING_2
        .word   $0a20,$0a40,$0a60,$0a80,$0aa0,$0ac0  ; $12: DEAD_VERT
        .word   $0000,$0020,$0ba0,$0bc0,$0100,$0120  ; $13: EYES_CLOSED_DOWN
        .word   $0000,$0020,$00c0,$0be0,$0100,$0120  ; $14: WINKING_DOWN
        .word   $12c0,$03e0,$12e0,$0420,$0440,$0460  ; $15: EYES_CLOSED_LEFT
        .word   $0d40,$0d60,$0d80,$0da0,$0dc0,$0de0  ; $16: ARMS_UP_DOWN
        .word   $0e00,$0e20,$0e40,$0e60,$0e80,$0ea0  ; $17: ARMS_UP_UP
        .word   $0ec0,$0ee0,$0f00,$0f20,$0f40,$0f60  ; $18: ANGRY
        .word   $0d40,$0020,$0d80,$00e0,$0dc0,$0120  ; $19: WAVING_1_DOWN
        .word   $1040,$0020,$1060,$00e0,$0dc0,$0120  ; $1a: WAVING_2_DOWN
        .word   $0180,$0e20,$0240,$0e60,$0280,$0ea0  ; $1b: WAVING_1_UP
        .word   $0180,$1080,$0240,$10a0,$0280,$0ea0  ; $1c: WAVING_2_UP
        .word   $0c00,$0c20,$0c40,$0c60,$0c80,$0ca0  ; $1d: LAUGHING_1
        .word   $0cc0,$0ce0,$0d00,$0d20,$0c80,$0ca0  ; $1e: LAUGHING_2
        .word   $0f80,$0fa0,$0fc0,$0fe0,$1000,$1020  ; $1f: SURPRISED
        .word   $10c0,$10e0,$1100,$1120,$0100,$0120  ; $20: HEAD_DOWN_DOWN
        .word   $1140,$1160,$1180,$11a0,$0280,$02a0  ; $21: HEAD_DOWN_UP
        .word   $11c0,$11e0,$1200,$1220,$0440,$0460  ; $22: HEAD_DOWN_LEFT
        .word   $1240,$1260,$1280,$12a0,$0100,$0120  ; $23: HEAD_TURNED
        .word   $1460,$1480,$1300,$1320,$1340,$1360  ; $24: WAGGING_FINGER_1
        .word   $1460,$1480,$1380,$1320,$1340,$1360  ; $25: WAGGING_FINGER_2
        .word   $13a0,$13c0,$13e0,$1400,$1420,$1440  ; $26: SPECIAL
        .word   $14a0,$14c0,$14e0,$1500,$1520,$1540  ; $27: TENT
        .word   $0a20,$0a40,$0a60,$0a80,$0aa0,$0ac0  ; $28: DEAD_HORZ
        .word   $0620,$0640,$0660,$0680,$06a0,$06c0  ; $29: NPC_SPECIAL_1
        .word   $0500,$0020,$0520,$00e0,$0540,$0120  ; $2a: NPC_WAVING_1
        .word   $0560,$0020,$0580,$00e0,$0540,$0120  ; $2b: NPC_WAVING_2
        .word   $05a0,$05c0,$05e0,$0600,$0100,$0120  ; $2c: NPC_HEAD_DOWN_DOWN
        .word   $0500,$0520,$0540,$0560,$0580,$05a0  ; $2d: NPC_SPECIAL_2
        .word   $1620,$1640,$1660,$1680,$15e0,$1600  ; $2e: RIDING_LEFT_1
        .word   $1560,$1580,$15a0,$15c0,$15e0,$1600  ; $2f: RIDING_LEFT_2
        .word   $00c0,$0020,$00e0,$0060,$0100,$00a0  ; $30: RAMUH_STAFF_RAISED
        .word   $0120,$0140,$0040,$0060,$0080,$00a0  ; $31: RAMUH_EYES_CLOSED
        .word   $0000,$0000,$0020,$0040,$0060,$0080  ; $32: SPECIAL_ANIM_1
        .word   $0000,$0000,$00a0,$00c0,$00e0,$0100  ; $33: SPECIAL_ANIM_2
        .word   $0000,$0000,$0120,$0140,$0160,$0180  ; $34: SPECIAL_ANIM_3
        .word   $0000,$0000,$01a0,$01c0,$01e0,$0200  ; $35: SPECIAL_ANIM_4
        .word   $05c0,$05e0,$0600,$0620,$0640,$0660  ; $36: OPERA_SINGER_MOUTH_OPEN
        .word   $0680,$06a0,$06c0,$06e0,$0640,$0660  ; $37: OPERA_SINGER_MOUTH_CLOSED
        .word   $0680,$06a0,$06c0,$06e0,$0640,$0660  ; $38: OPERA_SINGER_UNUSED
        .word   $0000,$0020,$0040,$0040,$0040,$0040  ; $39: MAP_SPRITE_FRAME_57

; pointers to object sprite graphics (low word)
MapSpriteGfxPtrsLo:
@d0f2:  .repeat MapSpriteGfx::COUNT, i
        .addr   array_item MapSpriteGfx, i
        .endrep

; pointers to object sprite graphics, tile size (bank byte)
; the high byte gets copied to $4305 and determines the number of bytes per tile
MapSpriteGfxPtrsHi:
@d23c:  .repeat MapSpriteGfx::COUNT, i
        .byte   .bankbyte(array_item MapSpriteGfx, i)
        .byte   $20
        .endrep

; ------------------------------------------------------------------------------
