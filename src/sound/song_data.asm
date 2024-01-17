.include "sound/song_script.inc"

; ------------------------------------------------------------------------------

; c5/3c5e
NumSongs:
        .byte   SONG_SCRIPT_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.include "sound/sample_brr.inc"

; c5/3c5f
SampleBRRPtrs:
        make_ptr_tbl_far SampleBRR, SAMPLE_BRR_ARRAY_LENGTH, 0

; ------------------------------------------------------------------------------

; c5/3d1c
SampleLoopStart:
        .word   $0b88                   ; SAMPLE_GUITAR_STEEL
        .word   $03b1                   ; SAMPLE_BASS_FINGER
        .word   $0759                   ; SAMPLE_PAN_FLUTE
        .word   $0f39                   ; SAMPLE_BANJO
        .word   $1047                   ; SAMPLE_CELLO
        .word   $0639                   ; SAMPLE_VOICE_SYNTH
        .word   $0441                   ; SAMPLE_FLUTE
        .word   $0804                   ; SAMPLE_FRENCH_HORN
        .word   $038d                   ; SAMPLE_SYNTH
        .word   $05d6                   ; SAMPLE_OBOE
        .word   $013b                   ; SAMPLE_ROCK_ORGAN
        .word   $1491                   ; SAMPLE_PIANO
        .word   $0321                   ; SAMPLE_STRINGS
        .word   $0402                   ; SAMPLE_TRUMPET
        .word   $0000                   ; SAMPLE_HIHAT_CLOSED
        .word   $0000                   ; SAMPLE_JEWS_HARP
        .word   $0000                   ; SAMPLE_HIHAT_OPEN
        .word   $0a8c                   ; SAMPLE_CRASH_CYMBAL
        .word   $0000                   ; SAMPLE_BREATH
        .word   $0000                   ; SAMPLE_SNARE_ACOUSTIC
        .word   $0000                   ; SAMPLE_FOOTSTEP
        .word   $0000                   ; SAMPLE_TIMPANI
        .word   $0000                   ; SAMPLE_TOM_TOM
        .word   $0678                   ; SAMPLE_PIZZ_BASS
        .word   $05cd                   ; SAMPLE_PIZZ_STRINGS
        .word   $0894                   ; SAMPLE_TUBA
        .word   $039f                   ; SAMPLE_HARP
        .word   $0480                   ; SAMPLE_BASS_PICK
        .word   $037b                   ; SAMPLE_MANDOLIN
        .word   $05fa                   ; SAMPLE_GUITAR_DIST
        .word   $03e7                   ; SAMPLE_WHISTLE
        .word   $0c18                   ; SAMPLE_CELESTA
        .word   $0000                   ; SAMPLE_SNARE_ELECTRIC
        .word   $0465                   ; SAMPLE_KICK_DRUM
        .word   $0000                   ; SAMPLE_COWBELL
        .word   $0d41                   ; SAMPLE_BELL
        .word   $02d9                   ; SAMPLE_PIPE_ORGAN
        .word   $06c0                   ; SAMPLE_LAUGH
        .word   $0000                   ; SAMPLE_CHOCOBO_1
        .word   $0000                   ; SAMPLE_CHOCOBO_2
        .word   $0000                   ; SAMPLE_CHOCOBO_3
        .word   $0000                   ; SAMPLE_FINGER_SNAP
        .word   $0000                   ; SAMPLE_RIMSHOT
        .word   $0477                   ; SAMPLE_CONTRABASS
        .word   $0000                   ; SAMPLE_RATCHET
        .word   $08dc                   ; SAMPLE_BONGO
        .word   $0000                   ; SAMPLE_SHAKER
        .word   $0000                   ; SAMPLE_WOOD_BLOCK
        .word   $0642                   ; SAMPLE_MUSIC_BOX
        .word   $0bfd                   ; SAMPLE_GUITAR_NYLON
        .word   $0be2                   ; SAMPLE_BAGPIPES
        .word   $0477                   ; SAMPLE_SHAKUHACHI
        .word   $0a17                   ; SAMPLE_TOWN_1
        .word   $04ec                   ; SAMPLE_TOWN_2
        .word   $15f9                   ; SAMPLE_SLEIGH_BELLS
        .word   $001b                   ; SAMPLE_VOICE_TENOR
        .word   $0477                   ; SAMPLE_VOICE_BARITONE
        .word   $0213                   ; SAMPLE_VOICE_ALTO
        .word   $001b                   ; SAMPLE_PIPE_ORGAN_LOW
        .word   $102c                   ; SAMPLE_DEVIL_SFX_1
        .word   $0fd2                   ; SAMPLE_DEVIL_SFX_2
        .word   $0654                   ; SAMPLE_XYLOPHONE
        .word   $0012                   ; SAMPLE_CROWD_NOISE

; ------------------------------------------------------------------------------

