; ------------------------------------------------------------------------------

.export WindowGfx, WindowPal

; ------------------------------------------------------------------------------

.segment "window_gfx"

; ed/0000
WindowGfx:
        .incbin "assets/gfx/window/window_0000.4bpp"
        .incbin "assets/gfx/window/window_0001.4bpp"
        .incbin "assets/gfx/window/window_0002.4bpp"
        .incbin "assets/gfx/window/window_0003.4bpp"
        .incbin "assets/gfx/window/window_0004.4bpp"
        .incbin "assets/gfx/window/window_0005.4bpp"
        .incbin "assets/gfx/window/window_0006.4bpp"
        .incbin "assets/gfx/window/window_0007.4bpp"

; ------------------------------------------------------------------------------

; ed/1c00
WindowPal:
        .incbin "assets/gfx/window/window_0000.pal"
        .incbin "assets/gfx/window/window_0001.pal"
        .incbin "assets/gfx/window/window_0002.pal"
        .incbin "assets/gfx/window/window_0003.pal"
        .incbin "assets/gfx/window/window_0004.pal"
        .incbin "assets/gfx/window/window_0005.pal"
        .incbin "assets/gfx/window/window_0006.pal"
        .incbin "assets/gfx/window/window_0007.pal"

; ------------------------------------------------------------------------------
