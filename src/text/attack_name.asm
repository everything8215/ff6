.include "src/text/attack_name.inc"
.include "src/text/dance_name.inc"
.include "src/text/genju_name.inc"
.include "src/text/genju_attack_name.inc"
.include "src/text/magic_name.inc"

; ------------------------------------------------------------------------------

.segment "attack_name"

; e6/f567
MagicName:
        .incbin "assets/text/magic_name.bin"

; ------------------------------------------------------------------------------

; e6/f6e1
GenjuName:
        .incbin "assets/text/genju_name.bin"

; ------------------------------------------------------------------------------

; e6/f7b9
AttackName:
        .incbin "assets/text/attack_name.bin"

; ------------------------------------------------------------------------------

; e6/fe8f
GenjuAttackName:
        .incbin "assets/text/genju_attack_name.bin"

; ------------------------------------------------------------------------------

; e6/ff9d
DanceName:
        .incbin "assets/text/dance_name.bin"

; ------------------------------------------------------------------------------
