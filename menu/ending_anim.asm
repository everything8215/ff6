
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: ending_anim.asm                                                      |
; |                                                                            |
; | description: animation data for ending cutscenes                           |
; |                                                                            |
; | created: 9/5/2022                                                          |
; +----------------------------------------------------------------------------+

.segment "ending_anim1"

; ------------------------------------------------------------------------------

; c2/8a70
@8a70:  .word   $0480
        .byte   $3c
        .word   $0490
        .byte   $3c
        .word   $0490
        .byte   $3c
        .word   $0410
        .byte   $1e
        .word   $0450
        .byte   $1e
        .word   $0440
        .byte   $1e
        .word   $04c0
        .byte   $3c
        .word   $0440
        .byte   $3c
        .word   $0400
        .byte   $3c
        .word   $8400
        .byte   $1e
        .word   $8410
        .byte   $1e
        .word   $0410
        .byte   $78
        .word   $0400
        .byte   $1e
        .word   $8400
        .byte   $3c
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $4400
        .byte   $1e
        .word   $c400
        .byte   $3c
        .word   $4400
        .byte   $3c
        .word   $0400
        .byte   $3c
        .word   $0500
        .byte   $3c
        .word   $0420
        .byte   $78
        .word   $0480
        .byte   $3c
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $fe

@8ac7:  .word   $0090
        .byte   $b4
        .word   $0410
        .byte   $b4
        .word   $0450
        .byte   $1e
        .word   $0440
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $fe

@8ad9:  .word   $08c0
        .byte   $3c
        .word   $08c0
        .byte   $3c
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0020
        .byte   $1e
        .word   $0440
        .byte   $1e
        .word   $0480
        .byte   $3c
        .word   $0220
        .byte   $61
        .word   $8200
        .byte   $46
        .word   $0200
        .byte   $fe

@8afa:  .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $0a
        .word   $0800
        .byte   $78
        .word   $08c0
        .byte   $5a
        .word   $0840
        .byte   $14
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0810
        .byte   $1e
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0820
        .byte   $0a
        .word   $0860
        .byte   $1e
        .word   $0800
        .byte   $fe

@8b36:  .word   $0100
        .byte   $fe

@8b39:  .word   $0400
        .byte   $fe

@8b3c:  .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $fe

@8b42:  .word   $0890
        .byte   $fe

; ------------------------------------------------------------------------------

; book animation 2
@8b45:  .word   $8b89
        .byte   $08
        .word   $8b91
        .byte   $08
        .word   $8b99
        .byte   $08
        .word   $8ba1
        .byte   $08
        .word   $8ba1
        .byte   $ff

; terminate book animation
@8b54:  .word   $8b89
        .byte   $08
        .word   $8b91
        .byte   $08
        .word   $8b99
        .byte   $08
        .word   $8ba9
        .byte   $08
        .word   $8b81
        .byte   $fe

; book animation 1
@8b63:  .word   $8b89
        .byte   $08
        .word   $8b91
        .byte   $08
        .word   $8b99
        .byte   $08
        .word   $8ba1
        .byte   $08
        .word   $8ba1
        .byte   $ff

