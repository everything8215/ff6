.list off
.ifndef MONSTER_DLG_INC
MONSTER_DLG_INC = 1

.global MonsterDlg, MonsterDlgPtrs

.scope MONSTER_DLG

        PTR_OFFSET = MonsterDlg
        .include "assets/text/monster_dlg.ptr"

.endscope

.endif
.list on
