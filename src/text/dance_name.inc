.list off
.ifndef DANCE_NAME_INC
DANCE_NAME_INC = 1

.global DanceName

.scope DANCE_NAME

        .include "assets/text/dance_name.ptr"

.endscope

.endif
.list on