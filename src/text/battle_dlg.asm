.include "src/text/battle_dlg.inc"

; ------------------------------------------------------------------------------

; d0/d000
.segment "battle_dlg_ptrs"

BattleDlgPtrs:
        ptr_tbl BATTLE_DLG

; ------------------------------------------------------------------------------

; d0/d200
.segment "battle_dlg"

BattleDlg:
        .incbin "assets/text/battle_dlg.bin"

; ------------------------------------------------------------------------------
