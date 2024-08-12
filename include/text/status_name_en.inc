.list off
.ifndef STATUS_NAME_INC
STATUS_NAME_INC = 1

.global StatusName

.scope StatusName

        ARRAY_LENGTH = 32
        ITEM_SIZE = 10
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
