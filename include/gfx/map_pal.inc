.list off
.ifndef MAP_PAL_INC
MAP_PAL_INC = 1

.global MapPal

.enum MAP_PAL
        FIGARO                          ;= $00  ; 0
        VILLAGE_EXT_1                   ;= $01  ; 1
        DOMA                            ;= $02  ; 2
        TOWN_EXT_1                      ;= $03  ; 3
        DOCKS                           ;= $04  ; 4
        CAVES_1                         ;= $05  ; 5
        CASTLE_INT                      ;= $06  ; 6
        RIVER                           ;= $07  ; 7
        IMP_CAMP                        ;= $08  ; 8
        MOUNTAINS_INT                   ;= $09  ; 9
        TOWN_INT_1                      ;= $0a  ; 10
        OPERA_1                         ;= $0b  ; 11
        NARSHE_EXT                      ;= $0c  ; 12
        SNOWFIELDS                      ;= $0d  ; 13
        TRAIN_EXT                       ;= $0e  ; 14
        TRAIN_INT                       ;= $0f  ; 15
        ZOZO_EXT_1                      ;= $10  ; 16
        VECTOR                          ;= $11  ; 17
        CAVES_2                         ;= $12  ; 18
        FLOATING_ISLAND                 ;= $13  ; 19
        ZOZO_INT                        ;= $14  ; 20
        CAVES_3                         ;= $15  ; 21
        VILLAGE_EXT_3                   ;= $16  ; 22
        MOUNTAINS_EXT_1                 ;= $17  ; 23
        MAGITEK_FACTORY                 ;= $18  ; 24
        AIRSHIP_EXT_1                   ;= $19  ; 25
        AIRSHIP_INT                     ;= $1a  ; 26
        CYANS_DREAM                     ;= $1b  ; 27
        FOREST                          ;= $1c  ; 28
        IMP_CASTLE_EXT                  ;= $1d  ; 29
        BEACH                           ;= $1e  ; 30
        IMP_CASTLE_INT                  ;= $1f  ; 31
        CAVES_4                         ;= $20  ; 32
        SEALED_GATE                     ;= $21  ; 33
        KEFKAS_TOWER_1                  ;= $22  ; 34
        BURNING_BUILDING                ;= $23  ; 35
        TOWN_INT_2                      ;= $24  ; 36
        NARSHE_INT                      ;= $25  ; 37
        VILLAGE_EXT_2                   ;= $26  ; 38
        OPERA_2                         ;= $27  ; 39
        DARILLS_TOMB_1                  ;= $28  ; 40
        TOWN_EXT_2                      ;= $29  ; 41
        ZOZO_EXT_2                      ;= $2a  ; 42
        KEFKAS_TOWER_2                  ;= $2b  ; 43
        CLIFFS                          ;= $2c  ; 44
        AIRSHIP_EXT_2                   ;= $2d  ; 45
        DARILLS_TOMB_2                  ;= $2e  ; 46
        MOUNTAINS_EXT_2                 ;= $2f  ; 47
.endenum

.scope MapPal
        ARRAY_LENGTH = MAP_PAL::MOUNTAINS_EXT_2 + 1
.endscope

.endif
.list on
