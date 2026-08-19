.include "src/text/char_name.inc"
.if LANG_JP
.include "src/text/char_title.inc"
.endif

; ------------------------------------------------------------------------------

; c4/78c0
.segment "char_name"

CharName:
        .incbin "assets/text/char_name.bin"

; ------------------------------------------------------------------------------

.if LANG_JP

; cf/3b40
.segment "char_title"

CharTitle:
        .incbin "assets/text/char_title.bin"

.endif

; ------------------------------------------------------------------------------
