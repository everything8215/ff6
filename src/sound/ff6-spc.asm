
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: spc/main.asm                                                         |
; |                                                                            |
; | description: spc-700 main sound program, some details taken from           |
; |              https://github.com/mogue/FF6-SoundEngine                      |
; |                                                                            |
; | created: 6/3/2023                                                          |
; +----------------------------------------------------------------------------+

.include "spc-ca65.inc"

; ------------------------------------------------------------------------------

.segment "code"

TREMOLO_BUGFIX = 0

; ------------------------------------------------------------------------------

; [ init spc ]

Init:
@0200:  clrp
        di
        mov     x,#$ff
        mov     sp,x
        mov     a,#$00
        mov     x,a
@0208:  mov     (x)+,a
        cmp     x,#$f0
        bne     @0208
        decw    $c6
        mov     a,#$00
        mov     y,#$0c
        call    !SetDSP
        mov     y,#$1c
        call    !SetDSP
        mov     y,#$2c
        call    !SetDSP
        mov     y,#$3c
        call    !SetDSP
        mov     y,#$2d
        call    !SetDSP
        mov     y,#$3d
        call    !SetDSP
        mov     y,#$4d
        call    !SetDSP
        mov     y,#$5d
        mov     a,#$1b
        call    !SetDSP
        mov     y,#$07
        mov     x,#$a0
@023f:  mov     $f2,y
        mov     $f3,x
        mov     a,y
        clrc
        adc     a,#$10
        mov     y,a
        bpl     @023f
        mov     $f1,#$30
        mov     $fa,#$27
        mov     $fb,#$80
        mov     $fc,#$05
        mov     $f1,#$07
        mov     $8c,#$05
        call    !SetEchoDelay
        mov     a,#$3f
        mov     y,#$0c
        call    !SetDSP
        mov     y,#$1c
        call    !SetDSP
        dec     $24
        mov     $c8,#$07
        dec     $a8
; fallthrough

; ------------------------------------------------------------------------------

; [ main code loop ]

Main:
@0272:  call    !CheckInterrupts
        mov     y,$fd
        beq     @0272
        bbs     $85.2,@027f
        bbc     $86.6,@0283
@027f:  mov     y,#$05
        bra     @0285
@0283:  mov     y,#$11
@0285:  mov     a,!DSPRegTbl-1+y
        mov     $f2,a
        mov     a,!DSPBufTbl-1+y
        mov     x,a
        mov     a,(x)
        mov     $f3,a
        dbnz    y,@0285
        mov     $24,y
        mov     $22,y
        bbs     $86.7,@02ae
        bbs     $85.3,@02a0
        mov     y,$52
        mov     a,!$adeb
@02a0 := *-2
;       mov     y,$ad
        mov     a,$dd
        movw    $f6,ya
        mov     y,$7b
        mov     a,#$00
        movw    $f4,ya
        bra     @02b1
@02ae:  call    !UpdateWaveOut
@02b1:  movw    ya,$d9
        bne     @0300
        dec     $c8
        bne     @02bf
        mov     $c8,#$07
        call    !UpdateInterruptEnv
@02bf:  call    !UpdateScripts
        mov     x,#$00
        mov     $8f,#$01
        mov     a,$83
        or      a,$84
        eor     a,#$ff
        and     a,$52
        and     a,$23
        mov     $a0,a
        bra     @02de
@02d5:  mov     $a3,x
        call    !UpdateFreqVol
@02da:  inc     x
        inc     x
        asl     $8f
@02de:  lsr     $a0
        bcs     @02d5
        bne     @02da
        mov     x,#$1e
        mov     $8f,#$80
        mov     a,$83
        or      a,$84
        mov     $a0,a
        bra     @02fa
@02f1:  mov     $a3,x
        call    !UpdateFreqVol
@02f6:  dec     x
        dec     x
        lsr     $8f
@02fa:  asl     $a0
        bcs     @02f1
        bne     @02f6
@0300:  mov     a,#$00
        mov     y,a
        movw    $db,ya
        jmp     !Main

; ------------------------------------------------------------------------------

; [ update channels every tick ]

UpdateScripts:
@0308:  bbs     $86.5,@032a
        mov     a,$46
        mov     y,$b7
        beq     @0323
        mul     ya
        mov     a,y
        bbs     $b7.7,@0320
        asl     a
        clrc
        adc     a,$46
        bcc     @0323
        mov     a,#$ff
        bra     @0323
@0320:  bne     @0323
        inc     a
@0323:  clrc
        adc     a,$47
        mov     $47,a
        bcc     @037d
@032a:  mov     x,#$00
        mov     $8f,#$01
        mov     $a0,$52
        bra     @036d
@0334:  mov     $a3,x
        dec     $25+x
@0336:  bne     @033f
        call    !ExecScript
        bra     @0366
@033f:  mov     y,#$00
        cmp     x,#$10
        bcs     @0346
        mov     a,#$fc
@0346 := *-1
;       inc     y
        mov     a,#$02
        cbne    $25+x,@0366
        mov     a,!$0059+y
        and     a,$8f
        bne     @0366
        mov     a,y
        bne     @0363
        mov     a,$8f
        tclr1   !$0023
        mov     a,$83
        or      a,$84
        and     a,$8f
        bne     @0366
@0363:  or      $24,$8f
@0366:  call    !UpdateChanEnv
@0369:  inc     x
        inc     x
        asl     $8f
@036d:  lsr     $a0
        bcs     @0334
        bne     @0369
        cmp     x,#$18
        bcs     @0394
        call    !UpdateSongEnv
        call    !CheckInterrupts
@037d:  mov     a,#$78
        clrc
        adc     a,$48
        mov     $48,a
        bcc     @0394
        mov     x,#$18
        mov     $8f,#$10
        mov     a,$83
        or      a,$84
        xcn     a
        mov     $a0,a
        bra     @036d
@0394:  ret

; ------------------------------------------------------------------------------

; [ update song envelopes ]

UpdateSongEnv:
@0395:  mov     a,$49
        beq     @03a1
        dec     $49
        movw    ya,$4a
        addw    ya,$45
        movw    $45,ya
@03a1:  mov     a,$50
        beq     @03ad
        dec     $50
        movw    ya,$4e
        addw    ya,$4c
        movw    $4c,ya
@03ad:  mov     a,$78
        beq     @03b9
        dec     $78
        movw    ya,$79
        addw    ya,$75
        movw    $75,ya
@03b9:  mov     a,$77
        beq     @03d8
        dec     $77
        mov     x,#$10
@03c1:  mov     a,!$00ff+x
        mov     y,a
        mov     a,!$00fe+x
        movw    $98,ya
        mov     a,$63+x
        mov     y,$64+x
        addw    ya,$98
        mov     $63+x,a
        mov     $64+x,y
        dec     x
        dec     x
        bne     @03c1
@03d8:  ret

; ------------------------------------------------------------------------------

; [ execute next script command ]

ExecScript:
@03d9:  call    !GetNextParam
        cmp     a,#$c4
        bcc     @03e5
        call    !ExecCmd
        bra     @03d9
@03e5:  mov     y,$25+x
        bne     @03f5
        mov     y,#$00
        mov     x,#$0e
        div     ya,x
        mov     x,$a3
        mov     a,!NoteDurTbl+y
        mov     $25+x,a
@03f5:  cmp     $a2,#$a8
        bcc     @0403
        cmp     $a2,#$b6
        bcs     @0402
        jmp     !@0499
@0402:  ret
@0403:  mov     a,$a2
        mov     y,#$00
        mov     x,#$0e
        div     ya,x
        mov     $a2,a
        mov     x,$a3
        mov     a,!$f600+x
        mov     y,#$0c
        mul     ya
        clrc
        adc     a,$a2
        clrc
        adc     a,!$f721+x
        setc
        sbc     a,#$0a
        mov     !$f761+x,a
        call    !CalcFreq
        mov     a,$c0
        mov     !$f8e0+x,a
        mov     a,$c1
        mov     !$f8e1+x,a
        mov     a,!$0151+x
        beq     @0438
        mov     $a2,a
        call    !InitVibrato
@0438:  mov     a,!$0170+x
        beq     @0444
        mov     $a2,a
        call    !InitTremolo
        mov     a,#$00
@0444:  mov     !$f8c0+x,a
        mov     !$f8c1+x,a
        mov     !$f860+x,a
        mov     !$f861+x,a
        mov     !$f780+x,a
        mov     !$f781+x,a
        cmp     x,#$10
        bcs     @047a
        or      $23,$8f
        mov     a,$83
        or      a,$84
        and     a,$8f
        bne     @0499
        mov     a,$8f
        and     a,$5f
        bne     @048d
        mov     a,$8f
        and     a,$5b
        beq     @048d
        and     a,$5d
        bne     @0490
        or      $5d,$8f
        bra     @048d
@047a:  mov     a,$8f
        and     a,$60
        bne     @048d
        mov     a,$8f
        and     a,$5c
        beq     @048d
        and     a,$5e
        bne     @0490
        or      $5e,$8f
@048d:  or      $22,$8f
@0490:  or      $db,$8f
        or      $dc,$8f
        call    !UpdateSample
@0499:  call    !FindNextNote
        mov     y,a
        mov     a,$8f
        cmp     x,#$10
        bcs     @04c4
        cmp     y,#$b6
        bcs     @04b0
        cmp     y,#$a8
        bcc     @04b6
        tset1   !$0059
        bra     @04e3
@04b0:  tclr1   !$005b
        tclr1   !$005f
@04b6:  tclr1   !$0059
        mov     a,$5b
        or      a,$5f
        and     a,$8f
        tset1   !$0059
        bra     @04e3
@04c4:  cmp     y,#$b6
        bcs     @04d1
        cmp     y,#$a8
        bcc     @04d7
        tset1   !$005a
        bra     @04e3
@04d1:  tclr1   !$005c
        tclr1   !$0060
@04d7:  tclr1   !$005a
        mov     a,$5c
        or      a,$60
        and     a,$8f
        tset1   !$005a
@04e3:  mov     a,!$0150+x
        beq     @0553
        clrc
        adc     a,!$f761+x
        mov     !$f761+x,a
        call    !CalcFreq
        mov     a,!$f8e1+x
        mov     y,a
        mov     a,!$f8e0+x
        movw    $98,ya
        movw    ya,$c0
        setc
        subw    ya,$98
        movw    $98,ya
        push    psw
        bcs     @050d
        eor     $98,#$ff
        eor     $99,#$ff
        incw    $98
@050d:  mov     a,!$f720+x
        bne     @0517
        mov     $9a,#$00
        bra     @0529
@0517:  mov     x,a
        mov     a,$99
        mov     y,#$00
        div     ya,x
        mov     $9a,a
        mov     a,$98
        div     ya,x
        mov     $99,a
        mov     a,#$00
        div     ya,x
        mov     $98,a
@0529:  pop     psw
        bcs     @053b
        eor     $98,#$ff
        eor     $99,#$ff
        eor     $9a,#$ff
        incw    $98
        bne     @053b
        inc     $9a
@053b:  mov     x,$a3
        movw    ya,$99
        mov     !$f780+x,a
        mov     a,y
        mov     !$f781+x,a
        mov     a,$98
        mov     !$f8a0+x,a
        mov     a,#$00
        mov     !$0150+x,a
        mov     !$f8a1+x,a
@0553:  ret

; ------------------------------------------------------------------------------

; [ calculate note frequency ]

CalcFreq:
@0554:  mov     x,#$0c               ;calculate pitch (a->+$c0)
        mov     y,#$00
        div     ya,x
        mov     x,$a3
        mov     $a1,a
        mov     a,y
        asl     a
        mov     y,a
        mov     a,!FreqMultTbl+y
        mov     $c2,a
        mov     a,!FreqMultTbl+1+y
        mov     $c3,a                ;+$c2 pitch mult
        mov     y,a
        mov     a,!$f740+x            ;wave mult + detune
        clrc
        adc     a,!$f760+x
        push    psw
        push    a
        mul     ya                    ;multiply upper pitch mult by wave mult
        movw    $c0,ya               ; store in +$c0
        mov     y,$c2
        pop     a
        mul     ya                    ;multiply lower pitch mult by wave mult
        mov     a,y
        mov     y,#$00
        addw    ya,$c0
        movw    $c0,ya
        mov     a,!$f741+x
        beq     @058f
        mul     ya
        mov     a,y
        mov     y,#$00
        addw    ya,$c0
        bra     @0591
