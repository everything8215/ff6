.list off
.ifndef MAP_TILE_PROP_INC
MAP_TILE_PROP_INC = 1

.global MapTileProp, MapTilePropPtrs

.enum MAP_TILE_PROP
        NONE                            ;= $00  ; 0
        FIGARO_CASTLE                   ;= $01  ; 1
        DOMA_CASTLE                     ;= $02  ; 2
        VILLAGE_EXT_1                   ;= $03  ; 3
        TOWN_EXT                        ;= $04  ; 4
        CASTLE_INT                      ;= $05  ; 5
        CAVES                           ;= $06  ; 6
        TOWN_INT                        ;= $07  ; 7
        NARSHE_EXT                      ;= $08  ; 8
        CAVES_FURNITURE                 ;= $09  ; 9
        CASTLE_BASEMENT                 ;= $0a  ; 10
        VILLAGE_EXT_2                   ;= $0b  ; 11
        MOUNTAINS_EXT                   ;= $0c  ; 12
        TRAIN_EXT                       ;= $0d  ; 13
        ZOZO                            ;= $0e  ; 14
        FLOATING_ISLAND                 ;= $0f  ; 15
        MOUNTAINS_INT                   ;= $10  ; 16
        DOCKS                           ;= $11  ; 17
        NARSHE_INTRO                    ;= $12  ; 18
        TRAIN_INT                       ;= $13  ; 19
        IMP_CAMP                        ;= $14  ; 20
        IMP_CASTLE_EXT                  ;= $15  ; 21
        AIRSHIP_EXT                     ;= $16  ; 22
        AIRSHIP_INT                     ;= $17  ; 23
        IMP_CASTLE_INT                  ;= $18  ; 24
        SNOWFIELDS                      ;= $19  ; 25
        FOREST                          ;= $1a  ; 26
        VECTOR                          ;= $1b  ; 27
        RIVER                           ;= $1c  ; 28
        OPERA_HOUSE                     ;= $1d  ; 29
        DESTROYED_TOWN                  ;= $1e  ; 30
        MAGITEK_FACTORY                 ;= $1f  ; 31
        DARILLS_TOMB                    ;= $20  ; 32
        OPERA_LOBBY                     ;= $21  ; 33
        BURNING_BUILDING                ;= $22  ; 34
        SEALED_GATE                     ;= $23  ; 35
        MAGITEK_LAB_1                   ;= $24  ; 36
        MAGITEK_LAB_2                   ;= $25  ; 37
        BEACH                           ;= $26  ; 38
        CYANS_DREAM                     ;= $27  ; 39
        KEFKAS_TOWER_1                  ;= $28  ; 40
        KEFKAS_TOWER_2                  ;= $29  ; 41
.endenum

.scope MapTileProp
        ARRAY_LENGTH = MAP_TILE_PROP::KEFKAS_TOWER_2 + 1
        Start := MapTileProp
.endscope

.endif
.list on
