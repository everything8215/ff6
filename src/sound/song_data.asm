.include "sound/song_script.inc"

; ------------------------------------------------------------------------------

; c5/3c5e
NumSongs:
        .byte   SONG_SCRIPT_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.include "sound/sample_brr.inc"

; c5/3c5f
SampleBRRPtrs:
        make_ptr_tbl_far SampleBRR, SAMPLE_BRR::ARRAY_LENGTH, 0

; ------------------------------------------------------------------------------

; c5/3d1c
SampleLoopStart:
        .word   $0b88                   ; GUITAR_STEEL
        .word   $03b1                   ; BASS_FINGER
        .word   $0759                   ; PAN_FLUTE
        .word   $0f39                   ; BANJO
        .word   $1047                   ; CELLO
        .word   $0639                   ; VOICE_SYNTH
        .word   $0441                   ; FLUTE
        .word   $0804                   ; FRENCH_HORN
        .word   $038d                   ; SYNTH
        .word   $05d6                   ; OBOE
        .word   $013b                   ; ROCK_ORGAN
        .word   $1491                   ; PIANO
        .word   $0321                   ; STRINGS
        .word   $0402                   ; TRUMPET
        .word   $0000                   ; HIHAT_CLOSED
        .word   $0000                   ; JEWS_HARP
        .word   $0000                   ; HIHAT_OPEN
        .word   $0a8c                   ; CRASH_CYMBAL
        .word   $0000                   ; BREATH
        .word   $0000                   ; SNARE_ACOUSTIC
        .word   $0000                   ; FOOTSTEP
        .word   $0000                   ; TIMPANI
        .word   $0000                   ; TOM_TOM
        .word   $0678                   ; PIZZ_BASS
        .word   $05cd                   ; PIZZ_STRINGS
        .word   $0894                   ; TUBA
        .word   $039f                   ; HARP
        .word   $0480                   ; BASS_PICK
        .word   $037b                   ; MANDOLIN
        .word   $05fa                   ; GUITAR_DIST
        .word   $03e7                   ; WHISTLE
        .word   $0c18                   ; CELESTA
        .word   $0000                   ; SNARE_ELECTRIC
        .word   $0465                   ; KICK_DRUM
        .word   $0000                   ; COWBELL
        .word   $0d41                   ; BELL
        .word   $02d9                   ; PIPE_ORGAN
        .word   $06c0                   ; LAUGH
        .word   $0000                   ; CHOCOBO_1
        .word   $0000                   ; CHOCOBO_2
        .word   $0000                   ; CHOCOBO_3
        .word   $0000                   ; FINGER_SNAP
        .word   $0000                   ; RIMSHOT
        .word   $0477                   ; CONTRABASS
        .word   $0000                   ; RATCHET
        .word   $08dc                   ; BONGO
        .word   $0000                   ; SHAKER
        .word   $0000                   ; WOOD_BLOCK
        .word   $0642                   ; MUSIC_BOX
        .word   $0bfd                   ; GUITAR_NYLON
        .word   $0be2                   ; BAGPIPES
        .word   $0477                   ; SHAKUHACHI
        .word   $0a17                   ; TOWN_1
        .word   $04ec                   ; TOWN_2
        .word   $15f9                   ; SLEIGH_BELLS
        .word   $001b                   ; VOICE_TENOR
        .word   $0477                   ; VOICE_BARITONE
        .word   $0213                   ; VOICE_ALTO
        .word   $001b                   ; PIPE_ORGAN_LOW
        .word   $102c                   ; DEVIL_SFX_1
        .word   $0fd2                   ; DEVIL_SFX_2
        .word   $0654                   ; XYLOPHONE
        .word   $0012                   ; CROWD_NOISE

; ------------------------------------------------------------------------------

