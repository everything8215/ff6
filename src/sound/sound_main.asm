
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: sound/sound_main.asm                                                 |
; |                                                                            |
; | description: sound program                                                 |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"
.include "code_ext.inc"

; ------------------------------------------------------------------------------

; [ begin/end block of SPC data ]

; each spc block is preceded by a 2-byte header containing the block size
.macro begin_spc_block _label
        .proc .ident(.string(_label))
        .word .ident(.sprintf("%s_SIZE", .string(_label))) - 2
.endmac

.macro end_spc_block _label
        .endproc
        .ident(.sprintf("%s_SIZE", .string(_label))) = .sizeof(.ident(.string(_label)))
.endmac

; ------------------------------------------------------------------------------

; [ make adsr value ]

.macro make_adsr attack, decay, sustain, release
        .byte $80 | (attack & $0f) | ((decay & $07) << 4)
        .byte (release & $1f) | ((sustain & $07) << 5)
.endmac

; ------------------------------------------------------------------------------

; [ make song sample list ]

.macro def_song_sample _sample_id
        ; use the sample id plus 1 (zero means no sample)
        .word _sample_id+1
.endmac

.macro begin_song_samples _song_id
        ; save the start position for this song's samples
        .ident(.sprintf("SongSamples_%04x", _song_id)) := *
.endmac

.macro end_song_samples _song_id
        ; fill remaining space with zeroes (32 bytes total)
        .res 32 + .ident(.sprintf("SongSamples_%04x", _song_id)) - *, 0
.endmac

; ------------------------------------------------------------------------------

.segment "sound_code"
.a8
.i16

; ------------------------------------------------------------------------------

InitSound_ext:
@0000:  jmp   InitSound
        nop

ExecSound_ext:
@0004:  jmp   ExecSound
        nop

TfrSong_ext:
@0008:  jmp   TfrSong
        nop

TfrSongScript_ext:
@000c:  jmp   TfrSongScript
        nop

; ------------------------------------------------------------------------------

; pointers to spc blocks (+$c50000)
InitTfrSrcTbl:
@0010:  .addr   SPCCode
        .addr   SfxPtrs
        .addr   SfxBRR
        .addr   SfxLoopStart
        .addr   SfxADSR
        .addr   SfxFreqMult

; destination address of each spc block
InitTfrDestTbl:
@001c:  .word   $0200,$2c00,$4800,$1b00,$1a80,$1a00

; pointers to misc spc data (+$C50000, unused)
@0028:  .addr   SongScriptPtrs
        .addr   SampleBRRPtrs
        .addr   SampleLoopStart
        .addr   SampleADSR
        .addr   SampleFreqMult
        .addr   SongSamples

; ------------------------------------------------------------------------------

; [ init spc ]

InitSound:
@0034:  phb
        phd
        php
        longa
        longi
        pha
        phx
        phy
        shorta
        lda     #$00
        pha
        plb
        ldx     #$1300                  ; set dp to $1300
        phx
        pld
        ldx     #$bbaa
        ldy     #$f0ff                  ; interrupt command $ff, subcommand $f0 (reset spc)
@004f:  sty     hAPUIO0
        cpx     hAPUIO0                 ; wait for acknowledgement from spc
        bne     @004f
        ldx     #$0000
        lda     f:InitTfrDestTbl        ; destination address of first spc chunk ($0200)
        sta     hAPUIO2
        lda     f:InitTfrDestTbl+1
        sta     hAPUIO3
        lda     #$cc
        sta     hAPUIO1
        sta     hAPUIO0
@0070:  cmp     hAPUIO0                 ; wait for acknowledgement from spc
        bne     @0070
@0075:  lda     #$00
        xba
        lda     f:InitTfrSrcTbl,x       ; pointer to spc chunk
        sta     $10
        lda     f:InitTfrSrcTbl+1,x
        sta     $11
        lda     #$c5
        sta     $12
        ldy     #$0000
        lda     [$10],y
        clc
        adc     #$02
        sta     $1c                     ; +$1c = total length of chunk
        iny
        lda     [$10],y
        adc     #$00
        sta     $1d
        iny