@058f:  mov     a,$c0
@0591:  pop     psw
        bmi     @0596
        addw    ya,$c2
@0596:  movw    $c0,ya
        mov     a,#$04               ;initial octave is always 4
        mov     y,$a1
        bmi     @05ac
        cmp     a,$a1
        bcs     @05b1
@05a2:  asl     $c0                   ;double or halve the value to get the right octave
        rol     $c1
        inc     a
        cbne    $a1,@05a2
        bra     @05b4
@05ac:  lsr     $c1
        ror     $c0
        dec     a
@05b1:  cbne    $a1,@05ac
@05b4:  ret

; ------------------------------------------------------------------------------

; [ execute script command ]

ExecCmd:
@05b5:  sbc     a,#$c4
        asl     a
        mov     y,a
        mov     a,!ScriptCmdTbl+1+y
        push    a
        mov     a,!ScriptCmdTbl+y
        push    a
        mov     a,y
        lsr     a
        mov     y,a
        mov     a,!ScriptCmdBytesTbl+y
        beq     _05d3

; get next script command
GetNextParam:
@05c9:  mov     a,[$02+x]
        mov     $a2,a
        inc     $02+x
        bne     _05d3
        inc     $03+x
_05d3:  ret

; ------------------------------------------------------------------------------

; [ find next note ]

FindNextNote:
@05d4:  mov     a,$02+x
        mov     y,$03+x
        movw    $90,ya
        mov     a,$26+x
        mov     $c5,a
@05de:  mov     y,#$00
@05e0:  mov     a,[$90]+y
        cmp     a,#$c4
        bcc     @0647
        incw    $90
        cmp     a,#$eb
        beq     @0647
        cmp     a,#$f6
        bne     @05f5
        call    !s_1658
        bra     @05de
@05f5:  cmp     a,#$e3
        bne     @05fe
        call    !s_1725
        bra     @05de
@05fe:  cmp     a,#$f5
        bne     @0607
        call    !s_1695
        bra     @05de
@0607:  cmp     a,#$e5
        bne     @0610
        call    !DisableSlur
        bra     @05de
@0610:  cmp     a,#$e7
        bne     @0619
        call    !DisableDrumRoll
        bra     @05de
@0619:  cmp     a,#$e9
        bne     @0622
        call    !s_1633
        bra     @05de
@0622:  cmp     a,#$ea
        bne     @062b
        call    !s_1639
        bra     @05de
@062b:  cmp     a,#$dc
        bne     @0637
        call    !DisableSlur
        call    !DisableDrumRoll
        bra     @05de
@0637:  setc
        sbc     a,#$c4
        mov     y,a
        mov     a,!ScriptCmdBytesTbl+y
        beq     @05de
        mov     y,a
@0641:  incw    $90
        dbnz    y,@0641
        bra     @05e0
@0647:  ret

; ------------------------------------------------------------------------------

; [ set dsp register ]

SetDSP:
@0648:  mov     $f2,y
        mov     $f3,a
        ret

; ------------------------------------------------------------------------------

; [ reset timers and ports ]

ResetPorts:
@064d:  mov     $f1,#$17
        mov     $f1,#$07
        ret

; ------------------------------------------------------------------------------

; [ update channel envelopes ]

UpdateChanEnv:
@0654:  setp                            ;refresh voice slides every tick
        mov     a,$11+x                ;vibrato
        beq     @065b
        dec     $11+x
@065b:  mov     a,$31+x                ;tremolo
        beq     @0661
        dec     $31+x
@0661:  clrp
        mov     a,!$f6a0+x              ;volume
        beq     @068d
        dec     a
        mov     !$f6a0+x,a
        mov     a,!$f620+x
        mov     $98,a
        mov     a,!$f621+x
        mov     $99,a
        mov     a,!$f641+x
        mov     y,a
        mov     a,!$f640+x
        addw    ya,$98
        mov     !$f620+x,a
        mov     a,y
        cmp     a,!$f621+x
        mov     !$f621+x,a
        beq     @068d
        or      $db,$8f
@068d:  mov     a,!$f6a1+x              ;pan
        beq     @06b8
        dec     a
        mov     !$f6a1+x,a
        mov     a,!$f660+x
        mov     $98,a
        mov     a,!$f661+x
        mov     $99,a
        mov     a,!$f681+x
        mov     y,a
        mov     a,!$f680+x
        addw    ya,$98
        mov     !$f660+x,a
        mov     a,y
        cmp     a,!$f661+x
        mov     !$f661+x,a
        beq     @06b8
        or      $db,$8f
@06b8:  mov     a,!$f8a0+x              ;
        mov     $98,a
        mov     a,!$f780+x
        mov     $99,a
        mov     a,!$f781+x
        mov     $9a,a
        movw    ya,$98
        bne     @06cf
        mov     a,$9a
        beq     @06fd
@06cf:  mov     a,!$f720+x
        dec     a
        bne     @06de
        mov     !$f780+x,a
        mov     !$f781+x,a
        mov     !$f8a0+x,a
@06de:  mov     !$f720+x,a
        clrc
        mov     a,!$f8e0+x
        mov     y,a
        mov     a,!$f8a1+x
        addw    ya,$98
        mov     !$f8a1+x,a
        mov     a,y
        mov     !$f8e0+x,a
        mov     a,$9a
        adc     a,!$f8e1+x
        mov     !$f8e1+x,a
        or      $dc,$8f
@06fd:  mov     a,!$0171+x              ;
        beq     @0744
        mov     a,!$f7a0+x
        mov     $98,a
        mov     a,!$f7a1+x
        mov     $99,a
        mov     a,!$f881+x
        mov     y,a
        mov     $9a,a
        mov     a,!$f880+x
        addw    ya,$98
        mov     !$f880+x,a
        mov     a,y
        cmp     a,!$f881+x
        mov     !$f881+x,a
        beq     @0726
        or      $db,$8f
@0726:  mov     a,!$f701+x
        dec     a
        bne     @0741
        eor     $98,#$ff
        eor     $99,#$ff
        incw    $98
        mov     a,$98
        mov     !$f7a0+x,a
        mov     a,$99
        mov     !$f7a1+x,a
        mov     a,!$f700+x
@0741:  mov     !$f701+x,a
@0744:  ret

; ------------------------------------------------------------------------------

; [ update frequency and volume ]

UpdateFreqVol:
@0745:  mov     a,!$0151+x            ;refresh vibrato,tremolo,volume,and pitch every frame
        beq     @0751
        mov     $a2,a
        mov     a,!$0111+x
        beq     @0754
@0751:  jmp     !@07fc
@0754:  mov     a,!$f7e1+x
        mov     y,a
        mov     a,!$f7e0+x
        movw    $c0,ya
        mov     a,!$f841+x
        mov     y,a
        mov     a,!$f840+x
        addw    ya,$c0
        movw    $c2,ya
        mov     !$f840+x,a
        mov     a,y
        cmp     a,!$f841+x
        beq     @07c8
        mov     !$f841+x,a
        asl     $c2
        rol     $c3
        mov     a,!$f8e1+x
        mov     y,#$0f
        mul     ya
        movw    $98,ya
        mov     a,!$f8e0+x
        mov     y,#$0f
        mul     ya
        mov     a,y
        mov     y,#$00
        addw    ya,$98
        movw    $98,ya
        mov     a,$c3
        mul     ya
        movw    $9a,ya
        mov     y,$98
        mov     a,$c3
        mul     ya
        mov     a,y
        mov     y,#$00
        addw    ya,$9a
        movw    $9a,ya
        mov     y,$c2
        mov     a,$99
        mul     ya
        mov     a,y
        mov     y,#$00
        addw    ya,$9a
        movw    $9a,ya
        bbc     $c3.7,@07b1
        subw    ya,$98
        movw    $9a,ya
@07b1:  mov     a,!$f8c1+x
        mov     y,a
        mov     a,!$f8c0+x
        cmpw    ya,$9a
        beq     @07c8
        movw    ya,$9a
        mov     !$f8c0+x,a
        mov     a,y
        mov     !$f8c1+x,a
        or      $dc,$8f
@07c8:  mov     a,!$f6c1+x
        dec     a
        bne     @07f9
        mov     a,!$f7c1+x
        mov     y,a
        mov     a,!$f7c0+x
        movw    $98,ya
        mov     a,$c1
        mov     $c2,a
        mov     a,!$0190+x
        mov     $9b,a
        and     $9b,#$70
        and     a,#$07
        call    !UpdateVibratoTremolo
        mov     !$f7e0+x,a
        mov     a,y
        mov     !$f7e1+x,a
        mov     a,$9a
        or      a,$9b
        mov     !$0190+x,a
        mov     a,!$f6c0+x
@07f9:  mov     !$f6c1+x,a
@07fc:  mov     a,!$0170+x            ;tremolo
        beq     @085d
        mov     $a2,a
        mov     a,!$0131+x
        bne     @085d
        mov     a,!$f821+x
        mov     y,a
        mov     a,!$f820+x
        movw    $c0,ya
        mov     $c2,y
        mov     a,!$f861+x
        mov     y,a
        mov     a,!$f860+x
        addw    ya,$c0
        mov     !$f860+x,a
        mov     a,y
        cmp     a,!$f861+x
        beq     @082b
        mov     !$f861+x,a
        or      $db,$8f
@082b:  mov     a,!$f6e1+x
        dec     a
        bne     @085a
        mov     a,!$f801+x
        mov     y,a
        mov     a,!$f800+x
        movw    $98,ya
        mov     a,!$0190+x
        mov     $9b,a
        and     $9b,#$07
        xcn     a
        and     a,#$07
        call    !UpdateVibratoTremolo
        mov     !$f820+x,a
        mov     a,y
        mov     !$f821+x,a
        mov     a,$9a
        xcn     a
        or      a,$9b
        mov     !$0190+x,a
        mov     a,!$f6e0+x
@085a:  mov     !$f6e1+x,a
@085d:  movw    ya,$db               ;refresh volume, pitch in dsp
        bne     @0862
        ret
@0862:  mov     a,x
        and     a,#$0f
        mov     $98,a
        mov     a,$98
        xcn     a
        lsr     a
        mov     $99,a
        mov     a,$8f
        and     a,$db
        beq     @0879
        tclr1   !$00db
        call    !UpdateChanVol
@0879:  mov     a,$8f
        and     a,$dc
        beq     @0887
        tclr1   !$00dc
        set1    $99.1
        call    !UpdateChanFreq
@0887:  ret

; ------------------------------------------------------------------------------

; [ update channel volume ]

UpdateChanVol:
@0888:  mov     $9a,#$80             ;set volume in dsp
        bbs     $85.0,@08b1
        bbs     $85.2,@08b1
        mov     a,$8f
        and     a,$84
        bne     @08b1
        mov     a,!$f661+x
        mov     y,a
        cmp     x,#$10
        bcc     @08a7
        mov     a,$b2
        eor     a,#$80
        call    !AddToPan
        mov     y,a
@08a7:  mov     a,!$f881+x
        call    !AddToPan
        eor     a,#$ff
        mov     $9a,a
@08b1:  mov     a,!$f621+x
        mov     y,a
        mov     $9b,a
        mov     a,!$f861+x
        beq     @08c8
        asl     a
        mul     ya
        bcs     @08c8
        mov     a,y
        adc     a,$9b
        bpl     @08c7
        mov     a,#$7f
@08c7:  mov     y,a
@08c8:  cmp     x,#$10
        bcs     @08d9
        mov     a,$a6
        mul     ya
        mov     a,$8f
        and     a,$61
        bne     @08e6
        mov     a,$51
        bra     @08e5
@08d9:  mov     a,$8f
        and     a,$84
        beq     @08e3
        mov     a,#$ff
        bra     @08e5
@08e3:  mov     a,$a8
@08e5:  mul     ya
@08e6:  mov     $9b,y
        mov     a,$9a
@08ea:  mov     y,a
        mov     a,$9b
        mul     ya
        mov     a,$8f
        and     a,$a4
        beq     @08f6
        mov     y,#$00
