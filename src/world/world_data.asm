; ------------------------------------------------------------------------------

.segment "world_data"

begin_fixed_block WorldDataPtrs2, $30

; ee/b260
WorldModDataPtrs:
        .faraddr World1ModData
        .faraddr World2ModData
        .faraddr WorldModDataEnd

; ee/b269
VehicleEvent_00:
        .faraddr $000068

VehicleEvent_01:
        .faraddr $00004f

VehicleEvent_02:
        .faraddr $000059

VehicleEvent_03:
        .faraddr $000088

VehicleEvent_04:
        .faraddr $00007f

VehicleEvent_05:
        .faraddr $00008f

VehicleEvent_06:
        .faraddr $000096

end_fixed_block WorldDataPtrs2

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
