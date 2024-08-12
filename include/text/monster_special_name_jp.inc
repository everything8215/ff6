.list off
.ifndef MONSTER_SPECIAL_NAME_INC
MONSTER_SPECIAL_NAME_INC = 1

.global MonsterSpecialName

.scope MonsterSpecialName

        ARRAY_LENGTH = 384
        ITEM_SIZE = 8
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
