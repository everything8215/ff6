; ------------------------------------------------------------------------------

.import EventScript_AirshipDeck, EventScript_WorldTent
.import EventScript_AirshipGround, EventScript_EnterPhoenixCave
.import EventScript_EnterKefkasTower, EventScript_EnterGogosLair
.import EventScript_DoomGazeDefeated

; ------------------------------------------------------------------------------

.segment "world_data"

begin_block WorldDataPtrs2, $30

; ee/b260
WorldModDataPtrs:
        .faraddr World1ModData
        .faraddr World2ModData
        .faraddr WorldModDataEnd

; ee/b269
VehicleEvent_00:
        .faraddr EventScript_AirshipDeck - EventScript

VehicleEvent_01:
        .faraddr EventScript_WorldTent - EventScript

VehicleEvent_02:
        .faraddr EventScript_AirshipGround - EventScript

VehicleEvent_03:
        .faraddr EventScript_EnterPhoenixCave - EventScript

VehicleEvent_04:
        .faraddr EventScript_EnterKefkasTower - EventScript

VehicleEvent_05:
        .faraddr EventScript_EnterGogosLair - EventScript

VehicleEvent_06:
        .faraddr EventScript_DoomGazeDefeated - EventScript

end_block WorldDataPtrs2

; ------------------------------------------------------------------------------

.segment "world_sine"
; python code to generate this table for x = [0...270]
; def world_sine(x):
;     x = 2.0 * math.pi * i / 360.0
;     return math.floor(abs(math.sin(x) * 255.0))

; ef/fef1
WorldSineTbl:
        .incbin "world_sine.dat"

; ------------------------------------------------------------------------------