@009a:  lda     [$10],y                 ; copy one byte
        sta     hAPUIO1
        xba
        sta     hAPUIO0
@00a3:  cmp     hAPUIO0                 ; wait for acknowledgement from spc
        bne     @00a3
        inc                             ; next byte
        xba
        iny
        cpy     $1c
        bne     @009a
        xba                             ; next chunk
        inc3
        bne     @00b6
        inc
@00b6:  inx2
        cpx     #$000c
        beq     @00da
        xba
        lda     f:InitTfrDestTbl,x      ; destination address of next spc chunk
        sta     hAPUIO2
        lda     f:InitTfrDestTbl+1,x
        sta     hAPUIO3
        xba
        sta     hAPUIO1
        sta     hAPUIO0
@00d3:  cmp     hAPUIO0                 ; wait for acknowledgement from spc
        bne     @00d3
        bra     @0075
@00da:  ldy     #$0200                  ; spc start address = $0200
        sty     hAPUIO2
        xba
        lda     #$00                    ; 0 indicates that this is the last chunk
        sta     hAPUIO1
        xba
        sta     hAPUIO0
@00ea:  cmp     hAPUIO0                 ; wait for acknowledgement from spc
        bne     @00ea
        xba
        sta     hAPUIO0
        ldx     #$0100
@00f6:  sta     $12ff,x                 ; clear $1300-$13ff
        dex
        bne     @00f6
        lda     #$ff                    ; clear current song index
        sta     $05
        longa
        lda     f:SfxBRR
        clc
        adc     #$4800
        sta     $f8
        sta     $a0
        ldx     #$0800                  ; wait for spc to initialize ???
@0111:  dex
        bne     @0111
        shorta
        lda     #$00                    ;
        sta     $fa
        lda     #$c5                    ;
        sta     $fb
        lda     #$05                    ; echo delay = 5 (80ms)
        sta     $f0
        asl3
        eor     #$ff
        inc
        clc
        adc     #$f5
        sta     $f2                     ; +$f1 = start of echo buffer
        stz     $f1
        bra     Exit

; ------------------------------------------------------------------------------

; [ spc command ]

ExecSound:
@0131:  phb
        phd
        php
        longa
        longi
        pha
        phx
        phy
        shorta
        lda     #$00
        pha
        plb
        ldx     #$1300      ; set dp to $1300
        phx
        pld

_c50146:
@0146:  shorta
        lda     $00         ; spc interrupt command
        beq     Exit       ; return if no command
        bmi     @0167
        cmp     #$10
        bcc     Exit       ; return if < $10
        cmp     #$18
        bcs     @0163       ; branch if >= $18
        and     #$0f
        asl
        xba
        lda     #$00
        pha
        xba
        pha
        plx
        jmp     (.loword(PlaySongTbl),x)
@0163:  cmp     #$30
        bcs     @016a
@0167:  jmp     InterruptSPC
@016a:  cmp     #$40
        bcs     Exit
        jmp     QuickPlaySong

; ------------------------------------------------------------------------------

; return
Exit:
@0171:  shorta
        stz     $00
        longa
        longi
        ply
        plx
        pla
        plp
        pld
        plb
        rtl

; ------------------------------------------------------------------------------

; [ play song ]

PlaySong:
@0180:  shorta
        lda     $01                     ; song index
        cmp     $05                     ; current song
        beq     Exit                    ; return if it's the same song
        cmp     f:NumSongs
        bcs     Exit                    ; return if song number is invalid
        jsr     CheckPauseSong
        lda     $01
        cmp     #$54
        bne     @019d                   ; branch if not song $54 (ending theme 2)
        lda     $05
        cmp     #$53
        beq     @01a4                   ; branch if current song is $53 (ending theme 1)
