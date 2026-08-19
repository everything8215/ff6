.list off
.ifndef ITEM_NAME_INC
ITEM_NAME_INC = 1

.global ItemName

.scope ITEM_NAME

        .include "assets/text/item_name.ptr"

.endscope

.endif
.list on
