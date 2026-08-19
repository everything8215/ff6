.list off
.ifndef MTE_TBL_INC
MTE_TBL_INC = 1

.global MTETbl, MTETblPtrs

.scope MTE_TBL

        PTR_OFFSET = MTETbl
        .include "assets/text/mte_tbl.ptr"

.endscope

.endif
.list on