; c5/3d9a
SampleFreqMult:
        .byte   $fd,$a0                 ; GUITAR_STEEL
        .byte   $a9,$40                 ; BASS_FINGER
        .byte   $b0,$80                 ; PAN_FLUTE
        .byte   $84,$00                 ; BANJO
        .byte   $b0,$20                 ; CELLO
        .byte   $af,$80                 ; VOICE_SYNTH
        .byte   $e1,$58                 ; FLUTE
        .byte   $fd,$a0                 ; FRENCH_HORN
        .byte   $90,$00                 ; SYNTH
        .byte   $a9,$16                 ; OBOE
        .byte   $be,$90                 ; ROCK_ORGAN
        .byte   $b0,$60                 ; PIANO
        .byte   $af,$a0                 ; STRINGS
        .byte   $a9,$00                 ; TRUMPET
        .byte   $00,$00                 ; HIHAT_CLOSED
        .byte   $9c,$00                 ; JEWS_HARP
        .byte   $00,$00                 ; HIHAT_OPEN
        .byte   $00,$00                 ; CRASH_CYMBAL
        .byte   $00,$00                 ; BREATH
        .byte   $00,$00                 ; SNARE_ACOUSTIC
        .byte   $00,$00                 ; FOOTSTEP
        .byte   $f9,$00                 ; TIMPANI
        .byte   $00,$00                 ; TOM_TOM
        .byte   $b7,$50                 ; PIZZ_BASS
        .byte   $70,$00                 ; PIZZ_STRINGS
        .byte   $fd,$a0                 ; TUBA
        .byte   $a9,$40                 ; HARP
        .byte   $fd,$a0                 ; BASS_PICK
        .byte   $fd,$a0                 ; MANDOLIN
        .byte   $29,$c0                 ; GUITAR_DIST
        .byte   $b9,$ff                 ; WHISTLE
        .byte   $a9,$00                 ; CELESTA
        .byte   $00,$00                 ; SNARE_ELECTRIC
        .byte   $00,$00                 ; KICK_DRUM
        .byte   $00,$00                 ; COWBELL
        .byte   $88,$00                 ; BELL
        .byte   $a7,$a8                 ; PIPE_ORGAN
        .byte   $00,$00                 ; LAUGH
        .byte   $43,$d0                 ; CHOCOBO_1
        .byte   $43,$00                 ; CHOCOBO_2
        .byte   $43,$00                 ; CHOCOBO_3
        .byte   $7f,$ff                 ; FINGER_SNAP
        .byte   $00,$00                 ; RIMSHOT
        .byte   $c5,$00                 ; CONTRABASS
        .byte   $00,$00                 ; RATCHET
        .byte   $00,$00                 ; BONGO
        .byte   $00,$00                 ; SHAKER
        .byte   $00,$00                 ; WOOD_BLOCK
        .byte   $00,$00                 ; MUSIC_BOX
        .byte   $68,$fc                 ; GUITAR_NYLON
        .byte   $6e,$e0                 ; BAGPIPES
        .byte   $ff,$00                 ; SHAKUHACHI
        .byte   $8d,$00                 ; TOWN_1
        .byte   $a9,$60                 ; TOWN_2
        .byte   $00,$00                 ; SLEIGH_BELLS
        .byte   $80,$00                 ; VOICE_TENOR
        .byte   $88,$00                 ; VOICE_BARITONE
        .byte   $29,$e4                 ; VOICE_ALTO
        .byte   $95,$00                 ; PIPE_ORGAN_LOW
        .byte   $00,$00                 ; DEVIL_SFX_1
        .byte   $00,$00                 ; DEVIL_SFX_2
        .byte   $a9,$60                 ; XYLOPHONE
        .byte   $00,$00                 ; CROWD_NOISE

; ------------------------------------------------------------------------------

; c5/3e18
SampleADSR:
        make_adsr 15,7,7,17             ; GUITAR_STEEL
        make_adsr 15,7,7,14             ; BASS_FINGER
        make_adsr 15,7,7,0              ; PAN_FLUTE
        make_adsr 15,7,7,19             ; BANJO
        make_adsr 15,7,7,0              ; CELLO
        make_adsr 15,7,7,0              ; VOICE_SYNTH
        make_adsr 15,7,7,0              ; FLUTE
        make_adsr 15,7,7,0              ; FRENCH_HORN
        make_adsr 15,7,7,0              ; SYNTH
        make_adsr 15,7,7,0              ; OBOE
        make_adsr 15,7,7,0              ; ROCK_ORGAN
        make_adsr 15,7,7,15             ; PIANO
        make_adsr 15,7,7,0              ; STRINGS
        make_adsr 15,7,7,0              ; TRUMPET
        make_adsr 15,7,7,0              ; HIHAT_CLOSED
        make_adsr 15,7,7,0              ; JEWS_HARP
        make_adsr 15,7,7,0              ; HIHAT_OPEN
        make_adsr 15,7,7,14             ; CRASH_CYMBAL
        make_adsr 15,7,7,0              ; BREATH
        make_adsr 15,7,7,0              ; SNARE_ACOUSTIC
        make_adsr 15,7,7,0              ; FOOTSTEP
        make_adsr 15,7,7,0              ; TIMPANI
        make_adsr 15,7,7,0              ; TOM_TOM
        make_adsr 15,7,7,12             ; PIZZ_BASS
        make_adsr 15,7,7,21             ; PIZZ_STRINGS
        make_adsr 15,7,7,0              ; TUBA
        make_adsr 15,7,7,16             ; HARP
        make_adsr 15,7,7,0              ; BASS_PICK
        make_adsr 15,7,7,16             ; MANDOLIN
        make_adsr 15,7,7,0              ; GUITAR_DIST
        make_adsr 15,7,7,0              ; WHISTLE
        make_adsr 15,7,7,10             ; CELESTA
        make_adsr 15,7,7,0              ; SNARE_ELECTRIC
        make_adsr 15,7,7,0              ; KICK_DRUM
        make_adsr 15,7,7,0              ; COWBELL
        make_adsr 15,7,7,10             ; BELL
        make_adsr 15,7,7,0              ; PIPE_ORGAN
        make_adsr 15,7,7,0              ; LAUGH
        make_adsr 15,7,7,0              ; CHOCOBO_1
        make_adsr 15,7,7,0              ; CHOCOBO_2
        make_adsr 15,7,7,0              ; CHOCOBO_3
        make_adsr 15,7,7,0              ; FINGER_SNAP
        make_adsr 15,7,7,0              ; RIMSHOT
        make_adsr 15,7,7,0              ; CONTRABASS
        make_adsr 15,7,7,0              ; RATCHET
        make_adsr 15,7,7,19             ; BONGO
        make_adsr 15,7,7,0              ; SHAKER
        make_adsr 15,7,7,0              ; WOOD_BLOCK
        make_adsr 15,7,7,13             ; MUSIC_BOX
        make_adsr 15,7,7,16             ; GUITAR_NYLON
        make_adsr 15,7,7,0              ; BAGPIPES
        make_adsr 15,7,7,0              ; SHAKUHACHI
        make_adsr 15,7,7,0              ; TOWN_1
        make_adsr 15,7,7,0              ; TOWN_2
        make_adsr 15,7,7,0              ; SLEIGH_BELLS
        make_adsr 15,7,7,0              ; VOICE_TENOR
        make_adsr 15,7,7,0              ; VOICE_BARITONE
        make_adsr 15,7,7,0              ; VOICE_ALTO
        make_adsr 15,7,7,0              ; PIPE_ORGAN_LOW
        make_adsr 15,7,7,0              ; DEVIL_SFX_1
        make_adsr 15,7,7,0              ; DEVIL_SFX_2
        make_adsr 15,7,7,12             ; XYLOPHONE
        make_adsr 15,7,7,0              ; CROWD_NOISE

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
        def_song_sample HARP
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample VOICE_SYNTH
        def_song_sample CONTRABASS
        end_song_samples 1