; c5/3d9a
SampleFreqMult:
        .byte   $fd,$a0                 ; SAMPLE_GUITAR_STEEL
        .byte   $a9,$40                 ; SAMPLE_BASS_FINGER
        .byte   $b0,$80                 ; SAMPLE_PAN_FLUTE
        .byte   $84,$00                 ; SAMPLE_BANJO
        .byte   $b0,$20                 ; SAMPLE_CELLO
        .byte   $af,$80                 ; SAMPLE_VOICE_SYNTH
        .byte   $e1,$58                 ; SAMPLE_FLUTE
        .byte   $fd,$a0                 ; SAMPLE_FRENCH_HORN
        .byte   $90,$00                 ; SAMPLE_SYNTH
        .byte   $a9,$16                 ; SAMPLE_OBOE
        .byte   $be,$90                 ; SAMPLE_ROCK_ORGAN
        .byte   $b0,$60                 ; SAMPLE_PIANO
        .byte   $af,$a0                 ; SAMPLE_STRINGS
        .byte   $a9,$00                 ; SAMPLE_TRUMPET
        .byte   $00,$00                 ; SAMPLE_HIHAT_CLOSED
        .byte   $9c,$00                 ; SAMPLE_JEWS_HARP
        .byte   $00,$00                 ; SAMPLE_HIHAT_OPEN
        .byte   $00,$00                 ; SAMPLE_CRASH_CYMBAL
        .byte   $00,$00                 ; SAMPLE_BREATH
        .byte   $00,$00                 ; SAMPLE_SNARE_ACOUSTIC
        .byte   $00,$00                 ; SAMPLE_FOOTSTEP
        .byte   $f9,$00                 ; SAMPLE_TIMPANI
        .byte   $00,$00                 ; SAMPLE_TOM_TOM
        .byte   $b7,$50                 ; SAMPLE_PIZZ_BASS
        .byte   $70,$00                 ; SAMPLE_PIZZ_STRINGS
        .byte   $fd,$a0                 ; SAMPLE_TUBA
        .byte   $a9,$40                 ; SAMPLE_HARP
        .byte   $fd,$a0                 ; SAMPLE_BASS_PICK
        .byte   $fd,$a0                 ; SAMPLE_MANDOLIN
        .byte   $29,$c0                 ; SAMPLE_GUITAR_DIST
        .byte   $b9,$ff                 ; SAMPLE_WHISTLE
        .byte   $a9,$00                 ; SAMPLE_CELESTA
        .byte   $00,$00                 ; SAMPLE_SNARE_ELECTRIC
        .byte   $00,$00                 ; SAMPLE_KICK_DRUM
        .byte   $00,$00                 ; SAMPLE_COWBELL
        .byte   $88,$00                 ; SAMPLE_BELL
        .byte   $a7,$a8                 ; SAMPLE_PIPE_ORGAN
        .byte   $00,$00                 ; SAMPLE_LAUGH
        .byte   $43,$d0                 ; SAMPLE_CHOCOBO_1
        .byte   $43,$00                 ; SAMPLE_CHOCOBO_2
        .byte   $43,$00                 ; SAMPLE_CHOCOBO_3
        .byte   $7f,$ff                 ; SAMPLE_FINGER_SNAP
        .byte   $00,$00                 ; SAMPLE_RIMSHOT
        .byte   $c5,$00                 ; SAMPLE_CONTRABASS
        .byte   $00,$00                 ; SAMPLE_RATCHET
        .byte   $00,$00                 ; SAMPLE_BONGO
        .byte   $00,$00                 ; SAMPLE_SHAKER
        .byte   $00,$00                 ; SAMPLE_WOOD_BLOCK
        .byte   $00,$00                 ; SAMPLE_MUSIC_BOX
        .byte   $68,$fc                 ; SAMPLE_GUITAR_NYLON
        .byte   $6e,$e0                 ; SAMPLE_BAGPIPES
        .byte   $ff,$00                 ; SAMPLE_SHAKUHACHI
        .byte   $8d,$00                 ; SAMPLE_TOWN_1
        .byte   $a9,$60                 ; SAMPLE_TOWN_2
        .byte   $00,$00                 ; SAMPLE_SLEIGH_BELLS
        .byte   $80,$00                 ; SAMPLE_VOICE_TENOR
        .byte   $88,$00                 ; SAMPLE_VOICE_BARITONE
        .byte   $29,$e4                 ; SAMPLE_VOICE_ALTO
        .byte   $95,$00                 ; SAMPLE_PIPE_ORGAN_LOW
        .byte   $00,$00                 ; SAMPLE_DEVIL_SFX_1
        .byte   $00,$00                 ; SAMPLE_DEVIL_SFX_2
        .byte   $a9,$60                 ; SAMPLE_XYLOPHONE
        .byte   $00,$00                 ; SAMPLE_CROWD_NOISE

; ------------------------------------------------------------------------------

