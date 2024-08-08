.list off
.ifndef BATTLE_BG_INC
BATTLE_BG_INC = 1

; ------------------------------------------------------------------------------

.global BattleBGProp, BattleBGPal, BattleBGTiles, BattleBGTilesPtrs
.global BattleBGGfx, BattleBGGfxPtrs

; ------------------------------------------------------------------------------

.enum BATTLE_BG
        FIELD_WOB                       ;= $00  ; 0
        FOREST_WOR                      ;= $01  ; 1
        DESERT_WOB                      ;= $02  ; 2
        FOREST_WOB                      ;= $03  ; 3
        ZOZO_INT                        ;= $04  ; 4
        FIELD_WOR                       ;= $05  ; 5
        VELDT                           ;= $06  ; 6
        CLOUDS                          ;= $07  ; 7
        NARSHE_EXT                      ;= $08  ; 8
        NARSHE_CAVES_1                  ;= $09  ; 9
        CAVES                           ;= $0a  ; 10
        MOUNTAINS_EXT                   ;= $0b  ; 11
        MOUNTAINS_INT                   ;= $0c  ; 12
        RIVER                           ;= $0d  ; 13
        IMP_CAMP                        ;= $0e  ; 14
        TRAIN_EXT                       ;= $0f  ; 15
        TRAIN_INT                       ;= $10  ; 16
        NARSHE_CAVES_2                  ;= $11  ; 17
        SNOWFIELDS                      ;= $12  ; 18
        TOWN_EXT                        ;= $13  ; 19
        IMP_CASTLE                      ;= $14  ; 20
        FLOATING_ISLAND                 ;= $15  ; 21
        KEFKAS_TOWER_EXT                ;= $16  ; 22
        OPERA_STAGE                     ;= $17  ; 23
        OPERA_CATWALK                   ;= $18  ; 24
        BURNING_BUILDING                ;= $19  ; 25
        CASTLE_INT                      ;= $1a  ; 26
        MAGITEK_LAB                     ;= $1b  ; 27
        COLOSSEUM                       ;= $1c  ; 28
        MAGITEK_FACTORY                 ;= $1d  ; 29
        VILLAGE_EXT                     ;= $1e  ; 30
        WATERFALL                       ;= $1f  ; 31
        OWZERS_HOUSE                    ;= $20  ; 32
        TRAIN_TRACKS                    ;= $21  ; 33
        SEALED_GATE                     ;= $22  ; 34
        UNDERWATER                      ;= $23  ; 35
        ZOZO                            ;= $24  ; 36
        AIRSHIP_CENTER                  ;= $25  ; 37
        DARILLS_TOMB                    ;= $26  ; 38
        CASTLE_EXT                      ;= $27  ; 39
        KEFKAS_TOWER_INT                ;= $28  ; 40
        AIRSHIP_WOR                     ;= $29  ; 41
        FIRE_CAVES                      ;= $2a  ; 42
        TOWN_INT                        ;= $2b  ; 43
        MAGITEK_TRAIN                   ;= $2c  ; 44
        FANATICS_TOWER                  ;= $2d  ; 45
        CYANS_DREAM                     ;= $2e  ; 46
        DESERT_WOR                      ;= $2f  ; 47
        AIRSHIP_WOB                     ;= $30  ; 48
        BATTLE_BG_31                    ;= $31  ; 49 (unused)
        GHOST_TRAIN                     ;= $32  ; 50
        FINAL_BATTLE_1                  ;= $33  ; 51
        FINAL_BATTLE_2                  ;= $34  ; 52
        FINAL_BATTLE_3                  ;= $35  ; 53
        FINAL_BATTLE_4                  ;= $36  ; 54
        TENTACLES                       ;= $37  ; 55

        DEFAULT = $ff
.endenum

.scope BattleBG
        ARRAY_LENGTH = BATTLE_BG::TENTACLES + 1
.endscope

; ------------------------------------------------------------------------------

