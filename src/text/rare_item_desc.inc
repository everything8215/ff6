.list off
.ifndef RARE_ITEM_DESC_INC
RARE_ITEM_DESC_INC = 1

.global RareItemDesc, RareItemDescPtrs

.scope RARE_ITEM_DESC

        .include "assets/text/rare_item_desc.ptr"

.endscope

.endif
.list on
