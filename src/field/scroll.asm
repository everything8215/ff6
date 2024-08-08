; ------------------------------------------------------------------------------

.include "field/treasure_prop.inc"

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ load treasure chest map data ]

InitTreasures:
@15d7:  longa
        lda     $82
        asl
        tax
        lda     f:TreasurePropPtrs+2,x
        sta     $1e
        lda     f:TreasurePropPtrs,x
        tax
        shorta0
        cpx     $1e
        beq     @1637
@15ef:  longa
        lda     f:TreasureProp::PosX,x
        sta     $2a
        lda     f:TreasureProp::PosY,x
        sta     $2b
        phx
        lda     f:TreasureProp::Switch,x
        and     #$01ff
        lsr3
        tay
        lda     f:TreasureProp::Switch,x
        and     #$0007
        tax
        shorta0
        lda     $1e40,y
        and     f:BitOrTbl,x
        beq     @162d
        ldx     $2a
        lda     $7f0000,x
        cmp     #$13
        bne     @162d
        lda     #$12
        sta     $7f0000,x
@162d:  plx
        inx5
        cpx     $1e
        bne     @15ef
@1637:  rts

; ------------------------------------------------------------------------------

; [ load bg2/bg3 color add/sub data ]

InitColorMath:
@1638:  lda     $0540                   ; bg2/bg3 add/sub mode
        asl
        clc
        adc     $0540
        tax
        lda     f:MapColorMath,x        ; color math designation ($2131)
        sta     $4f
        lda     #$22                    ; addition select ($2130)
        sta     $50
        lda     $4b                     ; fixed color fade
        bne     @1653
        lda     $4f
        sta     $4e
@1653:  lda     f:MapColorMath+1,x      ; main screen designation ($212c)
        ora     #$01                    ; bg1 always on
        sta     $51
        lda     f:MapColorMath+2,x      ; sub screen designation ($212d)
        sta     $53
        sta     hTS
        lda     $4b
        bne     @166c
        lda     $53
        sta     $52
@166c:  rts

.pushseg
.segment "map_color_math"

; c0/fe00
MapColorMath:
        fixed_block $40
        .byte   $00,$17,$00
        .byte   $44,$17,$13
        .byte   $13,$13,$04
        .byte   $02,$13,$04
        .byte   $42,$13,$17
        .byte   $04,$17,$13
        .byte   $41,$17,$16
        .byte   $43,$13,$17
        .byte   $41,$13,$17
        .byte   $81,$13,$04
        .byte   $51,$13,$17
        .byte   $82,$13,$04
        .byte   $60,$13,$14
        .byte   $83,$13,$04
        .byte   $51,$13,$04
        .byte   $62,$17,$13
        .byte   $84,$13,$04
        .byte   $86,$15,$02
        .byte   $54,$17,$11
        end_fixed_block

.popseg

; ------------------------------------------------------------------------------

; [ load bg2/bg3 parallax scrolling data ]

InitParallax:
@166d:  lda     $0536                   ; bg2/bg3 scroll mode
        asl3
        tax
        lda     f:MapParallax,x         ; bg2 horizontal scroll speed
        bmi     @1688
        longa
        asl4
        sta     $054b
        shorta0
        bra     @169a
@1688:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054b
        shorta0
@169a:  lda     f:MapParallax+1,x       ; bg2 vertical scroll speed
        bmi     @16ae
        longa
        asl4
        sta     $054d
        shorta0
        bra     @16c0
@16ae:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054d
        shorta0
@16c0:  lda     f:MapParallax+2,x       ; bg3 horizontal scroll speed
        bmi     @16d4
        longa
        asl4
        sta     $054f
        shorta0
        bra     @16e6
@16d4:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054f
        shorta0
@16e6:  lda     f:MapParallax+3,x       ; bg3 vertical scroll speed
        bmi     @16fa
        longa
        asl4
        sta     $0551
        shorta0
        bra     @170c
@16fa:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0551
        shorta0
