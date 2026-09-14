.export MapParallax

.include "map_parallax.inc"
.include "map_parallax.mac"

; ------------------------------------------------------------------------------

; c0/fe40
.segment "map_parallax"

MapParallax:

; 0: NONE
        map_parallax NONE
        end_map_parallax

; 1: PHANTOM_FOREST
        map_parallax PHANTOM_FOREST
        bg2_mult {8, 0}
        bg3_mult {32, 0}
        end_map_parallax

; 2: FOG_PARALLAX
        map_parallax FOG_PARALLAX
        bg2_mult {4, 4}
        bg3_speed {8, 8}
        end_map_parallax

; 3: TRAIN
        map_parallax TRAIN
        bg2_speed {-48, 0}
        bg2_mult {8, 16}
        end_map_parallax

; 4: PARALLAX
        map_parallax PARALLAX
        bg2_mult {4, 4}
        end_map_parallax

; 5: OPERA_HOUSE
        map_parallax OPERA_HOUSE
        bg2_mult {16, 12}
        end_map_parallax

; 6: FLOATING_ISLAND
        map_parallax FLOATING_ISLAND
        bg2_speed {0, 4}
        bg2_mult {8, 16}
        bg3_speed {8, 8}
        end_map_parallax

; 7: MAP_PARALLAX_7
        map_parallax MAP_PARALLAX_7
        bg3_speed {64, 64}
        end_map_parallax

; 8: AIRSHIP
        map_parallax AIRSHIP
        bg2_speed {-8, 0}
        end_map_parallax

; 9: SEALED_GATE
        map_parallax SEALED_GATE
        bg2_mult {16, 12}
        bg3_speed {32, 0}
        end_map_parallax

; 10: FOG
        map_parallax FOG
        bg3_speed {8, 8}
        end_map_parallax

; 11: FAST_FOG
        map_parallax FAST_FOG
        bg3_speed {-48, -48}
        end_map_parallax

; 12: AIRSHIP_CRASHING
        map_parallax AIRSHIP_CRASHING
        bg3_speed {0, 8}
        end_map_parallax

; 13: SLOW_FOG
        map_parallax SLOW_FOG
        bg3_speed {2, 4}
        end_map_parallax

; 14: FANATICS_TOWER
        map_parallax FANATICS_TOWER
        bg3_speed {32, -2}
        bg3_mult {8, 8}
        end_map_parallax

; 15: KEFKAS_TOWER_TOP
        map_parallax KEFKAS_TOWER_TOP
        bg2_mult {0, 12}
        bg3_speed {32, -8}
        bg3_mult {0, 0}
        end_map_parallax

; 16: MAP_PARALLAX_16
        map_parallax MAP_PARALLAX_16
        bg2_mult {0, 12}
        end_map_parallax

; 17: WATERFALL
        map_parallax WATERFALL
        bg2_mult {8, 8}
        bg3_mult {8, 8}
        end_map_parallax

; 18: KEFKAS_TOWER
        map_parallax KEFKAS_TOWER
        bg3_speed {8, 0}
        bg3_mult {8, 0}
        end_map_parallax

; 19: MAP_PARALLAX_19
        map_parallax MAP_PARALLAX_19
        bg2_speed {-16, 0}
        end_map_parallax

; 20: MAP_PARALLAX_20
        map_parallax MAP_PARALLAX_20
        bg3_speed {8, 8}
        end_map_parallax

; ------------------------------------------------------------------------------

.include "map_parallax.mac"