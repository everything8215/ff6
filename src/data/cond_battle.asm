.export CondBattle, sizeof_CondBattle

.segment "cond_battle"

; cf/3780
CondBattle:
        .word   $01c4,$01a8
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        calc_size CondBattle
; *** bug ***
; conditional battles below here will not be checked
; these are unused, so this has no effect
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0000,$0000
