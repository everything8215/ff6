.list off
.ifndef RARE_ITEM_NAME_INC
RARE_ITEM_NAME_INC = 1

.global RareItemName

.scope RareItemName

        ARRAY_LENGTH = 30
        ITEM_SIZE = 8
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
