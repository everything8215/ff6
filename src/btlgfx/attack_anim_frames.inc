.list off
.ifndef ATTACK_ANIM_FRAMES_INC
ATTACK_ANIM_FRAMES_INC = 1

.global AttackAnimFrames, AttackAnimFramesPtrs

.scope ATTACK_ANIM_FRAMES

        PTR_OFFSET := AttackAnimFrames
        .include "assets/data/btlgfx/attack_anim_frames.ptr"

.endscope

.endif
.list on
