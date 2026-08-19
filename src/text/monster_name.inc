.list off
.ifndef MONSTER_NAME_INC
MONSTER_NAME_INC = 1

.global MonsterName

.scope MONSTER_NAME

        .include "assets/text/monster_name.ptr"

.endscope

.endif
.list on
