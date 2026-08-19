.ifndef EVENT_TRIGGER_INC
EVENT_TRIGGER_INC = 1

; ------------------------------------------------------------------------------

.global EventTrigger, EventTriggerPtrs

; ------------------------------------------------------------------------------

.enum EVENT_TRIGGER
        COUNT = $01a0
        ITEM_SIZE = 5
        BASE_PTR = EventTriggerPtrs
.endenum

.scope EventTrigger
        Pos := EventTriggerPtrs
        PosX := EventTriggerPtrs
        PosY := EventTriggerPtrs + 1
        EventPtr := EventTriggerPtrs + 2
.endscope

; ------------------------------------------------------------------------------

.endif
