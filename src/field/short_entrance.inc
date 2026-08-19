.list off
.ifndef SHORT_ENTRANCE_INC
SHORT_ENTRANCE_INC = 1

.global ShortEntrance, ShortEntrancePtrs

.scope ShortEntrance

        SrcPos := ShortEntrancePtrs
        SrcX := ShortEntrancePtrs
        SrcY := ShortEntrancePtrs + 1
        Map := ShortEntrancePtrs + 2
        Flags := ShortEntrancePtrs + 3
        DestPos := ShortEntrancePtrs + 4
        DestX := ShortEntrancePtrs + 4
        DestY := ShortEntrancePtrs + 5

.endscope

.scope SHORT_ENTRANCE

        TRIGGER_SIZE = 6
        PTR_OFFSET = ShortEntrance - ShortEntrancePtrs
        .include "assets/data/field/short_entrance.ptr"

.endscope

.endif
.list on