; 02 Opening Theme 1 (1.01a)
        begin_song_samples 2
        def_song_sample PIPE_ORGAN
        def_song_sample VOICE_ALTO
        def_song_sample VOICE_TENOR
        def_song_sample PIANO
        end_song_samples 2

; 03 Opening Theme 2 (1.01b)
        begin_song_samples 3
        def_song_sample STRINGS
        def_song_sample FRENCH_HORN
        def_song_sample HARP
        def_song_sample TRUMPET
        def_song_sample BASS_PICK
        def_song_sample FLUTE
        def_song_sample BELL
        def_song_sample TUBA
        end_song_samples 3

; 04 Opening Theme 3 (1.01c)
        begin_song_samples 4
        def_song_sample OBOE
        def_song_sample STRINGS
        def_song_sample HARP
        def_song_sample FRENCH_HORN
        def_song_sample SNARE_ACOUSTIC
        def_song_sample BASS_FINGER
        end_song_samples 4

; 05 Awakening (1.03)
        begin_song_samples 5
        def_song_sample PIANO
        def_song_sample FLUTE
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample BASS_PICK
        def_song_sample OBOE
        end_song_samples 5

; 06 Terra (2.01)
        begin_song_samples 6
        def_song_sample PAN_FLUTE
        def_song_sample CRASH_CYMBAL
        def_song_sample STRINGS
        def_song_sample MANDOLIN
        def_song_sample FRENCH_HORN
        def_song_sample TIMPANI
        def_song_sample BASS_PICK
        def_song_sample SNARE_ACOUSTIC
        end_song_samples 6

; 07 Shadow (1.11)
        begin_song_samples 7
        def_song_sample JEWS_HARP
        def_song_sample WHISTLE
        def_song_sample GUITAR_NYLON
        def_song_sample PIZZ_BASS
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ACOUSTIC
        def_song_sample RIMSHOT
        end_song_samples 7

; 08 Strago (2.18)
        begin_song_samples 8
        def_song_sample FLUTE
        def_song_sample ROCK_ORGAN
        def_song_sample OBOE
        def_song_sample BANJO
        def_song_sample BASS_FINGER
        def_song_sample KICK_DRUM
        def_song_sample HIHAT_OPEN
        def_song_sample FINGER_SNAP
        def_song_sample WOOD_BLOCK
        def_song_sample COWBELL
        end_song_samples 8

; 09 Gau (1.18)
        begin_song_samples 9
        def_song_sample CELLO
        def_song_sample FLUTE
        def_song_sample GUITAR_NYLON
        def_song_sample STRINGS
        def_song_sample GUITAR_STEEL
        def_song_sample HARP
        def_song_sample BASS_PICK
        end_song_samples 9

; 0A Edgar & Sabin (1.07)
        begin_song_samples 10
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample FRENCH_HORN
        def_song_sample CRASH_CYMBAL
        def_song_sample TIMPANI
        def_song_sample TUBA
        end_song_samples 10

; 0B Coin Song (2.02)
        begin_song_samples 11
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample OBOE
        def_song_sample BASS_PICK
        end_song_samples 11

; 0C Cyan (1.13)
        begin_song_samples 12
        def_song_sample FRENCH_HORN
        def_song_sample SHAKUHACHI
        def_song_sample STRINGS
        def_song_sample SLEIGH_BELLS
        def_song_sample CRASH_CYMBAL
        def_song_sample TIMPANI
        def_song_sample CONTRABASS
        end_song_samples 12

; 0D Locke (1.04)
        begin_song_samples 13
        def_song_sample STRINGS
        def_song_sample FRENCH_HORN
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        def_song_sample CONTRABASS
        end_song_samples 13

; 0E Forever Rachel (2.04)
        begin_song_samples 14
        def_song_sample HARP
        def_song_sample BASS_PICK
        def_song_sample FRENCH_HORN
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample STRINGS
        end_song_samples 14

; 0F Relm (2.19)
        begin_song_samples 15
        def_song_sample BAGPIPES
        def_song_sample FLUTE
        def_song_sample OBOE
        def_song_sample HARP
        def_song_sample MANDOLIN
        def_song_sample STRINGS
        def_song_sample FRENCH_HORN
        end_song_samples 15

; 10 Setzer (2.11)
        begin_song_samples 16
        def_song_sample STRINGS
        def_song_sample FRENCH_HORN
        def_song_sample TRUMPET
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        def_song_sample CONTRABASS
        end_song_samples 16

