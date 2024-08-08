.list off
.ifndef MAP_GFX_INC
MAP_GFX_INC = 1

.global MapGfx, MapGfxPtrs, MapAnimGfx

.enum MAP_GFX
        CASTLE_EXT_1                    ;= $00  ; 0
        CASTLE_EXT_2                    ;= $01  ; 1
        CASTLE_EXT_3                    ;= $02  ; 2
        OPERA_1                         ;= $03  ; 3
        TOWN_EXT_1                      ;= $04  ; 4
        TOWN_EXT_2                      ;= $05  ; 5
        TOWN_EXT_3                      ;= $06  ; 6
        TOWN_EXT_4                      ;= $07  ; 7
        TOWN_EXT_5                      ;= $08  ; 8
        CASTLE_EXT_4                    ;= $09  ; 9
        TOWN_EXT_6                      ;= $0a  ; 10
        TOWN_EXT_7                      ;= $0b  ; 11
        DOCKS_1                         ;= $0c  ; 12
        DOCKS_2                         ;= $0d  ; 13
        CAVES                           ;= $0e  ; 14
        CASTLE_INT_1                    ;= $0f  ; 15
        CASTLE_INT_2                    ;= $10  ; 16
        CASTLE_INT_3                    ;= $11  ; 17
        CASTLE_INT_4                    ;= $12  ; 18
        DOCKS_3                         ;= $13  ; 19
        RIVER                           ;= $14  ; 20
        IMP_CAMP_1                      ;= $15  ; 21
        IMP_CAMP_2                      ;= $16  ; 22
        MOUNTAIN_INT_1                  ;= $17  ; 23
        MOUNTAIN_INT_2                  ;= $18  ; 24
        TOWN_INT_1                      ;= $19  ; 25
        TOWN_INT_2                      ;= $1a  ; 26
        TOWN_INT_3                      ;= $1b  ; 27
        MOUNTAIN_EXT_1                  ;= $1c  ; 28
        MOUNTAIN_EXT_2                  ;= $1d  ; 29
        NARSHE_EXT_1                    ;= $1e  ; 30
        NARSHE_EXT_2                    ;= $1f  ; 31
        NARSHE_EXT_3                    ;= $20  ; 32
        TOWN_EXT_8                      ;= $21  ; 33
        NARSHE_EXT_4                    ;= $22  ; 34
        KEFKAS_TOWER_1                  ;= $23  ; 35
        KEFKAS_TOWER_2                  ;= $24  ; 36
        BURNING_BUILDING                ;= $25  ; 37
        TRAIN_EXT_1                     ;= $26  ; 38
        TRAIN_EXT_2                     ;= $27  ; 39
        TRAIN_EXT_3                     ;= $28  ; 40
        FOREST_1                        ;= $29  ; 41
        TRAIN_INT                       ;= $2a  ; 42
        ZOZO_EXT_1                      ;= $2b  ; 43
        ZOZO_EXT_2                      ;= $2c  ; 44
        VECTOR_EXT                      ;= $2d  ; 45
        DARILLS_TOMB_1                  ;= $2e  ; 46
        MOUNTAINS_PARALLAX_1            ;= $2f  ; 47
        FLOATING_ISLAND_1               ;= $30  ; 48
        FLOATING_ISLAND_2               ;= $31  ; 49
        MOUNTAINS_PARALLAX_2            ;= $32  ; 50
        CASTLE_EXT_5                    ;= $33  ; 51
        TOWN_EXT_9                      ;= $34  ; 52
        WATERFALL_PARALLAX_1            ;= $35  ; 53
        FACTORY_1                       ;= $36  ; 54
        FACTORY_2                       ;= $37  ; 55
        FACTORY_3                       ;= $38  ; 56
        FACTORY_4                       ;= $39  ; 57
        FACTORY_5                       ;= $3a  ; 58
        AIRSHIP_1                       ;= $3b  ; 59
        AIRSHIP_2                       ;= $3c  ; 60
        AIRSHIP_3                       ;= $3d  ; 61
        AIRSHIP_4                       ;= $3e  ; 62
        CYANS_DREAM                     ;= $3f  ; 63
        WATERFALL_PARALLAX_2            ;= $40  ; 64
        FOREST_2                        ;= $41  ; 65
        KEFKAS_TOWER_3                  ;= $42  ; 66
        IMP_CASTLE_EXT_1                ;= $43  ; 67
        IMP_CASTLE_EXT_2                ;= $44  ; 68
        IMP_CASTLE_PARALLAX_1           ;= $45  ; 69
        IMP_CASTLE_PARALLAX_2           ;= $46  ; 70
        BEACH                           ;= $47  ; 71
        IMP_CASTLE_INT                  ;= $48  ; 72
        OPERA_2                         ;= $49  ; 73
        TRAIN_PARALLAX                  ;= $4a  ; 74
        SEALED_GATE_1                   ;= $4b  ; 75
        SEALED_GATE_2                   ;= $4c  ; 76
        SEALED_GATE_3                   ;= $4d  ; 77
        FACTORY_6                       ;= $4e  ; 78
        AIRSHIP_5                       ;= $4f  ; 79
        BEACH_PARALLAX                  ;= $50  ; 80
        DARILLS_TOMB_2                  ;= $51  ; 81
.endenum

.scope MapGfx
        ARRAY_LENGTH = MAP_GFX::DARILLS_TOMB_2 + 1
        Start := MapGfx
.endscope

.endif
.list on
