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
.endenum

.scope MapAnimGfxBG3
        ARRAY_LENGTH = MAP_ANIM_GFX_BG3::NARSHE + 1
        Start := MapAnimGfxBG3
.endscope

.endif
.list on