; 11 Epitaph (3.09)
        begin_song_samples 17
        def_song_sample MUSIC_BOX
        def_song_sample GUITAR_STEEL
        def_song_sample FLUTE
        end_song_samples 17

; 12 Celes (1.22)
        begin_song_samples 18
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample HARP
        def_song_sample CELESTA
        end_song_samples 18

; 13 Techno de Chocobo (2.03)
        begin_song_samples 19
        def_song_sample GUITAR_DIST
        def_song_sample ROCK_ORGAN
        def_song_sample BASS_PICK
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample SHAKER
        def_song_sample SNARE_ACOUSTIC
        def_song_sample KICK_DRUM
        def_song_sample CHOCOBO_1
        def_song_sample CHOCOBO_2
        def_song_sample CHOCOBO_3
        end_song_samples 19

; 14 The Decisive Battle (1.24)
        begin_song_samples 20
        def_song_sample STRINGS
        def_song_sample ROCK_ORGAN
        def_song_sample GUITAR_DIST
        def_song_sample BASS_PICK
        def_song_sample CRASH_CYMBAL
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ELECTRIC
        end_song_samples 20

; 15 Johnny C. Bad (2.12)
        begin_song_samples 21
        def_song_sample PIANO
        def_song_sample GUITAR_NYLON
        def_song_sample PIZZ_BASS
        def_song_sample SNARE_ACOUSTIC
        end_song_samples 21

; 16 Kefka (1.08)
        begin_song_samples 22
        def_song_sample PIZZ_STRINGS
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample HARP
        def_song_sample TIMPANI
        def_song_sample SNARE_ACOUSTIC
        def_song_sample CRASH_CYMBAL
        def_song_sample CONTRABASS
        end_song_samples 22

; 17 The Mines of Narshe (1.02)
        begin_song_samples 23
        def_song_sample STRINGS
        def_song_sample PIZZ_BASS
        def_song_sample HARP
        def_song_sample FOOTSTEP
        def_song_sample PIANO
        def_song_sample OBOE
        def_song_sample BREATH
        end_song_samples 23

; 18 Phantom Forest (1.15)
        begin_song_samples 24
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample VOICE_SYNTH
        def_song_sample GUITAR_NYLON
        def_song_sample PIZZ_BASS
        def_song_sample OBOE
        def_song_sample BREATH
        end_song_samples 24

; 19 Veldt (1.17)
        begin_song_samples 25
        def_song_sample TOM_TOM
        def_song_sample KICK_DRUM
        def_song_sample SHAKER
        def_song_sample OBOE
        def_song_sample BONGO
        def_song_sample STRINGS
        def_song_sample RATCHET
        def_song_sample CONTRABASS
        def_song_sample COWBELL
        end_song_samples 25

; 1A Save Them! (1.23)
        begin_song_samples 26
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample CONTRABASS
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        def_song_sample TUBA
        end_song_samples 26

; 1B The Emperor Gestahl (2.13)
        begin_song_samples 27
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample STRINGS
        def_song_sample SNARE_ACOUSTIC
        def_song_sample BELL
        def_song_sample BASS_PICK
        def_song_sample TIMPANI
        end_song_samples 27

; 1C Troops March On (1.12)
        begin_song_samples 28
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample BASS_FINGER
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        end_song_samples 28

; 1D Under Martial Law (1.21)
        begin_song_samples 29
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample OBOE
        def_song_sample FRENCH_HORN
        def_song_sample BASS_FINGER
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample KICK_DRUM
        end_song_samples 29

; 1E Waterfall
        begin_song_samples 30
        end_song_samples 30

; 1F Metamorphosis (1.25)
        begin_song_samples 31
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample BASS_FINGER
        def_song_sample CRASH_CYMBAL
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ELECTRIC
        def_song_sample TOM_TOM
        end_song_samples 31

; 20 Phantom Train (2.16)
        begin_song_samples 32
        def_song_sample GUITAR_NYLON
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample TUBA
        def_song_sample TIMPANI
        def_song_sample FLUTE
        def_song_sample SNARE_ACOUSTIC
        def_song_sample HIHAT_CLOSED
        end_song_samples 32

; 21 Another World of Beasts (2.20)
        begin_song_samples 33
        def_song_sample PIANO
        def_song_sample HARP
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample BASS_PICK
        end_song_samples 33

; 22 Grand Finale 2 (2.10b)
        begin_song_samples 34
        def_song_sample FRENCH_HORN
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        end_song_samples 34

; 23 Mt. Kolts (1.09)
        begin_song_samples 35
        def_song_sample STRINGS
        def_song_sample FRENCH_HORN
        def_song_sample ROCK_ORGAN
        def_song_sample HARP
        def_song_sample GUITAR_DIST
        def_song_sample BASS_FINGER
        def_song_sample TOM_TOM
        end_song_samples 35

; 24 Battle Theme (1.05)
        begin_song_samples 36
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample GUITAR_DIST
        def_song_sample BASS_FINGER
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample CRASH_CYMBAL
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ACOUSTIC
        end_song_samples 36

; 25 Fanfare
        begin_song_samples 37
        def_song_sample TRUMPET
        def_song_sample TUBA
        end_song_samples 37