@08f6:  mov     a,y
        mov     y,$98
        mov     !$00c9+y,a
        mov     y,a
        mov     a,$99
        mov     $f2,a
        cmp     y,$f3
        beq     @0907
        mov     $f3,y
@0907:  mov     a,$9a
        eor     a,#$ff
        not1    $0098.0
        inc     $99
        bbc     $99.1,@08ea
        ret
; ------------------------------------------------------------------------------

; [ update channel frequency ]

UpdateChanFreq:
@0914:  mov     a,!$f8e1+x            ;set wave rate in dsp
        mov     y,a
        mov     a,!$f8e0+x
        movw    $9a,ya
        mov     a,!$f8c1+x
        mov     y,a
        mov     a,!$f8c0+x
        addw    ya,$9a
        movw    $9a,ya
        cmp     x,#$10
        bcc     @0930
        movw    ya,$9a
        bra     @094b
@0930:  mov     a,$bc
        push    psw
        push    a
        mul     ya
        movw    $9c,ya
        pop     a
        mov     y,$9a
        mul     ya
        mov     a,y
        mov     y,#$00
        addw    ya,$9c
        pop     psw
        bmi     @094b
        asl     a
        push    a
        mov     a,y
        rol     a
        mov     y,a
        pop     a
        addw    ya,$9a
@094b:  push    x
        mov     x,$99
        mov     $f2,x
        cmp     a,$f3
        beq     @0956
        mov     $f3,a
@0956:  inc     x
        mov     $f2,x
        cmp     y,$f3
        beq     @095f
        mov     $f3,y
@095f:  pop     x
        ret
; ------------------------------------------------------------------------------

; [ update tremolo/vibrato rate ]

;    a: previous gain counter [0..7]
; +$98: max tremolo change rate (amplitude / cycle length)
;  $a2: tremolo amplitude (positive/negative/balanced)
; +$c0: previous change rate
;   ya: new tremolo change rate (out)
;  $9a: new gain counter [0..7] (out)

UpdateVibratoTremolo:
@0961:  mov     $9a,#$00
        cmp     $a2,#$c0
        bcs     @09b4
        cmp     $a2,#$80
        bcs     @098d

; positive
        eor     $c0,#$ff
        eor     $c1,#$ff
        incw    $c0
        mov     y,a
        beq     @09de
        dec     a
        mov     $9a,a
        bbs     $c1.7,@09de
        lsr     $99
        ror     $98
        lsr     $99
        ror     $98
        movw    ya,$98
        addw    ya,$c0
        bra     @09e0

; negative
@098d:  eor     $c0,#$ff
        eor     $c1,#$ff
        incw    $c0
        mov     y,a
        beq     @09de
        dec     a
        mov     $9a,a
        bbc     $c1.7,@09de
        lsr     $99
        ror     $98
        lsr     $99
        ror     $98
        eor     $98,#$ff
        eor     $99,#$ff
        incw    $98
        movw    ya,$98
        addw    ya,$c0
        bra     @09e0

; balanced
@09b4:  mov     y,a
        beq     @09d6
        dec     a
        mov     $9a,a
        bbc     $c1.7,@09c5
        eor     $c0,#$ff
        eor     $c1,#$ff
        incw    $c0
@09c5:  lsr     $99
        ror     $98
        lsr     $99
        ror     $98
        movw    ya,$98
        addw    ya,$c0
        movw    $c0,ya
        bbs     $c2.7,@09de
@09d6:  eor     $c0,#$ff
        eor     $c1,#$ff
        incw    $c0
@09de:  movw    ya,$c0
@09e0:  ret

; ------------------------------------------------------------------------------

; [ check interrupts ]

CheckInterrupts:
@09e1:  mov     x,$f4                  ;check interrupts
        beq     @0a1a
@09e5:  mov     x,$f4
        cmp     x,$f4
        bne     @09e5
        movw    ya,$f6
        movw    $8d,ya
        movw    ya,$f4
        movw    $8b,ya
        call    !ResetPorts
        mov     $f4,a
        mov     x,a
        bpl     @09fe
        jmp     !s_0c54                  ;if negative
@09fe:  cmp     x,#$10                 ;return if less than $10
        bcc     @0a1a
        cmp     x,#$20
        bcs     @0a13
        and     a,#$0f                 ;if between $10 and $20
        asl     a
        mov     y,a
        mov     a,!InterruptTbl+1+y
        push    a
        mov     a,!InterruptTbl+y
        push    a
        ret
@0a13:  cmp     x,#$30
        bcs     @0a1a
        jmp     !SystemSfx                  ;if between $20 and $30
@0a1a:  ret

; ------------------------------------------------------------------------------

; [ interrupt $14: load song (pause current song) ]

Interrupt_14:
@0a1b:  call    !SuspendSong                 ;load song
; fallthrough

; ------------------------------------------------------------------------------

; [ interrupt $10: load song ]

Interrupt_10:
@0a1e:  mov     $c4,#$10
        bra     _0a29

; ------------------------------------------------------------------------------

; [ interrupt $15: load song (alternate start position/pause current song) ]

Interrupt_15:
@0a23:  call    !SuspendSong
; fallthrough

; ------------------------------------------------------------------------------

; [ interrupt $11: load song (alternate start position) ]

; b1: song index
; b2: master volume

Interrupt_11:
@0a26:  mov     $c4,#$20
_0a29:  mov     a,#$ff               ;all keys off
        mov     y,#$5c
        call    !SetDSP
        mov     a,$76
        mov     $c7,$8c
        mov     a,$8d
        mov     $a6,a
        mov     $ad,#$00
        call    !DataTfr
        mov     a,#$00
        mov     y,a
        movw    $83,ya
        clr1    $86.5
        clr1    $85.3
        movw    $d9,ya
        mov     $dd,a
        cmp     $c6,$c7
        bne     @0a92
        call    !ResumeSong
        mov     a,$52
        beq     @0a92
        and     $8a,#$e0
        or      $8a,$62
        mov     x,#$00
        mov     $8f,#$01
@0a63:  inc     $25+x
        mov     $a3,x
        call    !UpdateSample
        mov     a,x
        xcn     a
        lsr     a
        mov     y,a
        mov     a,#$00
        call    !SetDSP
        inc     y
        call    !SetDSP
        inc     y
        mov     $99,y
        call    !UpdateChanFreq
        inc     x
        inc     x
        asl     $8f
        bne     @0a63
        mov     a,#$00
        mov     $54,a
        mov     $56,a
        mov     $58,a
        mov     $22,$23
        mov     $24,a
        bra     @0afc
@0a92:  mov     a,#$00
        mov     y,a
        mov     $52,a
        movw    $53,ya
        movw    $55,ya
        movw    $57,ya
        mov     $22,a
        mov     $24,a
        mov     $23,a
        mov     $59,a
        mov     $5b,a
        mov     $5f,a
        mov     $61,a
        mov     $46,#$01
        mov     $47,#$ff
        mov     $51,#$ff
        mov     $7b,a
        mov     y,$c4
        mov     x,#$10
@0aba:  mov     a,!$1c03+y
        mov     $01+x,a
        dec     y
        dec     x
        bne     @0aba
        mov     a,!$1c00
        mov     $00,a
        mov     a,!$1c01
        mov     $01,a
        mov     a,#$24
        mov     y,#$1c
        subw    ya,$00
        movw    $00,ya
        mov     x,#$0e
        mov     $8f,#$80
        mov     a,!$1c02
        mov     y,!$1c03
        movw    $98,ya
@0ae2:  mov     a,$02+x
        mov     y,$03+x
        cmpw    ya,$98
        beq     @0af6
        or      $52,$8f
        addw    ya,$00
        mov     $02+x,a
        mov     $03+x,y
        call    !InitChan
@0af6:  dec     x
        dec     x
        lsr     $8f
        bne     @0ae2
@0afc:  mov     $87,$53
        mov     $88,$55
        mov     $89,$57
        mov     a,#$00
        mov     y,a
        movw    $db,ya
        mov     x,#$ff
        mov     sp,x
        mov     a,$fd
        jmp     !Main

; ------------------------------------------------------------------------------

; [ init channel ]

InitChan:
@0b12:  mov     a,x
        asl     a
        mov     $26+x,a
        mov     a,#$00
        mov     !$0150+x,a
        mov     !$f780+x,a
        mov     !$f781+x,a
        mov     !$f8a0+x,a
        mov     !$0151+x,a
        mov     !$0170+x,a
        mov     !$0171+x,a
        mov     !$f880+x,a
        mov     !$f881+x,a
        mov     !$f760+x,a
        mov     !$f721+x,a
        inc     a
        mov     $25+x,a
        ret

; ------------------------------------------------------------------------------

; [ interrupt $18: game sound effects ]

; b1: sound effect index
; b2: pan value

Interrupt_18:
@0b3d:  movw    ya,$d9               ;se type 2
        beq     @0b42
        ret
@0b42:  mov     $90,$8c
        mov     $91,#$00
        asl     $90
        rol     $91
        asl     $90
        rol     $91
        mov     a,#$00
        mov     y,#$2c
        addw    ya,$90
        movw    $90,ya
        mov     x,#$1e
        mov     $8f,#$80
        mov     a,$83
        bne     @0b65
        mov     a,$84
        eor     a,#$f0
@0b65:  mov     $a1,a
@0b67:  mov     a,$a1
        and     a,$8f
        bne     @0b74
        lsr     $8f
        dec     x
        dec     x
        bbc     $8f.5,@0b67
@0b74:  mov     y,#$03
        mov     $a1,#$00
@0b79:  mov     a,[$90]+y
        beq     @0bb2
        mov     $03+x,a
        dec     y
        mov     a,[$90]+y
        mov     $02+x,a
        or      $a1,$8f
        call    !InitChan
        inc     $25+x
        mov     a,#$41
        mov     !$f621+x,a
        mov     a,#$80
        mov     !$f661+x,a
        mov     a,#$03
        mov     !$f600+x,a
        mov     a,#$00
        mov     !$f6a0+x,a
        mov     !$f6a1+x,a
        push    y
        call    !TerminateChan
        mov     a,#$04
        call    !ChangeSample
        pop     y
        dec     x
        dec     x
        lsr     $8f
        mov     a,#$dc
@0bb2 := *-1
;       dec     y
        dec     y
        bpl     @0b79
        mov     a,$83
        or      a,$a1
        tclr1   !$0022
        tclr1   !$005a
        tclr1   !$005c
        tclr1   !$0060
        tset1   !$0024
        mov     $a2,$83
        mov     x,#$1e
        mov     $8f,#$80
@0bd1:  asl     $a2
        bcc     @0bd8
        call    !TerminateChan
@0bd8:  dec     x
        dec     x
        lsr     $8f
        bbc     $8f.3,@0bd1
        mov     a,$a1
        mov     $83,a
        tclr1   !$0087
        tclr1   !$0089
        tclr1   !$0088
        mov     a,$8d
        mov     $b2,a
        ret

; ------------------------------------------------------------------------------

; [ interrupt $20-$2f: system sound effects ]

SystemSfx:
@0bf1:  movw    ya,$d9               ;se type 1
        bne     @0c53
        mov     a,x
        and     a,#$0f
        asl     a
        mov     y,a
        mov     x,#$20
        mov     a,$83
        or      a,$84
        and     a,#$f0
        mov     $8f,#$80
        cmp     a,#$f0
        beq     @0c15
@0c09:  dec     x
        dec     x
        asl     a
        bcc     @0c22
        lsr     $8f
        bbc     $8f.3,@0c09
        bra     @0c22
@0c15:  dec     x
        dec     x
        mov     a,$84
        and     a,$8f
        bne     @0c22
        lsr     $8f
        bbc     $8f.3,@0c15
@0c22:  mov     a,!SystemSfxTbl+1+y
        beq     @0c53
        mov     $03+x,a
        mov     a,!SystemSfxTbl+y
        mov     $02+x,a
        call    !InitChan
        inc     $25+x
        call    !TerminateChan
        mov     a,$8f
        tclr1   !$005a
        tclr1   !$005c
        tclr1   !$0060
        tset1   !$0024
        tclr1   !$0022
        tclr1   !$0087
        tclr1   !$0089
        tclr1   !$0088
        or      $84,$8f
@0c53:  ret

