.list off
.ifndef ATTACK_MSG_INC
ATTACK_MSG_INC = 1

.global AttackMsg, AttackMsgPtrs

.scope ATTACK_MSG

        PTR_OFFSET = AttackMsg
        .include "assets/text/attack_msg.ptr"

.endscope

.endif
.list on
