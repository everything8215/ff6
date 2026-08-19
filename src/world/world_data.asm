
; ------------------------------------------------------------------------------

.segment "world_data"

        fixed_block $30

; ee/b260
WorldModDataPtrs:
        ptr_tbl_far WORLD_MOD
        end_ptr_far WORLD_MOD

; ee/b269
VehicleEvent_00:
        .faraddr EventScript::AirshipDeck - EventScript

VehicleEvent_01:
        .faraddr EventScript::WorldTent - EventScript

VehicleEvent_02:
        .faraddr EventScript::AirshipGround - EventScript

VehicleEvent_03:
        .faraddr EventScript::EnterPhoenixCave - EventScript

VehicleEvent_04:
        .faraddr EventScript::EnterKefkasTower - EventScript

VehicleEvent_05:
        .faraddr EventScript::EnterGogosLair - EventScript

VehicleEvent_06:
        .faraddr EventScript::DoomGazeDefeated - EventScript

        end_fixed_block

; ------------------------------------------------------------------------------

.segment "world_sine"
; python code to generate this table for x = [0...270]
; def world_sine(x):
;     x = 2.0 * math.pi * i / 360.0
;     return math.floor(abs(math.sin(x) * 255.0))

; ef/fef1
WorldSineTbl:
        .byte   $00,$04,$08,$0d,$11,$16,$1a,$1f,$23,$27,$2c,$30,$35,$39,$3d,$41
        .byte   $46,$4a,$4e,$53,$57,$5b,$5f,$63,$67,$6b,$6f,$73,$77,$7b,$7f,$83
        .byte   $87,$8a,$8e,$92,$95,$99,$9c,$a0,$a3,$a7,$aa,$ad,$b1,$b4,$b7,$ba
        .byte   $bd,$c0,$c3,$c6,$c8,$cb,$ce,$d0,$d3,$d5,$d8,$da,$dc,$df,$e1,$e3
        .byte   $e5,$e7,$e8,$ea,$ec,$ee,$ef,$f1,$f2,$f3,$f5,$f6,$f7,$f8,$f9,$fa
        .byte   $fb,$fb,$fc,$fd,$fd,$fe,$fe,$fe,$fe,$fe,$ff,$fe,$fe,$fe,$fe,$fe
        .byte   $fd,$fd,$fc,$fb,$fb,$fa,$f9,$f8,$f7,$f6,$f5,$f3,$f2,$f1,$ef,$ee
        .byte   $ec,$ea,$e8,$e7,$e5,$e3,$e1,$df,$dc,$da,$d8,$d5,$d3,$d0,$ce,$cb
        .byte   $c8,$c6,$c3,$c0,$bd,$ba,$b7,$b4,$b1,$ad,$aa,$a7,$a3,$a0,$9c,$99
        .byte   $95,$92,$8e,$8a,$87,$83,$7f,$7b,$77,$73,$6f,$6b,$67,$63,$5f,$5b
        .byte   $57,$53,$4e,$4a,$46,$41,$3d,$39,$35,$30,$2c,$27,$23,$1f,$1a,$16
        .byte   $11,$0d,$08,$04,$00,$04,$08,$0d,$11,$16,$1a,$1f,$23,$27,$2c,$30
        .byte   $35,$39,$3d,$41,$46,$4a,$4e,$53,$57,$5b,$5f,$63,$67,$6b,$6f,$73
        .byte   $77,$7b,$7f,$83,$87,$8a,$8e,$92,$95,$99,$9c,$a0,$a3,$a7,$aa,$ad
        .byte   $b1,$b4,$b7,$ba,$bd,$c0,$c3,$c6,$c8,$cb,$ce,$d0,$d3,$d5,$d8,$da
        .byte   $dc,$df,$e1,$e3,$e5,$e7,$e8,$ea,$ec,$ee,$ef,$f1,$f2,$f3,$f5,$f6
        .byte   $f7,$f8,$f9,$fa,$fb,$fb,$fc,$fd,$fd,$fe,$fe,$fe,$fe,$fe,$ff

; ------------------------------------------------------------------------------