; ------------------------------------------------------------------------------

; [ interrupts $80-$ff ]

s_0c54:
@0c54:  cmp     x,#$f0
        bcs     @0c5c
        cmp     x,#$90
        bcs     @0c69
@0c5c:  mov     a,x
        and     a,#$1f
        asl     a
        mov     y,a
        mov     a,!InterruptTbl+33+y
        push    a
        mov     a,!InterruptTbl+32+y
        push    a
@0c69:  ret

; ------------------------------------------------------------------------------

; [ interrupt $80/$81/$82: set volume ]

; interrupt $80: set master & sound effect volume
; interrupt $81: set master volume
; interrupt $82: set sound effect volume
; b1: envelope duration
; b2: volume

Interrupt_80:
Interrupt_81:
Interrupt_82:
@0c6a:  mov     a,$8b
        cmp     a,#$82
        bcs     @0c76
        mov     y,$8d
        bne     @0c76
        setc
        mov     y,#$60
@0c76 := *-1
;       clrc
        mov1    $0085.3,c
        mov     x,#$00
        bbc     $8b.0,@0c82
        inc     a
        bra     @0c8f
@0c82:  bbc     $8b.1,@0c8a
        inc     a
        mov     x,#$02
        bra     @0c8f
@0c8a:  inc     $8b
        clrc
        adc     a,#$03
@0c8f:  mov     $98,a
@0c91:  mov     y,$8d
        mov     a,$8c
@0c95:  mov     $ad+x,a
        bne     @0ca3
        mov     $a6+x,y
        mov     $a5+x,a
        mov     $aa+x,a
        mov     $a9+x,a
        bra     @0cb6
@0ca3:  mov     a,y
        setc
        sbc     a,$a6+x
        beq     @0c95
        push    x
        call    !CalcEnvRate
        pop     x
        mov     $a9+x,a
        mov     $aa+x,y
        mov     a,#$00
        mov     $a5+x,a
@0cb6:  inc     $8b
        cmp     $8b,$98
        beq     @0cc1
        inc     x
        inc     x
        bra     @0c91
@0cc1:  mov     $db,#$ff
        ret

; ------------------------------------------------------------------------------

; [ calculate envelope rate ]

; carry set: negate rate
; carry clear: no negate (set by subtraction before calling)
;   a: difference in envelope values
; $8c: envelope duration
;  ya: envelope rate (out)

CalcEnvRate:
@0cc5:  push    psw
        bcs     @0ccb
        eor     a,#$ff
        inc     a
@0ccb:  mov     x,$8c
        mov     y,#$00
        div     ya,x
        mov     $c1,a
        mov     a,#$00
        div     ya,x
        mov     $c0,a
        pop     psw
        bcs     @0ce2
        eor     $c0,#$ff
        eor     $c1,#$ff
        incw    $c0
@0ce2:  movw    ya,$c0
        ret

; ------------------------------------------------------------------------------

; [ interrupt $83: set sound effect pan ]

Interrupt_83:
@0ce5:  mov     y,$8d
        mov     a,$8c
@0ce9:  mov     $b5,a
        bne     @0cf7
        mov     $b2,y
        mov     $b1,a
        mov     $b4,a
        mov     $b3,a
        bra     @0d05
@0cf7:  mov     a,y
        setc
        sbc     a,$b2
        beq     @0ce9
        call    !CalcEnvRate
        movw    $b3,ya
        mov     $b1,#$00
@0d05:  mov     $db,#$ff
        ret

; ------------------------------------------------------------------------------

; [ interrupt $84: set tempo ratio ]

; b1: envelope duration
; b2: tempo ratio (signed fraction)
;       $80 = 1/2x
;       $c0 = 3/4x
;       $00 = 1x
;       $40 = 1.5x
;       $7f = 2x

Interrupt_84:
@0d09:  mov     y,$8d
        mov     a,$8c
@0d0d:  mov     $ba,a
        bne     @0d1b
        mov     $b7,y
        mov     $b6,a
        mov     $b9,a
        mov     $b8,a
        bra     @0d31
@0d1b:  mov     $a2,$b7
        eor     $a2,#$80
        mov     a,y
        eor     a,#$80
        setc
        sbc     a,$a2
        beq     @0d0d
        call    !CalcEnvRate
        movw    $b8,ya
        mov     $b6,#$00
@0d31:  mov     $dc,#$ff
        ret

; ------------------------------------------------------------------------------

; [ interrupt $85: change pitch ]

Interrupt_85:
@0d35:  mov     y,$8d
        mov     a,$8c
@0d39:  mov     $bf,a
        bne     @0d47
        mov     $bc,y
        mov     $bb,a
        mov     $be,a
        mov     $bd,a
        bra     @0d5d
@0d47:  mov     $a2,$bc
        eor     $a2,#$80
        mov     a,y
        eor     a,#$80
        setc
        sbc     a,$a2
        beq     @0d39
        call    !CalcEnvRate
        movw    $bd,ya
        mov     $bb,#$00
@0d5d:  mov     $dc,#$ff
        ret

; ------------------------------------------------------------------------------

; [ interrupt $f3: enable/disable mono mode ]

; b1: 0 = stereo,1 = mono

Interrupt_f3:
@0d61:  mov     a,$8c
        bne     @0d69
        clr1    $85.0
        bra     @0d6b
@0d69:  set1    $85.0
@0d6b:  mov     $db,#$ff
        ret

; ------------------------------------------------------------------------------

; [ interrupt $f0/$f1/$f2: stop song/sound effect ]

; $f0: stop song and sound effect
; $f1: stop song
; $f2: stop sound effect

Interrupt_f0:
Interrupt_f1:
Interrupt_f2:
@0d6f:  bbs     $8b.1,@0d9f
        mov     a,$83
        or      a,$84
        eor     a,#$ff
        tset1   !$0024
        tclr1   !$0022
        tclr1   !$0087
        tclr1   !$0089
        tclr1   !$0088
        mov     a,#$00
        mov     $52,a
        mov     $d9,a
        mov     $53,a
        mov     $57,a
        mov     $55,a
        mov     $a0,a
        dec     a
        mov     $c6,a
        mov     $c7,a
        clr1    $85.3
        bbs     $8b.0,@0dc2
@0d9f:  mov     a,$83
        tset1   !$0024
        tclr1   !$0022
        tclr1   !$00db
        tclr1   !$00dc
        mov     $a1,a
        mov     x,#$1e
        mov     $8f,#$80
@0db4:  asl     $a1
        bcc     @0dbb
        call    !TerminateChan
@0dbb:  dec     x
        dec     x
        lsr     $8f
        bbc     $8f.3,@0db4
@0dc2:  ret

; ------------------------------------------------------------------------------

; [ interrupt $f4: mute voices ]

; b1: voices to mute (bitmask)

Interrupt_f4:
@0dc3:  mov     $a4,$8c
        mov     $db,#$ff
        ret

; ------------------------------------------------------------------------------

; [ interrupt $f5: pause/unpause song ]

; b1: 0 = unpause, 1 = pause

Interrupt_f5:
@0dca:  mov     a,$8c
        beq     @0e16
        mov     y,#$05
@0dd0:  mov     $f2,y
        mov     a,$f3
        and     a,#$7f
        mov     $f3,a
        mov     a,y
        clrc
        adc     a,#$10
        mov     y,a
        bpl     @0dd0
        mov     x,#$00
        mov     y,#$00
@0de3:  mov     $f2,y
        mov     $f3,x
        inc     y
        mov     $f2,y
        mov     $f3,x
        mov     a,y
        clrc
        adc     a,#$0f
        mov     y,a
        bpl     @0de3
        mov     $98,$52
        mov     $99,$83
        movw    ya,$98
        beq     @0e07
        movw    $d9,ya
        mov     a,#$00
        mov     $52,a
        mov     $83,a
        mov     $db,a
@0e07:  mov     $22,a
        mov     y,#$10
@0e0b:  mov     !$00c8+y,a
        dbnz    y,@0e0b
        mov     x,#$ff
        mov     sp,x
        jmp     !Main
@0e16:  mov     y,#$05
@0e18:  mov     $f2,y
        mov     a,$f3
        or      a,#$80
        mov     $f3,a
        mov     a,y
        clrc
        adc     a,#$10
        mov     y,a
        bpl     @0e18
        movw    ya,$d9
        beq     @0e37
        mov     $db,#$ff
        mov     $52,a
        mov     $83,y
        mov     a,#$00
        mov     y,a
        movw    $d9,ya
@0e37:  ret

; ------------------------------------------------------------------------------

; [ interrupt $fe: transfer data from scpu ]

DataTfr:
Interrupt_fe:
@0e38:  mov     x,$f4
        beq     @0e38
        cmp     x,$f4
        bne     @0e38

DataTfrNext:
@0e40:  mov     a,$f5
        cmp     a,#$f0
        beq     @0e71
        mov     $f5,a
        and     a,#$07
        asl     a
        push    a
        movw    ya,$f6
        movw    $90,ya
        pop     a
        cmp     y,#$1a
        bcc     @0e59
        cmp     y,#$f5
        bcc     @0e5b
@0e59:  mov     a,#$00
@0e5b:  mov     $f4,x
        mov     y,a
        mov     a,!DataTfrTbl+1+y
        push    a
        mov     a,!DataTfrTbl+y
        push    a
@0e66:  cmp     x,$f4
        beq     @0e66
@0e6a:  mov     x,$f4
        cmp     x,$f4
        bne     @0e6a
        ret
@0e71:  mov     $f4,x
        jmp     !ResetPorts

; subcommand $03: transfer three bytes at a time
DataTfr_03:
@0e76:  mov     y,#$00
        mov     a,$f5
        mov     [$90]+y,a
        mov     $f4,x
        inc     y
        mov     a,$f6
        mov     [$90]+y,a
        inc     y
        mov     a,$f7
        mov     [$90]+y,a
        clrc
        adc     $90,#$03
        adc     $91,#$00
        cmp     $91,#$f5
        beq     DataTfrNone
@0e94:  cmp     x,$f4
        beq     @0e94
@0e98:  mov     x,$f4
        cmp     x,$f4
        bne     @0e98
        mov     a,#$ff
        mov     y,#$f0
        cmp     y,$f4
        beq     @0eaf
        cmpw    ya,$f4
        bne     @0e76
        mov     $8c,y
        jmp     !Interrupt_ff
@0eaf:  jmp     !DataTfrNext

; subcommand $02: transfer two bytes at a time
DataTfr_02:
@0eb2:  mov     y,#$00
        mov     a,$f6
        mov     [$90]+y,a
        mov     $f4,x
        inc     y
        mov     a,$f7
        mov     [$90]+y,a
        incw    $90
        incw    $90
        cmp     $91,#$f5
        beq     DataTfrNone
@0ec8:  cmp     x,$f4
        beq     @0ec8
@0ecc:  mov     x,$f4
        cmp     x,$f4
        bne     @0ecc
        mov     a,#$ff
        mov     y,#$f0
        cmp     y,$f4
        beq     @0ee3
        cmpw    ya,$f4
        bne     @0eb2
        mov     $8c,y
        jmp     !Interrupt_ff
@0ee3:  jmp     !DataTfrNext

; subcommand $01: transfer one byte at a time
DataTfr_01:
@0ee6:  mov     y,#$00
        mov     $f4,x
        mov     a,$f7
        mov     [$90]+y,a
        incw    $90
        cmp     $91,#$f5
        beq     DataTfrNone
@0ef5:  cmp     x,$f4
        beq     @0ef5
@0ef9:  mov     x,$f4
        cmp     x,$f4
        bne     @0ef9
        mov     a,#$ff
        mov     y,#$f0
        cmp     y,$f4
        beq     @0f10
        cmpw    ya,$f4
        bne     @0ee6
        mov     $8c,y
        jmp     !Interrupt_ff
@0f10:  jmp     !DataTfrNext

; subcommand $00/$04/$05/$06: no transfer
DataTfrNone:
@0f13:  cmp     x,$f4
        beq     @0f13
@0f17:  mov     x,$f4
        cmp     x,$f4
        bne     @0f17
        mov     a,#$ff
        mov     y,#$f0
        cmp     y,$f4
        beq     @0f2e
        cmpw    ya,$f4
        bne     @0f13
        mov     $8c,y
        jmp     !Interrupt_ff