; c5/3e18
SampleADSR:
        make_adsr 15,7,7,17             ; SAMPLE_GUITAR_STEEL
        make_adsr 15,7,7,14             ; SAMPLE_BASS_FINGER
        make_adsr 15,7,7,0              ; SAMPLE_PAN_FLUTE
        make_adsr 15,7,7,19             ; SAMPLE_BANJO
        make_adsr 15,7,7,0              ; SAMPLE_CELLO
        make_adsr 15,7,7,0              ; SAMPLE_VOICE_SYNTH
        make_adsr 15,7,7,0              ; SAMPLE_FLUTE
        make_adsr 15,7,7,0              ; SAMPLE_FRENCH_HORN
        make_adsr 15,7,7,0              ; SAMPLE_SYNTH
        make_adsr 15,7,7,0              ; SAMPLE_OBOE
        make_adsr 15,7,7,0              ; SAMPLE_ROCK_ORGAN
        make_adsr 15,7,7,15             ; SAMPLE_PIANO
        make_adsr 15,7,7,0              ; SAMPLE_STRINGS
        make_adsr 15,7,7,0              ; SAMPLE_TRUMPET
        make_adsr 15,7,7,0              ; SAMPLE_HIHAT_CLOSED
        make_adsr 15,7,7,0              ; SAMPLE_JEWS_HARP
        make_adsr 15,7,7,0              ; SAMPLE_HIHAT_OPEN
        make_adsr 15,7,7,14             ; SAMPLE_CRASH_CYMBAL
        make_adsr 15,7,7,0              ; SAMPLE_BREATH
        make_adsr 15,7,7,0              ; SAMPLE_SNARE_ACOUSTIC
        make_adsr 15,7,7,0              ; SAMPLE_FOOTSTEP
        make_adsr 15,7,7,0              ; SAMPLE_TIMPANI
        make_adsr 15,7,7,0              ; SAMPLE_TOM_TOM
        make_adsr 15,7,7,12             ; SAMPLE_PIZZ_BASS
        make_adsr 15,7,7,21             ; SAMPLE_PIZZ_STRINGS
        make_adsr 15,7,7,0              ; SAMPLE_TUBA
        make_adsr 15,7,7,16             ; SAMPLE_HARP
        make_adsr 15,7,7,0              ; SAMPLE_BASS_PICK
        make_adsr 15,7,7,16             ; SAMPLE_MANDOLIN
        make_adsr 15,7,7,0              ; SAMPLE_GUITAR_DIST
        make_adsr 15,7,7,0              ; SAMPLE_WHISTLE
        make_adsr 15,7,7,10             ; SAMPLE_CELESTA
        make_adsr 15,7,7,0              ; SAMPLE_SNARE_ELECTRIC
        make_adsr 15,7,7,0              ; SAMPLE_KICK_DRUM
        make_adsr 15,7,7,0              ; SAMPLE_COWBELL
        make_adsr 15,7,7,10             ; SAMPLE_BELL
        make_adsr 15,7,7,0              ; SAMPLE_PIPE_ORGAN
        make_adsr 15,7,7,0              ; SAMPLE_LAUGH
        make_adsr 15,7,7,0              ; SAMPLE_CHOCOBO_1
        make_adsr 15,7,7,0              ; SAMPLE_CHOCOBO_2
        make_adsr 15,7,7,0              ; SAMPLE_CHOCOBO_3
        make_adsr 15,7,7,0              ; SAMPLE_FINGER_SNAP
        make_adsr 15,7,7,0              ; SAMPLE_RIMSHOT
        make_adsr 15,7,7,0              ; SAMPLE_CONTRABASS
        make_adsr 15,7,7,0              ; SAMPLE_RATCHET
        make_adsr 15,7,7,19             ; SAMPLE_BONGO
        make_adsr 15,7,7,0              ; SAMPLE_SHAKER
        make_adsr 15,7,7,0              ; SAMPLE_WOOD_BLOCK
        make_adsr 15,7,7,13             ; SAMPLE_MUSIC_BOX
        make_adsr 15,7,7,16             ; SAMPLE_GUITAR_NYLON
        make_adsr 15,7,7,0              ; SAMPLE_BAGPIPES
        make_adsr 15,7,7,0              ; SAMPLE_SHAKUHACHI
        make_adsr 15,7,7,0              ; SAMPLE_TOWN_1
        make_adsr 15,7,7,0              ; SAMPLE_TOWN_2
        make_adsr 15,7,7,0              ; SAMPLE_SLEIGH_BELLS
        make_adsr 15,7,7,0              ; SAMPLE_VOICE_TENOR
        make_adsr 15,7,7,0              ; SAMPLE_VOICE_BARITONE
        make_adsr 15,7,7,0              ; SAMPLE_VOICE_ALTO
        make_adsr 15,7,7,0              ; SAMPLE_PIPE_ORGAN_LOW
        make_adsr 15,7,7,0              ; SAMPLE_DEVIL_SFX_1
        make_adsr 15,7,7,0              ; SAMPLE_DEVIL_SFX_2
        make_adsr 15,7,7,12             ; SAMPLE_XYLOPHONE
        make_adsr 15,7,7,0              ; SAMPLE_CROWD_NOISE

; ------------------------------------------------------------------------------

; c5/3e96
SongScriptPtrs:
        make_ptr_tbl_far SongScript, $55, 0

; ------------------------------------------------------------------------------

SongSamples:

; 00 Silence
        begin_song_samples 0
        end_song_samples 0

; 01 The Prelude (3.16)
        begin_song_samples 1
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_VOICE_SYNTH
        def_song_sample SAMPLE_CONTRABASS
        end_song_samples 1

; 02 Opening Theme 1 (1.01a)
        begin_song_samples 2
        def_song_sample SAMPLE_PIPE_ORGAN
        def_song_sample SAMPLE_VOICE_ALTO
        def_song_sample SAMPLE_VOICE_TENOR
        def_song_sample SAMPLE_PIANO
        end_song_samples 2

; 03 Opening Theme 2 (1.01b)
        begin_song_samples 3
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_BELL
        def_song_sample SAMPLE_TUBA
        end_song_samples 3

; 04 Opening Theme 3 (1.01c)
        begin_song_samples 4
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_BASS_FINGER
        end_song_samples 4

