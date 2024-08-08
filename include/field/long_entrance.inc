.list off
.ifndef LONG_ENTRANCE_INC
LONG_ENTRANCE_INC = 1

.global LongEntrance, LongEntrancePtrs

.scope LongEntrance

        ITEM_SIZE = 7
        Start := LongEntrancePtrs

        SrcPos := Start
        SrcX := Start
        SrcY := Start + 1
        Length := Start + 2
        Map := Start + 3
        Flags := Start + 4
        DestPos := Start + 5
        DestX := Start + 5
        DestY := Start + 6

; ##############################################################################
; ###          AUTOMATICALLY GENERATED CODE, DO NOT MODIFY MANUALLY          ###
; ##############################################################################


; ##############################################################################

.endscope

.endif
.list on