; 26 The Wedding Waltz 1 (2.09a)
        begin_song_samples 38
        def_song_sample FLUTE
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample SNARE_ACOUSTIC
        end_song_samples 38

; 27 Aria de Mezzo Caraterre (2.08)
        begin_song_samples 39
        def_song_sample VOICE_ALTO
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample HARP
        def_song_sample FRENCH_HORN
        def_song_sample VOICE_ALTO
        end_song_samples 39

; 28 The Serpent Trench (1.19)
        begin_song_samples 40
        def_song_sample FRENCH_HORN
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        end_song_samples 40

; 29 Slam Shuffle (2.05)
        begin_song_samples 41
        end_song_samples 41

; 2A Kids Run Through the City Corner (1.20)
        begin_song_samples 42
        def_song_sample TOWN_1
        def_song_sample PIZZ_BASS
        def_song_sample GUITAR_NYLON
        def_song_sample STRINGS
        def_song_sample TOWN_2
        end_song_samples 42

; 2B ??? (2.16)
        begin_song_samples 43
        def_song_sample XYLOPHONE
        def_song_sample RATCHET
        def_song_sample WOOD_BLOCK
        def_song_sample LAUGH
        def_song_sample SLEIGH_BELLS
        def_song_sample SHAKER
        def_song_sample HIHAT_OPEN
        def_song_sample TOM_TOM
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ACOUSTIC
        end_song_samples 43

; 2C Grand Finale 1 (2.10a)
        begin_song_samples 44
        def_song_sample CROWD_NOISE
        end_song_samples 44

; 2D Gogo (3.08)
        begin_song_samples 45
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample FRENCH_HORN
        def_song_sample TRUMPET
        def_song_sample BASS_FINGER
        def_song_sample TIMPANI
        def_song_sample CRASH_CYMBAL
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ACOUSTIC
        end_song_samples 45

; 2E Returners (1.10)
        begin_song_samples 46
        def_song_sample FRENCH_HORN
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample CRASH_CYMBAL
        def_song_sample BASS_PICK
        def_song_sample SNARE_ACOUSTIC
        end_song_samples 46

; 2F Fanfare (1.06)
        begin_song_samples 47
        def_song_sample TRUMPET
        def_song_sample BASS_FINGER
        def_song_sample GUITAR_DIST
        def_song_sample SNARE_ACOUSTIC
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample KICK_DRUM
        end_song_samples 47

; 30 Umaro (3.11)
        begin_song_samples 48
        def_song_sample WOOD_BLOCK
        def_song_sample OBOE
        def_song_sample TRUMPET
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample FRENCH_HORN
        def_song_sample BASS_FINGER
        def_song_sample TIMPANI
        def_song_sample CRASH_CYMBAL
        end_song_samples 48

; 31 Mog (2.17)
        begin_song_samples 49
        def_song_sample FRENCH_HORN
        def_song_sample TRUMPET
        def_song_sample OBOE
        def_song_sample GUITAR_NYLON
        def_song_sample BANJO
        def_song_sample BASS_FINGER
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ELECTRIC
        def_song_sample TUBA
        end_song_samples 49

; 32 The Unforgiven (1.14)
        begin_song_samples 50
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample FLUTE
        def_song_sample FRENCH_HORN
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        def_song_sample CONTRABASS
        end_song_samples 50

; 33 The Fierce Battle (3.03)
        begin_song_samples 51
        def_song_sample FLUTE
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample SNARE_ACOUSTIC
        def_song_sample CRASH_CYMBAL
        def_song_sample TIMPANI
        def_song_sample SYNTH
        end_song_samples 51

; 34 The Day After (3.06)
        begin_song_samples 52
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample HARP
        def_song_sample GUITAR_NYLON
        def_song_sample MANDOLIN
        def_song_sample BASS_FINGER
        def_song_sample SHAKER
        def_song_sample KICK_DRUM
        end_song_samples 52

; 35 Blackjack (2.15)
        begin_song_samples 53
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample BASS_FINGER
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ACOUSTIC
        def_song_sample FLUTE
        end_song_samples 53

; 36 Catastrophe (3.02)
        begin_song_samples 54
        def_song_sample STRINGS
        def_song_sample FLUTE
        def_song_sample FRENCH_HORN
        def_song_sample CONTRABASS
        def_song_sample BASS_PICK
        def_song_sample TIMPANI
        def_song_sample CRASH_CYMBAL
        end_song_samples 54

; 37 The Magic House (3.10)
        begin_song_samples 55
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample GUITAR_NYLON
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample BASS_FINGER
        end_song_samples 55

; 38 Nighty Night
        begin_song_samples 56
        def_song_sample PIANO
        end_song_samples 56

; 39 Wind
        begin_song_samples 57
        def_song_sample SNARE_ELECTRIC
        end_song_samples 57

; 3A Windy Shores
        begin_song_samples 58
        end_song_samples 58

; 3B Dancing Mad 1, 2, & 3 (3.14)
        begin_song_samples 59
        def_song_sample PIPE_ORGAN
        def_song_sample PIPE_ORGAN_LOW
        def_song_sample VOICE_ALTO
        def_song_sample VOICE_TENOR
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        def_song_sample CRASH_CYMBAL
        def_song_sample BELL
        def_song_sample BASS_PICK
        def_song_sample BREATH
        end_song_samples 59

; 3C Train Braking
        begin_song_samples 60
        end_song_samples 60

