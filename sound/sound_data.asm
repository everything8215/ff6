
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: sound_data.asm                                                       |
; |                                                                            |
; | description: sound data                                                    |
; |                                                                            |
; | created: 12/7/2022                                                         |
; +----------------------------------------------------------------------------+

.segment "sound_data"

        .include "data/spc_data.asm"                            ; c5/070e
NumSongs:
        .byte   85                                              ; c5/3c5e

BRRSamplePtrs:
        make_ptr_tbl_far BRRSample, 63, 0                       ; c5/3c5f
        .include "data/sample_loop_start.asm"                   ; c5/3d1c
        .include "data/sample_freq_mult.asm"                    ; c5/3d9a
        .include "data/sample_adsr.asm"                         ; c5/3e18

SongScriptPtrs:
        make_ptr_tbl_far SongScript, 85, 0                      ; c5/3e96
        .include "data/song_samples.asm"                        ; c5/3f95
        .include "data/brr_sample.asm"                          ; c5/4a35
        .include "data/song_script.asm"                         ; c8/5c7a

; ------------------------------------------------------------------------------
