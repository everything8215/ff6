.list off
.ifndef BATTLE_DLG_INC
BATTLE_DLG_INC = 1

.global BattleDlg, BattleDlgPtrs

.scope BATTLE_DLG

        PTR_OFFSET = BattleDlg
        .include "assets/text/battle_dlg.ptr"

.endscope

.endif
.list on
