.list off
.ifndef TREASURE_PROP_INC
TREASURE_PROP_INC = 1

.global TreasureProp, TreasurePropPtrs

.scope TreasureProp

        ITEM_SIZE = 5
        Start := TreasureProp

        Pos := Start
        PosX := Start
        PosY := Start + 1
        Switch := Start + 2
        Content := Start + 4

; ##############################################################################
; ###          AUTOMATICALLY GENERATED CODE, DO NOT MODIFY MANUALLY          ###
; ##############################################################################


; ##############################################################################

.endscope

.endif
.list on
