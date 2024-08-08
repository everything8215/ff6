.list off
.ifndef MAP_GFX_BG3_INC
MAP_GFX_BG3_INC = 1

.global MapGfxBG3, MapGfxBG3Ptrs

.enum MAP_GFX_BG3
        MOUNTAINS_INT                   ;= $00  ; 0
        RIVER                           ;= $01  ; 1
        UNUSED_TRAIN                    ;= $02  ; 2
        NARSHE_STEAM                    ;= $03  ; 3
        CAVES_TORCH                     ;= $04  ; 4
        CAVES_ICE_WATER                 ;= $05  ; 5
        FOREST                          ;= $06  ; 6
        BEACH                           ;= $07  ; 7
        FIRE_WATER                      ;= $08  ; 8
        BURNING_BUILDING                ;= $09  ; 9
        RAIN                            ;= $0a  ; 10
        CLOUDS                          ;= $0b  ; 11
        DARILLS_TOMB                    ;= $0c  ; 12
        UNUSED_0D                       ;= $0d  ; 13
        MAGITEK_TUBES                   ;= $0e  ; 14
        WATERFALL                       ;= $0f  ; 15
        TOWN_WATER                      ;= $10  ; 16
        MAGITEK_FACTORY                 ;= $11  ; 17
.endenum

.scope MapGfxBG3
        ARRAY_LENGTH = MAP_GFX_BG3::MAGITEK_FACTORY + 1
        Start := MapGfxBG3
.endscope

.endif
.list on
