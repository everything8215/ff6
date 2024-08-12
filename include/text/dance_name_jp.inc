.list off
.ifndef DANCE_NAME_INC
DANCE_NAME_INC = 1

.global DanceName

.scope DanceName

        ARRAY_LENGTH = 8
        ITEM_SIZE = 8
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
