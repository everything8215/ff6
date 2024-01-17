.list off
.ifndef BATTLE_BG_INC
BATTLE_BG_INC = 1

; ------------------------------------------------------------------------------

.global BattleBGProp, BattleBGPal, BattleBGTiles, BattleBGTilesPtrs
.global BattleBGGfx, BattleBGGfxPtrs

; ------------------------------------------------------------------------------

BATTLE_BG_FIELD_WOB                     = $00  ; 0
BATTLE_BG_FOREST_WOR                    = $01  ; 1
BATTLE_BG_DESERT_WOB                    = $02  ; 2
BATTLE_BG_FOREST_WOB                    = $03  ; 3
BATTLE_BG_ZOZO_INT                      = $04  ; 4
BATTLE_BG_FIELD_WOR                     = $05  ; 5
BATTLE_BG_VELDT                         = $06  ; 6
BATTLE_BG_CLOUDS                        = $07  ; 7
BATTLE_BG_NARSHE_EXT                    = $08  ; 8
BATTLE_BG_NARSHE_CAVES_1                = $09  ; 9
BATTLE_BG_CAVES                         = $0a  ; 10
BATTLE_BG_MOUNTAINS_EXT                 = $0b  ; 11
BATTLE_BG_MOUNTAINS_INT                 = $0c  ; 12
BATTLE_BG_RIVER                         = $0d  ; 13
BATTLE_BG_IMP_CAMP                      = $0e  ; 14
BATTLE_BG_TRAIN_EXT                     = $0f  ; 15
BATTLE_BG_TRAIN_INT                     = $10  ; 16
BATTLE_BG_NARSHE_CAVES_2                = $11  ; 17
BATTLE_BG_SNOWFIELDS                    = $12  ; 18
BATTLE_BG_TOWN_EXT                      = $13  ; 19
BATTLE_BG_IMP_CASTLE                    = $14  ; 20
BATTLE_BG_FLOATING_ISLAND               = $15  ; 21
BATTLE_BG_KEFKAS_TOWER_EXT              = $16  ; 22
BATTLE_BG_OPERA_STAGE                   = $17  ; 23
BATTLE_BG_OPERA_CATWALK                 = $18  ; 24
BATTLE_BG_BURNING_BUILDING              = $19  ; 25
BATTLE_BG_CASTLE_INT                    = $1a  ; 26
BATTLE_BG_MAGITEK_LAB                   = $1b  ; 27
BATTLE_BG_COLOSSEUM                     = $1c  ; 28
BATTLE_BG_MAGITEK_FACTORY               = $1d  ; 29
BATTLE_BG_VILLAGE_EXT                   = $1e  ; 30
BATTLE_BG_WATERFALL                     = $1f  ; 31
BATTLE_BG_OWZERS_HOUSE                  = $20  ; 32
BATTLE_BG_TRAIN_TRACKS                  = $21  ; 33
BATTLE_BG_SEALED_GATE                   = $22  ; 34
BATTLE_BG_UNDERWATER                    = $23  ; 35
BATTLE_BG_ZOZO                          = $24  ; 36
BATTLE_BG_AIRSHIP_CENTER                = $25  ; 37
BATTLE_BG_DARILLS_TOMB                  = $26  ; 38
BATTLE_BG_CASTLE_EXT                    = $27  ; 39
BATTLE_BG_KEFKAS_TOWER_INT              = $28  ; 40
BATTLE_BG_AIRSHIP_WOR                   = $29  ; 41
BATTLE_BG_FIRE_CAVES                    = $2a  ; 42
BATTLE_BG_TOWN_INT                      = $2b  ; 43
BATTLE_BG_MAGITEK_TRAIN                 = $2c  ; 44
BATTLE_BG_FANATICS_TOWER                = $2d  ; 45
BATTLE_BG_CYANS_DREAM                   = $2e  ; 46
BATTLE_BG_DESERT_WOR                    = $2f  ; 47
BATTLE_BG_AIRSHIP_WOB                   = $30  ; 48
BATTLE_BG_31                            = $31  ; 49 (unused)
BATTLE_BG_GHOST_TRAIN                   = $32  ; 50
BATTLE_BG_FINAL_BATTLE_1                = $33  ; 51
BATTLE_BG_FINAL_BATTLE_2                = $34  ; 52
BATTLE_BG_FINAL_BATTLE_3                = $35  ; 53
BATTLE_BG_FINAL_BATTLE_4                = $36  ; 54
BATTLE_BG_TENTACLES                     = $37  ; 55