; lines marked with (*) use map bg graphics

.enum BATTLE_BG_GFX
        TOWN_EXT_1                      ;= $00  ; 0
        TOWN_EXT_2                      ;= $01  ; 1
        BATTLE_BG_GFX_2                 ;= $02  ; 2 (unused copy of #9)
        MOUNTAINS_EXT_1                 ;= $03  ; 3
        MOUNTAINS_INT_1                 ;= $04  ; 4
        RIVER_1                         ;= $05  ; 5
        IMP_CAMP_1                      ;= $06  ; 6
        TRAIN_EXT_1                     ;= $07  ; 7
        TRAIN_INT_1                     ;= $08  ; 8
        CAVES_1                         ;= $09  ; 9
        TRAIN_EXT_2                     ;= $0a  ; 10 (*)
        MOUNTAINS_EXT_2                 ;= $0b  ; 11 (*)
        MOUNTAINS_INT_2                 ;= $0c  ; 12 (*)
        RIVER_2                         ;= $0d  ; 13 (*)
        IMP_CAMP_2                      ;= $0e  ; 14 (*)
        GHOST_TRAIN_1                   ;= $0f  ; 15 (*)
        TRAIN_INT_2                     ;= $10  ; 16 (*)
        CAVES_2                         ;= $11  ; 17 (*)
        FIELD_1                         ;= $12  ; 18
        FIELD_2                         ;= $13  ; 19
        FIELD_3                         ;= $14  ; 20
        TRAIN_EXT_3                     ;= $15  ; 21 (*)
        COLOSSEUM                       ;= $16  ; 22
        BATTLE_BG_GFX_23                ;= $17  ; 23 (unused)
        DESERT_1                        ;= $18  ; 24
        FOREST_1                        ;= $19  ; 25
        FOREST_2                        ;= $1a  ; 26 (*)
        FIELD_WOR                       ;= $1b  ; 27
        VELDT                           ;= $1c  ; 28
        DESERT_2                        ;= $1d  ; 29
        IMP_CASTLE_1                    ;= $1e  ; 30
        FLOATING_ISLAND_1               ;= $1f  ; 31
        KEFKAS_TOWER_1                  ;= $20  ; 32
        OPERA_STAGE                     ;= $21  ; 33
        OPERA_CATWALK                   ;= $22  ; 34
        BURNING_BLDG_1                  ;= $23  ; 35
        CASTLE_INT                      ;= $24  ; 36
        MAGITEK_1                       ;= $25  ; 37
        CASTLE_EXT_1                    ;= $26  ; 38
        MAGITEK_2                       ;= $27  ; 39 (*)
        IMP_CASTLE_2                    ;= $28  ; 40 (*)
        FLOATING_ISLAND_2               ;= $29  ; 41 (*)
        KEFKAS_TOWER_2                  ;= $2a  ; 42 (*)
        OPERA_CURTAIN                   ;= $2b  ; 43 (*)
        BURNING_BLDG_2                  ;= $2c  ; 44 (*)
        TENTACLES                       ;= $2d  ; 45
        CASTLE_EXT_2                    ;= $2e  ; 46 (*)
        TOWN_INT_1                      ;= $2f  ; 47
        TOWN_INT_2                      ;= $30  ; 48 (*)
        GHOST_TRAIN_2                   ;= $31  ; 49 (*)
        UNDERWATER                      ;= $32  ; 50
        SEALED_GATE_1                   ;= $33  ; 51 (*)
        SEALED_GATE_2                   ;= $34  ; 52
        ZOZO_1                          ;= $35  ; 53 (*)
        ZOZO_2                          ;= $36  ; 54
        CLOUDS_1                        ;= $37  ; 55 (*)
        CLOUDS_2                        ;= $38  ; 56 (*)
        AIRSHIP                         ;= $39  ; 57
        DARILLS_TOMB_1                  ;= $3a  ; 58 (*)
        DARILLS_TOMB_2                  ;= $3b  ; 59
        WATERFALL                       ;= $3c  ; 60
        FINAL_BATTLE_1                  ;= $3d  ; 61
        FINAL_BATTLE_2                  ;= $3e  ; 62
        FINAL_BATTLE_3                  ;= $3f  ; 63
        FINAL_BATTLE_4                  ;= $40  ; 64
        FINAL_BATTLE_5                  ;= $41  ; 65
        FINAL_BATTLE_6                  ;= $42  ; 66
        FINAL_BATTLE_7                  ;= $43  ; 67
        FINAL_BATTLE_8                  ;= $44  ; 68
        FANATICS_TOWER                  ;= $45  ; 69
        MAGITEK_TRAIN_1                 ;= $46  ; 70
        MAGITEK_TRAIN_2                 ;= $47  ; 71 (*)
        DARILLS_TOMB_3                  ;= $48  ; 72 (*)
        CYANS_DREAM_1                   ;= $49  ; 73 (*)
        CYANS_DREAM_2                   ;= $4a  ; 74

        NONE = $ff
.endenum

.scope BattleBGGfx
        ARRAY_LENGTH = BATTLE_BG_GFX::CYANS_DREAM_2 + 1
.endscope

; ------------------------------------------------------------------------------

.enum BATTLE_BG_TILES
        FIELD_WOB                       ;= $00  ; 0
        NARSHE_EXT                      ;= $01  ; 1
        NARSHE_CAVES                    ;= $02  ; 2
        CAVES                           ;= $03  ; 3
        MOUNTAINS_EXT                   ;= $04  ; 4
        MOUNTAINS_INT                   ;= $05  ; 5
        RIVER                           ;= $06  ; 6
        IMP_CAMP                        ;= $07  ; 7
        TRAIN_EXT                       ;= $08  ; 8
        TRAIN_INT                       ;= $09  ; 9
        FANATICS_TOWER                  ;= $0a  ; 10
        DESERT                          ;= $0b  ; 11
        FOREST                          ;= $0c  ; 12
        FIELD_WOR                       ;= $0d  ; 13
        VELDT                           ;= $0e  ; 14
        SNOWFIELDS                      ;= $0f  ; 15
        TOWN_EXT                        ;= $10  ; 16
        IMP_CASTLE                      ;= $11  ; 17
        FLOATING_ISLAND                 ;= $12  ; 18
        KEFKAS_TOWER_EXT                ;= $13  ; 19
        OPERA_STAGE                     ;= $14  ; 20
        OPERA_CATWALK                   ;= $15  ; 21
        BURNING_BUILDING                ;= $16  ; 22
        CASTLE_INT                      ;= $17  ; 23
        MAGITEK_LAB                     ;= $18  ; 24
        COLOSSEUM                       ;= $19  ; 25
        SEALED_GATE                     ;= $1a  ; 26
        VILLAGE_EXT                     ;= $1b  ; 27
        WATERFALL                       ;= $1c  ; 28
        OWZERS_HOUSE                    ;= $1d  ; 29
        TRAIN_TRACKS                    ;= $1e  ; 30
        CLOUDS                          ;= $1f  ; 31
        TENTACLES                       ;= $20  ; 32
        TOWN_INT                        ;= $21  ; 33
        GHOST_TRAIN                     ;= $22  ; 34
        UNDERWATER                      ;= $23  ; 35
        MAGITEK_FACTORY                 ;= $24  ; 36
        ZOZO                            ;= $25  ; 37
        AIRSHIP_CENTER                  ;= $26  ; 38
        DARILLS_TOMB                    ;= $27  ; 39
        CASTLE_EXT                      ;= $28  ; 40
        KEFKAS_TOWER_INT                ;= $29  ; 41
        FINAL_BATTLE_1                  ;= $2a  ; 42
        FINAL_BATTLE_2                  ;= $2b  ; 43
        FINAL_BATTLE_3                  ;= $2c  ; 44
        MAGITEK_TRAIN                   ;= $2d  ; 45
        FINAL_BATTLE_4                  ;= $2e  ; 46
        CYANS_DREAM                     ;= $2f  ; 47
        AIRSHIP                         ;= $30  ; 48
.endenum

.scope BattleBGTiles
        ARRAY_LENGTH = BATTLE_BG_TILES::AIRSHIP + 1
.endscope

; ------------------------------------------------------------------------------

; battle background palettes
.enum BATTLE_BG_PAL
        FIELD_WOB                       ;= $00  ; 0
        NARSHE_EXT                      ;= $01  ; 1
        NARSHE_CAVES                    ;= $02  ; 2
        CAVES                           ;= $03  ; 3
        MOUNTAINS_EXT                   ;= $04  ; 4
        MOUNTAINS_INT                   ;= $05  ; 5
        RIVER                           ;= $06  ; 6
        IMP_CAMP                        ;= $07  ; 7
        TRAIN_EXT                       ;= $08  ; 8
        TRAIN_INT                       ;= $09  ; 9
        FANATICS_TOWER                  ;= $0a  ; 10
        DESERT_WOB                      ;= $0b  ; 11
        FOREST_WOB                      ;= $0c  ; 12
        FIELD_WOR                       ;= $0d  ; 13
        VELDT                           ;= $0e  ; 14
        SNOWFIELDS                      ;= $0f  ; 15
        TOWN_EXT                        ;= $10  ; 16
        IMP_CASTLE                      ;= $11  ; 17
        FLOATING_ISLAND                 ;= $12  ; 18
        KEFKAS_TOWER_EXT                ;= $13  ; 19
        OPERA_STAGE                     ;= $14  ; 20
        OPERA_CATWALK                   ;= $15  ; 21
        BURNING_BUILDING                ;= $16  ; 22
        CASTLE_INT                      ;= $17  ; 23
        MAGITEK                         ;= $18  ; 24
        COLOSSEUM                       ;= $19  ; 25
        SEALED_GATE                     ;= $1a  ; 26
        VILLAGE_EXT                     ;= $1b  ; 27
        WATERFALL                       ;= $1c  ; 28
        BATTLE_BG_PAL_29                ;= $1d  ; 29 (unused)
        TRAIN_TRACKS                    ;= $1e  ; 30
        BATTLE_BG_PAL_31                ;= $1f  ; 31 (unused)
        TENTACLES                       ;= $20  ; 32
        FIRE_CAVES                      ;= $21  ; 33
        TOWN_INT                        ;= $22  ; 34
        ZOZO_INT                        ;= $23  ; 35
        UNDERWATER                      ;= $24  ; 36
        ZOZO_EXT                        ;= $25  ; 37
        AIRSHIP_WOB                     ;= $26  ; 38
        DARILLS_TOMB                    ;= $27  ; 39
        CASTLE_EXT                      ;= $28  ; 40
        KEFKAS_TOWER_INT                ;= $29  ; 41
        BATTLE_BG_PAL_42                ;= $2a  ; 42 (unused)
        OWZERS_HOUSE                    ;= $2b  ; 43
        FINAL_BATTLE_1                  ;= $2c  ; 44
        FINAL_BATTLE_2                  ;= $2d  ; 45
        FINAL_BATTLE_3                  ;= $2e  ; 46
        MAGITEK_TRAIN                   ;= $2f  ; 47
        FINAL_BATTLE_4                  ;= $30  ; 48
        FOREST_WOR                      ;= $31  ; 49
        CYANS_DREAM                     ;= $32  ; 50
        AIRSHIP_WOR                     ;= $33  ; 51
        DESERT_WOR                      ;= $34  ; 52
.endenum

.scope BattleBGPal
        ARRAY_LENGTH = BATTLE_BG_PAL::DESERT_WOR + 1
.endscope

; ------------------------------------------------------------------------------

.endif
.list on