; 05 Awakening (1.03)
        begin_song_samples 5
        def_song_sample SAMPLE_PIANO
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_OBOE
        end_song_samples 5

; 06 Terra (2.01)
        begin_song_samples 6
        def_song_sample SAMPLE_PAN_FLUTE
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_MANDOLIN
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        end_song_samples 6

; 07 Shadow (1.11)
        begin_song_samples 7
        def_song_sample SAMPLE_JEWS_HARP
        def_song_sample SAMPLE_WHISTLE
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_PIZZ_BASS
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_RIMSHOT
        end_song_samples 7

; 08 Strago (2.18)
        begin_song_samples 8
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_ROCK_ORGAN
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_BANJO
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_FINGER_SNAP
        def_song_sample SAMPLE_WOOD_BLOCK
        def_song_sample SAMPLE_COWBELL
        end_song_samples 8

; 09 Gau (1.18)
        begin_song_samples 9
        def_song_sample SAMPLE_CELLO
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_GUITAR_STEEL
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_BASS_PICK
        end_song_samples 9

; 0A Edgar & Sabin (1.07)
        begin_song_samples 10
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_TUBA
        end_song_samples 10

; 0B Coin Song (2.02)
        begin_song_samples 11
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_BASS_PICK
        end_song_samples 11

; 0C Cyan (1.13)
        begin_song_samples 12
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_SHAKUHACHI
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_SLEIGH_BELLS
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CONTRABASS
        end_song_samples 12

; 0D Locke (1.04)
        begin_song_samples 13
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CONTRABASS
        end_song_samples 13

; 0E Forever Rachel (2.04)
        begin_song_samples 14
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        end_song_samples 14

; 0F Relm (2.19)
        begin_song_samples 15
        def_song_sample SAMPLE_BAGPIPES
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_MANDOLIN
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FRENCH_HORN
        end_song_samples 15

; 10 Setzer (2.11)
        begin_song_samples 16
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CONTRABASS
        end_song_samples 16

; 11 Epitaph (3.09)
        begin_song_samples 17
        def_song_sample SAMPLE_MUSIC_BOX
        def_song_sample SAMPLE_GUITAR_STEEL
        def_song_sample SAMPLE_FLUTE
        end_song_samples 17

; 12 Celes (1.22)
        begin_song_samples 18
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_CELESTA
        end_song_samples 18

; 13 Techno de Chocobo (2.03)
        begin_song_samples 19
        def_song_sample SAMPLE_GUITAR_DIST
        def_song_sample SAMPLE_ROCK_ORGAN
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_SHAKER
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_CHOCOBO_1
        def_song_sample SAMPLE_CHOCOBO_2
        def_song_sample SAMPLE_CHOCOBO_3
        end_song_samples 19

; 14 The Decisive Battle (1.24)
        begin_song_samples 20
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_ROCK_ORGAN
        def_song_sample SAMPLE_GUITAR_DIST
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ELECTRIC
        end_song_samples 20

; 15 Johnny C. Bad (2.12)
        begin_song_samples 21
        def_song_sample SAMPLE_PIANO
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_PIZZ_BASS
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        end_song_samples 21

; 16 Kefka (1.08)
        begin_song_samples 22
        def_song_sample SAMPLE_PIZZ_STRINGS
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_CONTRABASS
        end_song_samples 22

; 17 The Mines of Narshe (1.02)
        begin_song_samples 23
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_PIZZ_BASS
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_FOOTSTEP
        def_song_sample SAMPLE_PIANO
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_BREATH
        end_song_samples 23

; 18 Phantom Forest (1.15)
        begin_song_samples 24
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_VOICE_SYNTH
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_PIZZ_BASS
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_BREATH
        end_song_samples 24

; 19 Veldt (1.17)
        begin_song_samples 25
        def_song_sample SAMPLE_TOM_TOM
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SHAKER
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_BONGO
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_RATCHET
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_COWBELL
        end_song_samples 25

; 1A Save Them! (1.23)
        begin_song_samples 26
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_TUBA
        end_song_samples 26

; 1B The Emperor Gestahl (2.13)
        begin_song_samples 27
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_BELL
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_TIMPANI
        end_song_samples 27

; 1C Troops March On (1.12)
        begin_song_samples 28
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        end_song_samples 28

; 1D Under Martial Law (1.21)
        begin_song_samples 29
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_KICK_DRUM
        end_song_samples 29

; 1E Waterfall
        begin_song_samples 30
        end_song_samples 30

; 1F Metamorphosis (1.25)
        begin_song_samples 31
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ELECTRIC
        def_song_sample SAMPLE_TOM_TOM
        end_song_samples 31

; 20 Phantom Train (2.16)
        begin_song_samples 32
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_TUBA
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_HIHAT_CLOSED
        end_song_samples 32

; 21 Another World of Beasts (2.20)
        begin_song_samples 33
        def_song_sample SAMPLE_PIANO
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_BASS_PICK
        end_song_samples 33

; 22 Grand Finale 2 (2.10b)
        begin_song_samples 34
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        end_song_samples 34

; 23 Mt. Kolts (1.09)
        begin_song_samples 35
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_ROCK_ORGAN
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_GUITAR_DIST
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_TOM_TOM
        end_song_samples 35

