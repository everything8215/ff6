.list off
.ifndef MAP_TILESET_INC
MAP_TILESET_INC = 1

.global MapTileset, MapTilesetPtrs

.enum MAP_TILESET
        FIGARO_CASTLE                   ;= $00 ; 0
        VILLAGE_EXT_1_BG1               ;= $01 ; 1
        VILLAGE_EXT_1_BG2               ;= $02 ; 2
        DOMA_CASTLE_BG1                 ;= $03 ; 3
        DOMA_CASTLE_BG2                 ;= $04 ; 4
        TOWN_EXT_BG1                    ;= $05 ; 5
        TOWN_EXT_BG2                    ;= $06 ; 6
        DOCKS_BG1                       ;= $07 ; 7
        DOCKS_BG2                       ;= $08 ; 8
        CAVES_BG1                       ;= $09 ; 9
        CASTLE_INT_BG1                  ;= $0a ; 10
        CASTLE_INT_BG2                  ;= $0b ; 11
        RIVER                           ;= $0c ; 12
        IMP_CAMP_BG1                    ;= $0d ; 13
        IMP_CAMP_BG2                    ;= $0e ; 14
        MOUNTAINS_INT                   ;= $0f ; 15
        TOWN_INT_BG1                    ;= $10 ; 16
        TOWN_INT_BG2                    ;= $11 ; 17
        MOUNTAINS_EXT_BG1               ;= $12 ; 18
        NARSHE_EXT_BG1                  ;= $13 ; 19
        NARSHE_EXT_BG2                  ;= $14 ; 20
        DESTROYED_TOWN_BG1              ;= $15 ; 21
        DESTROYED_TOWN_BG2              ;= $16 ; 22
        SNOWFIELDS                      ;= $17 ; 23
        TRAIN_EXT_BG1                   ;= $18 ; 24
        TRAIN_INT_BG1                   ;= $19 ; 25
        TRAIN_INT_BG2                   ;= $1a ; 26
        ZOZO_BG1                        ;= $1b ; 27
        ZOZO_BG2                        ;= $1c ; 28
        VECTOR_BG1                      ;= $1d ; 29
        VECTOR_BG2                      ;= $1e ; 30
        CASTLE_BASEMENT_BG1             ;= $1f ; 31
        CASTLE_BASEMENT_BG2             ;= $20 ; 32
        CAVES_FURNITURE                 ;= $21 ; 33
        MAGITEK_LAB_1_BG1               ;= $22 ; 34
        FLOATING_ISLAND_BG1             ;= $23 ; 35
        FLOATING_ISLAND_BG2             ;= $24 ; 36
        MOUNTAINS_PARALLAX              ;= $25 ; 37
        NARSHE_CAVES_BG2                ;= $26 ; 38
        VILLAGE_EXT_2_BG1               ;= $27 ; 39
        VILLAGE_EXT_2_BG2               ;= $28 ; 40
        KEFKAS_TOWER_BG2                ;= $29 ; 41
        WATERFALL_SKY_PARALLAX          ;= $2a ; 42
        KEFKAS_TOWER_BG1                ;= $2b ; 43
        MOUNTAINS_EXT_BG2               ;= $2c ; 44
        TRAIN_EXT_BG2                   ;= $2d ; 45
        CAVES_BG2                       ;= $2e ; 46
        MAGITEK_FACTORY_BG1             ;= $2f ; 47
        MAGITEK_FACTORY_BG2             ;= $30 ; 48
        NARSHE_CLIFFS_PARALLAX          ;= $31 ; 49
        AIRSHIP_EXT_BG1                 ;= $32 ; 50
        AIRSHIP_EXT_BG2                 ;= $33 ; 51
        AIRSHIP_INT                     ;= $34 ; 52
        NARSHE_INTRO_BG1                ;= $35 ; 53
        CYANS_DREAM                     ;= $36 ; 54
        FOREST_BG1                      ;= $37 ; 55
        FOREST_BG2                      ;= $38 ; 56
        IMP_CASTLE_EXT_BG1              ;= $39 ; 57
        IMP_CASTLE_EXT_1_BG2            ;= $3a ; 58
        IMP_CASTLE_EXT_2_BG2            ;= $3b ; 59
        BEACH                           ;= $3c ; 60
        IMP_CASTLE_INT_BG1              ;= $3d ; 61
        IMP_CASTLE_INT_BG2              ;= $3e ; 62
        MAGITEK_LAB_2_BG1               ;= $3f ; 63
        CAVES_LAVA_BG2                  ;= $40 ; 64
        SEALED_GATE_BG1                 ;= $41 ; 65
        SEALED_GATE_BG2                 ;= $42 ; 66
        MAGITEK_LAB_BG2                 ;= $43 ; 67
        KEFKAS_TOWER_PARALLAX           ;= $44 ; 68
        MAP_TILESET_69                  ;= $45 ; 69
        BURNING_BUILDING                ;= $46 ; 70
        OPERA_HOUSE_BG1                 ;= $47 ; 71
        OPERA_HOUSE_BG2                 ;= $48 ; 72
        DARILLS_TOMB_BG1                ;= $49 ; 73
        DARILLS_TOMB_BG2                ;= $4a ; 74
.endenum

.scope MapTileset
        ARRAY_LENGTH = MAP_TILESET::DARILLS_TOMB_BG2 + 1
        Start := MapTileset
.endscope

.endif
.list on