BATTLE_BG_ARRAY_LENGTH                  = $38  ; 56

BATTLE_BG_DEFAULT                       = $ff  ; 255

; ------------------------------------------------------------------------------

; lines marked with (*) use map bg graphics

BATTLE_BG_GFX_TOWN_EXT_1                = $00  ; 0
BATTLE_BG_GFX_TOWN_EXT_2                = $01  ; 1
BATTLE_BG_GFX_02                        = $02  ; 2 (unused copy of $09)
BATTLE_BG_GFX_MOUNTAINS_EXT_1           = $03  ; 3
BATTLE_BG_GFX_MOUNTAINS_INT_1           = $04  ; 4
BATTLE_BG_GFX_RIVER_1                   = $05  ; 5
BATTLE_BG_GFX_IMP_CAMP_1                = $06  ; 6
BATTLE_BG_GFX_TRAIN_EXT_1               = $07  ; 7
BATTLE_BG_GFX_TRAIN_INT_1               = $08  ; 8
BATTLE_BG_GFX_CAVES_1                   = $09  ; 9
BATTLE_BG_GFX_TRAIN_EXT_2               = $0a  ; 10 (*)
BATTLE_BG_GFX_MOUNTAINS_EXT_2           = $0b  ; 11 (*)
BATTLE_BG_GFX_MOUNTAINS_INT_2           = $0c  ; 12 (*)
BATTLE_BG_GFX_RIVER_2                   = $0d  ; 13 (*)
BATTLE_BG_GFX_IMP_CAMP_2                = $0e  ; 14 (*)
BATTLE_BG_GFX_GHOST_TRAIN_1             = $0f  ; 15 (*)
BATTLE_BG_GFX_TRAIN_INT_2               = $10  ; 16 (*)
BATTLE_BG_GFX_CAVES_2                   = $11  ; 17 (*)
BATTLE_BG_GFX_FIELD_1                   = $12  ; 18
BATTLE_BG_GFX_FIELD_2                   = $13  ; 19
BATTLE_BG_GFX_FIELD_3                   = $14  ; 20
BATTLE_BG_GFX_TRAIN_EXT_3               = $15  ; 21 (*)
BATTLE_BG_GFX_COLOSSEUM                 = $16  ; 22
BATTLE_BG_GFX_17                        = $17  ; 23 (unused)
BATTLE_BG_GFX_DESERT_1                  = $18  ; 24
BATTLE_BG_GFX_FOREST_1                  = $19  ; 25
BATTLE_BG_GFX_FOREST_2                  = $1a  ; 26 (*)
BATTLE_BG_GFX_FIELD_WOR                 = $1b  ; 27
BATTLE_BG_GFX_VELDT                     = $1c  ; 28
BATTLE_BG_GFX_DESERT_2                  = $1d  ; 29
BATTLE_BG_GFX_IMP_CASTLE_1              = $1e  ; 30
BATTLE_BG_GFX_FLOATING_ISLAND_1         = $1f  ; 31
BATTLE_BG_GFX_KEFKAS_TOWER_1            = $20  ; 32
BATTLE_BG_GFX_OPERA_STAGE               = $21  ; 33
BATTLE_BG_GFX_OPERA_CATWALK             = $22  ; 34
BATTLE_BG_GFX_BURNING_BLDG_1            = $23  ; 35
BATTLE_BG_GFX_CASTLE_INT                = $24  ; 36
BATTLE_BG_GFX_MAGITEK_1                 = $25  ; 37
BATTLE_BG_GFX_CASTLE_EXT_1              = $26  ; 38
BATTLE_BG_GFX_MAGITEK_2                 = $27  ; 39 (*)
BATTLE_BG_GFX_IMP_CASTLE_2              = $28  ; 40 (*)
BATTLE_BG_GFX_FLOATING_ISLAND_2         = $29  ; 41 (*)
BATTLE_BG_GFX_KEFKAS_TOWER_2            = $2a  ; 42 (*)
BATTLE_BG_GFX_OPERA_CURTAIN             = $2b  ; 43 (*)
BATTLE_BG_GFX_BURNING_BLDG_2            = $2c  ; 44 (*)
BATTLE_BG_GFX_TENTACLES                 = $2d  ; 45
BATTLE_BG_GFX_CASTLE_EXT_2              = $2e  ; 46 (*)
BATTLE_BG_GFX_TOWN_INT_1                = $2f  ; 47
BATTLE_BG_GFX_TOWN_INT_2                = $30  ; 48 (*)
BATTLE_BG_GFX_GHOST_TRAIN_2             = $31  ; 49 (*)
BATTLE_BG_GFX_UNDERWATER                = $32  ; 50
BATTLE_BG_GFX_SEALED_GATE_1             = $33  ; 51 (*)
BATTLE_BG_GFX_SEALED_GATE_2             = $34  ; 52
BATTLE_BG_GFX_ZOZO_1                    = $35  ; 53 (*)
BATTLE_BG_GFX_ZOZO_2                    = $36  ; 54
BATTLE_BG_GFX_CLOUDS_1                  = $37  ; 55 (*)
BATTLE_BG_GFX_CLOUDS_2                  = $38  ; 56 (*)
BATTLE_BG_GFX_AIRSHIP                   = $39  ; 57
BATTLE_BG_GFX_DARILLS_TOMB_1            = $3a  ; 58 (*)
BATTLE_BG_GFX_DARILLS_TOMB_2            = $3b  ; 59
BATTLE_BG_GFX_WATERFALL                 = $3c  ; 60
BATTLE_BG_GFX_FINAL_BATTLE_1            = $3d  ; 61
BATTLE_BG_GFX_FINAL_BATTLE_2            = $3e  ; 62
BATTLE_BG_GFX_FINAL_BATTLE_3            = $3f  ; 63
BATTLE_BG_GFX_FINAL_BATTLE_4            = $40  ; 64
BATTLE_BG_GFX_FINAL_BATTLE_5            = $41  ; 65
BATTLE_BG_GFX_FINAL_BATTLE_6            = $42  ; 66
BATTLE_BG_GFX_FINAL_BATTLE_7            = $43  ; 67
BATTLE_BG_GFX_FINAL_BATTLE_8            = $44  ; 68
BATTLE_BG_GFX_FANATICS_TOWER            = $45  ; 69
BATTLE_BG_GFX_MAGITEK_TRAIN_1           = $46  ; 70
BATTLE_BG_GFX_MAGITEK_TRAIN_2           = $47  ; 71 (*)
BATTLE_BG_GFX_DARILLS_TOMB_3            = $48  ; 72 (*)
BATTLE_BG_GFX_CYANS_DREAM_1             = $49  ; 73 (*)
BATTLE_BG_GFX_CYANS_DREAM_2             = $4a  ; 74

