.list off
.ifndef ITEM_DESC_INC
ITEM_DESC_INC = 1

.global ItemDesc, ItemDescPtrs

.scope ITEM_DESC

        .include "assets/text/item_desc.ptr"

.endscope

.endif
.list on
