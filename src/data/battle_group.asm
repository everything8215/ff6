.export RandBattleGroup, EventBattleGroup, WorldBattleGroup, SubBattleGroup

.segment "battle_groups"

; ------------------------------------------------------------------------------

; [ random battle groups for world and sub-maps ]

; 1024 bytes total
; 256 battle groups, 4 battles per group, 3 common (5/16) then 1 rare (1/16)
; each battle index is 2 bytes (0 to 511)
; if the MSB of the battle index is set, add a random number (0..3) to the
; battle index (used on the floating island)

; cf/4800
RandBattleGroup:
        .incbin "assets/data/field/rand_battle_group.bin"

; ------------------------------------------------------------------------------

; [ random battle groups for events ]

; 512 bytes total
; 256 battle groups, 2 battles per group, common (3/4) then rate (1/4)
; each battle index is 2 bytes (0 to 511)
; if the MSB of the battle index is set, add a random number (0..3) to the
; battle index (never used for event battles)

; cf/5000
EventBattleGroup:
        .incbin "assets/data/field/event_battle_group.bin"

; ------------------------------------------------------------------------------

; [ random battle groups for each world map sector ]

; 512 bytes total
; WoB then WoR, 8x8 sectors per world
; 4 bytes per sector (field, forest, desert, dirt)
; provides index into RandBattleGroup

; cf/5400
WorldBattleGroup:
        .incbin "assets/data/field/world_battle_group.bin"

; ------------------------------------------------------------------------------

; [ random battle groups for each sub-map ]

; 512 bytes total
; one byte per sub-map, provides index into RandBattleGroup

; cf/5600
SubBattleGroup:
        .incbin "assets/data/field/sub_battle_group.bin"

; ------------------------------------------------------------------------------

        .include "world_battle_rate.asm"
        .include "sub_battle_rate.asm"

; ------------------------------------------------------------------------------