@0f2e:  jmp     !DataTfrNext

; subcommand $07: move chunk (+$90: source address)
DataTfr_07:
@0f31:  movw    ya,$f6
        movw    $92,ya
        mov     $f4,x
        call    !WaitSCPU
        movw    ya,$f6
        movw    $98,ya
        mov     $f4,x
        mov     y,#$00
@0f42:  mov     a,[$90]+y
        mov     [$92]+y,a
        inc     y
        bne     @0f4d
        inc     $91
        inc     $93
@0f4d:  decw    $98
        bne     @0f42
        call    !WaitSCPU
        bcs     @0f61
        movw    ya,$f6
        movw    $90,ya
        mov     $f4,x
        call    !WaitSCPU
        bra     @0f31
@0f61:  jmp     !DataTfrNext

; ------------------------------------------------------------------------------

; [ wait for acknowledgement from scpu ]

; carry set: last chunk,carry clear: not last chunk

WaitSCPU:
@0f64:  mov     a,#$ff
        mov     y,#$f0
@0f68:  cmp     x,$f4
        beq     @0f68
@0f6c:  mov     x,$f4
        cmp     x,$f4
        bne     @0f6c
        cmp     y,$f4
        beq     @0f7f
        cmpw    ya,$f4
        bne     @0f81
        mov     $8c,y
        jmp     !Interrupt_ff
@0f7f:  setc
        mov     y,#$60
@0f81 := *-1
;       clrc
        ret

; ------------------------------------------------------------------------------

; [ interrupt $f6: enable/disable fast forward ]

; b1: 0 = disable, 1 = enable

Interrupt_f6:
@0f83:  mov     a,$8c
        clrc
        adc     a,#$ff
        mov1    $0086.5,c
        bcs     @0f91
        mov     a,#$27
        bra     @0f93
@0f91:  mov     a,#$01
@0f93:  mov     $f1,#$06
        mov     $fa,a
        mov     $f1,#$07
        ret

; ------------------------------------------------------------------------------

; [ interrupt $89: enable conditional jump ]

Interrupt_89:
@0f9c:  mov     $dd,$52
        mov     $f6,$52
        ret

; ------------------------------------------------------------------------------

; [ interrupt $ff: reset ]

; b1: 1 = set waveform output mode, 2 = enable/disable echo, $f0 = reset spc
; b2: 0 = disable, 1 = enable

Interrupt_ff:
@0fa3:  mov     a,$8c

; set wave output mode
        cmp     a,#$01
        bne     @0fb3
        mov     a,$8d
        clrc
        adc     a,#$ff
        mov1    $0086.7,c
        bra     @0fd2

; enable/disable echo
@0fb3:  cmp     a,#$02
        bne     @0fc1
        mov     a,$8d
        clrc
        adc     a,#$ff
        mov1    $0086.6,c
        bra     @0fd2

; reset spc
@0fc1:  cmp     a,#$f0
        bne     @0fd2
        mov     a,#$e0
        mov     y,#$6c
        call    !SetDSP
        mov     $f1,#$80
        jmp     !$ffc0                  ; jump to IPL ROM
@0fd2:  ret

; ------------------------------------------------------------------------------

; [ unused interrupt/script command ]

ScriptCmdNone:
InterruptNone:
@0fd3:  ret

; ------------------------------------------------------------------------------

; [ add to pan value ]

; a: pan value (in/out)
; y: amount to add

AddToPan:
@0fd4:  mov     $c0,a
        mov     a,y
        clrc
        adc     a,$c0
        bbs     $c0.7,@0fe3

; add
        bcc     @0fe7
        mov     a,#$ff                  ; clamp to $ff
        bra     @0fe7

; subtract
@0fe3:  bcs     @0fe7
        mov     a,#$00                  ; clamp to zero
@0fe7:  ret

; ------------------------------------------------------------------------------

; [ interrupt $fd: set dsp register ]

Interrupt_fd:
@0fe8:  mov     y,$8c
        mov     a,$8d
        jmp     !SetDSP

; ------------------------------------------------------------------------------

; [ wait for echo buffer ]

WaitEchoBuf:
@0fef:  mov     $f1,#$05
        mov     a,$fe
        mov     $f1,#$07
        mov     a,#$00
@0ff9:  mov     y,$fe
        beq     @0ff9
        inc     a
        cmp     a,(x)
        bne     @0ff9
        ret

; ------------------------------------------------------------------------------

; [ interrupt $fc: set echo delay ]

; b1: echo delay (lower nybble active)

Interrupt_fc:
SetEchoDelay:
@1002:  and     $8c,#$0f             ;interrupt code fc
        mov     $80,$8c
        call    !ClearEchoBuf
        call    !InitEchoBuf
        mov     a,$52
        bne     @1014
        mov     $4d,a
@1014:  ret

; ------------------------------------------------------------------------------

; [ clear echo buffer ]

ClearEchoBuf:
@1015:  mov     $f2,#$6c
        mov     a,$f3
        or      a,#$20
        mov     $f3,a
        mov     y,#$7d
        mov     $f2,y
        mov     a,$f3
        and     a,#$0f
        mov     $81,a
        mov     a,$80
        call    !SetDSP
        asl     a
        asl     a
        asl     a
        eor     a,#$ff
        inc     a
        clrc
        adc     a,#$f5
        mov     y,#$6d
        call    !SetDSP
        mov     x,#$81
        call    !WaitEchoBuf
        ret

; ------------------------------------------------------------------------------

; [ init echo buffer ]

InitEchoBuf:
@1041:  mov     a,$80
        beq     @104a
        mov     x,#$80
        call    !WaitEchoBuf
@104a:  mov     $f2,#$6c
        mov     a,$f3
        and     a,#$df
        mov     $f3,a
        ret

; ------------------------------------------------------------------------------

; [ save paused song data ]

SuspendSong:
@1054:  cmp     $c7,#$2f             ;save song state
        beq     @1094
        mov     $c6,$c7
        mov     a,#$00
        mov     $90,a
        mov     a,#$f6
        mov     $91,a
        mov     a,#$00
        mov     $92,a
        mov     a,#$fa
        mov     $93,a
        mov     y,#$00
@106e:  mov     a,[$90]+y
        mov     [$92]+y,a
        inc     y
        bne     @106e
        inc     $91
        inc     $93
        cmp     $91,#$fa
        bne     @106e
        decw    $92
        mov     y,#$80
@1082:  mov     a,!$ffff+y
        mov     [$92]+y,a
        dbnz    y,@1082
        inc     $93
        mov     y,#$a0
@108d:  mov     a,!$00ff+y
        mov     [$92]+y,a
        dbnz    y,@108d
@1094:  ret

; ------------------------------------------------------------------------------

; [ restore paused song data ]

ResumeSong:
@1095:  mov     $c6,#$ff             ;load song state
        mov     a,#$00
        mov     $90,a
        mov     a,#$f6
        mov     $91,a
        mov     a,#$00
        mov     $92,a
        mov     a,#$fa
        mov     $93,a
        mov     y,#$00
@10aa:  mov     a,[$92]+y
        mov     [$90]+y,a
        inc     y
        bne     @10aa
        inc     $91
        inc     $93
        cmp     $91,#$fa
        bne     @10aa
        decw    $92
        mov     y,#$80
@10be:  mov     a,[$92]+y
        mov     !$ffff+y,a
        dbnz    y,@10be
        inc     $93
        mov     y,#$a0
@10c9:  mov     a,[$92]+y
        mov     !$00ff+y,a
        dbnz    y,@10c9
        mov     $8b,#$81
        mov     $8c,#$10
        mov     $8d,#$ff
        mov     $a6,#$20
        jmp     !Interrupt_80

; ------------------------------------------------------------------------------

; [ update waveform output ]

UpdateWaveOut:
@10df:  mov     a,#$98
        mov     $9d,a
        mov     a,#$c9
        mov     $a1,#$00
        bbs     $86.4,@10f0
        mov     $8f,#$09
        bra     @10f8
@10f0:  mov     $8f,#$49
        clrc
        adc     a,#$08
        set1    $a1.7
@10f8:  mov     $9e,a
        clrc
        adc     a,#$08
        mov     $a0,a
@10ff:  mov     x,$9e
        mov     y,$8f
        mov     $f2,y
        mov     y,$f3
        push    y
        mov     a,(x)+
        asl     a
        mul     ya
        mov     a,y
        and     a,#$70
        mov     $9c,a
        pop     y
        mov     a,(x)+
        asl     a
        mul     ya
        mov     a,y
        mov     $9e,x
        mov     x,$9d
        xcn     a
        and     a,#$07
        or      a,$9c
        or      a,$a1
        mov     (x)+,a
        mov     $9d,x
        clrc
        adc     $8f,#$10
        cmp     $9e,$a0
        bne     @10ff
        movw    ya,$98
        movw    $f4,ya
        movw    ya,$9a
        movw    $f6,ya
        not1    $0086.4
        ret

; ------------------------------------------------------------------------------

; [ update interrupt envelopes ]

UpdateInterruptEnv:
@1138:  mov     a,$ad
        beq     @114b
        dec     $ad
        movw    ya,$a9
        addw    ya,$a5
        cmp     y,$a6
        movw    $a5,ya
        beq     @114b
        or      $db,$52
@114b:  mov     a,$af
        beq     @116c
        movw    ya,$ab
        addw    ya,$a7
        cmp     y,$a8
        movw    $a7,ya
        beq     @115c
        or      $db,$83
@115c:  dec     $af
        bne     @116c
        mov     a,y
        bne     @116c
        mov     $a8,#$ff
        mov     $8b,#$f2
        call    !Interrupt_f0
@116c:  mov     a,$b5
        beq     @117f
        dec     $b5
        movw    ya,$b3
        addw    ya,$b1
        cmp     y,$b2
        movw    $b1,ya
        beq     @117f
        or      $db,$83
@117f:  mov     a,$ba
        beq     @118b
        dec     $ba
        movw    ya,$b8
        addw    ya,$b6
        movw    $b6,ya
@118b:  mov     a,$bf
        beq     @119e
        dec     $bf
        movw    ya,$bd
        addw    ya,$bb
        cmp     y,$bc
        movw    $bb,ya
        beq     @119e
        or      $dc,$52
@119e:  ret

; ------------------------------------------------------------------------------

; jump table for interrupt $FE
DataTfrTbl:
@119f:  .addr   DataTfrNone
        .addr   DataTfr_01
        .addr   DataTfr_02
        .addr   DataTfr_03
        .addr   DataTfrNone
        .addr   DataTfrNone
        .addr   DataTfrNone
        .addr   DataTfr_07

; ------------------------------------------------------------------------------

; [ song command $f0: set tempo ]

; b1: tempo (bpm)

ScriptCmd_f0:
@11af:  mov     $46,a                ;set tempo
        mov     a,#$00
        mov     $45,a
_11b5:  mov     $49,a
        ret

; ------------------------------------------------------------------------------

; [ song command $f1: set tempo w/ envelope ]

; b1: envelope duration (in ticks)
; b2: tempo (bpm)

ScriptCmd_f1:
@11b8:  mov     $49,a                ;ritard tempo
        mov     $8c,a
        call    !GetNextParam
        mov     y,$8c
        beq     ScriptCmd_f0
        setc
        sbc     a,$46
        beq     _11b5
        call    !CalcEnvRate
        mov     x,$a3
        movw    $4a,ya
        ret

; ------------------------------------------------------------------------------

; [ song command $f4: set song volume ]

; b1: song volume

ScriptCmd_f4:
@11d0:  mov     $51,a                ;set master volume
        ret

; ------------------------------------------------------------------------------

; [ song command $c4: set voice volume ]

; b1: volume (high bit inactive)

ScriptCmd_c4:
@11d3:  and     a,#$7f               ;set voice volume
        mov     !$f621+x,a
        mov     a,#$00
        mov     !$f620+x,a
        or      $db,$8f
_11e0:  mov     !$f6a0+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $c5: set voice volume w/ envelope ]

; b1: envelope duration (in ticks)
; b2: target volume (high bit inactive)

