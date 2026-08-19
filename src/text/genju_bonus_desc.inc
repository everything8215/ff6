.list off
.ifndef GENJU_BONUS_DESC_INC
GENJU_BONUS_DESC_INC = 1

.global GenjuBonusDesc, GenjuBonusDescPtrs

.scope GENJU_BONUS_DESC

        .include "assets/text/genju_bonus_desc.ptr"

.endscope

.endif
.list on
