
; ------------------------------------------------------------------------------

; [ make song sample list ]

.mac song_samples
        _song_sample_seq .set 0
.endmac

.mac sample sample_id
        ; use the sample id plus 1 (zero means no sample)
        .word SAMPLE_BRR::sample_id + 1
        ; count how many samples have been used
        _song_sample_seq .set _song_sample_seq + 1
.endmac

.mac end_song_samples
        ; fill remaining space with zeroes (32 bytes total)
        .res 32 - _song_sample_seq * 2, 0
.endmac

.mac inc_sample_brr id, filename
        array_label SAMPLE_BRR, SAMPLE_BRR::id
        .incbin .sprintf("assets/sound/sample_brr/%s.brr", filename)
.endmac

; ------------------------------------------------------------------------------

; c5/3c5f
SampleBRRPtrs:
        ptr_tbl_far SAMPLE_BRR

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
        adsr 15,7,7,17             ; GUITAR_STEEL
        adsr 15,7,7,14             ; BASS_FINGER
        adsr 15,7,7,0              ; PAN_FLUTE
        adsr 15,7,7,19             ; BANJO
        adsr 15,7,7,0              ; CELLO
        adsr 15,7,7,0              ; VOICE_SYNTH
        adsr 15,7,7,0              ; FLUTE
        adsr 15,7,7,0              ; FRENCH_HORN
        adsr 15,7,7,0              ; SYNTH
        adsr 15,7,7,0              ; OBOE
        adsr 15,7,7,0              ; ROCK_ORGAN
        adsr 15,7,7,15             ; PIANO
        adsr 15,7,7,0              ; STRINGS
        adsr 15,7,7,0              ; TRUMPET
        adsr 15,7,7,0              ; HIHAT_CLOSED
        adsr 15,7,7,0              ; JEWS_HARP
        adsr 15,7,7,0              ; HIHAT_OPEN
        adsr 15,7,7,14             ; CRASH_CYMBAL
        adsr 15,7,7,0              ; BREATH
        adsr 15,7,7,0              ; SNARE_ACOUSTIC
        adsr 15,7,7,0              ; FOOTSTEP
        adsr 15,7,7,0              ; TIMPANI
        adsr 15,7,7,0              ; TOM_TOM
        adsr 15,7,7,12             ; PIZZ_BASS
        adsr 15,7,7,21             ; PIZZ_STRINGS
        adsr 15,7,7,0              ; TUBA
        adsr 15,7,7,16             ; HARP
        adsr 15,7,7,0              ; BASS_PICK
        adsr 15,7,7,16             ; MANDOLIN
        adsr 15,7,7,0              ; GUITAR_DIST
        adsr 15,7,7,0              ; WHISTLE
        adsr 15,7,7,10             ; CELESTA
        adsr 15,7,7,0              ; SNARE_ELECTRIC
        adsr 15,7,7,0              ; KICK_DRUM
        adsr 15,7,7,0              ; COWBELL
        adsr 15,7,7,10             ; BELL
        adsr 15,7,7,0              ; PIPE_ORGAN
        adsr 15,7,7,0              ; LAUGH
        adsr 15,7,7,0              ; CHOCOBO_1
        adsr 15,7,7,0              ; CHOCOBO_2
        adsr 15,7,7,0              ; CHOCOBO_3
        adsr 15,7,7,0              ; FINGER_SNAP
        adsr 15,7,7,0              ; RIMSHOT
        adsr 15,7,7,0              ; CONTRABASS
        adsr 15,7,7,0              ; RATCHET
        adsr 15,7,7,19             ; BONGO
        adsr 15,7,7,0              ; SHAKER
        adsr 15,7,7,0              ; WOOD_BLOCK
        adsr 15,7,7,13             ; MUSIC_BOX
        adsr 15,7,7,16             ; GUITAR_NYLON
        adsr 15,7,7,0              ; BAGPIPES
        adsr 15,7,7,0              ; SHAKUHACHI
        adsr 15,7,7,0              ; TOWN_1
        adsr 15,7,7,0              ; TOWN_2
        adsr 15,7,7,0              ; SLEIGH_BELLS
        adsr 15,7,7,0              ; VOICE_TENOR
        adsr 15,7,7,0              ; VOICE_BARITONE
        adsr 15,7,7,0              ; VOICE_ALTO
        adsr 15,7,7,0              ; PIPE_ORGAN_LOW
        adsr 15,7,7,0              ; DEVIL_SFX_1
        adsr 15,7,7,0              ; DEVIL_SFX_2
        adsr 15,7,7,12             ; XYLOPHONE
        adsr 15,7,7,0              ; CROWD_NOISE

