.ifndef EVENT_TRIGGER_INC
EVENT_TRIGGER_INC = 1

; ------------------------------------------------------------------------------

.global EventTriggerPtrs

; ------------------------------------------------------------------------------

.scope EventTrigger
        ARRAY_LENGTH = $01a0
        ITEM_SIZE = 5
        Start := EventTriggerPtrs
        Pos := Start
        PosX := Start
        PosY := Start + 1
        EventPtr := Start + 2
.endscope

; ------------------------------------------------------------------------------

.endif
