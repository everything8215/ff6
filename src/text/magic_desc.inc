.list off
.ifndef MAGIC_DESC_INC
MAGIC_DESC_INC = 1

.global MagicDesc, MagicDescPtrs

.scope MAGIC_DESC

        .include "assets/text/magic_desc.ptr"

.endscope

.endif
.list on
