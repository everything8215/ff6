.list off
.ifndef CHAR_NAME_INC
CHAR_NAME_INC = 1

.global CharName

.scope CharName

        ARRAY_LENGTH = 64
        ITEM_SIZE = 6
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