; ------------------------------------------------------------------------------

; c5/3e96
SongScriptPtrs:
        ptr_tbl_far SONG_SCRIPT

; ------------------------------------------------------------------------------

SongSamples:

; 00 Silence
        song_samples
        end_song_samples

; 01 The Prelude (3.16)
        song_samples
        sample HARP
        sample FLUTE
        sample STRINGS
        sample VOICE_SYNTH
        sample CONTRABASS
        end_song_samples

; 02 Opening Theme 1 (1.01a)
        song_samples
        sample PIPE_ORGAN
        sample VOICE_ALTO
        sample VOICE_TENOR
        sample PIANO
        end_song_samples

; 03 Opening Theme 2 (1.01b)
        song_samples
        sample STRINGS
        sample FRENCH_HORN
        sample HARP
        sample TRUMPET
        sample BASS_PICK
        sample FLUTE
        sample BELL
        sample TUBA
        end_song_samples

; 04 Opening Theme 3 (1.01c)
        song_samples
        sample OBOE
        sample STRINGS
        sample HARP
        sample FRENCH_HORN
        sample SNARE_ACOUSTIC
        sample BASS_FINGER
        end_song_samples

; 05 Awakening (1.03)
        song_samples
        sample PIANO
        sample FLUTE
        sample HARP
        sample STRINGS
        sample BASS_PICK
        sample OBOE
        end_song_samples

; 06 Terra (2.01)
        song_samples
        sample PAN_FLUTE
        sample CRASH_CYMBAL
        sample STRINGS
        sample MANDOLIN
        sample FRENCH_HORN
        sample TIMPANI
        sample BASS_PICK
        sample SNARE_ACOUSTIC
        end_song_samples

; 07 Shadow (1.11)
        song_samples
        sample JEWS_HARP
        sample WHISTLE
        sample GUITAR_NYLON
        sample PIZZ_BASS
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample KICK_DRUM
        sample SNARE_ACOUSTIC
        sample RIMSHOT
        end_song_samples

; 08 Strago (2.18)
        song_samples
        sample FLUTE
        sample ROCK_ORGAN
        sample OBOE
        sample BANJO
        sample BASS_FINGER
        sample KICK_DRUM
        sample HIHAT_OPEN
        sample FINGER_SNAP
        sample WOOD_BLOCK
        sample COWBELL
        end_song_samples

; 09 Gau (1.18)
        song_samples
        sample CELLO
        sample FLUTE
        sample GUITAR_NYLON
        sample STRINGS
        sample GUITAR_STEEL
        sample HARP
        sample BASS_PICK
        end_song_samples

; 0A Edgar & Sabin (1.07)
        song_samples
        sample TRUMPET
        sample STRINGS
        sample FRENCH_HORN
        sample CRASH_CYMBAL
        sample TIMPANI
        sample TUBA
        end_song_samples

; 0B Coin Song (2.02)
        song_samples
        sample FLUTE
        sample STRINGS
        sample OBOE
        sample BASS_PICK
        end_song_samples

; 0C Cyan (1.13)
        song_samples
        sample FRENCH_HORN
        sample SHAKUHACHI
        sample STRINGS
        sample SLEIGH_BELLS
        sample CRASH_CYMBAL
        sample TIMPANI
        sample CONTRABASS
        end_song_samples

; 0D Locke (1.04)
        song_samples
        sample STRINGS
        sample FRENCH_HORN
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        sample CONTRABASS
        end_song_samples