ScriptCmd_c5:
@11e4:  mov     !$f6a0+x,a            ;crescendo/decrescendo
        mov     $8c,a
        call    !GetNextParam
        and     a,#$7f
        mov     y,$8c
        beq     ScriptCmd_c4
        setc
        sbc     a,!$f621+x
        beq     _11e0
        call    !CalcEnvRate
        mov     x,$a3
        mov     !$f640+x,a
        mov     a,y
        mov     !$f641+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $f2: set echo volume ]

; b1: echo volume (signed)

ScriptCmd_f2:
_1205:  mov1    c,$00a2.7
        ror     a
        mov     $4d,a
        mov     a,#$00
        mov     $4c,a
_120f:  mov     $50,a
        ret

; ------------------------------------------------------------------------------

; [ song command $f3: set echo volume w/ envelope ]

; b1: envelope duration (in ticks)
; b2: echo volume

ScriptCmd_f3:
@1212:  mov     $50,a
        mov     $8c,a
        call    !GetNextParam
        mov     y,$8c
        beq     _1205
        mov1    c,$00a2.7
        ror     a
        eor     a,#$80
        not1    $004d.7
        setc
        sbc     a,$4d
        not1    $004d.7
        beq     _120f
        call    !CalcEnvRate
        mov     x,$a3
        movw    $4e,ya
        ret

; ------------------------------------------------------------------------------

; [ song command $c6: set voice pan ]

; b1: pan value (01 = left,40 = center,7f = right,top bit inactive)

ScriptCmd_c6:
@1236:  asl     a                     ;set pan
        mov     !$f661+x,a
        mov     a,#$00
        mov     !$f660+x,a
        or      $db,$8f
_1242:  mov     !$f6a1+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $c7: set voice pan w/ envelope ]

; b1: envelope duration (in ticks)
; b2: pan value (01 = left,40 = center,7f = right,top bit inactive)

ScriptCmd_c7:
@1246:  mov     !$f6a1+x,a            ;panslide
        mov     $8c,a
        call    !GetNextParam
        mov     y,$8c
        beq     ScriptCmd_c6
        asl     a
        setc
        sbc     a,!$f661+x
        beq     _1242
        call    !CalcEnvRate
        mov     x,$a3
        mov     !$f680+x,a
        mov     a,y
        mov     !$f681+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $c8: change pitch w/ envelope ]

; b1: envelope duration (in ticks)
; b2: pitch offset (in half steps)

ScriptCmd_c8:
@1266:  inc     a                     ;glissando
        mov     !$f720+x,a
        call    !GetNextParam
        mov     !$0150+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $da: add to transpose ]

; b1: value to add (in half steps,signed)

ScriptCmd_da:
@1271:  clrc                          ;add to transpose
        adc     a,!$f721+x
; fallthrough

; ------------------------------------------------------------------------------

; [ song command $d9: set transpose ]

; b1: transpose value (in half steps,signed)

ScriptCmd_d9:
@1275:  mov     !$f721+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $f7: set echo feedback ]

; b1: envelope duration (in ticks)
; b2: echo feedback (signed)

ScriptCmd_f7:
@1279:  mov     $78,a                ;set echo feedback
        mov     $8c,a
        call    !GetNextParam
        mov     y,$8c
        beq     @1298
        eor     a,#$80
        not1    $0076.7
        setc
        sbc     a,$76
        not1    $0076.7
        call    !CalcEnvRate
        mov     x,$a3
        movw    $79,ya
        bra     @129a
@1298:  mov     $76,a
@129a:  ret

; ------------------------------------------------------------------------------

; [ song command $f8: set filter ]

; b1: envelope duration (in ticks)
; b2: filter index (at $17a8)

ScriptCmd_f8:
@129b:  mov     $77,a                ;set filter
        mov     $8c,a
        call    !GetNextParam
        and     a,#$03
        inc     a
        asl     a
        asl     a
        asl     a
        mov     y,a
        mov     x,#$10
        mov     a,$8c
        beq     @12d6
@12af:  mov     a,#$00
        mov     $63+x,a
        mov     a,$64+x
        eor     a,#$80
        mov     $98,a
        mov     a,!FilterTbl-1+y
        eor     a,#$80
        setc
        sbc     a,$98
        push    y
        push    x
        call    !CalcEnvRate
        pop     x
        mov     !$00fe+x,a
        mov     a,y
        mov     !$00ff+x,a
        pop     y
        dec     y
        dec     x
        dec     x
        bne     @12af
        bra     @12e0
@12d6:  mov     a,!FilterTbl-1+y
        mov     $64+x,a
        dec     y
        dec     x
        dec     x
        bne     @12d6
@12e0:  mov     x,$a3
        ret

; ------------------------------------------------------------------------------

; [ song command $c9: enable vibrato ]

; b1: delay (in ticks)
; b2: cycle duration (4.875ms * this value * 2 = wave period)
; b3: xxaaaaaa
;     x: 0/1 = positive vibrato,2 = negative vibrato,3 = balanced vibrato
;     a: amplitude (low 6 bits active)

ScriptCmd_c9:
@12e3:  mov     !$0110+x,a            ;enable vibrato
        call    !GetNextParam
        mov     !$f6c0+x,a
        mov     $98,a
        call    !GetNextParam
        mov     !$0151+x,a
        call    !CalcVibratoRate
        mov     x,$a3
        movw    ya,$98
        mov     !$f7c0+x,a
        mov     a,y
        mov     !$f7c1+x,a
; fallthrough

; ------------------------------------------------------------------------------

; [ init vibrato ]

InitVibrato:
@1302:  mov     a,#$00
        mov     !$f8c0+x,a
        mov     !$f8c1+x,a
        mov     !$f840+x,a
        mov     !$f841+x,a
        mov     a,!$f6c0+x
        mov     !$f6c1+x,a
        mov     a,!$f7c1+x
        mov     y,a
        mov     a,!$f7c0+x
        movw    $98,ya
        mov     a,!$0190+x
        and     a,#$70
        mov     y,a
        mov     a,!$0110+x
        mov     !$0111+x,a
        call    !CalcVibratoDelay
        mov     !$0190+x,a
        mov     a,$98
        mov     !$f7e0+x,a
        mov     a,$99
        mov     !$f7e1+x,a
        ret

; ------------------------------------------------------------------------------

; [ calculate vibrato/tremolo change rate ]

;    a: amplitude
;  $98: cycle length
; +$98: amplitude change rate (out)

CalcVibratoRate:
@133c:  and     a,#$3f
        inc     a
        mov     y,#$00
        mov     $99,y
        mov     x,$98
        beq     @134d
        div     ya,x
        mov     $99,a
        mov     a,#$00
        div     ya,x
@134d:  mov     $98,a
        lsr     $99
        ror     $98
        lsr     $99
        ror     $98
        movw    ya,$98
        bne     @135d
        inc     $98
@135d:  asl     $98
        rol     $99
        asl     $98
        rol     $99
        ret

; ------------------------------------------------------------------------------

; [ calculate initial vibrato/tremolo change rate ]

;    a: delay (in ticks)
;    y: saved gain counter
; +$98: max change rate
;    a: gain counter (out)
; +$98: initial change rate (out)

CalcVibratoDelay:
@1366:  push    psw
        beq     @1371
        lsr     $99
        ror     $98
        lsr     $99
        ror     $98
@1371:  cmp     $a2,#$80
        bcc     @1383
        cmp     $a2,#$c0
        bcs     @1383
        eor     $98,#$ff
        eor     $99,#$ff
        incw    $98
@1383:  pop     psw
        beq     @138a
        mov     a,y
        or      a,#$07
        mov     y,#$dd
@138a := *-1
;       mov     a,y
        ret

; ------------------------------------------------------------------------------

; [ song command $ca: disable vibrato ]

ScriptCmd_ca:
@138c:  mov     !$0151+x,a            ;disable vibrato
        mov     !$f8c0+x,a
        mov     !$f8c1+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $cb: enable tremolo ]

; b1: delay (in ticks)
; b2: cycle duration (4.875ms * this value * 2 = wave period)
; b3: xxaaaaaa
;     x: 0/1 = positive tremolo, 2 = negative tremolo, 3 = balanced tremolo
;     a: amplitude (low 6 bits active)

ScriptCmd_cb:
@1396:  mov     !$0130+x,a
        call    !GetNextParam
        mov     !$f6e0+x,a
        mov     $98,a
        call    !GetNextParam
        mov     !$0170+x,a
        call    !CalcVibratoRate
        mov     x,$a3
        mov     a,$98
        mov     !$f800+x,a
        mov     a,$99
        mov     !$f801+x,a

; ------------------------------------------------------------------------------

; [ init tremolo ]

InitTremolo:
@13b6:  mov     a,#$00
        mov     !$f860+x,a
        mov     !$f861+x,a
        mov     a,!$f6e0+x
        mov     !$f6e1+x,a
        mov     a,!$f801+x
        mov     y,a
        mov     a,!$f800+x
        movw    $98,ya
        mov     a,!$0190+x
.if TREMOLO_BUGFIX
        and     a,#$07
        xcn     a
.else
        and     a,#$70
.endif
        mov     y,a
        mov     a,!$0130+x
        mov     !$0131+x,a
        call    !CalcVibratoDelay
.if TREMOLO_BUGFIX
        xcn     a
.endif
        mov     !$0190+x,a
        mov     a,$98
        mov     !$f820+x,a
        mov     a,$99
        mov     !$f821+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $cc: disable tremolo ]

ScriptCmd_cc:
@13ea:  mov     !$0170+x,a            ;disable tremolo
        mov     !$f860+x,a
        mov     !$f861+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $cd: enable pansweep ]

ScriptCmd_cd:
@13f4:  clrc                          ;enable pansweep
        inc     a
        beq     @1400
        and     a,#$fe
        bne     @1401
        mov     a,#$02
        bra     @1401
@1400:  setc
@1401:  mov     !$f700+x,a
        ror     a
        mov     !$f701+x,a
        mov     y,a
        call    !GetNextParam
        asl     a
        mov     a,$a2
        and     a,#$7f
        bcc     @1415
        eor     a,#$7f
@1415:  mov     $98,a
        mov     a,y
        bpl     @141f
        mov     $99,#$00
        bra     @1432
@141f:  mov     x,a
        mov     y,#$00
        mov     a,$98
        div     ya,x
        mov     $99,a
        mov     a,#$00
        div     ya,x
        mov     $98,a
        movw    ya,$98
        bne     @1432
        inc     $98
@1432:  bcc     @143c
        eor     $98,#$ff
        eor     $99,#$ff
        incw    $98
@143c:  mov     x,$a3
        mov     a,$98
        mov     !$f7a0+x,a
        mov     a,$99
        mov     !$f7a1+x,a
        mov     a,$a2
; fallthrough

; ------------------------------------------------------------------------------

; [ song command $ce: disable pansweep ]

ScriptCmd_ce:
@144a:  mov     !$0171+x,a
        mov     a,#$00
        mov     !$f880+x,a
        mov     !$f881+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $d7: increment octave ]

ScriptCmd_d7:
@1456:  mov     a,!$f600+x            ;increment octave
        inc     a
        bra     _1460

; ------------------------------------------------------------------------------

; [ song command $d8: decrement octave ]

ScriptCmd_d8:
@145c:  mov     a,!$f600+x            ;decrement octave
        dec     a
; fallthrough

; ------------------------------------------------------------------------------

; [ song command $d6: set octave ]

ScriptCmd_d6:
_1460:  mov     !$f600+x,a            ;set octave
        ret

; ------------------------------------------------------------------------------

; [ song command $d4: enable echo ]

ScriptCmd_d4:
@1464:  cmp     x,#$10               ;enable echo
        bcs     @146d
        or      $53,$8f
        bra     _1470
@146d:  or      $54,$8f
_1470:  mov     a,$83
        or      a,$84
        eor     a,#$ff
        and     a,$53
        or      a,$54
        mov     $87,a
        ret

; ------------------------------------------------------------------------------

; [ song command $d5: disable echo ]

ScriptCmd_d5:
DisableEcho:
@147d:  mov     a,$8f                ;disable echo
        cmp     x,#$10
        bcs     @1488
        tclr1   !$0053
        bra     _1470
@1488:  tclr1   !$0054
        bra     _1470

; ------------------------------------------------------------------------------

; [ song command $d0: enable noise ]

