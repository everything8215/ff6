
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: cutscene.asm                                                         |
; |                                                                            |
; | description: cutscene program                                              |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.export OpeningCredits_ext, TitleScreen_ext
.export FloatingIslandScene_ext, WorldOfRuinScene_ext

; ------------------------------------------------------------------------------

.segment "cutscene_code"
.a8
.i16

; ------------------------------------------------------------------------------

OpeningCredits_ext:
@6800:  jmp     OpeningCredits

TitleScreen_ext:
@6803:  jmp     TitleScreen

FloatingIslandScene_ext:
@6806:  jmp     FloatingIslandScene

WorldOfRuinScene_ext:
@6809:  jmp     WorldOfRuinScene

; ------------------------------------------------------------------------------

TitleScreen:
@680c:  lda     #$ff                    ; set return code to start a new game
        sta     $0200
        rtl

; ------------------------------------------------------------------------------

OpeningCredits:
@6813:  rtl

; ------------------------------------------------------------------------------

FloatingIslandScene:
@681a:  rtl

; ------------------------------------------------------------------------------

WorldOfRuinScene:
@6821:  rtl

; ------------------------------------------------------------------------------