; book animation (Strago's ending scene)
@8b72:  .word   $8b89
        .byte   $08
        .word   $8b91
        .byte   $08
        .word   $8b99
        .byte   $08
        .word   $8ba1
        .byte   $08
        .word   $8ba1
        .byte   $ff

; book animation tile data
@8b81:  .byte   $1c,$00,$06,$00,$c8,$0b,$d9,$3a
@8b89:  .byte   $1c,$00,$06,$00,$e4,$0b,$d9,$3a
@8b91:  .byte   $1c,$00,$06,$00,$48,$0d,$d9,$3a
@8b99:  .byte   $1c,$00,$06,$00,$64,$0d,$d9,$3a
@8ba1:  .byte   $1c,$00,$06,$00,$c8,$0e,$d9,$3a
@8ba9:  .byte   $1c,$00,$06,$00,$e4,$0e,$d9,$3a

; @8bb1:
; ba 8b 02
; d3 8b 02
; d3 8b ff
;
; 06
; 80 00 0c 32
; 90 00 0e 32
; 80 10 20 32
; 90 10 22 32
; 08 18 6c 32
; 18 18 7c 32
;
; 06
; 80 00 0c 32
; 90 00 0e 32
; 80 10 20 32
; 90 10 22 32
; 08 18 6d 32
; 18 18 7d 32
;
; 01 8c 2b
; 0a 8c 2b
; 13 8c 2b
; 1c 8c 2b
; 13 8c 2b
; 0a 8c 2b
; 01 8c ff
;
; 02
; 00 00 70 32
; 08 00 71 32
;
; 02
; 00 00 72 32
; 08 00 73 32
;
; 02
; 00 00 74 32
; 08 00 75 32
;
; 02
; 00 00 76 32
; 08 00 77 32
;
; 2e 8c 02
; 47 8c 02
; 47 8c ff
;
; 06
; 90 00 0c 72
; 80 00 0e 72
; 90 10 20 72
; 80 10 22 72
; 10 18 6c 72
; 00 18 7c 72
;
; 06
; 90 00 0c 72
; 80 00 0e 72
; 90 10 20 72
; 80 10 22 72
; 10 18 6d 72
; 00 18 7d 72
;
; 63 8c fe
;
; 1e
; b0 38 00 36
; b0 48 02 36
; b0 58 04 36
; c0 38 00 76
; c0 48 02 76
; c0 58 04 76
; b0 00 c0 70
; a0 00 c2 70
; 90 00 c4 70
; b0 10 c6 70
; a0 10 c8 70
; 90 10 ca 70
; b0 20 cc 70
; a0 20 ce 70
; b0 30 e0 70
; 28 30 e2 70
; 90 20 e3 70
; 88 28 e6 70
; c0 00 c0 30
; d0 00 c2 30
; e0 00 c4 30
; c0 10 c6 30
; d0 10 c8 30
; e0 10 ca 30
; c0 20 cc 30
; d0 20 ce 30
; c0 30 e0 30
; 50 30 e2 30
; e0 20 e3 30
; e8 28 e6 30
;
; df 8c fe
;
; 04
; 00 00 08 32
; 08 00 09 32
; 00 08 18 32
; 08 08 19 32
;
; f9 8c 01
; 0a 8d 01
; 0a 8d ff
;
; 04
; 00 00 0a 32
; 08 00 0b 32
; 00 08 1a 32
; 08 08 1b 32
;
; 00
;
; 1a 8d 06
; 23 8d 06
; 2c 8d 06
; 35 8d 06
; 0a 8d fe
;
; 02
; 80 00 40 3e
; 90 00 42 3e
;
; 02
; 80 00 44 3e
; 90 00 46 3e
;
; 02
; 80 00 48 3e
; 90 00 4a 3e
;
; 02
; 80 00 4c 3e
; 90 00 4e 3e
;
; 4d 8d 01
; 5e 8d 01
; 6f 8d 01
; 80 8d 01
; 80 8d ff
;
; 04
; 80 00 80 30
; 90 00 82 30
; 80 10 a0 30
; 90 10 a2 30
;
; 04
; 80 00 84 30
; 90 00 86 30
; 80 10 a4 30
; 90 10 a6 30
;
; 04
; 80 00 88 30
; 90 00 8a 30
; 80 10 a8 30
; 90 10 aa 30
;
; 04
; 80 00 8c 30
; 90 00 8e 30
; 80 10 ac 30
; 90 10 ae 30
;
; a0 8d 01
; b1 8d 01
; c2 8d 01
; d3 8d 01
; d3 8d ff
;
; 04
; 90 00 80 70
; 80 00 82 70
; 90 10 a0 70
; 80 10 a2 70
;
; 04
; 90 00 84 70
; 80 00 86 70
; 90 10 a4 70
; 80 10 a6 70
;
; 04
; 90 00 88 70
; 80 00 8a 70
; 90 10 a8 70
; 80 10 aa 70
;
; 04
; 90 00 8c 70
; 80 00 8e 70
; 90 10 ac 70
; 80 10 ae 70

@8de4:

; ------------------------------------------------------------------------------

.segment "ending_anim2"

; ------------------------------------------------------------------------------

; helmet eyes animation data (Gogo's ending scene)
@f450:  .word   $f453
        .byte   $fe

; helmet eyes sprite data
@f453:  .byte   1
        .byte   $00,$00,$6c,$38

; ------------------------------------------------------------------------------

; mini-moogle animation data (Umaro's ending scene)
@f458:  .word   $f497
        .byte   $04
        .word   $f4a9
        .byte   $04
        .word   $f4bb
        .byte   $04
        .word   $f4c4
        .byte   $04
        .word   $f4cd
        .byte   $04
        .word   $f50c
        .byte   $04
        .word   $f503
        .byte   $04
        .word   $f4f1
        .byte   $04
        .word   $f4f1
        .byte   $ff

@f473:  .word   $f4f1
        .byte   $04
        .word   $f4fa
        .byte   $04
        .word   $f4fa
        .byte   $ff

@f47c:  .word   $f4bb
        .byte   $fe

@f47f:  .word   $f4d6
        .byte   $50
        .word   $f4df
        .byte   $fe

@f485:  .word   $f4cd
        .byte   $3c
        .word   $f4df
        .byte   $fe

@f48b:  .word   $f4cd
        .byte   $28
        .word   $f4df
        .byte   $fe

@f491:  .word   $f4cd
        .byte   $14
        .word   $f4df
        .byte   $fe

@f497:  .byte   2
        .byte   00,$00,$50,$38
        .byte   00,$08,$58,$38

@f4a0:  .byte   2
        .byte   00,$00,$51,$38
        .byte   00,$08,$59,$38

@f4a9:  .byte   2
        .byte   00,$00,$52,$38
        .byte   00,$08,$5a,$38

@f4b2:  .byte   2
        .byte   00,$00,$53,$38
        .byte   00,$08,$5b,$38

@f4bb:  .byte   2
        .byte   00,$00,$54,$38
        .byte   00,$08,$5a,$38

@f4c4:  .byte   2
        .byte   00,$00,$55,$38
        .byte   00,$08,$5a,$38

@f4cd:  .byte   2
        .byte   00,$00,$56,$38
        .byte   00,$08,$5e,$38

@f4d6:  .byte   2
        .byte   00,$00,$57,$38
        .byte   00,$08,$58,$38

@f4df:  .byte   2
        .byte   00,$08,$5c,$38
        .byte   08,$08,$5d,$38

@f4e8:  .byte   2
        .byte   00,$00,$60,$38
        .byte   00,$08,$61,$38

@f4f1:  .byte   2
        .byte   00,$00,$52,$78
        .byte   00,$08,$5a,$78

@f4fa:  .byte   2
        .byte   00,$00,$53,$78
        .byte   00,$08,$5b,$78

@f503:  .byte   2
        .byte   00,$00,$54,$78
        .byte   00,$08,$5a,$78

@f50c:  .byte   2
        .byte   00,$00,$55,$78
        .byte   00,$08,$5a,$78

; ------------------------------------------------------------------------------

; mini-moogle animation data (Mog's ending scene)
@f515:  .word   $f52a
        .byte   $04
        .word   $f53b
        .byte   $04
        .word   $f548
        .byte   $04
        .word   $f555
        .byte   $04
        .word   $f548
        .byte   $04
        .word   $f53b
        .byte   $04
        .word   $f52a
        .byte   $ff

@f52a:  .byte   4
        .byte   $00,$00,$62,$38
        .byte   $08,$00,$63,$38
        .byte   $00,$08,$64,$38
        .byte   $08,$08,$65,$38

@f53b:  .byte   3
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$67,$38
        .byte   $08,$08,$68,$38

@f548:  .byte   3
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$69,$38
        .byte   $08,$08,$6a,$38

@f555:  .byte   2
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$6b,$38

; ------------------------------------------------------------------------------

; y-offset for jumping mini-moogle
@f55e:  .byte   $fe,$fe,$fe,$ff,$ff,$ff,$00,$00,$01,$01,$02,$02,$03,$03,$04,$04

; ------------------------------------------------------------------------------

; skull animation data (Umaro's ending scene)
@f56e:  .word   $f57a
        .byte   $b4
        .word   $f57a
        .byte   $b4
        .word   $f57a
        .byte   $3c
        .word   $f593
        .byte   $fe

@f57a:  .byte   6
        .byte   $00,$00,$80,$38
        .byte   $08,$00,$81,$38
        .byte   $00,$08,$82,$38
        .byte   $08,$08,$83,$38
        .byte   $00,$10,$86,$38
        .byte   $08,$10,$87,$38

@f593:  .byte   8
        .byte   $00,$00,$80,$38
        .byte   $08,$00,$81,$38
        .byte   $00,$08,$84,$38
        .byte   $08,$08,$85,$38
        .byte   $00,$10,$88,$38
        .byte   $08,$10,$89,$38
        .byte   $00,$18,$8a,$38
        .byte   $08,$18,$8b,$38

; ------------------------------------------------------------------------------

; pendant animation data (Terra's ending scene)
@f5b4:  .word   $f612
        .byte   $10
        .word   $f5d5
        .byte   $04
        .word   $f5da
        .byte   $04
        .word   $f5df
        .byte   $04
        .word   $f5e4
        .byte   $04
        .word   $f5f5
        .byte   $04
        .word   $f5e4
        .byte   $04
        .word   $f5df
        .byte   $04
        .word   $f5da
        .byte   $04
        .word   $f5d5
        .byte   $04
        .word   $f612
        .byte   $fe

@f5d5:  .byte   1
        .byte   $04,$04,$4c,$38

@f5da:  .byte   1
        .byte   $04,$04,$4d,$38

@f5df:  .byte   1
        .byte   $04,$04,$4e,$38

@f5e4:  .byte   4
        .byte   $00,$00,$4f,$38
        .byte   $08,$00,$6d,$38
        .byte   $00,$08,$6e,$38
        .byte   $08,$08,$6f,$38

@f5f5:  .byte   1
        .byte   $04,$04,$4e,$78

; ------------------------------------------------------------------------------

; katana animation data (Cyan's ending scene)
@f5fa:  .word   $f613
        .byte   $04
        .word   $f618
        .byte   $04
        .word   $f61d
        .byte   $04
        .word   $f632
        .byte   $04
        .word   $f61d
        .byte   $04
        .word   $f618
        .byte   $04
        .word   $f613
        .byte   $04
        .word   $f612
        .byte   $fe

@f612:  .byte   0

@f613:  .byte   1
        .byte   $08,$08,$44,$38

@f618:  .byte   1
        .byte   $08,$08,$45,$38

@f61d:  .byte   5
        .byte   $08,$00,$46,$38
        .byte   $00,$08,$47,$38
        .byte   $08,$08,$48,$38
        .byte   $10,$08,$47,$78
        .byte   $08,$10,$46,$b8

@f632:  .byte   5
        .byte   $08,$00,$49,$38
        .byte   $00,$08,$4a,$38
        .byte   $08,$08,$4b,$38
        .byte   $10,$08,$4a,$78
        .byte   $08,$10,$49,$b8

; ------------------------------------------------------------------------------

; helmet eyes animation data (Gau's ending scene)
@f647:
        .word   $f612
        .byte   $b4
        .word   $f6b9
        .byte   $02
        .word   $f6b0
        .byte   $02
        .word   $f6a7
        .byte   $02
        .word   $f69e
        .byte   $0a
        .word   $f6a7
        .byte   $02
        .word   $f6b0
        .byte   $02
        .word   $f6b9
        .byte   $01
        .word   $f6b0
        .byte   $01
        .word   $f6a7
        .byte   $01
        .word   $f69e
        .byte   $1e
        .word   $f6a7
        .byte   $02
        .word   $f6b0
        .byte   $02
        .word   $f6b9
        .byte   $01
        .word   $f6b0
        .byte   $01
        .word   $f6a7
        .byte   $01
        .word   $f69e
        .byte   $1e
        .word   $f6a7
        .byte   $04
        .word   $f6b0
        .byte   $04
        .word   $f6b9
        .byte   $02
        .word   $f6c2
        .byte   $04
        .word   $f6d3
        .byte   $04
        .word   $f6e4
        .byte   $04
        .word   $f6f5
        .byte   $04
        .word   $f6e4
        .byte   $04
        .word   $f6d3
        .byte   $04
        .word   $f6c2
        .byte   $04
        .word   $f6b9
        .byte   $02
        .word   $f6b9
        .byte   $fe

@f69e:  .byte   2
        .byte   $00,$00,$00,$38
        .byte   $08,$00,$00,$78

@f6a7:  .byte   2
        .byte   $00,$00,$01,$38
        .byte   $08,$00,$01,$78

@f6b0:  .byte   2
        .byte   $00,$00,$02,$38
        .byte   $08,$00,$02,$78

@f6b9:  .byte   2
        .byte   $00,$00,$03,$38
        .byte   $08,$00,$03,$78

@f6c2:  .byte   4
        .byte   $00,$00,$04,$38
        .byte   $08,$00,$04,$78
        .byte   $00,$08,$05,$38
        .byte   $08,$08,$05,$78

@f6d3:  .byte   4
        .byte   $00,$00,$06,$38
        .byte   $08,$00,$06,$78
        .byte   $00,$08,$07,$38
        .byte   $08,$08,$07,$78

@f6e4:  .byte   4
        .byte   $00,$00,$08,$38
        .byte   $08,$00,$08,$78
        .byte   $00,$08,$09,$38
        .byte   $08,$08,$09,$78

@f6f5:  .byte   4
        .byte   $00,$00,$0a,$38
        .byte   $08,$00,$0a,$78
        .byte   $00,$08,$0b,$38
        .byte   $08,$08,$0b,$78

; ------------------------------------------------------------------------------

@f706:  .word   $f715
        .byte   $08
        .word   $f71a
        .byte   $08
        .word   $f71f
        .byte   $08
        .word   $f724
        .byte   $08
        .word   $f724
        .byte   $ff

@f715:  .byte   1
        .byte   $00,$00,$06,$34

@f71a:  .byte   1
        .byte   $00,$00,$07,$34

@f71f:  .byte   1
        .byte   $00,$00,$16,$34

@f724:  .byte   1
        .byte   $00,$00,$17,$34

; ------------------------------------------------------------------------------

@f729:  .word   $f738
        .byte   $08
        .word   $f73d
        .byte   $08
        .word   $f738
        .byte   $08
        .word   $f742
        .byte   $08
        .word   $f742
        .byte   $ff

@f738:  .byte   1
        .byte   $00,$00,$6a,$34

@f73d:  .byte   1
        .byte   $00,$00,$6b,$34

@f742:  .byte   1
        .byte   $00,$00,$7a,$34

; ------------------------------------------------------------------------------

@f747:  .word   $f74a
        .byte   $fe

@f74a:  .byte   1
        .byte   $00,$00,$7b,$34

; ------------------------------------------------------------------------------

@f74f:  .word   $f75e
        .byte   $08
        .word   $f763
        .byte   $08
        .word   $f768
        .byte   $08
        .word   $f76d
        .byte   $08
        .word   $f76d
        .byte   $ff

@f75e:  .byte   1
        .byte   $00,$00,$6e,$3c

@f763:  .byte   1
        .byte   $00,$00,$6f,$3c

@f768:  .byte   1
        .byte   $00,$00,$7e,$3c

@f76d:  .byte   1
        .byte   $00,$00,$7f,$3c

; ------------------------------------------------------------------------------

@f772:  .word   $f781
        .byte   $08
        .word   $f78a
        .byte   $08
        .word   $f793
        .byte   $08
        .word   $f7a4
        .byte   $08
        .word   $f7a4
        .byte   $ff

@f781:  .byte   2
        .byte   $00,$00,$60,$3c
        .byte   $08,$00,$61,$3c

@f78a:  .byte   2
        .byte   $00,$00,$62,$3c
        .byte   $08,$00,$63,$3c

@f793:  .byte   4
        .byte   $00,$00,$64,$3c
        .byte   $08,$00,$65,$3c
        .byte   $00,$08,$3c,$3c
        .byte   $08,$08,$3d,$3c

@f7a4:  .byte   4
        .byte   $00,$00,$66,$3c
        .byte   $08,$00,$67,$3c
        .byte   $00,$08,$3e,$3c
        .byte   $08,$08,$3f,$3c

; ------------------------------------------------------------------------------

; birds for ending scene with ship
@f7b5:  .word   $f706
        .byte   $f0
        .byte   $18
        .word   $f729
        .byte   $20
        .byte   $70
        .word   $f74f
        .byte   $b0
        .byte   $68
        .word   $f74f
        .byte   $c8
        .byte   $50
        .word   $f706
        .byte   $28
        .byte   $40
        .word   $f772
        .byte   $58
        .byte   $a0
        .word   $f706
        .byte   $f0
        .byte   $18
        .word   $f729
        .byte   $20
        .byte   $70
        .word   $f74f
        .byte   $b0
        .byte   $68
        .word   $f74f
        .byte   $c8
        .byte   $50
        .word   $f706
        .byte   $28
        .byte   $40
        .word   $f772
        .byte   $50
        .byte   $50
        .word   $f729
        .byte   $a0
        .byte   $50
        .word   $f74f
        .byte   $20
        .byte   $60
        .word   $f74f
        .byte   $c0
        .byte   $78
        .word   $f74f
        .byte   $d0
        .byte   $48
        .word   $f706
        .byte   $28
        .byte   $70
        .word   $f74f
        .byte   $50
        .byte   $60

; ------------------------------------------------------------------------------

; ship animation data (unused)
@f7fd:  .word   $f815
        .byte   $08
        .word   $f847
        .byte   $08
        .word   $f879
        .byte   $08
        .word   $f879
        .byte   $ff

; ship animation data (unused)
@f809:  .word   $f82e
        .byte   $08
        .word   $f860
        .byte   $08
        .word   $f892
        .byte   $08
        .word   $f892
        .byte   $ff

@f815:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$28,$74
        .byte   $00,$10,$29,$74

@f82e:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

@f847:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$2c,$74
        .byte   $00,$10,$2d,$74

@f860:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

@f879:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$2e,$74
        .byte   $00,$10,$2f,$74

@f892:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

; ------------------------------------------------------------------------------

; "And you" animation data
@f8ab:  .word   $f8ae
        .byte   $fe

@f8ae:  .byte   $18                     ; should be $0c ???
        .byte   $00,$08,$00,$31
        .byte   $00,$10,$10,$31
        .byte   $08,$08,$0D,$31
        .byte   $08,$10,$1D,$31
        .byte   $10,$08,$03,$31
        .byte   $10,$10,$13,$31
        .byte   $20,$08,$28,$31
        .byte   $20,$10,$38,$31
        .byte   $28,$08,$0E,$31
        .byte   $28,$10,$1E,$31
        .byte   $30,$08,$24,$31
        .byte   $30,$10,$34,$31

; ------------------------------------------------------------------------------

; character graphics pose offsets
MenuCharPoseOffsets:
@f8df:  .word   $03C0
        .word   $0500
        .word   $0540

; character graphics VRAM pointers
CharGfxVRAMAddr:
@f8e5:  .word   $3000
        .word   $3080
        .word   $3200
        .word   $3280
        .word   $3400
        .word   $3480
        .word   $3600
        .word   $3680
        .word   $3800
        .word   $3880
        .word   $3A00
        .word   $3A80
        .word   $3C00
        .word   $3C80
        .word   $3E00
        .word   $3E80
        .word   $3040
        .word   $30C0
        .word   $3240
        .word   $32C0
        .word   $3440
        .word   $34C0

; ------------------------------------------------------------------------------

; pointers to character graphics
MenuCharGfxPtrs:
@f911:  .word   $00D5,$0000
        .word   $00D5,$16A0
        .word   $00D5,$2D40
        .word   $00D5,$43E0
        .word   $00D5,$5A80
        .word   $00D5,$7120
        .word   $00D5,$87C0
        .word   $00D5,$9E60
        .word   $00D5,$B500
        .word   $00D5,$CBA0
        .word   $00D5,$E240
        .word   $00D5,$F8E0
        .word   $00D6,$0F80
        .word   $00D6,$2620
        .word   $00D6,$3CC0
        .word   $00D6,$5360
        .word   $00D6,$6A00
        .word   $00D6,$7F60
        .word   $00D6,$94C0
        .word   $00D6,$AA20
        .word   $00D6,$BF80
        .word   $00D6,$D4E0

; ------------------------------------------------------------------------------