; 0E Forever Rachel (2.04)
        song_samples
        sample HARP
        sample BASS_PICK
        sample FRENCH_HORN
        sample OBOE
        sample FLUTE
        sample STRINGS
        end_song_samples

; 0F Relm (2.19)
        song_samples
        sample BAGPIPES
        sample FLUTE
        sample OBOE
        sample HARP
        sample MANDOLIN
        sample STRINGS
        sample FRENCH_HORN
        end_song_samples

; 10 Setzer (2.11)
        song_samples
        sample STRINGS
        sample FRENCH_HORN
        sample TRUMPET
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        sample CONTRABASS
        end_song_samples

; 11 Epitaph (3.09)
        song_samples
        sample MUSIC_BOX
        sample GUITAR_STEEL
        sample FLUTE
        end_song_samples

; 12 Celes (1.22)
        song_samples
        sample FLUTE
        sample STRINGS
        sample HARP
        sample CELESTA
        end_song_samples

; 13 Techno de Chocobo (2.03)
        song_samples
        sample GUITAR_DIST
        sample ROCK_ORGAN
        sample BASS_PICK
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample SHAKER
        sample SNARE_ACOUSTIC
        sample KICK_DRUM
        sample CHOCOBO_1
        sample CHOCOBO_2
        sample CHOCOBO_3
        end_song_samples

; 14 The Decisive Battle (1.24)
        song_samples
        sample STRINGS
        sample ROCK_ORGAN
        sample GUITAR_DIST
        sample BASS_PICK
        sample CRASH_CYMBAL
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample KICK_DRUM
        sample SNARE_ELECTRIC
        end_song_samples

; 15 Johnny C. Bad (2.12)
        song_samples
        sample PIANO
        sample GUITAR_NYLON
        sample PIZZ_BASS
        sample SNARE_ACOUSTIC
        end_song_samples

; 16 Kefka (1.08)
        song_samples
        sample PIZZ_STRINGS
        sample STRINGS
        sample TRUMPET
        sample FRENCH_HORN
        sample OBOE
        sample FLUTE
        sample HARP
        sample TIMPANI
        sample SNARE_ACOUSTIC
        sample CRASH_CYMBAL
        sample CONTRABASS
        end_song_samples

; 17 The Mines of Narshe (1.02)
        song_samples
        sample STRINGS
        sample PIZZ_BASS
        sample HARP
        sample FOOTSTEP
        sample PIANO
        sample OBOE
        sample BREATH
        end_song_samples

; 18 Phantom Forest (1.15)
        song_samples
        sample FLUTE
        sample STRINGS
        sample VOICE_SYNTH
        sample GUITAR_NYLON
        sample PIZZ_BASS
        sample OBOE
        sample BREATH
        end_song_samples

; 19 Veldt (1.17)
        song_samples
        sample TOM_TOM
        sample KICK_DRUM
        sample SHAKER
        sample OBOE
        sample BONGO
        sample STRINGS
        sample RATCHET
        sample CONTRABASS
        sample COWBELL
        end_song_samples

; 1A Save Them! (1.23)
        song_samples
        sample STRINGS
        sample TRUMPET
        sample CONTRABASS
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        sample TUBA
        end_song_samples

; 1B The Emperor Gestahl (2.13)
        song_samples
        sample TRUMPET
        sample FRENCH_HORN
        sample STRINGS
        sample SNARE_ACOUSTIC
        sample BELL
        sample BASS_PICK
        sample TIMPANI
        end_song_samples

; 1C Troops March On (1.12)
        song_samples
        sample STRINGS
        sample TRUMPET
        sample FRENCH_HORN
        sample BASS_FINGER
        sample SNARE_ACOUSTIC
        sample TIMPANI
        end_song_samples

; 1D Under Martial Law (1.21)
        song_samples
        sample HARP
        sample STRINGS
        sample OBOE
        sample FRENCH_HORN
        sample BASS_FINGER
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample KICK_DRUM
        end_song_samples

; 1E Waterfall
        song_samples
        end_song_samples

