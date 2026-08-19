.list off
.ifndef BUSHIDO_DESC_INC
BUSHIDO_DESC_INC = 1

.global BushidoDesc, BushidoDescPtrs

.scope BUSHIDO_DESC

        .include "assets/text/bushido_desc.ptr"

.endscope

.endif
.list on