@019d:  lda     $f3
        beq     @01a4                   ; branch if previous song was not > $1000 bytes
        jsr     TfrGameSfxPtrs
@01a4:  shorta
        lda     $02                     ;
        sta     hAPUIO2
        lda     $01                     ; song number
        sta     hAPUIO1
        lda     $00                     ; spc command
        sta     hAPUIO0
@01b5:  cmp     hAPUIO0
        bne     @01b5                   ; wait for acknowledgement from spc
        inc
        and     #$7f
        sta     $1e
        longa
        ldx     #$0020
@01c4:  stz     $141e,x                 ; clear $141f-$142e
        dex
        bne     @01c4
        lda     #$1400                  ; pointer to instruments used
        sta     $10
        lda     #$1420                  ; pointer to instruments that need to be transferred
        sta     $12
        lda     $00
        and     #$ff00                  ; song number * 32
        lsr3
        tax
        adc     #$0020
        sta     $1c
@01e2:  lda     f:SongSamples,x
        sta     ($10)
        inc     $10                     ; next instrument
        inc     $10
        ldy     #$0040
@01ef:  cmp     $131e,y                 ; check if that instrument was already loaded in the spc
        beq     @01fe
        dey2
        bne     @01ef
        sta     ($12)                   ; add to instruments that need to be transferred
        inc     $12
        inc     $12
@01fe:  inx2                            ; next instrument
        cpx     $1c
        bne     @01e2
        lda     $1420                   ; first instrument that needs to be transferred
        bne     @020c                   ; branch if any instruments need to be transferred
        jmp     TfrSongScript

; skip instruments that are already loaded in the correct order
@020c:  ldx     #$0000                  ; pointer to next instrument in spc
        stx     $1c
@0211:  lda     $1420,x                 ; instrument number
        beq     @0253                   ; branch if no instrument
        phx
        dec
        sta     $e2
        asl
        clc
        adc     $e2
        tax
        shorta
        lda     f:SampleBRRPtrs,x
        sta     $10
        lda     f:SampleBRRPtrs+1,x
        sta     $11
        lda     f:SampleBRRPtrs+2,x
        sta     $12
        ldy     $10
        stz     $10
        stz     $11
        lda     [$10],y                 ; length of brr data
        xba
        iny
        bne     @0241
        inc     $12
@0241:  lda     [$10],y
        xba
        longa
        clc
        adc     $1c                     ; add to brr data pointer
        sta     $1c
        plx
        inx2                            ; next instrument
        cpx     #$0020
        bne     @0211
@0253:  ldx     #$0040                  ; find the last instrument that needs to be transferred
@0256:  lda     $1e,x
        bne     @0260
        dex2
        bne     @0256
        bra     @026b                   ; branch if no instruments need to be transferred
@0260:  lda     $a0,x                   ; pointer to
        clc
        adc     $1c                     ; add brr data pointer
        bcs     @026e                   ; branch on overflow ???
        cmp     $f1
        bcs     @026e                   ; branch if data is past the beginning of the echo buffer
@026b:  jmp     $031c                   ; transfer instruments and song data to spc

; move instruments that are already loaded (start at the end of the list)
@026e:  shorta
        lda     #$07                    ; command $07 (move chunk)
        sta     hAPUIO1
        longa
        ldx     #0
@027a:  lda     $20,x
        beq     @0296
        ldy     #0
@0281:  cmp     $1400,y
        beq     @028f
        iny2
        cpy     #$0020
        bne     @0281
        stz     $20,x
@028f:  inx2
        cpx     #$0040
        bne     @027a
@0296:  ldx     #$0000
@0299:  lda     $20,x
        beq     @02a4
        inx2
        cpx     #$0040
        bne     @0299
@02a4:  stx     $1c
        ldx     #$0040
@02a9:  lda     $1e,x
        bne     @02b1
        dex2
        bne     @02a9