; 24 Battle Theme (1.05)
        begin_song_samples 36
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_GUITAR_DIST
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        end_song_samples 36

; 25 Fanfare
        begin_song_samples 37
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_TUBA
        end_song_samples 37

; 26 The Wedding Waltz 1 (2.09a)
        begin_song_samples 38
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        end_song_samples 38

; 27 Aria de Mezzo Caraterre (2.08)
        begin_song_samples 39
        def_song_sample SAMPLE_VOICE_ALTO
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_VOICE_ALTO
        end_song_samples 39

; 28 The Serpent Trench (1.19)
        begin_song_samples 40
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        end_song_samples 40

; 29 Slam Shuffle (2.05)
        begin_song_samples 41
        end_song_samples 41

; 2A Kids Run Through the City Corner (1.20)
        begin_song_samples 42
        def_song_sample SAMPLE_TOWN_1
        def_song_sample SAMPLE_PIZZ_BASS
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TOWN_2
        end_song_samples 42

; 2B ??? (2.16)
        begin_song_samples 43
        def_song_sample SAMPLE_XYLOPHONE
        def_song_sample SAMPLE_RATCHET
        def_song_sample SAMPLE_WOOD_BLOCK
        def_song_sample SAMPLE_LAUGH
        def_song_sample SAMPLE_SLEIGH_BELLS
        def_song_sample SAMPLE_SHAKER
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_TOM_TOM
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        end_song_samples 43

; 2C Grand Finale 1 (2.10a)
        begin_song_samples 44
        def_song_sample SAMPLE_CROWD_NOISE
        end_song_samples 44

; 2D Gogo (3.08)
        begin_song_samples 45
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        end_song_samples 45

; 2E Returners (1.10)
        begin_song_samples 46
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        end_song_samples 46

; 2F Fanfare (1.06)
        begin_song_samples 47
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_GUITAR_DIST
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_KICK_DRUM
        end_song_samples 47

; 30 Umaro (3.11)
        begin_song_samples 48
        def_song_sample SAMPLE_WOOD_BLOCK
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CRASH_CYMBAL
        end_song_samples 48

; 31 Mog (2.17)
        begin_song_samples 49
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_BANJO
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ELECTRIC
        def_song_sample SAMPLE_TUBA
        end_song_samples 49

; 32 The Unforgiven (1.14)
        begin_song_samples 50
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CONTRABASS
        end_song_samples 50

; 33 The Fierce Battle (3.03)
        begin_song_samples 51
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_SYNTH
        end_song_samples 51

; 34 The Day After (3.06)
        begin_song_samples 52
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_MANDOLIN
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_SHAKER
        def_song_sample SAMPLE_KICK_DRUM
        end_song_samples 52

; 35 Blackjack (2.15)
        begin_song_samples 53
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_BASS_FINGER
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_FLUTE
        end_song_samples 53

; 36 Catastrophe (3.02)
        begin_song_samples 54
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CRASH_CYMBAL
        end_song_samples 54

; 37 The Magic House (3.10)
        begin_song_samples 55
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_GUITAR_NYLON
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_BASS_FINGER
        end_song_samples 55

; 38 Nighty Night
        begin_song_samples 56
        def_song_sample SAMPLE_PIANO
        end_song_samples 56

; 39 Wind
        begin_song_samples 57
        def_song_sample SAMPLE_SNARE_ELECTRIC
        end_song_samples 57

; 3A Windy Shores
        begin_song_samples 58
        end_song_samples 58

; 3B Dancing Mad 1, 2, & 3 (3.14)
        begin_song_samples 59
        def_song_sample SAMPLE_PIPE_ORGAN
        def_song_sample SAMPLE_PIPE_ORGAN_LOW
        def_song_sample SAMPLE_VOICE_ALTO
        def_song_sample SAMPLE_VOICE_TENOR
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_BELL
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_BREATH
        end_song_samples 59

; 3C Train Braking
        begin_song_samples 60
        end_song_samples 60

; 3D Spinach Rag (2.06)
        begin_song_samples 61
        def_song_sample SAMPLE_PIANO
        end_song_samples 61

; 3E Rest in Peace (3.04)
        begin_song_samples 62
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_HARP
        end_song_samples 62

; 3F Chocobos Running
        begin_song_samples 63
        end_song_samples 63

; 40 The Dream of a Train
        begin_song_samples 64
        end_song_samples 64

; 41 Overture 1 (2.07a)
        begin_song_samples 65
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_TIMPANI
        end_song_samples 65

; 42 Overture 2 (2.07b)
        begin_song_samples 66
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_VOICE_BARITONE
        end_song_samples 66

; 43 Overture 3 (2.07c)
        begin_song_samples 67
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_GUITAR_NYLON
        end_song_samples 67

; 44 The Wedding Waltz 2 (2.09b)
        begin_song_samples 68
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        end_song_samples 68

; 45 The Wedding Waltz 3 (2.09c)
        begin_song_samples 69
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_VOICE_BARITONE
        def_song_sample SAMPLE_VOICE_ALTO
        def_song_sample SAMPLE_VOICE_TENOR
        def_song_sample SAMPLE_TRUMPET
        end_song_samples 69

; 46 The Wedding Waltz 4 (2.09d)
        begin_song_samples 70
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        end_song_samples 70

