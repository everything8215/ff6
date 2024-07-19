.list off
.ifndef SAMPLE_BRR_INC
SAMPLE_BRR_INC = 1

.global SampleBRR, SampleBRRPtrs

; instrument sample ids
.enum SAMPLE_BRR
        GUITAR_STEEL                     ;= $00  ; 0
        BASS_FINGER                      ;= $01  ; 1
        PAN_FLUTE                        ;= $02  ; 2
        BANJO                            ;= $03  ; 3
        CELLO                            ;= $04  ; 4
        VOICE_SYNTH                      ;= $05  ; 5
        FLUTE                            ;= $06  ; 6
        FRENCH_HORN                      ;= $07  ; 7
        SYNTH                            ;= $08  ; 8
        OBOE                             ;= $09  ; 9
        ROCK_ORGAN                       ;= $0a  ; 10
        PIANO                            ;= $0b  ; 11
        STRINGS                          ;= $0c  ; 12
        TRUMPET                          ;= $0d  ; 13
        HIHAT_CLOSED                     ;= $0e  ; 14
        JEWS_HARP                        ;= $0f  ; 15
        HIHAT_OPEN                       ;= $10  ; 16
        CRASH_CYMBAL                     ;= $11  ; 17
        BREATH                           ;= $12  ; 18
        SNARE_ACOUSTIC                   ;= $13  ; 19
        FOOTSTEP                         ;= $14  ; 20
        TIMPANI                          ;= $15  ; 21
        TOM_TOM                          ;= $16  ; 22
        PIZZ_BASS                        ;= $17  ; 23
        PIZZ_STRINGS                     ;= $18  ; 24
        TUBA                             ;= $19  ; 25
        HARP                             ;= $1a  ; 26
        BASS_PICK                        ;= $1b  ; 27
        MANDOLIN                         ;= $1c  ; 28
        GUITAR_DIST                      ;= $1d  ; 29
        WHISTLE                          ;= $1e  ; 30
        CELESTA                          ;= $1f  ; 31
        SNARE_ELECTRIC                   ;= $20  ; 32
        KICK_DRUM                        ;= $21  ; 33
        COWBELL                          ;= $22  ; 34
        BELL                             ;= $23  ; 35
        PIPE_ORGAN                       ;= $24  ; 36
        LAUGH                            ;= $25  ; 37
        CHOCOBO_1                        ;= $26  ; 38
        CHOCOBO_2                        ;= $27  ; 39
        CHOCOBO_3                        ;= $28  ; 40
        FINGER_SNAP                      ;= $29  ; 41
        RIMSHOT                          ;= $2a  ; 42
        CONTRABASS                       ;= $2b  ; 43
        RATCHET                          ;= $2c  ; 44
        BONGO                            ;= $2d  ; 45
        SHAKER                           ;= $2e  ; 46
        WOOD_BLOCK                       ;= $2f  ; 47
        MUSIC_BOX                        ;= $30  ; 48
        GUITAR_NYLON                     ;= $31  ; 49
        BAGPIPES                         ;= $32  ; 50
        SHAKUHACHI                       ;= $33  ; 51
        TOWN_1                           ;= $34  ; 52
        TOWN_2                           ;= $35  ; 53
        SLEIGH_BELLS                     ;= $36  ; 54
        VOICE_TENOR                      ;= $37  ; 55
        VOICE_BARITONE                   ;= $38  ; 56
        VOICE_ALTO                       ;= $39  ; 57
        PIPE_ORGAN_LOW                   ;= $3a  ; 58
        DEVIL_SFX_1                      ;= $3b  ; 59
        DEVIL_SFX_2                      ;= $3c  ; 60
        XYLOPHONE                        ;= $3d  ; 61
        CROWD_NOISE                      ;= $3e  ; 62
.endenum

SAMPLE_BRR::ARRAY_LENGTH                 = $3f  ; 64

.endif
.list on
