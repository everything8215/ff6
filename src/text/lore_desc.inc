.list off
.ifndef LORE_DESC_INC
LORE_DESC_INC = 1

.global LoreDesc, LoreDescPtrs

.scope LORE_DESC

        .include "assets/text/lore_desc.ptr"

.endscope

.endif
.list on
