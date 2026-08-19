.list off
.ifndef LONG_ENTRANCE_INC
LONG_ENTRANCE_INC = 1

.global LongEntrance, LongEntrancePtrs

.scope LongEntrance

        SrcPos := LongEntrancePtrs
        SrcX := LongEntrancePtrs
        SrcY := LongEntrancePtrs + 1
        Length := LongEntrancePtrs + 2
        Map := LongEntrancePtrs + 3
        Flags := LongEntrancePtrs + 4
        DestPos := LongEntrancePtrs + 5
        DestX := LongEntrancePtrs + 5
        DestY := LongEntrancePtrs + 6

.endscope

.scope LONG_ENTRANCE

        TRIGGER_SIZE = 7
        PTR_OFFSET = LongEntrance - LongEntrancePtrs
        .include "assets/data/field/long_entrance.ptr"

.endscope

.endif
.list on
