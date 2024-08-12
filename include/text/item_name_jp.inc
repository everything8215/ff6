.list off
.ifndef ITEM_NAME_INC
ITEM_NAME_INC = 1

.global ItemName

.scope ItemName

        ARRAY_LENGTH = 256
        ITEM_SIZE = 9
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