ScriptCmd_d0:
@148d:  cmp     x,#$10               ;enable noise
        bcs     @1496
        or      $55,$8f
        bra     _1499
@1496:  or      $56,$8f
_1499:  mov     $98,$56
        clr1    $98.0
        mov     a,$8a
        and     a,#$e0
        mov     y,$56
        bne     @14aa
        or      a,$62
        bra     @14ac
@14aa:  or      a,$63
@14ac:  mov     $8a,a
        mov     a,$83
        or      a,$84
        eor     a,#$ff
        and     a,$55
        or      a,$98
        mov     $88,a
        ret

; ------------------------------------------------------------------------------

; [ song command $d1: disable noise ]

ScriptCmd_d1:
DisableNoise:
@14bb:  mov     a,$8f                ;disable noise
        cmp     x,#$10
        bcs     @14c6
        tclr1   !$0055
        bra     _1499
@14c6:  tclr1   !$0056
        bra     _1499

; ------------------------------------------------------------------------------

; [ song command $cf: set noise clock ]

; b1: noise clock value ($1f max)

ScriptCmd_cf:
@14cb:  and     a,#$1f               ;set noise clock
        cmp     x,#$10
        bcs     @14d5
        mov     $62,a
        bra     _1499
@14d5:  mov     $63,a
        bra     _1499

; ------------------------------------------------------------------------------

; [ song command $d2: enable pitch modulation ]

ScriptCmd_d2:
@14d9:  cmp     x,#$10               ;enable pitch modulation
        bcs     @14e2
        or      $57,$8f
        bra     _14e5
@14e2:  or      $58,$8f
_14e5:  mov     a,$83
        or      a,$84
        eor     a,#$ff
        and     a,$57
        or      a,$58
        mov     $89,a
        ret

; ------------------------------------------------------------------------------

; [ song command $d3: disable pitch modulation ]

ScriptCmd_d3:
DisablePitchMod:
@14f2:  mov     a,$8f                ;disable pitch modulation
        cmp     x,#$10
        bcs     @14fd
        tclr1   !$0057
        bra     _14e5
@14fd:  tclr1   !$0058
        bra     _14e5

; ------------------------------------------------------------------------------

; [ song command $dc: change sample ]

ChangeSample:
ScriptCmd_dc:
@1502:  mov     !$f601+x,a            ;change sample
        asl     a
        mov     y,a
        mov     a,!$1a00+y
        mov     !$f740+x,a
        mov     a,!$1a01+y
        mov     !$f741+x,a
        mov     a,!$1a80+y
        mov     !$f900+x,a
        mov     a,!$1a81+y
        mov     !$f901+x,a
        cmp     x,#$10
        bcs     @1528
        mov     a,$8f
        tclr1   !$0061
@1528:  ret

; ------------------------------------------------------------------------------

; [ update sample and adsr data ]

UpdateSample:
@1529:  mov     a,!$f601+x            ;set voice's sample in dsp
        mov     y,a
        mov     a,x
        xcn     a
        lsr     a
        or      a,#$04
        mov     $f2,a
        mov     $f3,y
        bra     SetADSR

; ------------------------------------------------------------------------------

; [ song command $dd: set adsr attack value ]

ScriptCmd_dd:
@1538:  and     a,#$0f               ;set adsr attack value
        mov     $a2,a
        mov     a,!$f900+x
        and     a,#$70
        or      a,$a2
        or      a,#$80
        mov     !$f900+x,a
; fallthrough

; ------------------------------------------------------------------------------

; [ set ADSR value in DSP ]

SetADSR:
_1548:  cmp     x,#$10               ;refresh adsr data in dsp
        bcs     @1555
        mov     a,$83
        or      a,$84
        and     a,$8f
        beq     @1555
        ret
@1555:  mov     a,x
        xcn     a
        lsr     a
        or      a,#$05
        mov     y,a
        mov     a,!$f900+x
        call    !SetDSP
        inc     y
        mov     a,!$f901+x
        jmp     !SetDSP

; ------------------------------------------------------------------------------

; [ song command $de: set adsr decay value ]

ScriptCmd_de:
@1568:  and     a,#$07               ;set adsr decay value
        xcn     a
        mov     $a2,a
        mov     a,!$f900+x
        and     a,#$0f
        or      a,$a2
        or      a,#$80
        mov     !$f900+x,a
        bra     SetADSR

; ------------------------------------------------------------------------------

; [ song command $df: set adsr sustain value ]

ScriptCmd_df:
@157b:  and     a,#$07               ;set adsr sustain value
        xcn     a
        asl     a
        mov     $a2,a
        mov     a,!$f901+x
        and     a,#$1f
        or      a,$a2
        mov     !$f901+x,a
        bra     SetADSR

; ------------------------------------------------------------------------------

; [ song command $e0: set adsr release value ]

ScriptCmd_e0:
@158d:  and     a,#$1f               ;set adsr release value
        mov     $a2,a
        mov     a,!$f901+x
        and     a,#$e0
        or      a,$a2
        mov     !$f901+x,a
        bra     SetADSR

; ------------------------------------------------------------------------------

; [ song command $e1: reset adsr values to default ]

ScriptCmd_e1:
@159d:  mov     a,!$f601+x
        asl     a
        mov     y,a
        mov     a,!$1a80+y
        mov     !$f900+x,a
        mov     a,!$1a81+y
        mov     !$f901+x,a
        bra     SetADSR

; ------------------------------------------------------------------------------

; [ song command $fb: ignore song volume ]

; note: this gets cleared when the instrument changes

ScriptCmd_fb:
@15b0:  or      $61,$8f
        ret

; ------------------------------------------------------------------------------

; [ song command $e4: enable slur ]

ScriptCmd_e4:
@15b4:  mov     a,$8f                ;enable slur
        cmp     x,#$10
        bcs     @15c5
        tset1   !$005b
        tclr1   !$005d
        tclr1   !$005f
        bra     @15ce
@15c5:  tset1   !$005c
        tclr1   !$005e
        tclr1   !$0060
@15ce:  ret

; ------------------------------------------------------------------------------

; [ disable slur ]

DisableSlur:
@15cf:  mov     a,$8f
        cmp     x,#$10
        bcs     @15da
        tclr1   !$005b
        bra     @15dd
@15da:  tclr1   !$005c
@15dd:  ret

; ------------------------------------------------------------------------------

; [ song command $e6: enable drum roll ]

ScriptCmd_e6:
@15de:  mov     a,$8f                ;disable slur
        cmp     x,#$10
        bcs     @15ec
        tset1   !$005f
        tclr1   !$005b
        bra     @15f2
@15ec:  tset1   !$0060
        tclr1   !$005c
@15f2:  ret

; ------------------------------------------------------------------------------

; [ disable drum roll ]

DisableDrumRoll:
@15f3:  mov     a,$8f
        cmp     x,#$10
        bcs     @15fe
        tclr1   !$005f
        bra     @1601
@15fe:  tclr1   !$0060
@1601:  ret

; ------------------------------------------------------------------------------

; [ song command $e9: play game sound effect (voice a) ]

ScriptCmd_e9:
@1602:  mov     y,#$00
        bra     _1608

; ------------------------------------------------------------------------------

; [ song command $ea: play game sound effect (voice b) ]

ScriptCmd_ea:
@1606:  mov     y,#$02
_1608:  call    !GetGameSfxPtr
        mov     $02+x,a
        mov     $03+x,y
        mov     a,y
        bne     @1615
        jmp     !ScriptCmdTerminate
@1615:  ret

; ------------------------------------------------------------------------------

; [ load pointer to game sound effect script ]

GetGameSfxPtr:
@1616:  mov     $93,#$00             ;load se2 pointer a -> ya
        asl     a
        rol     $93
        asl     a
        rol     $93
        mov     $92,a
        mov     a,y
        mov     y,#$2c
        addw    ya,$92
        movw    $92,ya
        mov     y,#$00
        mov     a,[$92]+y
        push    a
        inc     y
        mov     a,[$92]+y
        mov     y,a
        pop     a
        ret

; ------------------------------------------------------------------------------

; [  ]

s_1633:
@1633:  mov     a,[$90]+y
        mov     y,#$00
        bra     _163d

; ------------------------------------------------------------------------------

; [  ]

s_1639:
@1639:  mov     a,[$90]+y
        mov     y,#$02
_163d:  call    !GetGameSfxPtr
        movw    $90,ya
        mov     a,y
        beq     @1649
        pop     a
        pop     a
        mov     a,#$eb
@1649:  ret

; ------------------------------------------------------------------------------

; [ song command $f6: jump ]

; +b1: jump address

ScriptCmd_f6:
@164a:  mov     y,a                  ;jump
        call    !GetNextParam
        mov     a,y
        mov     y,$a2
        addw    ya,$00
        mov     $02+x,a
        mov     $03+x,y
        ret

; ------------------------------------------------------------------------------

; [  ]

s_1658:
@1658:  mov     a,[$90]+y
        push    a
        inc     y
        mov     a,[$90]+y
        mov     y,a
        pop     a
        addw    ya,$00
        movw    $90,ya
        ret

; ------------------------------------------------------------------------------

; [ song command $f5: jump to second ending ]

;  b1: repeat count (2 = second ending,3 = third ending,...)
; +b2: jump address

; note: this command doesn't work for sound effects
;       the loop will end only if this command is reached during the final loop

ScriptCmd_f5:
@1665:  mov     $9a,a
        call    !GetNextParam
        mov     $98,a
        call    !GetNextParam
        mov     $99,a
        mov     y,$26+x
        mov     a,!$f920+y
        cbne    $9a,@1694
        mov     a,!$f940+y
        dec     a
        bne     @168c
        mov     a,x
        asl     a
        dec     a
        dec     $26+x
        cbne    $26+x,@168c
        clrc
        adc     a,#$04
        mov     $26+x,a
@168c:  movw    ya,$98
        addw    ya,$00
        mov     $02+x,a
        mov     $03+x,y
@1694:  ret

; ------------------------------------------------------------------------------

; [  ]

s_1695:
@1695:  mov     y,$c5
        mov     a,!$f920+y
        mov     y,#$00
        cmp     a,[$90]+y
        bne     @16b9
        mov     y,$c5
        mov     a,!$f940+y
        dec     a
        bne     @16b4
        mov     a,x
        asl     a
        dec     a
        dec     $c5
        cbne    $c5,@16b4
        clrc
        adc     $c5,#$04
@16b4:  mov     y,#$01
        jmp     !s_1658
@16b9:  incw    $90
        incw    $90
        incw    $90
        ret

; ------------------------------------------------------------------------------

; [ song command $e2: loop start ]

; b1: loop count - 1

; note: up to 4 loops may be nested for each voice,if more loops are
; nested,the first loop will be overwritten

ScriptCmd_e2:
@16c0:  inc     $26+x                 ;loop start
        mov     a,x
        asl     a
        clrc
        adc     a,#$04
        cbne    $26+x,@16cf
        setc
        sbc     a,#$04
        mov     $26+x,a
@16cf:  mov     y,$26+x
        mov     a,$a2
        beq     @16d6
        inc     a
@16d6:  mov     !$f940+y,a
        cmp     x,#$10
        bcs     @16e2
        mov     a,#$01
        mov     !$f920+y,a
@16e2:  mov     a,y
        asl     a
        mov     y,a
        mov     a,$02+x
        mov     !$f980+y,a
        mov     a,$03+x
        mov     !$f981+y,a
        ret

; ------------------------------------------------------------------------------

; [ song command $e3: loop end ]

ScriptCmd_e3:
@16f0:  mov     y,$26+x              ;loop end
        cmp     x,#$10
        bcs     @16fd
        mov     a,!$f920+y
        inc     a
        mov     !$f920+y,a
@16fd:  mov     a,!$f940+y
        beq     @1717
        dec     a
        bne     @1714
        mov     a,x
        asl     a
        dec     a
        dec     $26+x
        cbne    $26+x,@1724
        clrc
        adc     a,#$04
        mov     $26+x,a
        bra     @1724
@1714:  mov     !$f940+y,a
@1717:  mov     a,y
        asl     a
        mov     y,a
        mov     a,!$f980+y
        mov     $02+x,a
        mov     a,!$f981+y
        mov     $03+x,a
