.list off
.ifndef STATUS_NAME_INC
STATUS_NAME_INC = 1

.global StatusName

.scope STATUS_NAME

        .include "assets/text/status_name.ptr"

.endscope

.endif
.list on
