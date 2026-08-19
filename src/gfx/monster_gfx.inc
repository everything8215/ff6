.list off
.ifndef MONSTER_GFX_INC
MONSTER_GFX_INC = 1

.global MonsterGfx, MonsterGfxProp, MonsterPal, MonsterStencil

; ------------------------------------------------------------------------------

; small stencils (64x64 pixels)
.enum MONSTER_STENCIL_SMALL
        GUARD                           ;= $00  ; 0
        SOLDIER                         ;= $01  ; 1
        TEMPLAR                         ;= $02  ; 2
        NINJA                           ;= $03  ; 3
        SAMURAI                         ;= $04  ; 4
        OROG                            ;= $05  ; 5
        MAG_ROADER_1                    ;= $06  ; 6
        HAZER                           ;= $07  ; 7
        DAHLING                         ;= $08  ; 8
        RAIN_MAN                        ;= $09  ; 9
        BRAWLER                         ;= $0a  ; 10
        APOKRYPHOS                      ;= $0b  ; 11
        DARK_FORCE                      ;= $0c  ; 12
        WHISPER                         ;= $0d  ; 13
        OVER_MIND                       ;= $0e  ; 14
        RHODOX                          ;= $0f  ; 15
        WERE_RAT                        ;= $10  ; 16
        URSUS                           ;= $11  ; 17
        RHINOTAUR                       ;= $12  ; 18
        LEAFER                          ;= $13  ; 19
        STRAY_CAT                       ;= $14  ; 20
        LOBO                            ;= $15  ; 21
        DOBERMAN                        ;= $16  ; 22
        VOMAMMOTH                       ;= $17  ; 23
        FIDOR                           ;= $18  ; 24
        BASKERVOR                       ;= $19  ; 25
        SURIANDER                       ;= $1a  ; 26
        MESOSAUR                        ;= $1b  ; 27
        PTERODON                        ;= $1c  ; 28
        FOSSILFANG                      ;= $1d  ; 29
        TYRANOSAUR                      ;= $1e  ; 30
        DARK_WIND                       ;= $1f  ; 31
        BEAKOR                          ;= $20  ; 32
        VULTURE                         ;= $21  ; 33
        HERMITCRAB                      ;= $22  ; 34
        TRAPPER                         ;= $23  ; 35
        HORNET                          ;= $24  ; 36
        CRASSHOPPR                      ;= $25  ; 37
        DELTA_BUG                       ;= $26  ; 38
        GILOMANTIS                      ;= $27  ; 39
        TRILIUM                         ;= $28  ; 40
        NIGHTSHADE                      ;= $29  ; 41
        TUMBLEWEED                      ;= $2a  ; 42
        BLOOMPIRE                       ;= $2b  ; 43
        TRILOBITER                      ;= $2c  ; 44
        SIEGFRIED                       ;= $2d  ; 45
        NAUTILOID                       ;= $2e  ; 46
        EXOCITE                         ;= $2f  ; 47
        ANGUIFORM                       ;= $30  ; 48
        REACH_FROG                      ;= $31  ; 49
        LIZARD                          ;= $32  ; 50
        CHICKENLIP                      ;= $33  ; 51
        PIPSQUEAK                       ;= $34  ; 52
        MTEKARMOR                       ;= $35  ; 53
        SKY_ARMOR                       ;= $36  ; 54
        TELSTAR                         ;= $37  ; 55
        VAPORITE                        ;= $38  ; 56
        FLAN                            ;= $39  ; 57
        ING                             ;= $3a  ; 58
        HUMPTY                          ;= $3b  ; 59
        BRAINPAN                        ;= $3c  ; 60
        CRULLER                         ;= $3d  ; 61
        CACTROT                         ;= $3e  ; 62
        REPO_MAN                        ;= $3f  ; 63
        HARVESTER                       ;= $40  ; 64
        BOMB                            ;= $41  ; 65
        STILL_LIFE                      ;= $42  ; 66
        BOXED_SET                       ;= $43  ; 67
        SLAMDANCER                      ;= $44  ; 68
        PUG                             ;= $45  ; 69
        MAGIC_URN                       ;= $46  ; 70
        MOVER                           ;= $47  ; 71
        FIGALIZ                         ;= $48  ; 72
        ASPIK                           ;= $49  ; 73
        GHOST                           ;= $4a  ; 74
        ARENEID                         ;= $4b  ; 75
        ACTANEON                        ;= $4c  ; 76
        SAND_HORSE                      ;= $4d  ; 77
        MAD_OSCAR                       ;= $4e  ; 78
        CRAWLY                          ;= $4f  ; 79
        BLEARY                          ;= $50  ; 80
        MAG_ROADER_2                    ;= $51  ; 81
        FORTIS                          ;= $52  ; 82
        TRIXTER                         ;= $53  ; 83
        WOOLLY                          ;= $54  ; 84
        VETERAN                         ;= $55  ; 85
        WHELK_SHELL                     ;= $56  ; 86
        GHOSTTRAIN                      ;= $57  ; 87
        SHIVA                           ;= $58  ; 88
        IFRIT_BOSS                      ;= $59  ; 89
        UMARO                           ;= $5a  ; 90
        FLAMEEATER                      ;= $5b  ; 91
        TENTACLE_1                      ;= $5c  ; 92
        CURLEY                          ;= $5d  ; 93
        LARRY                           ;= $5e  ; 94
        MOE                             ;= $5f  ; 95
        HIDONITE                        ;= $60  ; 96
        ULTROS_1                        ;= $61  ; 97
        ULTROS_2                        ;= $62  ; 98
        WHELK_HEAD_1                    ;= $63  ; 99
        WHELK_HEAD_2                    ;= $64  ; 100
        MERCHANT                        ;= $65  ; 101
        B_DAY_SUIT                      ;= $66  ; 102
        TENTACLE_2                      ;= $67  ; 103
        RIGHT_BLADE                     ;= $68  ; 104
        LEFT_BLADE                      ;= $69  ; 105
        ROUGH                           ;= $6a  ; 106
        STRIKER                         ;= $6b  ; 107
        LASER_GUN                       ;= $6c  ; 108
        SPECK                           ;= $6d  ; 109
        MISSILEBAY                      ;= $6e  ; 110
        KEFKA                           ;= $6f  ; 111
        PIRANHA                         ;= $70  ; 112
        SOULSAVER                       ;= $71  ; 113
        RAMUH                           ;= $72  ; 114
        SIREN                           ;= $73  ; 115
        SHOAT                           ;= $74  ; 116
        MADUIN                          ;= $75  ; 117
        STRAY                           ;= $76  ; 118
        KIRIN                           ;= $77  ; 119
        ZONESEEK                        ;= $78  ; 120
        CARBUNKL                        ;= $79  ; 121
        PHANTOM                         ;= $7a  ; 122
        SRAPHIM                         ;= $7b  ; 123
        GOLEM                           ;= $7c  ; 124
        UNICORN                         ;= $7d  ; 125
        TIGERBREAK                      ;= $7e  ; 126
        IMP                             ;= $7f  ; 127