BATTLE_BG_GFX_ARRAY_LENGTH              = $4b  ; 75

BATTLE_BG_GFX_NONE                      = $ff  ; 255

; ------------------------------------------------------------------------------

BATTLE_BG_TILES_FIELD_WOB               = $00  ; 0
BATTLE_BG_TILES_NARSHE_EXT              = $01  ; 1
BATTLE_BG_TILES_NARSHE_CAVES            = $02  ; 2
BATTLE_BG_TILES_CAVES                   = $03  ; 3
BATTLE_BG_TILES_MOUNTAINS_EXT           = $04  ; 4
BATTLE_BG_TILES_MOUNTAINS_INT           = $05  ; 5
BATTLE_BG_TILES_RIVER                   = $06  ; 6
BATTLE_BG_TILES_IMP_CAMP                = $07  ; 7
BATTLE_BG_TILES_TRAIN_EXT               = $08  ; 8
BATTLE_BG_TILES_TRAIN_INT               = $09  ; 9
BATTLE_BG_TILES_FANATICS_TOWER          = $0a  ; 10
BATTLE_BG_TILES_DESERT                  = $0b  ; 11
BATTLE_BG_TILES_FOREST                  = $0c  ; 12
BATTLE_BG_TILES_FIELD_WOR               = $0d  ; 13
BATTLE_BG_TILES_VELDT                   = $0e  ; 14
BATTLE_BG_TILES_SNOWFIELDS              = $0f  ; 15
BATTLE_BG_TILES_TOWN_EXT                = $10  ; 16
BATTLE_BG_TILES_IMP_CASTLE              = $11  ; 17
BATTLE_BG_TILES_FLOATING_ISLAND         = $12  ; 18
BATTLE_BG_TILES_KEFKAS_TOWER_EXT        = $13  ; 19
BATTLE_BG_TILES_OPERA_STAGE             = $14  ; 20
BATTLE_BG_TILES_OPERA_CATWALK           = $15  ; 21
BATTLE_BG_TILES_BURNING_BUILDING        = $16  ; 22
BATTLE_BG_TILES_CASTLE_INT              = $17  ; 23
BATTLE_BG_TILES_MAGITEK_LAB             = $18  ; 24
BATTLE_BG_TILES_COLOSSEUM               = $19  ; 25
BATTLE_BG_TILES_SEALED_GATE             = $1a  ; 26
BATTLE_BG_TILES_VILLAGE_EXT             = $1b  ; 27
BATTLE_BG_TILES_WATERFALL               = $1c  ; 28
BATTLE_BG_TILES_OWZERS_HOUSE            = $1d  ; 29
BATTLE_BG_TILES_TRAIN_TRACKS            = $1e  ; 30
BATTLE_BG_TILES_CLOUDS                  = $1f  ; 31
BATTLE_BG_TILES_TENTACLES               = $20  ; 32
BATTLE_BG_TILES_TOWN_INT                = $21  ; 33
BATTLE_BG_TILES_GHOST_TRAIN             = $22  ; 34
BATTLE_BG_TILES_UNDERWATER              = $23  ; 35
BATTLE_BG_TILES_MAGITEK_FACTORY         = $24  ; 36
BATTLE_BG_TILES_ZOZO                    = $25  ; 37
BATTLE_BG_TILES_AIRSHIP_CENTER          = $26  ; 38
BATTLE_BG_TILES_DARILLS_TOMB            = $27  ; 39
BATTLE_BG_TILES_CASTLE_EXT              = $28  ; 40
BATTLE_BG_TILES_KEFKAS_TOWER_INT        = $29  ; 41
BATTLE_BG_TILES_FINAL_BATTLE_1          = $2a  ; 42
BATTLE_BG_TILES_FINAL_BATTLE_2          = $2b  ; 43
BATTLE_BG_TILES_FINAL_BATTLE_3          = $2c  ; 44
BATTLE_BG_TILES_MAGITEK_TRAIN           = $2d  ; 45
BATTLE_BG_TILES_FINAL_BATTLE_4          = $2e  ; 46
BATTLE_BG_TILES_CYANS_DREAM             = $2f  ; 47
BATTLE_BG_TILES_AIRSHIP                 = $30  ; 48