@02b1:  cpx     $1c
        bne     @02b8
        jmp     $031c                   ; transfer instruments and song data to spc

;
@02b8:  ldy     #0
@02bb:  lda     $1320,y
        bne     @030d                   ; skip if instrument can't be moved
        tyx
        bra     @02c7
@02c3:  lda     $20,x
        bne     @02d0
@02c7:  inx2
        cpx     #$0040
        bne     @02c3
        bra     @0316
@02d0:  sta     $1320,y
        stz     $20,x
        lda     $a0,x
        sta     hAPUIO2                 ; source address
        shorta
        lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        longa
        lda     $13a0,y                 ; destination address
        sta     hAPUIO2
        clc
        adc     $60,x
        sta     $13a2,y
        shorta
        lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        longa
        lda     $60,x
        sta     hAPUIO2                 ; size
        sta     $1360,y
        shorta
        lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
@030d:  longa
        iny2                            ; next instrument
        cpy     #$0040
        bne     @02bb
@0316:  shorta
        lda     #$f0
        sta     $1e
; fall through

; ------------------------------------------------------------------------------

; [ transfer instruments and song data to spc ]

TfrSong:
@031c:  shorta
        ldx     #0
@0321:  lda     $20,x
        beq     @0333
        inx2
        cpx     #$0040
        bne     @0321
        lda     #$00
@032e:  sta     $1f,x
        dex
        bne     @032e
@0333:  ldy     #$0000
@0336:  longa
        lda     $1420,y
        beq     @0371
        sta     $20,x
        phy
        phx
        dec
        sta     $e2
        asl
        clc
        adc     $e2
        tax
        shorta
        lda     f:SampleBRRPtrs,x
        sta     $10
        lda     f:SampleBRRPtrs+1,x
        sta     $11
        lda     f:SampleBRRPtrs+2,x
        sta     $12
        ldy     $10
        stz     $10
        stz     $11
        plx
        jsr     TfrSamples
        ply
        iny2
        inx2
        cpy     #$0020
        bne     @0336
@0371:  jmp     TfrSongScript

; ------------------------------------------------------------------------------

; [ transfer instrument brr data to spc ]

TfrSamples:
@0374:  php
        phx
        shorta
        plx
        phx
        lda     $a0,x                   ; destination address
        sta     hAPUIO2
        lda     $a1,x
        sta     hAPUIO3
        lda     #$03                    ; transfer 3 bytes at a time
        sta     hAPUIO1
        lda     $1e
        sta     hAPUIO0
@038e:  cmp     hAPUIO0
        bne     @038e                   ; wait for acknowledgement from spc
        inc
        and     #$7f
        sta     $1e
        lda     [$10],y                 ; size
        sta     $1c
        sta     $60,x
        clc
        adc     $a0,x                   ; set pointer to next instrument brr data
        sta     $a2,x
        iny
        bne     @03a8
        inc     $12
@03a8:  lda     [$10],y
        sta     $1d
        sta     $61,x
        adc     $a1,x
        sta     $a3,x
        iny
        bne     @03b7
        inc     $12
@03b7:  ldx     $1c                     ; x = bytes remaining to transfer
@03b9:  lda     [$10],y                 ; transfer 3 bytes
        sta     hAPUIO1
        iny
        bne     @03c3
        inc     $12
@03c3:  lda     [$10],y
        sta     hAPUIO2
        iny
        bne     @03cd
        inc     $12
@03cd:  lda     [$10],y
        sta     hAPUIO3
        iny
        bne     @03d7
        inc     $12
@03d7:  lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        dex3                            ; next 3 bytes
        bne     @03b9
        lda     #$f0                    ; command $f0 (end of data transfer)
        sta     $1e
        plx
        plp
        rts

; ------------------------------------------------------------------------------

; [ transfer song data to spc ]

TfrSongScript:
@03ea:  longa
        lda     #$1480
        sta     $10
        ldx     #$0000
