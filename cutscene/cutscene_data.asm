
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: cutscene_data.asm                                                    |
; |                                                                            |
; | description: data for cutscenes                                            |
; |                                                                            |
; | created: 8/17/2022                                                         |
; +----------------------------------------------------------------------------+

.segment "title_opening_gfx"

; d8/f000
        .include "gfx/title_opening_gfx.asm"
        .res $24

; d9/4e96
        .include "gfx/floating_cont_gfx.asm"

.segment "ruin_cutscene_gfx"

; ec/e900
        .include "gfx/ruin_cutscene_gfx.asm"

; ------------------------------------------------------------------------------