; 3D Spinach Rag (2.06)
        begin_song_samples 61
        def_song_sample PIANO
        end_song_samples 61

; 3E Rest in Peace (3.04)
        begin_song_samples 62
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample HARP
        end_song_samples 62

; 3F Chocobos Running
        begin_song_samples 63
        end_song_samples 63

; 40 The Dream of a Train
        begin_song_samples 64
        end_song_samples 64

; 41 Overture 1 (2.07a)
        begin_song_samples 65
        def_song_sample STRINGS
        def_song_sample HARP
        def_song_sample CONTRABASS
        def_song_sample SNARE_ACOUSTIC
        def_song_sample CRASH_CYMBAL
        def_song_sample TIMPANI
        end_song_samples 65

; 42 Overture 2 (2.07b)
        begin_song_samples 66
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample VOICE_BARITONE
        end_song_samples 66

; 43 Overture 3 (2.07c)
        begin_song_samples 67
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample CONTRABASS
        def_song_sample FRENCH_HORN
        def_song_sample SNARE_ACOUSTIC
        def_song_sample CRASH_CYMBAL
        def_song_sample TIMPANI
        def_song_sample FLUTE
        def_song_sample GUITAR_NYLON
        end_song_samples 67

; 44 The Wedding Waltz 2 (2.09b)
        begin_song_samples 68
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        end_song_samples 68

; 45 The Wedding Waltz 3 (2.09c)
        begin_song_samples 69
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample VOICE_BARITONE
        def_song_sample VOICE_ALTO
        def_song_sample VOICE_TENOR
        def_song_sample TRUMPET
        end_song_samples 69

; 46 The Wedding Waltz 4 (2.09d)
        begin_song_samples 70
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        end_song_samples 70

; 47 Devil's Lab (2.14)
        begin_song_samples 71
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample BASS_PICK
        def_song_sample DEVIL_SFX_2
        def_song_sample DEVIL_SFX_1
        def_song_sample KICK_DRUM
        def_song_sample SNARE_ELECTRIC
        end_song_samples 71

; 48 Fire!/Explosion
        begin_song_samples 72
        end_song_samples 72

; 49 Cranes Rising
        begin_song_samples 73
        def_song_sample DEVIL_SFX_2
        end_song_samples 73

; 4A Inside the Burning House
        begin_song_samples 74
        end_song_samples 74

; 4B New Continent (3.01)
        begin_song_samples 75
        def_song_sample STRINGS
        def_song_sample HARP
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TUBA
        def_song_sample CRASH_CYMBAL
        def_song_sample TIMPANI
        def_song_sample BASS_PICK
        end_song_samples 75

; 4C Searching for Friends (3.07)
        begin_song_samples 76
        def_song_sample PAN_FLUTE
        def_song_sample STRINGS
        def_song_sample BASS_PICK
        def_song_sample HIHAT_OPEN
        def_song_sample HIHAT_CLOSED
        def_song_sample VOICE_SYNTH
        end_song_samples 76

; 4D Fanatics (3.12)
        begin_song_samples 77
        def_song_sample VOICE_TENOR
        def_song_sample VOICE_ALTO
        def_song_sample VOICE_BARITONE
        def_song_sample SLEIGH_BELLS
        def_song_sample TIMPANI
        def_song_sample CRASH_CYMBAL
        def_song_sample PIPE_ORGAN
        end_song_samples 77

; 4E Last Dungeon and Aura (3.13)
        begin_song_samples 78
        def_song_sample TRUMPET
        def_song_sample TIMPANI
        def_song_sample STRINGS
        def_song_sample BASS_PICK
        def_song_sample SNARE_ACOUSTIC
        def_song_sample CRASH_CYMBAL
        end_song_samples 78

; 4F Dark World (3.05)
        begin_song_samples 79
        def_song_sample PIPE_ORGAN
        def_song_sample MUSIC_BOX
        def_song_sample BELL
        def_song_sample FLUTE
        def_song_sample PIANO
        end_song_samples 79

; 50 Dancing Mad 5 (3.14)
        begin_song_samples 80
        def_song_sample ROCK_ORGAN
        def_song_sample GUITAR_DIST
        def_song_sample BASS_PICK
        def_song_sample CRASH_CYMBAL
        def_song_sample HIHAT_CLOSED
        def_song_sample HIHAT_OPEN
        def_song_sample TOM_TOM
        def_song_sample SNARE_ELECTRIC
        def_song_sample KICK_DRUM
        def_song_sample PIPE_ORGAN
        end_song_samples 80

; 51 Silence
        begin_song_samples 81
        end_song_samples 81

; 52 Dancing Mad 4 (3.14)
        begin_song_samples 82
        def_song_sample PIPE_ORGAN
        def_song_sample VOICE_ALTO
        def_song_sample VOICE_TENOR
        end_song_samples 82

; 53 Ending Theme 1 (3.15a)
        begin_song_samples 83
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample FLUTE
        def_song_sample OBOE
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample TUBA
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        def_song_sample HARP
        end_song_samples 83

; 54 Ending Theme 2 (3.15b)
        begin_song_samples 84
        def_song_sample STRINGS
        def_song_sample CONTRABASS
        def_song_sample FLUTE
        def_song_sample OBOE
        def_song_sample TRUMPET
        def_song_sample FRENCH_HORN
        def_song_sample TUBA
        def_song_sample CRASH_CYMBAL
        def_song_sample SNARE_ACOUSTIC
        def_song_sample TIMPANI
        def_song_sample HARP
        end_song_samples 84