@03f4:  lda     $1400,x
        beq     @0424                   ; branch if no instrument
        ldy     #$0000
@03fc:  cmp     $1320,y
        beq     @040d                   ;
        iny2
        cpy     #$0040
        bne     @03fc
        lda     #$0000
        bra     @0424
@040d:  phx
        dec
        asl
        tax
        lda     $13a0,y                 ; pointer to instrument
        sta     ($10)
        inc     $10
        inc     $10
        clc
        adc     f:SampleLoopStart,x
        sta     ($10)
        plx
        bra     @042c
@0424:  sta     ($10)                   ; clear pointer to instrument
        inc     $10
        inc     $10
        sta     ($10)                   ; clear loop start pointer
@042c:  inc     $10
        inc     $10
        inx2                            ; next instrument
        cpx     #$0020
        bne     @03f4
        shorta
        ldx     #$1b80                  ; address of brr pointers in spc ram
        stx     hAPUIO2
        lda     #$02                    ; transfer 2 bytes at a time
        sta     hAPUIO1
        lda     $1e
        sta     hAPUIO0
@0449:  cmp     hAPUIO0
        bne     @0449
        inc
        and     #$7f
        sta     $1e
        ldx     #$0000
@0456:  lda     $1480,x                 ; transfer brr pointer and loop start
        sta     hAPUIO2
        lda     $1481,x
        sta     hAPUIO3
        lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        inx2                            ; next instrument
        cpx     #$0040
        bne     @0456
        lda     #$f0                    ; command $f0 (end of data transfer)
        sta     $1e
        shorta
        ldx     #$1a40                  ; address of instrument pitch multipliers in spc ram
        stx     hAPUIO2
        lda     #$02                    ; transfer 2 bytes at a time
        sta     hAPUIO1
        lda     $1e
        sta     hAPUIO0
@0486:  cmp     hAPUIO0
        bne     @0486
        inc
        and     #$7f
        sta     $1e
        ldy     #$0000
@0493:  longa
        lda     $1400,y                 ; instrument number
        dec
        asl
        tax
        lda     f:SampleFreqMult,x
        sta     hAPUIO2
        shorta
        lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        iny2                            ; next instrument
        cpy     #$0020
        bne     @0493
        lda     #$f0                    ; command $f0 (end of data transfer)
        sta     $1e
        shorta
        ldx     #$1ac0                  ; address of adsr data in spc ram
        stx     hAPUIO2
        lda     #$02                    ; transfer 2 bytes at a time
        sta     hAPUIO1
        lda     $1e
        sta     hAPUIO0
@04c8:  cmp     hAPUIO0
        bne     @04c8
        inc
        and     #$7f
        sta     $1e
        ldy     #$0000
@04d5:  longa
        lda     $1400,y                 ; instrument number
        dec
        asl
        tax
        lda     f:SampleADSR,x
        sta     hAPUIO2
        shorta
        lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        iny2                            ; next instrument
        cpy     #$0020
        bne     @04d5
        lda     #$f0                    ; end of chunk
        sta     $1e
        shorta
        lda     $05                     ; previous song
        bmi     @0506                   ; branch if previous song invalid
        ldx     $04                     ; save previous song info
        stx     $08
        ldx     $06
        stx     $0a
@0506:  ldx     $00                     ; set current song info
        stx     $04
        ldx     $02
        stx     $06
        ldx     #$1c00                  ; transfer destination = $1c00 (song data)
        stx     hAPUIO2
        lda     #$02                    ; transfer 2 bytes at a time
        sta     hAPUIO1
        lda     $1e
        sta     hAPUIO0
