.list off
.ifndef BATTLE_EVENT_SCRIPT_INC
BATTLE_EVENT_SCRIPT_INC = 1

.global BattleEventScript, BattleEventScriptPtrs

.scope BATTLE_EVENT_SCRIPT

        PTR_OFFSET = BattleEventScript
        .include "assets/data/btlgfx/battle_event_script.ptr"

.endscope

.endif
.list on
