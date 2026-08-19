.list off
.ifndef TREASURE_PROP_INC
TREASURE_PROP_INC = 1

.global TreasureProp, TreasurePropPtrs

.scope TreasureProp

        Pos := TreasureProp
        PosX := TreasureProp
        PosY := TreasureProp + 1
        Switch := TreasureProp + 2
        Contents := TreasureProp + 4

.endscope

.scope TREASURE_PROP

        TRIGGER_SIZE = 5
        .include "assets/data/field/treasure_prop.ptr"

.endscope

.endif
.list on