@170c:  lda     f:MapParallax+4,x       ; bg2 horizontal scroll multiplier
        sta     $0553
        lda     f:MapParallax+5,x       ; bg2 vertical scroll multiplier
        sta     $0554
        lda     f:MapParallax+6,x       ; bg3 horizontal scroll multiplier
        sta     $0555
        lda     f:MapParallax+7,x       ; bg3 vertical scroll multiplier
        sta     $0556
        rts

.pushseg
.segment "map_parallax"

; c0/fe40
MapParallax:
        .incbin "map_parallax.dat"

.popseg

; ------------------------------------------------------------------------------

; [ init map size ]

InitMapSize:
@1729:  ldx     $00
        stx     $5b         ; clear scroll position
        stx     $5d
        stx     $5f
        stx     $61
        stx     $63
        stx     $65
        stx     $67
        stx     $69
        stx     $6b
        stx     $6d
        stx     $6f
        stx     $71
        stx     $73         ; clear movement scroll speed
        stx     $75
        stx     $77
        stx     $79
        stx     $7b
        stx     $7d
        stx     $0547       ; clear event scroll speed
        stx     $0549
        stx     $054b
        stx     $054d
        stx     $054f
        stx     $0551
        stz     $0586       ; disable scrolling redraw
        stz     $0585
        stz     $0588
        stz     $0587
        stz     $058a
        stz     $0589
        jsr     InitScrollClip
        jsr     CalcScrollRange
        rts

; ------------------------------------------------------------------------------

; map size masks
ScrollClipTbl:
@177a:  .byte   $0f,$1f,$3f,$7f,$ff

; ------------------------------------------------------------------------------

; [ calculate min/max scroll positions ]

CalcScrollRange:
@177f:  ldx     $1fc0
        stx     $1f66
        ldx     $053e
        bne     @179a
        stz     $062c
        stz     $062e
        lda     #$ff
        sta     $062d
        sta     $062f
        bra     @17b6
@179a:  lda     #$08
        sta     $062c
        lda     $053e
        sec
        sbc     #$07
        sta     $062d
        lda     #$07
        sta     $062e
        lda     $053f
        sec
        sbc     #$07
        sta     $062f
@17b6:  lda     $062c
        cmp     $1f66
        bcc     @17c3
        sta     $1f66
        bra     @17ce
@17c3:  lda     $062d
        cmp     $1f66
        bcs     @17ce
        sta     $1f66
@17ce:  lda     $062e
        cmp     $1f67
        bcc     @17db
        sta     $1f67
        bra     @17e6
@17db:  lda     $062f
        cmp     $1f67
        bcs     @17e6
        sta     $1f67
@17e6:  rts

; ------------------------------------------------------------------------------

; [ update bg clip data ]

InitScrollClip:
@17e7:  lda     $0537
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $89
        lda     $0537
        lsr2
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $88
        lda     $0537
        lsr4
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $87
        lda     $0537
        lsr6
        tax
        lda     f:ScrollClipTbl,x
        sta     $86
        lda     $0538
        lsr4
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $8b
        lda     $0538
        lsr6
        tax
        lda     f:ScrollClipTbl,x
        sta     $8a
        lda     $0538
        and     #$01
        sta     $0591
        lda     $0538
        lsr
        and     #$01
        sta     $0592
        lda     $0538
        lsr
        and     #$01
        sta     $0593
        rts

; ------------------------------------------------------------------------------

; [ init map tiles ]

InitMapTiles:
@185c:  lda     $0542
        sec
        sbc     #$0f
        sta     $0542
        lda     $0544
        sec
        sbc     #$0f
        sta     $0544
        lda     $0546
        sec
        sbc     #$0f
        sta     $0546
        lda     #$10
@1879:  pha
        jsr     InitBG1VScroll
        jsr     TfrBG1TilesVScroll
        jsr     InitBG2VScroll
        jsr     TfrBG2TilesVScroll
        jsr     InitBG3VScroll
        jsr     TfrBG3TilesVScroll
        inc     $0542
        inc     $0544
        inc     $0546
        pla
        dec
        bne     @1879
        dec     $0542
        dec     $0544
        dec     $0546
        rts

; ------------------------------------------------------------------------------