; ------------------------------------------------------------------------------

.macro inc_sample_brr id, filename
        .ident(.sprintf("SampleBRR_%04x", SAMPLE_BRR::id)) := *
        .incbin .sprintf("src/sound/sample_brr/%s.brr", filename)
.endmac

; c5/4a35 - include instrument sample brr data
        inc_sample_brr GUITAR_STEEL, "guitar_steel"
        inc_sample_brr BASS_FINGER, "bass_finger"
        inc_sample_brr PAN_FLUTE, "pan_flute"
        inc_sample_brr BANJO, "banjo"
        inc_sample_brr CELLO, "cello"
        inc_sample_brr VOICE_SYNTH, "voice_synth"
        inc_sample_brr FLUTE, "flute"
        inc_sample_brr FRENCH_HORN, "french_horn"
        inc_sample_brr SYNTH, "synth"
        inc_sample_brr OBOE, "oboe"
        inc_sample_brr ROCK_ORGAN, "rock_organ"
        inc_sample_brr PIANO, "piano"
        inc_sample_brr STRINGS, "strings"
        inc_sample_brr TRUMPET, "trumpet"
        inc_sample_brr HIHAT_CLOSED, "hihat_closed"
        inc_sample_brr JEWS_HARP, "jews_harp"
        inc_sample_brr HIHAT_OPEN, "hihat_open"
        inc_sample_brr CRASH_CYMBAL, "crash_cymbal"
        inc_sample_brr BREATH, "breath"
        inc_sample_brr SNARE_ACOUSTIC, "snare_acoustic"
        inc_sample_brr FOOTSTEP, "footstep"
        inc_sample_brr TIMPANI, "timpani"
        inc_sample_brr TOM_TOM, "tom_tom"
        inc_sample_brr PIZZ_BASS, "pizz_bass"
        inc_sample_brr PIZZ_STRINGS, "pizz_strings"
        inc_sample_brr TUBA, "tuba"
        inc_sample_brr HARP, "harp"
        inc_sample_brr BASS_PICK, "bass_pick"
        inc_sample_brr MANDOLIN, "mandolin"
        inc_sample_brr GUITAR_DIST, "guitar_dist"
        inc_sample_brr WHISTLE, "whistle"
        inc_sample_brr CELESTA, "celesta"
        inc_sample_brr SNARE_ELECTRIC, "snare_electric"
        inc_sample_brr KICK_DRUM, "kick_drum"
        inc_sample_brr COWBELL, "cowbell"
        inc_sample_brr BELL, "bell"
        inc_sample_brr PIPE_ORGAN, "pipe_organ"
        inc_sample_brr LAUGH, "laugh"
        inc_sample_brr CHOCOBO_1, "chocobo_1"
        inc_sample_brr CHOCOBO_2, "chocobo_2"
        inc_sample_brr CHOCOBO_3, "chocobo_3"
        inc_sample_brr FINGER_SNAP, "finger_snap"
        inc_sample_brr RIMSHOT, "rimshot"
        inc_sample_brr CONTRABASS, "contrabass"
        inc_sample_brr RATCHET, "ratchet"
        inc_sample_brr BONGO, "bongo"
        inc_sample_brr SHAKER, "shaker"
        inc_sample_brr WOOD_BLOCK, "wood_block"
        inc_sample_brr MUSIC_BOX, "music_box"
        inc_sample_brr GUITAR_NYLON, "guitar_nylon"
        inc_sample_brr BAGPIPES, "bagpipes"
        inc_sample_brr SHAKUHACHI, "shakuhachi"
        inc_sample_brr TOWN_1, "town_1"
        inc_sample_brr TOWN_2, "town_2"
        inc_sample_brr SLEIGH_BELLS, "sleigh_bells"
        inc_sample_brr VOICE_TENOR, "voice_tenor"
        inc_sample_brr VOICE_BARITONE, "voice_baritone"
        inc_sample_brr VOICE_ALTO, "voice_alto"
        inc_sample_brr PIPE_ORGAN_LOW, "pipe_organ_low"
        inc_sample_brr DEVIL_SFX_1, "devil_sfx_1"
        inc_sample_brr DEVIL_SFX_2, "devil_sfx_2"
        inc_sample_brr XYLOPHONE, "xylophone"
        inc_sample_brr CROWD_NOISE, "crowd_noise"

; ------------------------------------------------------------------------------

.macro inc_song_script id, filename
        .ident(.sprintf("SongScript_%04x", SONG::id)) := *
        .include .sprintf("song_script/%s", filename)
.endmac