BATTLE_BG_TILES_ARRAY_LENGTH            = 49

; ------------------------------------------------------------------------------

; battle background palettes
BATTLE_BG_PAL_FIELD_WOB                 = $00  ; 0
BATTLE_BG_PAL_NARSHE_EXT                = $01  ; 1
BATTLE_BG_PAL_NARSHE_CAVES              = $02  ; 2
BATTLE_BG_PAL_CAVES                     = $03  ; 3
BATTLE_BG_PAL_MOUNTAINS_EXT             = $04  ; 4
BATTLE_BG_PAL_MOUNTAINS_INT             = $05  ; 5
BATTLE_BG_PAL_RIVER                     = $06  ; 6
BATTLE_BG_PAL_IMP_CAMP                  = $07  ; 7
BATTLE_BG_PAL_TRAIN_EXT                 = $08  ; 8
BATTLE_BG_PAL_TRAIN_INT                 = $09  ; 9
BATTLE_BG_PAL_FANATICS_TOWER            = $0a  ; 10
BATTLE_BG_PAL_DESERT_WOB                = $0b  ; 11
BATTLE_BG_PAL_FOREST_WOB                = $0c  ; 12
BATTLE_BG_PAL_FIELD_WOR                 = $0d  ; 13
BATTLE_BG_PAL_VELDT                     = $0e  ; 14
BATTLE_BG_PAL_SNOWFIELDS                = $0f  ; 15
BATTLE_BG_PAL_TOWN_EXT                  = $10  ; 16
BATTLE_BG_PAL_IMP_CASTLE                = $11  ; 17
BATTLE_BG_PAL_FLOATING_ISLAND           = $12  ; 18
BATTLE_BG_PAL_KEFKAS_TOWER_EXT          = $13  ; 19
BATTLE_BG_PAL_OPERA_STAGE               = $14  ; 20
BATTLE_BG_PAL_OPERA_CATWALK             = $15  ; 21
BATTLE_BG_PAL_BURNING_BUILDING          = $16  ; 22
BATTLE_BG_PAL_CASTLE_INT                = $17  ; 23
BATTLE_BG_PAL_MAGITEK                   = $18  ; 24
BATTLE_BG_PAL_COLOSSEUM                 = $19  ; 25
BATTLE_BG_PAL_SEALED_GATE               = $1a  ; 26
BATTLE_BG_PAL_VILLAGE_EXT               = $1b  ; 27
BATTLE_BG_PAL_WATERFALL                 = $1c  ; 28
BATTLE_BG_PAL_1d                        = $1d  ; 29 (unused)
BATTLE_BG_PAL_TRAIN_TRACKS              = $1e  ; 30
BATTLE_BG_PAL_1f                        = $1f  ; 31 (unused)
BATTLE_BG_PAL_TENTACLES                 = $20  ; 32
BATTLE_BG_PAL_FIRE_CAVES                = $21  ; 33
BATTLE_BG_PAL_TOWN_INT                  = $22  ; 34
BATTLE_BG_PAL_ZOZO_INT                  = $23  ; 35
BATTLE_BG_PAL_UNDERWATER                = $24  ; 36
BATTLE_BG_PAL_ZOZO_EXT                  = $25  ; 37
BATTLE_BG_PAL_AIRSHIP_WOB               = $26  ; 38
BATTLE_BG_PAL_DARILLS_TOMB              = $27  ; 39
BATTLE_BG_PAL_CASTLE_EXT                = $28  ; 40
BATTLE_BG_PAL_KEFKAS_TOWER_INT          = $29  ; 41
BATTLE_BG_PAL_42                        = $2a  ; 42 (unused)
BATTLE_BG_PAL_OWZERS_HOUSE              = $2b  ; 43
BATTLE_BG_PAL_FINAL_BATTLE_1            = $2c  ; 44
BATTLE_BG_PAL_FINAL_BATTLE_2            = $2d  ; 45
BATTLE_BG_PAL_FINAL_BATTLE_3            = $2e  ; 46
BATTLE_BG_PAL_MAGITEK_TRAIN             = $2f  ; 47
BATTLE_BG_PAL_FINAL_BATTLE_4            = $30  ; 48
BATTLE_BG_PAL_FOREST_WOR                = $31  ; 49
BATTLE_BG_PAL_CYANS_DREAM               = $32  ; 50
BATTLE_BG_PAL_AIRSHIP_WOR               = $33  ; 51
BATTLE_BG_PAL_DESERT_WOR                = $34  ; 52

BATTLE_BG_PAL_ARRAY_LENGTH              = 53

; ------------------------------------------------------------------------------

.endif
.list on