; 1F Metamorphosis (1.25)
        song_samples
        sample STRINGS
        sample TRUMPET
        sample FRENCH_HORN
        sample BASS_FINGER
        sample CRASH_CYMBAL
        sample KICK_DRUM
        sample SNARE_ELECTRIC
        sample TOM_TOM
        end_song_samples

; 20 Phantom Train (2.16)
        song_samples
        sample GUITAR_NYLON
        sample TRUMPET
        sample STRINGS
        sample CONTRABASS
        sample TUBA
        sample TIMPANI
        sample FLUTE
        sample SNARE_ACOUSTIC
        sample HIHAT_CLOSED
        end_song_samples

; 21 Another World of Beasts (2.20)
        song_samples
        sample PIANO
        sample HARP
        sample FLUTE
        sample STRINGS
        sample BASS_PICK
        end_song_samples

; 22 Grand Finale 2 (2.10b)
        song_samples
        sample FRENCH_HORN
        sample TRUMPET
        sample STRINGS
        sample CONTRABASS
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        end_song_samples

; 23 Mt. Kolts (1.09)
        song_samples
        sample STRINGS
        sample FRENCH_HORN
        sample ROCK_ORGAN
        sample HARP
        sample GUITAR_DIST
        sample BASS_FINGER
        sample TOM_TOM
        end_song_samples

; 24 Battle Theme (1.05)
        song_samples
        sample STRINGS
        sample TRUMPET
        sample GUITAR_DIST
        sample BASS_FINGER
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample CRASH_CYMBAL
        sample KICK_DRUM
        sample SNARE_ACOUSTIC
        end_song_samples

; 25 Fanfare
        song_samples
        sample TRUMPET
        sample TUBA
        end_song_samples

; 26 The Wedding Waltz 1 (2.09a)
        song_samples
        sample FLUTE
        sample HARP
        sample STRINGS
        sample CONTRABASS
        sample SNARE_ACOUSTIC
        end_song_samples

; 27 Aria de Mezzo Caraterre (2.08)
        song_samples
        sample VOICE_ALTO
        sample STRINGS
        sample CONTRABASS
        sample HARP
        sample FRENCH_HORN
        sample VOICE_ALTO
        end_song_samples

; 28 The Serpent Trench (1.19)
        song_samples
        sample FRENCH_HORN
        sample STRINGS
        sample CONTRABASS
        end_song_samples

; 29 Slam Shuffle (2.05)
        song_samples
        end_song_samples

; 2A Kids Run Through the City Corner (1.20)
        song_samples
        sample TOWN_1
        sample PIZZ_BASS
        sample GUITAR_NYLON
        sample STRINGS
        sample TOWN_2
        end_song_samples

; 2B ??? (2.16)
        song_samples
        sample XYLOPHONE
        sample RATCHET
        sample WOOD_BLOCK
        sample LAUGH
        sample SLEIGH_BELLS
        sample SHAKER
        sample HIHAT_OPEN
        sample TOM_TOM
        sample KICK_DRUM
        sample SNARE_ACOUSTIC
        end_song_samples

; 2C Grand Finale 1 (2.10a)
        song_samples
        sample CROWD_NOISE
        end_song_samples

; 2D Gogo (3.08)
        song_samples
        sample OBOE
        sample FLUTE
        sample FRENCH_HORN
        sample TRUMPET
        sample BASS_FINGER
        sample TIMPANI
        sample CRASH_CYMBAL
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample KICK_DRUM
        sample SNARE_ACOUSTIC
        end_song_samples

; 2E Returners (1.10)
        song_samples
        sample FRENCH_HORN
        sample TRUMPET
        sample STRINGS
        sample CONTRABASS
        sample CRASH_CYMBAL
        sample BASS_PICK
        sample SNARE_ACOUSTIC
        end_song_samples

; 2F Fanfare (1.06)
        song_samples
        sample TRUMPET
        sample BASS_FINGER
        sample GUITAR_DIST
        sample SNARE_ACOUSTIC
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample KICK_DRUM
        end_song_samples

