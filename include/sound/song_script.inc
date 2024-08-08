.list off
.ifndef SONG_SCRIPT_INC
SONG_SCRIPT_INC = 1

.global SongScript, SongScriptPtrs

; song ids
.enum SONG
        SILENCE                         ;= $00  ; 0
        PRELUDE                         ;= $01  ; 1
        OPENING_THEME_1                 ;= $02  ; 2
        OPENING_THEME_2                 ;= $03  ; 3
        OPENING_THEME_3                 ;= $04  ; 4
        AWAKENING                       ;= $05  ; 5
        TERRA                           ;= $06  ; 6
        SHADOW                          ;= $07  ; 7
        STRAGO                          ;= $08  ; 8
        GAU                             ;= $09  ; 9
        FIGARO                          ;= $0a  ; 10
        COIN_SONG                       ;= $0b  ; 11
        CYAN                            ;= $0c  ; 12
        LOCKE                           ;= $0d  ; 13
        FOREVER_RACHEL                  ;= $0e  ; 14
        RELM                            ;= $0f  ; 15
        SETZER                          ;= $10  ; 16
        EPITAPH                         ;= $11  ; 17
        CELES                           ;= $12  ; 18
        TECHNO_DE_CHOCOBO               ;= $13  ; 19
        DECISIVE_BATTLE                 ;= $14  ; 20
        JOHNNY_C_BAD                    ;= $15  ; 21
        KEFKA                           ;= $16  ; 22
        NARSHE                          ;= $17  ; 23
        PHANTOM_FOREST                  ;= $18  ; 24
        VELDT                           ;= $19  ; 25
        SAVE_THEM                       ;= $1a  ; 26
        GESTAHL                         ;= $1b  ; 27
        TROOPS_MARCH_ON                 ;= $1c  ; 28
        UNDER_MARTIAL_LAW               ;= $1d  ; 29
        WATERFALL                       ;= $1e  ; 30
        METAMORPHOSIS                   ;= $1f  ; 31
        PHANTOM_TRAIN                   ;= $20  ; 32
        ESPER_WORLD                     ;= $21  ; 33
        GRAND_FINALE_2                  ;= $22  ; 34
        MT_KOLTS                        ;= $23  ; 35
        BATTLE_THEME                    ;= $24  ; 36
        FANFARE                         ;= $25  ; 37
        WEDDING_WALTZ_1                 ;= $26  ; 38
        ARIA_DI_MEZZO_CARATERRE         ;= $27  ; 39
        SERPENT_TRENCH                  ;= $28  ; 40
        SLAM_SHUFFLE                    ;= $29  ; 41
        KIDS_RUN_THROUGH_THE_CITY       ;= $2a  ; 42
        HUH                             ;= $2b  ; 43
        GRAND_FINALE_1                  ;= $2c  ; 44
        GOGO                            ;= $2d  ; 45
        RETURNERS                       ;= $2e  ; 46
        VICTORY_FANFARE                 ;= $2f  ; 47
        UMARO                           ;= $30  ; 48
        MOG                             ;= $31  ; 49
        THE_UNFORGIVEN                  ;= $32  ; 50
        FIERCE_BATTLE                   ;= $33  ; 51
        DAY_AFTER                       ;= $34  ; 52
        BLACKJACK                       ;= $35  ; 53
        CATASTROPHE                     ;= $36  ; 54
        MAGIC_HOUSE                     ;= $37  ; 55
        NIGHTY_NIGHT                    ;= $38  ; 56
        WIND                            ;= $39  ; 57
        WINDY_SHORES                    ;= $3a  ; 58
        DANCING_MAD_1_2_3               ;= $3b  ; 59
        TRAIN_BRAKING                   ;= $3c  ; 60
        SPINACH_RAG                     ;= $3d  ; 61
        REST_IN_PEACE                   ;= $3e  ; 62
        CHOCOBOS_RUNNING                ;= $3f  ; 63
        DREAM_OF_A_TRAIN                ;= $40  ; 64
        OVERTURE_1                      ;= $41  ; 65
        OVERTURE_2                      ;= $42  ; 66
        OVERTURE_3                      ;= $43  ; 67
        WEDDING_WALTZ_2                 ;= $44  ; 68
        WEDDING_WALTZ_3                 ;= $45  ; 69
        WEDDING_WALTZ_4                 ;= $46  ; 70
        DEVILS_LAB                      ;= $47  ; 71
        FIRE_EXPLOSION                  ;= $48  ; 72
        CRANES_RISING                   ;= $49  ; 73
        BURNING_HOUSE                   ;= $4a  ; 74
        NEW_CONTINENT                   ;= $4b  ; 75
        SEARCHING_FOR_FRIENDS           ;= $4c  ; 76
        FANATICS                        ;= $4d  ; 77
        LAST_DUNGEON                    ;= $4e  ; 78
        DARK_WORLD                      ;= $4f  ; 79
        DANCING_MAD_5                   ;= $50  ; 80
        SONG_81                         ;= $51  ; 81
        DANCING_MAD_4                   ;= $52  ; 82
        ENDING_THEME_1                  ;= $53  ; 83
        ENDING_THEME_2                  ;= $54  ; 84
        NONE = $ff
.endenum

.scope SongScript
        ARRAY_LENGTH = SONG::ENDING_THEME_2 + 1
.endscope

.endif
.list on
