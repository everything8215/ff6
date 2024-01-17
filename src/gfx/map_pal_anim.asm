; ------------------------------------------------------------------------------

.export MapPalAnimColors

; ------------------------------------------------------------------------------

.segment "map_pal_anim"

; e6/f200
begin_fixed_block MapPalAnimColors, $0290
        .incbin "map_pal_anim/pal_0000.pal"
        .incbin "map_pal_anim/pal_0001.pal"
        .incbin "map_pal_anim/pal_0002.pal"
        .incbin "map_pal_anim/pal_0003.pal"
        .incbin "map_pal_anim/pal_0004.pal"
        .incbin "map_pal_anim/pal_0005.pal"
        .incbin "map_pal_anim/pal_0006.pal"
        .incbin "map_pal_anim/pal_0007.pal"
        .incbin "map_pal_anim/pal_0008.pal"
        .incbin "map_pal_anim/pal_0009.pal"
        .incbin "map_pal_anim/pal_000a.pal"
        .incbin "map_pal_anim/pal_000b.pal"
        .incbin "map_pal_anim/pal_000c.pal"
        .incbin "map_pal_anim/pal_000d.pal"
        .incbin "map_pal_anim/pal_000e.pal"
        .incbin "map_pal_anim/pal_000f.pal"
        .incbin "map_pal_anim/pal_0010.pal"
        .incbin "map_pal_anim/pal_0011.pal"
end_fixed_block MapPalAnimColors

; ------------------------------------------------------------------------------