@1724:  ret

; ------------------------------------------------------------------------------

; [  ]

s_1725:
@1725:  mov     y,$c5
        mov     a,!$f940+y
        beq     @173d
        dec     a
        bne     @173d
        mov     a,x
        asl     a
        dec     a
        dec     $c5
        cbne    $c5,@174a
        clrc
        adc     $c5,#$04
        bra     @174a
@173d:  mov     a,y
        asl     a
        mov     y,a
        mov     a,!$f980+y
        mov     $90,a
        mov     a,!$f981+y
        mov     $91,a
@174a:  ret

; ------------------------------------------------------------------------------

; [ song command $e8: add to note duration ]

; b1: ticks to add to duration

ScriptCmd_e8:
@174b:  mov     $25+x,a
        ret

; ------------------------------------------------------------------------------

; [ song command $db: set detune ]

; b1: detune

ScriptCmd_db:
@174e:  mov     !$f760+x,a            ;set detune
        ret

; ------------------------------------------------------------------------------

; [ song command $f9: increment output code ]

ScriptCmd_f9:
@1752:  inc     $7b
        ret

; ------------------------------------------------------------------------------

; [ song command $fa: clear output code ]

ScriptCmd_fa:
@1755:  mov     $7b,#$00
        ret

; ------------------------------------------------------------------------------

; [ song command $fc: conditional jump ]

; +b1: jump address

ScriptCmd_fc:
@1759:  mov     y,a
        call    !GetNextParam
        mov     a,$8f
        and     a,$dd
        beq     @176f
        tclr1   !$00dd
        mov     a,y
        mov     y,$a2
        addw    ya,$00
        mov     $02+x,a
        mov     $03+x,y
@176f:  ret

; ------------------------------------------------------------------------------

; [ song command: end of script ]

ScriptCmdTerminate:
@1770:  pop     a
        pop     a
; fallthrough

; ------------------------------------------------------------------------------

; [ terminate channel ]

TerminateChan:
@1772:  mov     a,$8f
        cmp     x,#$10
        bcs     @177d
        tclr1   !$0052
        bra     @1786
@177d:  tclr1   !$0083
        tclr1   !$0084
        tclr1   !$005d
@1786:  call    !DisableNoise
        call    !DisablePitchMod
        jmp     !DisableEcho

; ------------------------------------------------------------------------------

; note pitch multipliers
; ($1000 * 2 ^ ((note - 11) / 12)),note = 0,1,2,3,...
FreqMultTbl:
@178f:  .word   $0879,$08fa,$0983,$0a14,$0aad,$0b50,$0bfc,$0cb2
        .word   $0d74,$0e41,$0f1a,$1000,$10f3

; ------------------------------------------------------------------------------

; filter data
FilterTbl:
@17a9:  .byte   $7f,$00,$00,$00,$00,$00,$00,$00
        .byte   $0c,$21,$2b,$2b,$13,$fe,$f3,$f9
        .byte   $58,$bf,$db,$f0,$fe,$07,$0c,$0c
        .byte   $34,$33,$00,$d9,$e5,$01,$fc,$eb
        .byte   $80,$80,$80,$80,$7f,$7f,$7f,$7f

; ------------------------------------------------------------------------------

; note durations
NoteDurTbl:
@17d1:  .byte   $c0,$60,$40,$48,$30,$20,$24,$18,$10,$0c,$08,$06,$04,$03

; ------------------------------------------------------------------------------

; pointers to system sound effect scripts
SystemSfxTbl:
@17df:  .addr   SystemSfx_00
        .addr   SystemSfx_01
        .addr   SystemSfx_02
        .addr   SystemSfx_03
        .addr   SystemSfx_04
        .addr   0
        .addr   0
        .addr   0
        .addr   SystemSfx_08
        .addr   SystemSfx_09
        .addr   0
        .addr   0
        .addr   SystemSfx_0c
        .addr   0
        .addr   0
        .addr   0

; ------------------------------------------------------------------------------

; system sound effect scripts

; system sound effect $00: cursor select
SystemSfx_00:
@17ff:  .byte   $c4,$46         ; set volume to 70
        .byte   $dc,$05         ; set instrument to 5
        .byte   $c8,$06,$0c     ; change pitch +12 half steps over 6 ticks
        .byte   $d6,$06         ; set octave to 6
        .byte   $6c             ; note g,sixteenth note triplet
        .byte   $eb             ; end of script

; system sound effect $01: cursor move
SystemSfx_01:
@180a:  .byte   $c4,$46         ; set volume to 70
        .byte   $dc,$05         ; set instrument to 5
        .byte   $c8,$06,$0c     ; change pitch +12 half steps over 6 ticks
        .byte   $d6,$06         ; set octave to 6
        .byte   $96             ; note bb,sixteenth note triplet
        .byte   $eb             ; end of script

; system sound effect $02: error
SystemSfx_02:
@1815:  .byte   $c4,$6e
        .byte   $d6,$04
        .byte   $dc,$06
        .byte   $e2,$04
        .byte   $37
        .byte   $e3
        .byte   $eb

; system sound effect $03: ring (success)
SystemSfx_03:
@1820:  .byte   $c4,$46
        .byte   $dc,$03
        .byte   $dd,$0e
        .byte   $d6,$07
        .byte   $e4
        .byte   $28
        .byte   $37
        .byte   $53
        .byte   $6e
        .byte   $7c
        .byte   $e0,$16
        .byte   $90
        .byte   $eb

; system sound effect $04: delete/erase
SystemSfx_04:
@1832:  .byte   $c4,$46
        .byte   $dc,$07
        .byte   $d6,$07
        .byte   $dd,$06
        .byte   $e0,$16
        .byte   $6c
        .byte   $eb

; system sound effect $08: player 1 character active
SystemSfx_08:
@183e:  .byte   $c4,$6e         ; set volume to 110
        .byte   $c9,$00,$0c,$7f ; enable vibrato (cycle length 12,amplitude +63)
        .byte   $dc,$06         ; set instrument to 6
        .byte   $d6,$05         ; set octave to 5
        .byte   $88             ; note a,sixteenth note triplet
        .byte   $d7             ; increment octave
        .byte   $c4,$64         ; set volume to 100
        .byte   $42             ; note e,sixteenth note triplet
        .byte   $c4,$50         ; set volume to 80
        .byte   $42             ; note e,sixteenth note triplet
        .byte   $c4,$3c         ; set volume to 50
        .byte   $42             ; note e,sixteenth note triplet
        .byte   $c4,$28         ; set volume to 40
        .byte   $42             ; note e,sixteenth note triplet
        .byte   $eb             ; end of script

; system sound effect $09: player 2 character active
SystemSfx_09:
@1857:  .byte   $c4,$6e         ; set volume to 110
        .byte   $c9,$00,$0c,$7f ; enable vibrato (cycle length 12,amplitude +63)
        .byte   $dc,$06         ; set instrument to 6
        .byte   $d6,$05         ; set octave to 5
        .byte   $42             ; note e,sixteenth note triplet
        .byte   $c4,$64         ; set volume to 100
        .byte   $a4             ; note b,sixteenth note triplet
        .byte   $c4,$50         ; set volume to 80
        .byte   $a4             ; note b,sixteenth note triplet
        .byte   $c4,$3c         ; set volume to 50
        .byte   $a4             ; note b,sixteenth note triplet
        .byte   $c4,$28         ; set volume to 40
        .byte   $a4             ; note b,sixteenth note triplet
        .byte   $eb             ; end of script

; system sound effect $0c: ching
SystemSfx_0c:
@186f:  .byte   $c4,$41
        .byte   $dc,$05
        .byte   $d6,$07
        .byte   $e0,$18
        .byte   $99
        .byte   $cb,$00,$06,$bf
        .byte   $e0,$12
        .byte   $d4
        .byte   $9d
        .byte   $eb

; ------------------------------------------------------------------------------

; script command jump table
ScriptCmdTbl:
@1881:  .addr   ScriptCmd_c4
        .addr   ScriptCmd_c5
        .addr   ScriptCmd_c6
        .addr   ScriptCmd_c7
        .addr   ScriptCmd_c8
        .addr   ScriptCmd_c9
        .addr   ScriptCmd_ca
        .addr   ScriptCmd_cb
        .addr   ScriptCmd_cc
        .addr   ScriptCmd_cd
        .addr   ScriptCmd_ce
        .addr   ScriptCmd_cf
        .addr   ScriptCmd_d0
        .addr   ScriptCmd_d1
        .addr   ScriptCmd_d2
        .addr   ScriptCmd_d3
        .addr   ScriptCmd_d4
        .addr   ScriptCmd_d5
        .addr   ScriptCmd_d6
        .addr   ScriptCmd_d7
        .addr   ScriptCmd_d8
        .addr   ScriptCmd_d9
        .addr   ScriptCmd_da
        .addr   ScriptCmd_db
        .addr   ScriptCmd_dc
        .addr   ScriptCmd_dd
        .addr   ScriptCmd_de
        .addr   ScriptCmd_df
        .addr   ScriptCmd_e0
        .addr   ScriptCmd_e1
        .addr   ScriptCmd_e2
        .addr   ScriptCmd_e3
        .addr   ScriptCmd_e4
        .addr   ScriptCmdNone
        .addr   ScriptCmd_e6
        .addr   ScriptCmdNone
        .addr   ScriptCmd_e8
        .addr   ScriptCmd_e9
        .addr   ScriptCmd_ea
        .addr   ScriptCmdTerminate
        .addr   ScriptCmdTerminate
        .addr   ScriptCmdTerminate
        .addr   ScriptCmdTerminate
        .addr   ScriptCmdTerminate
        .addr   ScriptCmd_f0
        .addr   ScriptCmd_f1
        .addr   ScriptCmd_f2
        .addr   ScriptCmd_f3
        .addr   ScriptCmd_f4
        .addr   ScriptCmd_f5
        .addr   ScriptCmd_f6
        .addr   ScriptCmd_f7
        .addr   ScriptCmd_f8
        .addr   ScriptCmd_f9
        .addr   ScriptCmd_fa
        .addr   ScriptCmd_fb
        .addr   ScriptCmd_fc
        .addr   ScriptCmdTerminate
        .addr   ScriptCmdTerminate
        .addr   ScriptCmdTerminate

; ------------------------------------------------------------------------------

; number of data bytes for each script command
ScriptCmdBytesTbl:
@18f9:  .byte           1,2,1,2,2,3,0,3,0,2,0,1
        .byte   0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1
        .byte   1,0,1,0,0,0,0,0,1,1,1,0,0,0,0,0
        .byte   1,2,1,2,1,3,2,2,2,0,0,0,2,0,0,0

; ------------------------------------------------------------------------------

; interrupt jump table ($10-$1f)
InterruptTbl:
@1935:  .addr   Interrupt_10
        .addr   Interrupt_11
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   Interrupt_14
        .addr   Interrupt_15
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   Interrupt_18
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone

; interrupt jump table ($80-$8f)
@1955:  .addr   Interrupt_80
        .addr   Interrupt_81
        .addr   Interrupt_82
        .addr   Interrupt_83
        .addr   Interrupt_84
        .addr   Interrupt_85
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   Interrupt_89
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone

; interrupt jump table ($f0-$ff)
@1975:  .addr   Interrupt_f0
        .addr   Interrupt_f1
        .addr   Interrupt_f2
        .addr   Interrupt_f3
        .addr   Interrupt_f4
        .addr   Interrupt_f5
        .addr   Interrupt_f6
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   InterruptNone
        .addr   Interrupt_fc
        .addr   Interrupt_fd
        .addr   Interrupt_fe
        .addr   Interrupt_ff

; ------------------------------------------------------------------------------

; pointers to dsp registers
DSPRegTbl:
@1995:  .byte   $4c,$2d,$3d,$6c,$5c,$4d,$2c,$3c,$0d
        .byte   $0f,$1f,$2f,$3f,$4f,$5f,$6f,$7f

; ------------------------------------------------------------------------------

; pointers to dsp buffers in ram
DSPBufTbl:
@19a6:  .byte   $22,$89,$88,$8a,$24,$87,$4d,$4d,$76
        .byte   $66,$68,$6a,$6c,$6e,$70,$72,$74

; ------------------------------------------------------------------------------
