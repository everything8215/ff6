.list off
.ifndef DLG_INC
DLG_INC = 1

.global Dlg, DlgPtrs

.scope DLG

        PTR_OFFSET = Dlg
        .include "assets/text/dlg.ptr"

.endscope

.endif
.list on
