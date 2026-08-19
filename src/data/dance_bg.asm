.include "src/gfx/battle_bg.inc"

.export DanceBG

.segment "dance_bg"

; d1/f9ab
DanceBG:
        .byte BATTLE_BG::FIELD_WOB      ; 0: WIND_SONG
        .byte BATTLE_BG::FOREST_WOB     ; 1: FOREST_SUITE
        .byte BATTLE_BG::DESERT_WOB     ; 2: DESERT_ARIA
        .byte BATTLE_BG::TOWN_INT       ; 3: LOVE_SONATA
        .byte BATTLE_BG::MOUNTAINS_EXT  ; 4: EARTH_BLUES
        .byte BATTLE_BG::UNDERWATER     ; 5: WATER_RONDO
        .byte BATTLE_BG::CAVES          ; 6: DUSK_REQUIEM
        .byte BATTLE_BG::SNOWFIELDS     ; 7: SNOWMAN_JAZZ
        .byte BATTLE_BG::FOREST_WOR     ; unused
        .byte BATTLE_BG::FOREST_WOR     ; unused