.endenum

; ------------------------------------------------------------------------------

; large stencils (128x128 pixels)
.enum MONSTER_STENCIL_LARGE
        OSTEOSAUR                       ;= $00  ; 0
        PHUNBABA                        ;= $01  ; 1
        CHIMERA                         ;= $02  ; 2
        BEHEMOTH                        ;= $03  ; 3
        DRAGON                          ;= $04  ; 4
        CZARDRAGON                      ;= $05  ; 5
        BRACHOSAUR                      ;= $06  ; 6
        HARPY                           ;= $07  ; 7
        HOOVER                          ;= $08  ; 8
        RIDER                           ;= $09  ; 9
        CHUPON                          ;= $0a  ; 10
        LETHAL_WPN                      ;= $0b  ; 11
        HADESGIGAS                      ;= $0c  ; 12
        BUFFALAX                        ;= $0d  ; 13
        CRITIC                          ;= $0e  ; 14
        DIDALOS                         ;= $0f  ; 15
        VARGAS                          ;= $10  ; 16
        TUNNELARMR                      ;= $11  ; 17
        DADALUMA                        ;= $12  ; 18
        NUMBER_024                      ;= $13  ; 19
        NUMBER_128                      ;= $14  ; 20
        CRANE                           ;= $15  ; 21
        GUARDIAN                        ;= $16  ; 22
        AIR_FORCE                       ;= $17  ; 23
        TRITOCH_BOSS                    ;= $18  ; 24
        ATMAWEAPON                      ;= $19  ; 25
        DOOM_GAZE                       ;= $1a  ; 26
        CHADARNOOK_LADY                 ;= $1b  ; 27
        HIDON                           ;= $1c  ; 28
        DOOM                            ;= $1d  ; 29
        GODDESS                         ;= $1e  ; 30
        POLTRGEIST                      ;= $1f  ; 31
        FINAL_KEFKA                     ;= $20  ; 32
        CHADARNOOK_DEMON                ;= $21  ; 33
        IFRIT                           ;= $22  ; 34
        TERRATO                         ;= $23  ; 35
        BISMARK                         ;= $24  ; 36
        PALIDOR                         ;= $25  ; 37
        TRITOCH                         ;= $26  ; 38
        ODIN                            ;= $27  ; 39
        RAIDEN                          ;= $28  ; 40
        BAHAMUT                         ;= $29  ; 41
        ALEXANDR                        ;= $2a  ; 42
        CRUSADER_1                      ;= $2b  ; 43
        FENRIR                          ;= $2c  ; 44
        STARLET                         ;= $2d  ; 45
        PHOENIX                         ;= $2e  ; 46
        CRUSADER_2                      ;= $2f  ; 47
.endenum

; ------------------------------------------------------------------------------

.endif
.list on