; 47 Devil's Lab (2.14)
        begin_song_samples 71
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_DEVIL_SFX_2
        def_song_sample SAMPLE_DEVIL_SFX_1
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_SNARE_ELECTRIC
        end_song_samples 71

; 48 Fire!/Explosion
        begin_song_samples 72
        end_song_samples 72

; 49 Cranes Rising
        begin_song_samples 73
        def_song_sample SAMPLE_DEVIL_SFX_2
        end_song_samples 73

; 4A Inside the Burning House
        begin_song_samples 74
        end_song_samples 74

; 4B New Continent (3.01)
        begin_song_samples 75
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_HARP
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TUBA
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_BASS_PICK
        end_song_samples 75

; 4C Searching for Friends (3.07)
        begin_song_samples 76
        def_song_sample SAMPLE_PAN_FLUTE
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_VOICE_SYNTH
        end_song_samples 76

; 4D Fanatics (3.12)
        begin_song_samples 77
        def_song_sample SAMPLE_VOICE_TENOR
        def_song_sample SAMPLE_VOICE_ALTO
        def_song_sample SAMPLE_VOICE_BARITONE
        def_song_sample SAMPLE_SLEIGH_BELLS
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_PIPE_ORGAN
        end_song_samples 77

; 4E Last Dungeon and Aura (3.13)
        begin_song_samples 78
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_CRASH_CYMBAL
        end_song_samples 78

; 4F Dark World (3.05)
        begin_song_samples 79
        def_song_sample SAMPLE_PIPE_ORGAN
        def_song_sample SAMPLE_MUSIC_BOX
        def_song_sample SAMPLE_BELL
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_PIANO
        end_song_samples 79

; 50 Dancing Mad 5 (3.14)
        begin_song_samples 80
        def_song_sample SAMPLE_ROCK_ORGAN
        def_song_sample SAMPLE_GUITAR_DIST
        def_song_sample SAMPLE_BASS_PICK
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_HIHAT_CLOSED
        def_song_sample SAMPLE_HIHAT_OPEN
        def_song_sample SAMPLE_TOM_TOM
        def_song_sample SAMPLE_SNARE_ELECTRIC
        def_song_sample SAMPLE_KICK_DRUM
        def_song_sample SAMPLE_PIPE_ORGAN
        end_song_samples 80

; 51 Silence
        begin_song_samples 81
        end_song_samples 81

; 52 Dancing Mad 4 (3.14)
        begin_song_samples 82
        def_song_sample SAMPLE_PIPE_ORGAN
        def_song_sample SAMPLE_VOICE_ALTO
        def_song_sample SAMPLE_VOICE_TENOR
        end_song_samples 82

; 53 Ending Theme 1 (3.15a)
        begin_song_samples 83
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TUBA
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_HARP
        end_song_samples 83

; 54 Ending Theme 2 (3.15b)
        begin_song_samples 84
        def_song_sample SAMPLE_STRINGS
        def_song_sample SAMPLE_CONTRABASS
        def_song_sample SAMPLE_FLUTE
        def_song_sample SAMPLE_OBOE
        def_song_sample SAMPLE_TRUMPET
        def_song_sample SAMPLE_FRENCH_HORN
        def_song_sample SAMPLE_TUBA
        def_song_sample SAMPLE_CRASH_CYMBAL
        def_song_sample SAMPLE_SNARE_ACOUSTIC
        def_song_sample SAMPLE_TIMPANI
        def_song_sample SAMPLE_HARP
        end_song_samples 84

; ------------------------------------------------------------------------------

.macro inc_sample_brr _id, _filename
        .ident(.sprintf("SampleBRR_%04x", _id)) := *
        .incbin .sprintf("src/sound/sample_brr/%s.brr", _filename)
.endmac