; 30 Umaro (3.11)
        song_samples
        sample WOOD_BLOCK
        sample OBOE
        sample TRUMPET
        sample FLUTE
        sample STRINGS
        sample FRENCH_HORN
        sample BASS_FINGER
        sample TIMPANI
        sample CRASH_CYMBAL
        end_song_samples

; 31 Mog (2.17)
        song_samples
        sample FRENCH_HORN
        sample TRUMPET
        sample OBOE
        sample GUITAR_NYLON
        sample BANJO
        sample BASS_FINGER
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample KICK_DRUM
        sample SNARE_ELECTRIC
        sample TUBA
        end_song_samples

; 32 The Unforgiven (1.14)
        song_samples
        sample STRINGS
        sample TRUMPET
        sample FLUTE
        sample FRENCH_HORN
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        sample CONTRABASS
        end_song_samples

; 33 The Fierce Battle (3.03)
        song_samples
        sample FLUTE
        sample TRUMPET
        sample FRENCH_HORN
        sample STRINGS
        sample CONTRABASS
        sample SNARE_ACOUSTIC
        sample CRASH_CYMBAL
        sample TIMPANI
        sample SYNTH
        end_song_samples

; 34 The Day After (3.06)
        song_samples
        sample OBOE
        sample FLUTE
        sample HARP
        sample GUITAR_NYLON
        sample MANDOLIN
        sample BASS_FINGER
        sample SHAKER
        sample KICK_DRUM
        end_song_samples

; 35 Blackjack (2.15)
        song_samples
        sample STRINGS
        sample TRUMPET
        sample FRENCH_HORN
        sample BASS_FINGER
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample KICK_DRUM
        sample SNARE_ACOUSTIC
        sample FLUTE
        end_song_samples

; 36 Catastrophe (3.02)
        song_samples
        sample STRINGS
        sample FLUTE
        sample FRENCH_HORN
        sample CONTRABASS
        sample BASS_PICK
        sample TIMPANI
        sample CRASH_CYMBAL
        end_song_samples

; 37 The Magic House (3.10)
        song_samples
        sample OBOE
        sample FLUTE
        sample GUITAR_NYLON
        sample STRINGS
        sample CONTRABASS
        sample BASS_FINGER
        end_song_samples

; 38 Nighty Night
        song_samples
        sample PIANO
        end_song_samples

; 39 Wind
        song_samples
        sample SNARE_ELECTRIC
        end_song_samples

; 3A Windy Shores
        song_samples
        end_song_samples

; 3B Dancing Mad 1, 2, & 3 (3.14)
        song_samples
        sample PIPE_ORGAN
        sample PIPE_ORGAN_LOW
        sample VOICE_ALTO
        sample VOICE_TENOR
        sample SNARE_ACOUSTIC
        sample TIMPANI
        sample CRASH_CYMBAL
        sample BELL
        sample BASS_PICK
        sample BREATH
        end_song_samples

; 3C Train Braking
        song_samples
        end_song_samples

; 3D Spinach Rag (2.06)
        song_samples
        sample PIANO
        end_song_samples

; 3E Rest in Peace (3.04)
        song_samples
        sample FLUTE
        sample STRINGS
        sample CONTRABASS
        sample HARP
        end_song_samples

; 3F Chocobos Running
        song_samples
        end_song_samples

; 40 The Dream of a Train
        song_samples
        end_song_samples

; 41 Overture 1 (2.07a)
        song_samples
        sample STRINGS
        sample HARP
        sample CONTRABASS
        sample SNARE_ACOUSTIC
        sample CRASH_CYMBAL
        sample TIMPANI
        end_song_samples

; 42 Overture 2 (2.07b)
        song_samples
        sample STRINGS
        sample CONTRABASS
        sample VOICE_BARITONE
        end_song_samples

; 43 Overture 3 (2.07c)
        song_samples
        sample STRINGS
        sample TRUMPET
        sample CONTRABASS
        sample FRENCH_HORN
        sample SNARE_ACOUSTIC
        sample CRASH_CYMBAL
        sample TIMPANI
        sample FLUTE
        sample GUITAR_NYLON
        end_song_samples