@051e:  cmp     hAPUIO0
        bne     @051e                   ; wait for acknowledgement from spc
        inc
        and     #$7f
        sta     $1e
        longa
        lda     $01                     ; song number
        and     #$00ff
        sta     $e2
        asl
        clc
        adc     $e2
        tax
        shorta
        lda     f:SongScriptPtrs,x
        sta     $10
        lda     f:SongScriptPtrs+1,x
        sta     $11
        lda     f:SongScriptPtrs+2,x
        sta     $12
        ldy     $10
        stz     $10
        stz     $11
        lda     [$10],y                 ; +$1c = size
        sta     $1c
        iny
        bne     @0559
        inc     $12
@0559:  lda     [$10],y
        sta     $1d
        iny
        bne     @0562
        inc     $12
@0562:  ldx     $1c
        cpx     #$1000
        bcc     @056b                   ; branch if size < $1000
        inc     $f3                     ; data will overlap pointers to type 2 sound effects
@056b:  lda     [$10],y                 ; copy two bytes to spc
        sta     hAPUIO2
        iny
        bne     @0575
        inc     $12
@0575:  lda     [$10],y
        sta     hAPUIO3
        iny
        bne     @057f
        inc     $12
@057f:  lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        dex2                            ; next two bytes
        bpl     @056b
        lda     #$f0                    ; command $f0 (end of data transfer)
        ldx     #$0400
        sta     hAPUIO1
        sta     hAPUIO0
@0595:  cmp     hAPUIO0
        beq     @05a0                   ; wait for acknowledgement from spc
        dex
        bne     @0595
        ldx     #$0400                  ; wait a little bit longer...
@05a0:  dex
        bne     @05a0
        jmp     Exit

; ------------------------------------------------------------------------------

; [ spc interrupt ]

InterruptSPC:
@05a6:  shorta
        lda     $03                     ; copy data to spc ports
        sta     hAPUIO3
        lda     $02
        sta     hAPUIO2
        lda     $01
        sta     hAPUIO1
        lda     $00
        ldx     #$0400
        sta     hAPUIO0
@05bf:  cmp     hAPUIO0                 ; wait for acknowledgement from spc
        beq     @05c7
        dex
        bne     @05bf                   ; check 1024 times, then give up and continue anyway
@05c7:  cmp     #$f0
        bcc     @0605                   ; return if command < $f0
        cmp     #$f2
        bcs     @05e3                   ; branch if command >= $f2

; command $f0/$f1 (stop song)
        lda     $05
        bmi     @05dd                   ; branch if current song is invalid
        sta     $09                     ; save previous song info
        lda     $04
        sta     $08
        ldx     $06
        stx     $0a
@05dd:  lda     #$ff                    ; clear current song
        sta     $05
        bra     @0605

; command $f2-$ff
@05e3:  cmp     #$fc
        bne     @0605                   ; return if not command $fc

; command $fc (set echo delay)
        lda     $01
        and     #$0f
        sta     $f0                     ; echo delay
        asl3
        eor     #$ff
        inc
        clc
        adc     #$f5
        sta     $f2                     ; start of echo delay buffer
        ldx     #$0000
        lda     #$00
@05fd:  sta     $20,x                   ; clear $1320-$135f ???
        inx
        cpx     #$0040
        bne     @05fd
@0605:  jmp     Exit

; ------------------------------------------------------------------------------

; [ spc command $30-$3f: quick load song ]

QuickPlaySong:
@0608:  longa
        and     #$000f
        asl2
        tax
        lda     f:QuickPlaySongTbl+2,x
        sta     $02
        lda     f:QuickPlaySongTbl,x
        sta     $00
        jmp     _c50146

; ------------------------------------------------------------------------------

; [ check if current song gets paused ]

CheckPauseSong:
@061f:  php
        shorta
        lda     $00
        cmp     #$14
        bcs     @0638                   ; branch if new song pauses current song
        ldx     #0
@062b:  lda     f:PauseSongTbl,x
        bmi     @063e                   ; return if end of list is reached
        cmp     $01
        beq     @0638                   ; branch if new song doesn't pause current song
        inx
        bra     @062b