; c5/4a35 - include instrument sample brr data
        inc_sample_brr SAMPLE_GUITAR_STEEL, "guitar_steel"
        inc_sample_brr SAMPLE_BASS_FINGER, "bass_finger"
        inc_sample_brr SAMPLE_PAN_FLUTE, "pan_flute"
        inc_sample_brr SAMPLE_BANJO, "banjo"
        inc_sample_brr SAMPLE_CELLO, "cello"
        inc_sample_brr SAMPLE_VOICE_SYNTH, "voice_synth"
        inc_sample_brr SAMPLE_FLUTE, "flute"
        inc_sample_brr SAMPLE_FRENCH_HORN, "french_horn"
        inc_sample_brr SAMPLE_SYNTH, "synth"
        inc_sample_brr SAMPLE_OBOE, "oboe"
        inc_sample_brr SAMPLE_ROCK_ORGAN, "rock_organ"
        inc_sample_brr SAMPLE_PIANO, "piano"
        inc_sample_brr SAMPLE_STRINGS, "strings"
        inc_sample_brr SAMPLE_TRUMPET, "trumpet"
        inc_sample_brr SAMPLE_HIHAT_CLOSED, "hihat_closed"
        inc_sample_brr SAMPLE_JEWS_HARP, "jews_harp"
        inc_sample_brr SAMPLE_HIHAT_OPEN, "hihat_open"
        inc_sample_brr SAMPLE_CRASH_CYMBAL, "crash_cymbal"
        inc_sample_brr SAMPLE_BREATH, "breath"
        inc_sample_brr SAMPLE_SNARE_ACOUSTIC, "snare_acoustic"
        inc_sample_brr SAMPLE_FOOTSTEP, "footstep"
        inc_sample_brr SAMPLE_TIMPANI, "timpani"
        inc_sample_brr SAMPLE_TOM_TOM, "tom_tom"
        inc_sample_brr SAMPLE_PIZZ_BASS, "pizz_bass"
        inc_sample_brr SAMPLE_PIZZ_STRINGS, "pizz_strings"
        inc_sample_brr SAMPLE_TUBA, "tuba"
        inc_sample_brr SAMPLE_HARP, "harp"
        inc_sample_brr SAMPLE_BASS_PICK, "bass_pick"
        inc_sample_brr SAMPLE_MANDOLIN, "mandolin"
        inc_sample_brr SAMPLE_GUITAR_DIST, "guitar_dist"
        inc_sample_brr SAMPLE_WHISTLE, "whistle"
        inc_sample_brr SAMPLE_CELESTA, "celesta"
        inc_sample_brr SAMPLE_SNARE_ELECTRIC, "snare_electric"
        inc_sample_brr SAMPLE_KICK_DRUM, "kick_drum"
        inc_sample_brr SAMPLE_COWBELL, "cowbell"
        inc_sample_brr SAMPLE_BELL, "bell"
        inc_sample_brr SAMPLE_PIPE_ORGAN, "pipe_organ"
        inc_sample_brr SAMPLE_LAUGH, "laugh"
        inc_sample_brr SAMPLE_CHOCOBO_1, "chocobo_1"
        inc_sample_brr SAMPLE_CHOCOBO_2, "chocobo_2"
        inc_sample_brr SAMPLE_CHOCOBO_3, "chocobo_3"
        inc_sample_brr SAMPLE_FINGER_SNAP, "finger_snap"
        inc_sample_brr SAMPLE_RIMSHOT, "rimshot"
        inc_sample_brr SAMPLE_CONTRABASS, "contrabass"
        inc_sample_brr SAMPLE_RATCHET, "ratchet"
        inc_sample_brr SAMPLE_BONGO, "bongo"
        inc_sample_brr SAMPLE_SHAKER, "shaker"
        inc_sample_brr SAMPLE_WOOD_BLOCK, "wood_block"
        inc_sample_brr SAMPLE_MUSIC_BOX, "music_box"
        inc_sample_brr SAMPLE_GUITAR_NYLON, "guitar_nylon"
        inc_sample_brr SAMPLE_BAGPIPES, "bagpipes"
        inc_sample_brr SAMPLE_SHAKUHACHI, "shakuhachi"
        inc_sample_brr SAMPLE_TOWN_1, "town_1"
        inc_sample_brr SAMPLE_TOWN_2, "town_2"
        inc_sample_brr SAMPLE_SLEIGH_BELLS, "sleigh_bells"
        inc_sample_brr SAMPLE_VOICE_TENOR, "voice_tenor"
        inc_sample_brr SAMPLE_VOICE_BARITONE, "voice_baritone"
        inc_sample_brr SAMPLE_VOICE_ALTO, "voice_alto"
        inc_sample_brr SAMPLE_PIPE_ORGAN_LOW, "pipe_organ_low"
        inc_sample_brr SAMPLE_DEVIL_SFX_1, "devil_sfx_1"
        inc_sample_brr SAMPLE_DEVIL_SFX_2, "devil_sfx_2"
        inc_sample_brr SAMPLE_XYLOPHONE, "xylophone"
        inc_sample_brr SAMPLE_CROWD_NOISE, "crowd_noise"

; ------------------------------------------------------------------------------

.macro inc_song_script _id, _filename
        .ident(.sprintf("SongScript_%04x", _id)) := *
        .ifnblank _filename
                .include .sprintf("song_script/%s", _filename)
        .endif
.endmac