; 44 The Wedding Waltz 2 (2.09b)
        song_samples
        sample STRINGS
        sample CONTRABASS
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        end_song_samples

; 45 The Wedding Waltz 3 (2.09c)
        song_samples
        sample STRINGS
        sample CONTRABASS
        sample VOICE_BARITONE
        sample VOICE_ALTO
        sample VOICE_TENOR
        sample TRUMPET
        end_song_samples

; 46 The Wedding Waltz 4 (2.09d)
        song_samples
        sample STRINGS
        sample CONTRABASS
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        end_song_samples

; 47 Devil's Lab (2.14)
        song_samples
        sample TRUMPET
        sample STRINGS
        sample CONTRABASS
        sample BASS_PICK
        sample DEVIL_SFX_2
        sample DEVIL_SFX_1
        sample KICK_DRUM
        sample SNARE_ELECTRIC
        end_song_samples

; 48 Fire!/Explosion
        song_samples
        end_song_samples

; 49 Cranes Rising
        song_samples
        sample DEVIL_SFX_2
        end_song_samples

; 4A Inside the Burning House
        song_samples
        end_song_samples

; 4B New Continent (3.01)
        song_samples
        sample STRINGS
        sample HARP
        sample SNARE_ACOUSTIC
        sample TUBA
        sample CRASH_CYMBAL
        sample TIMPANI
        sample BASS_PICK
        end_song_samples

; 4C Searching for Friends (3.07)
        song_samples
        sample PAN_FLUTE
        sample STRINGS
        sample BASS_PICK
        sample HIHAT_OPEN
        sample HIHAT_CLOSED
        sample VOICE_SYNTH
        end_song_samples

; 4D Fanatics (3.12)
        song_samples
        sample VOICE_TENOR
        sample VOICE_ALTO
        sample VOICE_BARITONE
        sample SLEIGH_BELLS
        sample TIMPANI
        sample CRASH_CYMBAL
        sample PIPE_ORGAN
        end_song_samples

; 4E Last Dungeon and Aura (3.13)
        song_samples
        sample TRUMPET
        sample TIMPANI
        sample STRINGS
        sample BASS_PICK
        sample SNARE_ACOUSTIC
        sample CRASH_CYMBAL
        end_song_samples

; 4F Dark World (3.05)
        song_samples
        sample PIPE_ORGAN
        sample MUSIC_BOX
        sample BELL
        sample FLUTE
        sample PIANO
        end_song_samples

; 50 Dancing Mad 5 (3.14)
        song_samples
        sample ROCK_ORGAN
        sample GUITAR_DIST
        sample BASS_PICK
        sample CRASH_CYMBAL
        sample HIHAT_CLOSED
        sample HIHAT_OPEN
        sample TOM_TOM
        sample SNARE_ELECTRIC
        sample KICK_DRUM
        sample PIPE_ORGAN
        end_song_samples

; 51 Silence
        song_samples
        end_song_samples

; 52 Dancing Mad 4 (3.14)
        song_samples
        sample PIPE_ORGAN
        sample VOICE_ALTO
        sample VOICE_TENOR
        end_song_samples

; 53 Ending Theme 1 (3.15a)
        song_samples
        sample STRINGS
        sample CONTRABASS
        sample FLUTE
        sample OBOE
        sample TRUMPET
        sample FRENCH_HORN
        sample TUBA
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        sample HARP
        end_song_samples

; 54 Ending Theme 2 (3.15b)
        song_samples
        sample STRINGS
        sample CONTRABASS
        sample FLUTE
        sample OBOE
        sample TRUMPET
        sample FRENCH_HORN
        sample TUBA
        sample CRASH_CYMBAL
        sample SNARE_ACOUSTIC
        sample TIMPANI
        sample HARP
        end_song_samples

; ------------------------------------------------------------------------------

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

.delmac song_samples
.delmac sample
.delmac end_song_samples
.delmac inc_sample_brr