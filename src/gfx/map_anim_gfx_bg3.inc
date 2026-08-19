.list off
.ifndef MAP_ANIM_GFX_BG3_INC
MAP_ANIM_GFX_BG3_INC = 1

.global MapAnimGfxBG3, MapAnimGfxBG3Ptrs

.enum MAP_ANIM_GFX_BG3
        RIVER
        FIRE
        RAIN
        CAVES
        BEACH
        NARSHE

        COUNT
        BASE_PTR = MapAnimGfxBG3
.endenum

.endif
.list on