; c8/5c7a
        SongScript_0051 := *
        inc_song_script SILENCE, "silence.asm"
        inc_song_script PRELUDE, "prelude.asm"
        inc_song_script AWAKENING, "awakening.asm"
        inc_song_script TERRA, "terra.asm"
        inc_song_script SHADOW, "shadow.asm"
        inc_song_script STRAGO, "strago.asm"
        inc_song_script GAU, "gau.asm"
        inc_song_script FIGARO, "figaro.asm"
        inc_song_script COIN_SONG, "coin_song.asm"
        inc_song_script CYAN, "cyan.asm"
        inc_song_script LOCKE, "locke.asm"
        inc_song_script FOREVER_RACHEL, "forever_rachel.asm"
        inc_song_script RELM, "relm.asm"
        inc_song_script SETZER, "setzer.asm"
        inc_song_script EPITAPH, "epitaph.asm"
        inc_song_script CELES, "celes.asm"
        inc_song_script TECHNO_DE_CHOCOBO, "techno_de_chocobo.asm"
        .include "song_script/unused.asm"
        inc_song_script DECISIVE_BATTLE, "decisive_battle.asm"
        inc_song_script JOHNNY_C_BAD, "johnny_c_bad.asm"
        inc_song_script OPENING_THEME_2, "opening_2.asm"
        inc_song_script KEFKA, "kefka.asm"
        inc_song_script NARSHE, "narshe.asm"
        inc_song_script PHANTOM_FOREST, "phantom_forest.asm"
        inc_song_script OPENING_THEME_3, "opening_3.asm"
        inc_song_script VELDT, "veldt.asm"
        inc_song_script SAVE_THEM, "save_them.asm"
        inc_song_script GESTAHL, "gestahl.asm"
        inc_song_script TROOPS_MARCH_ON, "troops_march_on.asm"
        inc_song_script UNDER_MARTIAL_LAW, "under_martial_law.asm"
        inc_song_script WATERFALL, "waterfall.asm"
        inc_song_script METAMORPHOSIS, "metamorphosis.asm"
        inc_song_script PHANTOM_TRAIN, "phantom_train.asm"
        inc_song_script ESPER_WORLD, "esper_world.asm"
        inc_song_script GRAND_FINALE_2, "grand_finale_2.asm"
        inc_song_script MT_KOLTS, "mt_kolts.asm"
        inc_song_script BATTLE_THEME, "battle_theme.asm"
        inc_song_script FANFARE, "fanfare.asm"
        inc_song_script WEDDING_WALTZ_1, "wedding_waltz_1.asm"
        inc_song_script ARIA_DI_MEZZO_CARATERRE, "aria_di_mezzo_caraterre.asm"
        inc_song_script KIDS_RUN_THROUGH_THE_CITY, "kids_run_through_the_city.asm"
        inc_song_script GOGO, "gogo.asm"
        inc_song_script RETURNERS, "returners.asm"
        inc_song_script VICTORY_FANFARE, "victory_fanfare.asm"
        inc_song_script UMARO, "umaro.asm"
        inc_song_script MOG, "mog.asm"
        inc_song_script THE_UNFORGIVEN, "the_unforgiven.asm"
        inc_song_script FIERCE_BATTLE, "fierce_battle.asm"
        inc_song_script DAY_AFTER, "day_after.asm"
        inc_song_script BLACKJACK, "blackjack.asm"
        inc_song_script CATASTROPHE, "catastrophe.asm"
        inc_song_script MAGIC_HOUSE, "magic_house.asm"
        inc_song_script NIGHTY_NIGHT, "nighty_night.asm"
        inc_song_script WIND, "wind.asm"
        inc_song_script WINDY_SHORES, "windy_shores.asm"
        inc_song_script DANCING_MAD_1_2_3, "dancing_mad_1_2_3.asm"
        inc_song_script TRAIN_BRAKING, "train_braking.asm"
        inc_song_script SPINACH_RAG, "spinach_rag.asm"
        inc_song_script REST_IN_PEACE, "rest_in_peace.asm"
        inc_song_script CHOCOBOS_RUNNING, "chocobos_running.asm"
        inc_song_script DREAM_OF_A_TRAIN, "dream_of_a_train.asm"
        inc_song_script OVERTURE_1, "overture_1.asm"
        inc_song_script OVERTURE_2, "overture_2.asm"
        inc_song_script OVERTURE_3, "overture_3.asm"
        inc_song_script WEDDING_WALTZ_2, "wedding_waltz_2.asm"
        inc_song_script WEDDING_WALTZ_3, "wedding_waltz_3.asm"
        inc_song_script WEDDING_WALTZ_4, "wedding_waltz_4.asm"
        inc_song_script OPENING_THEME_1, "opening_1.asm"
        inc_song_script DEVILS_LAB, "devils_lab.asm"
        inc_song_script FIRE_EXPLOSION, "fire_explosion.asm"
        inc_song_script CRANES_RISING, "cranes_rising.asm"
        inc_song_script BURNING_HOUSE, "burning_house.asm"
        inc_song_script HUH, "huh.asm"
        inc_song_script SERPENT_TRENCH, "serpent_trench.asm"
        inc_song_script SLAM_SHUFFLE, "slam_shuffle.asm"
        inc_song_script GRAND_FINALE_1, "grand_finale_1.asm"
        inc_song_script NEW_CONTINENT, "new_continent.asm"
        inc_song_script SEARCHING_FOR_FRIENDS, "searching_for_friends.asm"
        inc_song_script FANATICS, "fanatics.asm"
        inc_song_script LAST_DUNGEON, "last_dungeon.asm"
        inc_song_script DARK_WORLD, "dark_world.asm"
        inc_song_script DANCING_MAD_5, "dancing_mad_5.asm"
        inc_song_script DANCING_MAD_4, "dancing_mad_4.asm"
        inc_song_script ENDING_THEME_1, "ending_1.asm"
        inc_song_script ENDING_THEME_2, "ending_2.asm"

; ------------------------------------------------------------------------------
