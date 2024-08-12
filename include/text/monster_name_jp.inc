.list off
.ifndef MONSTER_NAME_INC
MONSTER_NAME_INC = 1

.global MonsterName

.scope MonsterName

        ARRAY_LENGTH = 384
        ITEM_SIZE = 8
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
