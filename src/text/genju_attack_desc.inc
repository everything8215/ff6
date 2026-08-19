.list off
.ifndef GENJU_ATTACK_DESC_INC
GENJU_ATTACK_DESC_INC = 1

.global GenjuAttackDesc, GenjuAttackDescPtrs

.scope GENJU_ATTACK_DESC

        .include "assets/text/genju_attack_desc.ptr"

.endscope

.endif
.list on
