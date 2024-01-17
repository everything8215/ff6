.list off
.ifndef SONG_SCRIPT_INC
SONG_SCRIPT_INC = 1

.global SongScript, SongScriptPtrs

; song ids
SONG_SILENCE                            = $00  ; 0
SONG_PRELUDE                            = $01  ; 1
SONG_OPENING_THEME_1                    = $02  ; 2
SONG_OPENING_THEME_2                    = $03  ; 3
SONG_OPENING_THEME_3                    = $04  ; 4
SONG_AWAKENING                          = $05  ; 5
SONG_TERRA                              = $06  ; 6
SONG_SHADOW                             = $07  ; 7
SONG_STRAGO                             = $08  ; 8
SONG_GAU                                = $09  ; 9
SONG_FIGARO                             = $0a  ; 10
SONG_COIN_SONG                          = $0b  ; 11
SONG_CYAN                               = $0c  ; 12
SONG_LOCKE                              = $0d  ; 13
SONG_FOREVER_RACHEL                     = $0e  ; 14
SONG_RELM                               = $0f  ; 15
SONG_SETZER                             = $10  ; 16
SONG_EPITAPH                            = $11  ; 17
SONG_CELES                              = $12  ; 18
SONG_TECHNO_DE_CHOCOBO                  = $13  ; 19
SONG_DECISIVE_BATTLE                    = $14  ; 20
SONG_JOHNNY_C_BAD                       = $15  ; 21
SONG_KEFKA                              = $16  ; 22
SONG_NARSHE                             = $17  ; 23
SONG_PHANTOM_FOREST                     = $18  ; 24
SONG_VELDT                              = $19  ; 25
SONG_SAVE_THEM                          = $1a  ; 26
SONG_GESTAHL                            = $1b  ; 27
SONG_TROOPS_MARCH_ON                    = $1c  ; 28
SONG_UNDER_MARTIAL_LAW                  = $1d  ; 29
SONG_WATERFALL                          = $1e  ; 30
SONG_METAMORPHOSIS                      = $1f  ; 31
SONG_PHANTOM_TRAIN                      = $20  ; 32
SONG_ESPER_WORLD                        = $21  ; 33
SONG_GRAND_FINALE_2                     = $22  ; 34
SONG_MT_KOLTS                           = $23  ; 35
SONG_BATTLE_THEME                       = $24  ; 36
SONG_FANFARE                            = $25  ; 37
SONG_WEDDING_WALTZ_1                    = $26  ; 38
SONG_ARIA_DI_MEZZO_CARATERRE            = $27  ; 39
SONG_SERPENT_TRENCH                     = $28  ; 40
SONG_SLAM_SHUFFLE                       = $29  ; 41
SONG_KIDS_RUN_THROUGH_THE_CITY          = $2a  ; 42
SONG_HUH                                = $2b  ; 43
SONG_GRAND_FINALE_1                     = $2c  ; 44
SONG_GOGO                               = $2d  ; 45
SONG_RETURNERS                          = $2e  ; 46
SONG_VICTORY_FANFARE                    = $2f  ; 47
SONG_UMARO                              = $30  ; 48
SONG_MOG                                = $31  ; 49
SONG_THE_UNFORGIVEN                     = $32  ; 50
SONG_FIERCE_BATTLE                      = $33  ; 51
SONG_DAY_AFTER                          = $34  ; 52
SONG_BLACKJACK                          = $35  ; 53
SONG_CATASTROPHE                        = $36  ; 54
SONG_MAGIC_HOUSE                        = $37  ; 55
SONG_NIGHTY_NIGHT                       = $38  ; 56
SONG_WIND                               = $39  ; 57
SONG_WINDY_SHORES                       = $3a  ; 58
SONG_DANCING_MAD_1_2_3                  = $3b  ; 59
SONG_TRAIN_BRAKING                      = $3c  ; 60
SONG_SPINACH_RAG                        = $3d  ; 61
SONG_REST_IN_PEACE                      = $3e  ; 62
SONG_CHOCOBOS_RUNNING                   = $3f  ; 63
SONG_DREAM_OF_A_TRAIN                   = $40  ; 64
SONG_OVERTURE_1                         = $41  ; 65
SONG_OVERTURE_2                         = $42  ; 66
SONG_OVERTURE_3                         = $43  ; 67
SONG_WEDDING_WALTZ_2                    = $44  ; 68
SONG_WEDDING_WALTZ_3                    = $45  ; 69
SONG_WEDDING_WALTZ_4                    = $46  ; 70
SONG_DEVILS_LAB                         = $47  ; 71
SONG_FIRE_EXPLOSION                     = $48  ; 72
SONG_CRANES_RISING                      = $49  ; 73
SONG_BURNING_HOUSE                      = $4a  ; 74
SONG_NEW_CONTINENT                      = $4b  ; 75
SONG_SEARCHING_FOR_FRIENDS              = $4c  ; 76
SONG_FANATICS                           = $4d  ; 77
SONG_LAST_DUNGEON                       = $4e  ; 78
SONG_DARK_WORLD                         = $4f  ; 79
SONG_DANCING_MAD_5                      = $50  ; 80
SONG_0051                               = $51  ; 81
SONG_DANCING_MAD_4                      = $52  ; 82
SONG_ENDING_THEME_1                     = $53  ; 83
SONG_ENDING_THEME_2                     = $54  ; 84

SONG_SCRIPT_ARRAY_LENGTH                = $55  ; 85

SONG_NONE                               = $ff  ; 255

.endif
.list on
