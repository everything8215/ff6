.include "src/text/attack_msg.inc"

; ------------------------------------------------------------------------------

; d1/f000
.segment "attack_msg"

AttackMsg:
.if LANG_EN
        fixed_block $07a0
.else
        fixed_block $09ab
.endif
        .incbin "assets/text/attack_msg.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

; d1/f7a0
.segment "attack_msg_ptrs"

AttackMsgPtrs:
.if LANG_EN
        fixed_block $020b
        ptr_tbl ATTACK_MSG
        end_fixed_block
.else
        ptr_tbl ATTACK_MSG
.endif

; ------------------------------------------------------------------------------
