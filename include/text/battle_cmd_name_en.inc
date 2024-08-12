.list off
.ifndef BATTLE_CMD_NAME_INC
BATTLE_CMD_NAME_INC = 1

.global BattleCmdName

.scope BattleCmdName

        ARRAY_LENGTH = 32
        ITEM_SIZE = 7
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
