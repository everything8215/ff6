.list off
.ifndef MAP_SPRITE_GFX_INC
MAP_SPRITE_GFX_INC = 1

.global MapSpriteGfx, VehicleGfx

.enum MAP_SPRITE_GFX
        TERRA                           ;= $00  ; 0
        LOCKE                           ;= $01  ; 1
        CYAN                            ;= $02  ; 2
        SHADOW                          ;= $03  ; 3
        EDGAR                           ;= $04  ; 4
        SABIN                           ;= $05  ; 5
        CELES                           ;= $06  ; 6
        STRAGO                          ;= $07  ; 7
        RELM                            ;= $08  ; 8
        SETZER                          ;= $09  ; 9
        MOG                             ;= $0a  ; 10
        GAU                             ;= $0b  ; 11
        GOGO                            ;= $0c  ; 12
        UMARO                           ;= $0d  ; 13
        SOLDIER                         ;= $0e  ; 14
        IMP                             ;= $0f  ; 15
        LEO                             ;= $10  ; 16
        BANON                           ;= $11  ; 17
        ESPER_TERRA                     ;= $12  ; 18
        MERCHANT                        ;= $13  ; 19
        GHOST                           ;= $14  ; 20
        KEFKA                           ;= $15  ; 21
        GESTAHL                         ;= $16  ; 22
        OLD_MAN                         ;= $17  ; 23
        MAN                             ;= $18  ; 24
        DOG                             ;= $19  ; 25
        CELES_DRESS                     ;= $1a  ; 26
        RICH_MAN                        ;= $1b  ; 27
        DRACO                           ;= $1c  ; 28
        ARVIS                           ;= $1d  ; 29
        PILOT                           ;= $1e  ; 30
        ULTROS                          ;= $1f  ; 31
        SPIFFY_GAU                      ;= $20  ; 32
        HOOKER                          ;= $21  ; 33
        CHANCELLOR                      ;= $22  ; 34
        CLYDE                           ;= $23  ; 35
        OLD_WOMAN                       ;= $24  ; 36
        WOMAN                           ;= $25  ; 37
        BOY                             ;= $26  ; 38
        GIRL                            ;= $27  ; 39
        BIRD                            ;= $28  ; 40
        RACHEL                          ;= $29  ; 41
        KATARIN                         ;= $2a  ; 42
        IMPRESARIO                      ;= $2b  ; 43
        ESPER_ELDER                     ;= $2c  ; 44
        YURA                            ;= $2d  ; 45
        SIEGFRIED                       ;= $2e  ; 46
        CID                             ;= $2f  ; 47
        MADUIN                          ;= $30  ; 48
        BANDIT                          ;= $31  ; 49
        VARGAS                          ;= $32  ; 50
        MONSTER                         ;= $33  ; 51
        NARSHE_GUARD                    ;= $34  ; 52
        TRAIN_CONDUCTOR                 ;= $35  ; 53
        SHOPKEEPER                      ;= $36  ; 54
        FAERIE                          ;= $37  ; 55
        WOLF                            ;= $38  ; 56
        DRAGON                          ;= $39  ; 57
        FISH                            ;= $3a  ; 58
        FIGARO_GUARD                    ;= $3b  ; 59
        DARILL                          ;= $3c  ; 60
        CHUPON                          ;= $3d  ; 61
        EMPEROR_SERVANT                 ;= $3e  ; 62
        RAMUH                           ;= $3f  ; 63
        FIGARO_GUARD_RIDING             ;= $40  ; 64
        CELES_CHAINS                    ;= $41  ; 65
        GAU_KUNG_FU                     ;= $42  ; 66
        GAU_BANDANA                     ;= $43  ; 67
        KING_DOMA                       ;= $44  ; 68
        NUMBER_128                      ;= $45  ; 69
        MAGI_WARRIOR_1                  ;= $46  ; 70
        SKULL_STATUE                    ;= $47  ; 71
        IFRIT                           ;= $48  ; 72
        PHANTOM                         ;= $49  ; 73
        SHIVA                           ;= $4a  ; 74
        UNICORN                         ;= $4b  ; 75
        BISMARK                         ;= $4c  ; 76
        CARBUNCL                        ;= $4d  ; 77
        SHOAT                           ;= $4e  ; 78
        OWZER_1                         ;= $4f  ; 79
        OWZER_2                         ;= $50  ; 80
        BLACKJACK                       ;= $51  ; 81
        FIGARO_GUARD_DEAD               ;= $52  ; 82
        NUMBER_024                      ;= $53  ; 83
        TREASURE_CHEST                  ;= $54  ; 84
        MAGI_WARRIOR_2                  ;= $55  ; 85
        ATMA                            ;= $56  ; 86
        SMALL_STATUE                    ;= $57  ; 87
        FLOWERS                         ;= $58  ; 88
        ENVELOPE                        ;= $59  ; 89
        PLANT                           ;= $5a  ; 90
        MAGICITE                        ;= $5b  ; 91
        BOOK                            ;= $5c  ; 92
        BABY                            ;= $5d  ; 93
        QUESTION_MARK                   ;= $5e  ; 94
        EXCLAMATION_POINT               ;= $5f  ; 95
        SLAVE_CROWN                     ;= $60  ; 96
        WEIGHT                          ;= $61  ; 97
        BIRD_BANDANA                    ;= $62  ; 98
        EYES                            ;= $63  ; 99
        BANDANA                         ;= $64  ; 100
        NOTHING                         ;= $65  ; 101
        FLYING_BIRD_1                   ;= $66  ; 102
        FLYING_BIRD_2                   ;= $67  ; 103
        BIG_SPARKLE                     ;= $68  ; 104
        MULTI_SPARKLES                  ;= $69  ; 105
        SMALL_SPARKLE                   ;= $6a  ; 106
        COIN                            ;= $6b  ; 107
        RAT                             ;= $6c  ; 108
        TURTLE                          ;= $6d  ; 109
        SMALL_BIRD_UP                   ;= $6e  ; 110
        SAVE_POINT                      ;= $6f  ; 111
        FLAME                           ;= $70  ; 112
        EXPLOSION                       ;= $71  ; 113
        TENTACLE_1                      ;= $72  ; 114
        TENTACLE_2                      ;= $73  ; 115
        BIG_SWITCH                      ;= $74  ; 116
        FLOOR_SWITCH                    ;= $75  ; 117
        ROCK                            ;= $76  ; 118
        CRANE_HOOK_3                    ;= $77  ; 119
        ELEVATOR                        ;= $78  ; 120
        FLYING_TERRA_1                  ;= $79  ; 121
        FLYING_TERRA_2                  ;= $7a  ; 122
        ENDING_TERRA_3                  ;= $7b  ; 123
        DIVING_HELMET                   ;= $7c  ; 124
        GUARDIAN_1                      ;= $7d  ; 125
        GUARDIAN_2                      ;= $7e  ; 126
        GUARDIAN_3                      ;= $7f  ; 127
        CRANE_HOOK_2                    ;= $80  ; 128
        GUARDIAN_4                      ;= $81  ; 129
        GUARDIAN_5                      ;= $82  ; 130
        GUARDIAN_6                      ;= $83  ; 131
        CRANE_HOOK_1                    ;= $84  ; 132
        MAGITEK_MACHINE                 ;= $85  ; 133
        GATE_1                          ;= $86  ; 134
        GATE_2                          ;= $87  ; 135
        GATE_3                          ;= $88  ; 136
        AIR_FORCE                       ;= $89  ; 137
        LEO_SWORD                       ;= $8a  ; 138
        MAGITEK_TRAIN_1                 ;= $8b  ; 139
        MAGITEK_TRAIN_2                 ;= $8c  ; 140
        MAGITEK_TRAIN_3                 ;= $8d  ; 141
        MAGITEK_TRAIN_4                 ;= $8e  ; 142
        CRANE_1                         ;= $8f  ; 143
        CRANE_2                         ;= $90  ; 144
        CRANE_3                         ;= $91  ; 145
        CHADARNOOK_1                    ;= $92  ; 146
        CHADARNOOK_2                    ;= $93  ; 147
        CHADARNOOK_3                    ;= $94  ; 148
        FALCON_1                        ;= $95  ; 149
        FALCON_2                        ;= $96  ; 150
        FALCON_3                        ;= $97  ; 151
        FLYING_TERRA_3                  ;= $98  ; 152
        TRITOCH                         ;= $99  ; 153
        ODIN                            ;= $9a  ; 154
        GODDESS_1                       ;= $9b  ; 155
        DOOM_1                          ;= $9c  ; 156
        POLTERGEIST_1                   ;= $9d  ; 157
        GODDESS_2                       ;= $9e  ; 158
        GODDESS_3                       ;= $9f  ; 159
        DOOM_2                          ;= $a0  ; 160
        DOOM_3                          ;= $a1  ; 161
        ENDING_TERRA_1                  ;= $a2  ; 162
        ENDING_TERRA_2                  ;= $a3  ; 163
        SMALL_BIRD_LEFT                 ;= $a4  ; 164
.endenum

.scope MapSpriteGfx
        ARRAY_LENGTH = MAP_SPRITE_GFX::SMALL_BIRD_LEFT + 1

        ; export all map sprite offsets
        .repeat ARRAY_LENGTH, i
                .global .ident(.sprintf("_%d", i))
        .endrep
.endscope

.endif
.list on
