.list off
.ifndef OVERLAY_PROP_INC
OVERLAY_PROP_INC = 1

.global OverlayProp, OverlayPropPtrs

.enum OVERLAY_PROP
        NONE                            ;= $00  ; 0
        TOWN_EXT                        ;= $01  ; 1
        CAVES                           ;= $02  ; 2
        TOWN_INT                        ;= $03  ; 3
        NARSHE_EXT                      ;= $04  ; 4
        CAVES_FURNITURE                 ;= $05  ; 5
        MOUNTAINS_EXT_1                 ;= $06  ; 6
        TRAIN_EXT                       ;= $07  ; 7
        ZOZO_EXT                        ;= $08  ; 8
        TRAIN_INT                       ;= $09  ; 9
        IMP_CAMP                        ;= $0a  ; 10
        FOREST                          ;= $0b  ; 11
        OPERA_HOUSE                     ;= $0c  ; 12
        DESTROYED_TOWN                  ;= $0d  ; 13
        MAGITEK_FACTORY                 ;= $0e  ; 14
        FIGARO_CASTLE_EXT               ;= $0f  ; 15
        DOMA_EXT                        ;= $10  ; 16
        VILLAGE_EXT_1                   ;= $11  ; 17
        CASTLE_INT                      ;= $12  ; 18
        CASTLE_BASEMENT                 ;= $13  ; 19
        VILLAGE_EXT_2                   ;= $14  ; 20
        FLOATING_ISLAND                 ;= $15  ; 21
        AIRSHIP_EXT                     ;= $16  ; 22
        AIRSHIP_INT                     ;= $17  ; 23
        IMP_CASTLE_INT                  ;= $18  ; 24
        VECTOR_EXT                      ;= $19  ; 25
        OVERLAY_26                      ;= $1a  ; 26
        MOUNTAINS_INT                   ;= $1b  ; 27
        IMP_CASTLE_EXT                  ;= $1c  ; 28
        MAGITEK_LAB                     ;= $1d  ; 29
        DARILLS_TOMB                    ;= $1e  ; 30
        KEFKAS_TOWER                    ;= $1f  ; 31
        OVERLAY_32                      ;= $20  ; 32
        MOUNTAINS_EXT_2                 ;= $21  ; 33
        SNOWFIELDS                      ;= $22  ; 34
        OVERLAY_35                      ;= $23  ; 35 (unused)
        OVERLAY_36                      ;= $24  ; 36 (unused)
        OVERLAY_37                      ;= $25  ; 37 (unused)
        OVERLAY_38                      ;= $26  ; 38 (unused)
        OVERLAY_39                      ;= $27  ; 39 (unused)
        OVERLAY_40                      ;= $28  ; 40 (unused)
        OVERLAY_41                      ;= $29  ; 41 (unused)
        OVERLAY_42                      ;= $2a  ; 42 (unused)
        OVERLAY_43                      ;= $2b  ; 43 (unused)
        OVERLAY_44                      ;= $2c  ; 44 (unused)
.endenum

OVERLAY_PROP::ARRAY_LENGTH               = $2d  ; 45

.endif
.list on