; c8/5c7a
        inc_song_script SONG_0051
        inc_song_script SONG_SILENCE, "silence.asm"
        inc_song_script SONG_PRELUDE, "prelude.asm"
        inc_song_script SONG_AWAKENING, "awakening.asm"
        inc_song_script SONG_TERRA, "terra.asm"
        inc_song_script SONG_SHADOW, "shadow.asm"
        inc_song_script SONG_STRAGO, "strago.asm"
        inc_song_script SONG_GAU, "gau.asm"
        inc_song_script SONG_FIGARO, "figaro.asm"
        inc_song_script SONG_COIN_SONG, "coin_song.asm"
        inc_song_script SONG_CYAN, "cyan.asm"
        inc_song_script SONG_LOCKE, "locke.asm"
        inc_song_script SONG_FOREVER_RACHEL, "forever_rachel.asm"
        inc_song_script SONG_RELM, "relm.asm"
        inc_song_script SONG_SETZER, "setzer.asm"
        inc_song_script SONG_EPITAPH, "epitaph.asm"
        inc_song_script SONG_CELES, "celes.asm"
        inc_song_script SONG_TECHNO_DE_CHOCOBO, "techno_de_chocobo.asm"
        .include "song_script/unused.asm"
        inc_song_script SONG_DECISIVE_BATTLE, "decisive_battle.asm"
        inc_song_script SONG_JOHNNY_C_BAD, "johnny_c_bad.asm"
        inc_song_script SONG_OPENING_THEME_2, "opening_2.asm"
        inc_song_script SONG_KEFKA, "kefka.asm"
        inc_song_script SONG_NARSHE, "narshe.asm"
        inc_song_script SONG_PHANTOM_FOREST, "phantom_forest.asm"
        inc_song_script SONG_OPENING_THEME_3, "opening_3.asm"
        inc_song_script SONG_VELDT, "veldt.asm"
        inc_song_script SONG_SAVE_THEM, "save_them.asm"
        inc_song_script SONG_GESTAHL, "gestahl.asm"
        inc_song_script SONG_TROOPS_MARCH_ON, "troops_march_on.asm"
        inc_song_script SONG_UNDER_MARTIAL_LAW, "under_martial_law.asm"
        inc_song_script SONG_WATERFALL, "waterfall.asm"
        inc_song_script SONG_METAMORPHOSIS, "metamorphosis.asm"
        inc_song_script SONG_PHANTOM_TRAIN, "phantom_train.asm"
        inc_song_script SONG_ESPER_WORLD, "esper_world.asm"
        inc_song_script SONG_GRAND_FINALE_2, "grand_finale_2.asm"
        inc_song_script SONG_MT_KOLTS, "mt_kolts.asm"
        inc_song_script SONG_BATTLE_THEME, "battle_theme.asm"
        inc_song_script SONG_FANFARE, "fanfare.asm"
        inc_song_script SONG_WEDDING_WALTZ_1, "wedding_waltz_1.asm"
        inc_song_script SONG_ARIA_DI_MEZZO_CARATERRE, "aria_di_mezzo_caraterre.asm"
        inc_song_script SONG_KIDS_RUN_THROUGH_THE_CITY, "kids_run_through_the_city.asm"
        inc_song_script SONG_GOGO, "gogo.asm"
        inc_song_script SONG_RETURNERS, "returners.asm"
        inc_song_script SONG_VICTORY_FANFARE, "victory_fanfare.asm"
        inc_song_script SONG_UMARO, "umaro.asm"
        inc_song_script SONG_MOG, "mog.asm"
        inc_song_script SONG_THE_UNFORGIVEN, "the_unforgiven.asm"
        inc_song_script SONG_FIERCE_BATTLE, "fierce_battle.asm"
        inc_song_script SONG_DAY_AFTER, "day_after.asm"
        inc_song_script SONG_BLACKJACK, "blackjack.asm"
        inc_song_script SONG_CATASTROPHE, "catastrophe.asm"
        inc_song_script SONG_MAGIC_HOUSE, "magic_house.asm"
        inc_song_script SONG_NIGHTY_NIGHT, "nighty_night.asm"
        inc_song_script SONG_WIND, "wind.asm"
        inc_song_script SONG_WINDY_SHORES, "windy_shores.asm"
        inc_song_script SONG_DANCING_MAD_1_2_3, "dancing_mad_1_2_3.asm"
        inc_song_script SONG_TRAIN_BRAKING, "train_braking.asm"
        inc_song_script SONG_SPINACH_RAG, "spinach_rag.asm"
        inc_song_script SONG_REST_IN_PEACE, "rest_in_peace.asm"
        inc_song_script SONG_CHOCOBOS_RUNNING, "chocobos_running.asm"
        inc_song_script SONG_DREAM_OF_A_TRAIN, "dream_of_a_train.asm"
        inc_song_script SONG_OVERTURE_1, "overture_1.asm"
        inc_song_script SONG_OVERTURE_2, "overture_2.asm"
        inc_song_script SONG_OVERTURE_3, "overture_3.asm"
        inc_song_script SONG_WEDDING_WALTZ_2, "wedding_waltz_2.asm"
        inc_song_script SONG_WEDDING_WALTZ_3, "wedding_waltz_3.asm"
        inc_song_script SONG_WEDDING_WALTZ_4, "wedding_waltz_4.asm"
        inc_song_script SONG_OPENING_THEME_1, "opening_1.asm"
        inc_song_script SONG_DEVILS_LAB, "devils_lab.asm"
        inc_song_script SONG_FIRE_EXPLOSION, "fire_explosion.asm"
        inc_song_script SONG_CRANES_RISING, "cranes_rising.asm"
        inc_song_script SONG_BURNING_HOUSE, "burning_house.asm"
        inc_song_script SONG_HUH, "huh.asm"
        inc_song_script SONG_SERPENT_TRENCH, "serpent_trench.asm"
        inc_song_script SONG_SLAM_SHUFFLE, "slam_shuffle.asm"
        inc_song_script SONG_GRAND_FINALE_1, "grand_finale_1.asm"
        inc_song_script SONG_NEW_CONTINENT, "new_continent.asm"
        inc_song_script SONG_SEARCHING_FOR_FRIENDS, "searching_for_friends.asm"
        inc_song_script SONG_FANATICS, "fanatics.asm"
        inc_song_script SONG_LAST_DUNGEON, "last_dungeon.asm"
        inc_song_script SONG_DARK_WORLD, "dark_world.asm"
        inc_song_script SONG_DANCING_MAD_5, "dancing_mad_5.asm"
        inc_song_script SONG_DANCING_MAD_4, "dancing_mad_4.asm"
        inc_song_script SONG_ENDING_THEME_1, "ending_1.asm"
        inc_song_script SONG_ENDING_THEME_2, "ending_2.asm"

; ------------------------------------------------------------------------------