@0638:  lda     #$04                    ; pause current song
        ora     $00
        sta     $00
@063e:  plp
        rts

; ------------------------------------------------------------------------------

; [ transfer pointers to game sound effects to spc ]

; Ending theme 1 is too long to fit in the spc's ram, so it overwrites the
; pointers to game sound effects that are stored right afterward. This
; function puts them back

TfrGameSfxPtrs:
@0640:  shorta
        lda     #$fe                    ; spc command $fe
@0644:  sta     hAPUIO0
        cmp     hAPUIO0
        bne     @0644                   ; wait for acknowledgement from spc
        inc
        and     #$7f
        xba
        ldx     #$2c00                  ; destination address (pointers to game sound effects)
        stx     hAPUIO2
        lda     #$02                    ; transfer 2 bytes at a time
        sta     hAPUIO1
        xba
        sta     hAPUIO0
@065f:  cmp     hAPUIO0
        bne     @065f
        inc
        and     #$7f
        sta     $1e
        lda     f:SfxPtrs               ; size of data ($1c00)
        sta     $1c
        lda     f:SfxPtrs+1
        sta     $1d
        ldx     #0
@0678:  lda     f:SfxPtrs+2,x           ; transfer data (pointers to sound effect data)
        sta     hAPUIO2
        lda     f:SfxPtrs+3,x
        sta     hAPUIO3
        inx2                            ; next two bytes
        lda     $1e
        jsr     WaitTfrSPC
        sta     $1e
        cpx     $1c
        bne     @0678
        lda     #$f0                    ; command $f0 (end of data transfer)
        ldx     #$0400
        sta     hAPUIO1
        sta     hAPUIO0
@069e:  cmp     hAPUIO0
        beq     @06a6                   ; wait for acknowledgement from spc
        dex
        bne     @069e
@06a6:  stz     $f3                     ; data no longer overlaps pointers to type 2 sound effects
        rts

; ------------------------------------------------------------------------------

; [ wait for data transfer to spc ]

WaitTfrSPC:
@06a9:  php
        shorta
        sta     hAPUIO0
@06af:  cmp     hAPUIO0
        bne     @06af
        inc
        and     #$7f
        plp
        rts

; ------------------------------------------------------------------------------

; spc command data for command $30-$3f (quick load new song)
QuickPlaySongTbl:
@06b9:  .byte   $10,$00,$ff,$00
        .byte   $10,$01,$ff,$00
        .byte   $10,$02,$ff,$00
        .byte   $10,$03,$ff,$00
        .byte   $10,$04,$ff,$00
        .byte   $10,$05,$ff,$00
        .byte   $10,$06,$ff,$00
        .byte   $10,$07,$ff,$00
        .byte   $10,$08,$ff,$00
        .byte   $10,$09,$ff,$00
        .byte   $10,$0a,$ff,$00
        .byte   $10,$0b,$ff,$00
        .byte   $10,$0c,$ff,$00
        .byte   $10,$0d,$ff,$00
        .byte   $10,$0e,$ff,$00
        .byte   $10,$0f,$ff,$00

; songs which pause the current song
PauseSongTbl:
@06f9:  .byte   $24,$38,$14,$33,$ff

; spc command $10-$17 jump table (load new song)
PlaySongTbl:
@06fe:  .addr   PlaySong                ; don't pause current song
        .addr   PlaySong
        .addr   Exit
        .addr   Exit
        .addr   PlaySong                ; pause current song
        .addr   PlaySong
        .addr   Exit
        .addr   Exit

; ------------------------------------------------------------------------------

.segment "sound_data"

; ------------------------------------------------------------------------------

; c5/070e
begin_spc_block SPCCode
        .incbin "src/sound/ff6-spc.dat"
end_spc_block SPCCode

; ------------------------------------------------------------------------------

.include "sfx_data.asm"
.include "song_data.asm"

; ------------------------------------------------------------------------------
