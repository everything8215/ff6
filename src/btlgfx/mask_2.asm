; ------------------------------------------------------------------------------

; [ update circle shape ]

UpdateCircleShape:
        .i8
        lda     near wCircleShape       ; circle shape
        asl
        tax
        jmp     (near CircleShapeTbl,x)
        .i16

CircleShapeTbl:
        ptr_tbl CIRCLE_SHAPE

; ------------------------------------------------------------------------------

; [ circle shape $07: ultima ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::ULTIMA
        .i8
        ldx     #$fe
        stz     $22
        stz     $26
@d559:  lda     $26
        and     #$01
        bne     @d58d
        lda     $16
        sec
        sbc     near w7e9e1f,y
        bcc     @d56b
        cmp     #$08
        bcs     @d56d
@d56b:  lda     #$08
@d56d:  sta     f:hWMDATA
        sta     near w7e961f,x
        lda     near w7e9e1f,y
        clc
        adc     $18
        bcs     @d580
        cmp     #$f7
        bcc     @d582
@d580:  lda     #$f7
@d582:  sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
        bra     @d5b1
@d58d:  lda     $16
        sec
        sbc     near w7e9e1f,y
        bcc     @d599
        cmp     #$08
        bcs     @d59b
@d599:  lda     #$08
@d59b:  sta     near w7e961f,x
        lda     near w7e9e1f,y
        clc
        adc     $18
        bcs     @d5aa
        cmp     #$f7
        bcc     @d5ac
@d5aa:  lda     #$f7
@d5ac:  sta     near w7e961f+1,x
        dex2
@d5b1:  inc     $26
        iny
        cpy     $12
        bne     @d559
        clr_a
        sta     near w7e9e1f,y
        dey
        lda     near w7e9e1f,y
        dec
        sta     $12
@d5c3:  lda     near w7e9e1f,y
        cmp     near w7e9e1f-1,y
        beq     @d621
        lda     $26
        and     #$01
        bne     @d5fd
        lda     $16
        sec
        sbc     $12
        bcc     @d5dc
        cmp     #$08
        bcs     @d5de
@d5dc:  lda     #$08
@d5de:  sta     f:hWMDATA
        sta     near w7e961f,x
        lda     $12
        clc
        adc     $18
        bcs     @d5f0
        cmp     #$f7
        bcc     @d5f2
@d5f0:  lda     #$f7
@d5f2:  sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
        bra     @d61f
@d5fd:  lda     $16
        sec
        sbc     $12
        bcc     @d608
        cmp     #$08
        bcs     @d60a
@d608:  lda     #$08
@d60a:  sta     near w7e961f,x
        lda     $12
        clc
        adc     $18
        bcs     @d618
        cmp     #$f7
        bcc     @d61a
@d618:  lda     #$f7
@d61a:  sta     near w7e961f+1,x
        dex2
@d61f:  inc     $26
@d621:  dec     $12
        dey
        bne     @d5c3
        rts
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $04: vertical oval ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::VERT_OVAL
        .i8
@d627:  ldx     #$fc
@d629:  lda     $16
        sec
        sbc     near w7e9e1f,y
        bcc     @d635
        cmp     #$08
        bcs     @d637
@d635:  lda     #$08
@d637:  sta     f:hWMDATA
        sta     $22
        sta     near w7e961f,x
        sta     near w7e961f+2,x
        lda     near w7e9e1f,y
        clc
        adc     $18
        bcs     @d64f
        cmp     #$f7
        bcc     @d651
@d64f:  lda     #$f7
@d651:  sta     f:hWMDATA
        sta     $23
        sta     near w7e961f+1,x
        sta     near w7e961f+3,x
        lda     $22
        sta     f:hWMDATA
        lda     $23
        sta     f:hWMDATA
        dex4
        iny
        cpy     $12
        bne     @d629
        clr_a
        sta     near w7e9e1f,y
        dey
        lda     near w7e9e1f,y
        dec
        sta     $12
@d67d:  lda     near w7e9e1f,y
        cmp     near w7e9e1f-1,y
        beq     @d6c7
        lda     $16
        sec
        sbc     $12
        bcc     @d690
        cmp     #$08
        bcs     @d692
@d690:  lda     #$08
@d692:  sta     f:hWMDATA
        sta     $22
        sta     near w7e961f,x
        sta     near w7e961f+2,x
        lda     $12
        clc
        adc     $18
        bcs     @d6a9
        cmp     #$f7
        bcc     @d6ab
@d6a9:  lda     #$f7
@d6ab:  sta     f:hWMDATA
        sta     $23
        sta     near w7e961f+1,x
        sta     near w7e961f+3,x
        lda     $22
        sta     f:hWMDATA
        lda     $23
        sta     f:hWMDATA
        dex4
@d6c7:  dec     $12
        dey
        bne     @d67d
        rts
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $03: beam from top ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::TOP_BEAM
        .i8
@d6cd:  jsr     array_item CIRCLE_SHAPE, CIRCLE_SHAPE::CIRCLE
        longa
        clr_ax
        lda     near w7e971f
@d6d7:  sta     near w7e961f,x
        sta     near w7e961f+$40,x
        sta     near w7e961f+$80,x
        sta     near w7e961f+$c0,x
        inx2
        cpx     #$40
        bne     @d6d7
        shorta0
        rts
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $06: horizontal oval ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::HORZ_OVAL
        .i8
@d6ed:  ldx     #$fe
        stz     $22
        stz     $26
@d6f3:  lda     $26
        and     #$01
        bne     @d725
        lda     $16
        sec
        sbc     near w7e9e1f,y
        bcc     @d705
        cmp     #$08
        bcs     @d707
@d705:  lda     #$08
@d707:  sta     f:hWMDATA
        sta     near w7e961f,x
        lda     near w7e9e1f,y
        clc
        adc     $18
        bcs     @d71a
        cmp     #$f7
        bcc     @d71c
@d71a:  lda     #$f7
@d71c:  sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
@d725:  inc     $26
        iny
        cpy     $12
        bne     @d6f3
        clr_a
        sta     near w7e9e1f,y
        dey
        lda     near w7e9e1f,y
        dec
        sta     $12
@d737:  lda     near w7e9e1f,y
        cmp     near w7e9e1f-1,y
        beq     @d771
        lda     $26
        and     #$01
        bne     @d76f
        lda     $16
        sec
        sbc     $12
        bcc     @d750
        cmp     #$08
        bcs     @d752
@d750:  lda     #$08
@d752:  sta     f:hWMDATA
        sta     near w7e961f,x
        lda     $12
        clc
        adc     $18
        bcs     @d764
        cmp     #$f7
        bcc     @d766
@d764:  lda     #$f7
@d766:  sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
@d76f:  inc     $26
@d771:  dec     $12
        dey
        bne     @d737
        rts
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $00: circle ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::CIRCLE
        .i8
@d777:  ldx     #$fe
@d779:  lda     $16
        sec
        sbc     near w7e9e1f,y
        bcc     @d785
        cmp     #$08
        bcs     @d787
@d785:  lda     #$08
@d787:  sta     f:hWMDATA
        sta     near w7e961f,x
        lda     near w7e9e1f,y
        clc
        adc     $18
        bcs     @d79a
        cmp     #$f7
        bcc     @d79c
@d79a:  lda     #$f7
@d79c:  sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
        iny
        cpy     $12
        bne     @d779
        jmp     _c2d86e
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $01: bio blast ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::BIO_BLAST
        .i8
@d7ad:  ldx     #$fe
        lda     near w7e961a
        clc
        adc     #$02
        sta     $26
        sta     near w7e961a
@d7ba:  lda     $26
        clc
        adc     #$04
        sta     $26
        phx
        jsr     CalcSine8_near
        sta     $18
        sta     $16
        lda     $1a
        clc
        adc     $18
        sta     $18
        lda     $1a
        clc
        adc     $16
        sta     $16
        plx
        lda     $16
        sec
        sbc     near w7e9e1f,y
        bcc     @d7e4
        cmp     #$08
        bcs     @d7e6
@d7e4:  lda     #$08
@d7e6:  sta     f:hWMDATA
        sta     near w7e961f,x
        lda     near w7e9e1f,y
        clc
        adc     $18
        bcs     @d7f9
        cmp     #$f7
        bcc     @d7fb
@d7f9:  lda     #$f7
@d7fb:  sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
        iny
        cpy     $12
        bne     @d7ba
        jmp     _c2d86e
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $08: slimer blob ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::SLIMER_BLOB
        .i8
@d80c:  jsr     UpdateBlob
        jmp     _c2d9de
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $02: big blob ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::BIG_BLOB
        .i8
@d812:  jsr     UpdateBlob
        jmp     _c2da04
        .i16

; ------------------------------------------------------------------------------

; [ circle shape $05: small blob ]

        array_label CIRCLE_SHAPE, CIRCLE_SHAPE::SMALL_BLOB
        .i8
@d818:  jsr     UpdateBlob
        jmp     _c2d9f1
        .i16

; ------------------------------------------------------------------------------

; [ update blob ]

UpdateBlob:
circle_02_main:
        .i8
@d81e:  ldx     #$fe
@d820:  lda     #$00
        sec
        sbc     near w7e9e1f,y
        sta     f:hWMDATA
        sta     near w7e961f,x
        lda     near w7e9e1f,y
        sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
        iny
        cpy     $12
        bne     @d820
        clr_a
        sta     near w7e9e1f,y
        dey
        lda     near w7e9e1f,y
        dec
        sta     $12
@d849:  lda     near w7e9e1f,y
        cmp     near w7e9e1f-1,y
        beq     @d868
        lda     #$00
        sec
        sbc     $12
        sta     f:hWMDATA
        sta     near w7e961f,x
        lda     $12
        sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
@d868:  dec     $12
        dey
        bne     @d849
        rts
        .i16

; ------------------------------------------------------------------------------

; [  ]

_c2d86e:
@d86e:  clr_a
        sta     near w7e9e1f,y
        dey
        lda     near w7e9e1f,y
        dec
        sta     $12
@d879:  lda     near w7e9e1f,y
        cmp     near w7e9e1f-1,y
        beq     @d8ab
        lda     $16
        sec
        sbc     $12
        bcc     @d88c
        cmp     #$08
        bcs     @d88e
@d88c:  lda     #$08
@d88e:  sta     f:hWMDATA
        sta     near w7e961f,x
        lda     $12
        clc
        adc     $18
        bcs     @d8a0
        cmp     #$f7
        bcc     @d8a2
@d8a0:  lda     #$f7
@d8a2:  sta     f:hWMDATA
        sta     near w7e961f+1,x
        dex2
@d8ab:  dec     $12
        dey
        bne     @d879
        rts

; ------------------------------------------------------------------------------

; [ reset window position buffer ??? ]

_c2d8b1:
clr_circle_mask_data:
@d8b1:  clr_ax
        longa
        shorti
        lda     #$00ff      ; left position = 0, right position = 255
@d8ba:  sta     near w7e961f,x
        sta     near w7e961f+$40,x
        sta     near w7e961f+$80,x
        sta     near w7e961f+$c0,x
        sta     near w7e961f+$0100,x
        sta     near w7e961f+$0140,x
        sta     near w7e961f+$0180,x
        sta     near w7e961f+$01c0,x
        inx2
        cpx     #$40
        bne     @d8ba
        longi
        shorta
        rts

; ------------------------------------------------------------------------------

; [ update circle (long access) ]

UpdateCircle_far:
@d8dd:  jsr     UpdateCircle
        rtl

; ------------------------------------------------------------------------------

; [ update circle ]

UpdateCircle:
@d8e1:  jsr     _c2d8b1
        lda     near w7e9613
        and     #$7f
        bne     @d8ec       ; return if circle size is zero
        rts
@d8ec:  shorti
        sta     $14
        sta     $1e
        lda     near w7e9614       ; circle x position
        sta     $1a
        stz     $20
        lda     near w7e9619       ;
        sta     $24
        lda     near wCircleShape       ; circle shape
        cmp     #CIRCLE_SHAPE::SLIMER_BLOB
        beq     @d90d
        cmp     #CIRCLE_SHAPE::SMALL_BLOB
        beq     @d90d
        cmp     #CIRCLE_SHAPE::BIG_BLOB
        bne     @d922
@d90d:  lda     $14
        sta     $24
        lda     near w7e961a       ;
        jsr     CalcSine8_near
        sta     $24
        lda     $14
        clc
        adc     $24
        sta     $14
        sta     $1e
@d922:  clr_ay
        dec
@d925:  sta     $12
        lda     $1e
        cmp     $20
        bcc     @d950
        sta     near w7e9e1f,y     ;
        lda     $20
        asl
        dec
        sta     $10
        iny
        inc     $20
        lda     $14
        sec
        sbc     $10
        sta     $14
        cmp     $12
        bcc     @d925
        dec     $1e
        lda     $1e
        asl
        clc
        adc     $14
        sta     $14
        bra     @d925
@d950:  sty     $12
        lda     #<w7e971f        ; $7e971f (window position buffer)
        sta     f:hWMADDL
        lda     #>w7e971f
        sta     f:hWMADDM
        lda     #^w7e971f
        sta     f:hWMADDH
        clr_ay
        lda     $1a
        sta     $16
        sta     $18
        jsr     UpdateCircleShape
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

; common routine used for both circle and triangle

_c2d96f:
set_circle_mask_buf:
@d96f:  longi
        lda     near w7e9615
        cmp     #$81
        bcc     @d9a3
        sec
        sbc     #$80
        beq     @d9a3
        longa
        asl2
        sta     $22
        clr_ax
        lda     near wCircleShape       ; circle shape
        and     #$00ff
        cmp     #CIRCLE_SHAPE::TOP_BEAM
        bne     @d995
        lda     near w7e961f
        bra     @d998
@d995:  lda     #$00ff
@d998:  sta     near w7e9a1f+2,x
        inx4
        cpx     $22
        bne     @d998
@d9a3:  lda     near w7e9615
        longa
        and     #$00ff
        asl2
        tax
        clr_ay
@d9b0:  lda     near w7e961f,y
        sta     near w7e981f+2,x
        iny2
        cpy     #$0200
        bne     @d9ce
        lda     #$00ff
@d9c0:  sta     near w7e981f+2,x
        inx4
        cpx     #$045c
        bne     @d9c0
        bra     @d9d7
@d9ce:  inx4
        cpx     #$045c
        bne     @d9b0
@d9d7:  shorta0
        inc     near w7e6197
        rts

; ------------------------------------------------------------------------------

; [ update slimer blob ]

_c2d9de:
@d9de:  longi
        lda     #$08
        sta     near w7e961c
        lda     #$10
        sta     near w7e961e
        lda     #$04
        sta     near w7e961d
        bra     _da15

; ------------------------------------------------------------------------------

; [ update small blob ]

_c2d9f1:
@d9f1:  longi
        lda     #$04
        sta     near w7e961c
        lda     #$0a
        sta     near w7e961e
        lda     #$08
        sta     near w7e961d
        bra     _da15

; ------------------------------------------------------------------------------

; [ update big blob ]

_c2da04:
@da04:  longi
        lda     #$08
        sta     near w7e961c
        lda     #$20
        sta     near w7e961e
        lda     #$04
        sta     near w7e961d
_da15:  lda     near w7e961a
        clc
        adc     near w7e961c
        sta     near w7e961a
        sta     $26
        lda     near w7e961e
        sta     $24
        lda     near w7e961d
        sta     $28
        clr_ay
@da2d:  lda     $26
        clc
        adc     $28
        sta     $26
        lda     near w7e961f+1,y
        beq     @da65
        lda     $26
        jsr     CalcSine8_near
        clc
        adc     $16
        sta     $22
        lda     near w7e961f,y
        clc
        adc     $22
        bcc     @da4f
        cmp     #$08
        bcs     @da51
@da4f:  lda     #$08
@da51:  sta     near w7e961f,y
        lda     near w7e961f+1,y
        clc
        adc     $22
        bcs     @da60
        cmp     #$f7
        bcc     @da62
@da60:  lda     #$f7
@da62:  sta     near w7e961f+1,y
@da65:  iny2
        cpy     #$0200
        bne     @da2d
        rts

; ------------------------------------------------------------------------------

; [ update triangle (far) ]

UpdateTriangle_far:
@da6d:  jsr     UpdateTriangle
        rtl

; ------------------------------------------------------------------------------

; [ update triangle ]

; sort triangle vertices (topmost, leftmost, rightmost), then generate
; window mask hdma data

UpdateTriangle:
@da71:  jsr     _c2d8b1
        lda     near w7e615c
        cmp     near w7e615e
        beq     @da9c
        bcc     @da9c
        lda     near w7e6160
        cmp     near w7e615e
        beq     @daa3
        bcc     @daa3
        ldx     near w7e615b
        stx     near w7e6165
        ldx     near w7e615d
        stx     near w7e6161
        ldx     near w7e615f
        stx     near w7e6163
        bra     @dac9
@da9c:  cmp     near w7e6160
        beq     @dab7
        bcc     @dab7
@daa3:  ldx     near w7e615f
        stx     near w7e6161
        ldx     near w7e615b
        stx     near w7e6163
        ldx     near w7e615d
        stx     near w7e6165
        bra     @dac9
@dab7:  ldx     near w7e615b
        stx     near w7e6161
        ldx     near w7e615d
        stx     near w7e6163
        ldx     near w7e615f
        stx     near w7e6165
@dac9:  lda     near w7e6163
        cmp     near w7e6165
        beq     @dae1
        bcc     @dae1
        ldx     near w7e6163
        phx
        ldx     near w7e6165
        stx     near w7e6163
        plx
        stx     near w7e6165
@dae1:  ldx     near w7e6161
        stx     near w7e614c
        ldx     near w7e6163
        stx     near w7e614e
        jsl     _c2dcc8
        lda     near w7e6161
        sta     $1e
        lda     near w7e6162
        sta     $20
        jsr     _c2db6a
        ldx     near w7e6161
        stx     near w7e614c
        ldx     near w7e6165
        stx     near w7e614e
        jsl     _c2dcc8
        lda     near w7e6161
        sta     $1e
        lda     near w7e6162
        sta     $20
        jsr     _c2dc19
        lda     near w7e6164
        cmp     near w7e6166
        beq     @db44
        bcc     @db44
        ldx     near w7e6165
        stx     near w7e614c
        ldx     near w7e6163
        stx     near w7e614e
        jsl     _c2dcc8
        lda     near w7e6165
        sta     $1e
        lda     near w7e6166
        sta     $20
        jsr     _c2dc19
        bra     @db61
@db44:  ldx     near w7e6163
        stx     near w7e614c
        ldx     near w7e6165
        stx     near w7e614e
        jsl     _c2dcc8
        lda     near w7e6163
        sta     $1e
        lda     near w7e6164
        sta     $20
        jsr     _c2db6a
@db61:  lda     near w7e6155
        sta     near w7e9615
        jmp     _c2d96f

; ------------------------------------------------------------------------------

; [  ]

_c2db6a:
line_set:
@db6a:  lda     near w7e6154
        sta     $10
        bmi     @db75
        lda     #$08
        bra     @db77
@db75:  lda     #$f7
@db77:  sta     $14
        stz     $11
        stz     $15
        stz     $1f
        lda     $20
        longa
        asl
        tay
        lda     $10
        sec
        sbc     #$0080
        sta     $10
        shorta0
        ldx     near w7e6152
        stx     $22
        stx     $24
        lda     $23
        bne     @db9c
        rts
@db9c:  lda     near w7e6150
        bmi     @dbdd
@dba1:  lda     $24
@dba3:  cmp     $23
        bcc     @dbae
        sec
        sbc     $23
        inc     $1e
        bra     @dba3
@dbae:  clc
        adc     $22
        sta     $24
        longa
        lda     $1e
        clc
        adc     $10
        cmp     #$0009
        bcc     @dbc4
        cmp     #$00f8
        bcc     @dbc6
@dbc4:  lda     $14
@dbc6:  sta     $12
        shorta0
        lda     $12
        cmp     near w7e961f+1,y
        bne     @dbd3
        inc
@dbd3:  sta     near w7e961f,y
        iny2
        dec     $25
        bne     @dba1
        rts
@dbdd:  lda     $24
@dbdf:  cmp     $23
        bcc     @dbea
        sec
        sbc     $23
        dec     $1e
        bra     @dbdf
@dbea:  clc
        adc     $22
        sta     $24
        longa
        lda     $1e
        clc
        adc     $10
        cmp     #$0009
        bcc     @dc00
        cmp     #$00f8
        bcc     @dc02
@dc00:  lda     $14
@dc02:  sta     $12
        shorta0
        lda     $12
        cmp     near w7e961f+1,y
        bne     @dc0f
        inc
@dc0f:  sta     near w7e961f,y
        iny2
        dec     $25
        bne     @dbdd
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2dc19:
line_set2:
@dc19:  lda     near w7e6154
        sta     $10
        bmi     @dc24
        lda     #$08
        bra     @dc26
@dc24:  lda     #$f7
@dc26:  sta     $14
        stz     $15
        stz     $11
        stz     $1f
        lda     $20
        longa
        asl
        tay
        lda     $10
        sec
        sbc     #$0080
        sta     $10
        shorta0
        ldx     near w7e6152
        stx     $22
        stx     $24
        lda     $23
        bne     @dc4b
        rts
@dc4b:  lda     near w7e6150
        bmi     @dc8c
@dc50:  lda     $24
@dc52:  cmp     $23
        bcc     @dc5d
        sec
        sbc     $23
        inc     $1e
        bra     @dc52
@dc5d:  clc
        adc     $22
        sta     $24
        longa
        lda     $1e
        clc
        adc     $10
        cmp     #$0009
        bcc     @dc73
        cmp     #$00f8
        bcc     @dc75
@dc73:  lda     $14
@dc75:  sta     $12
        shorta0
        lda     $12
        cmp     near w7e961f,y
        bne     @dc82
        dec
@dc82:  sta     near w7e961f+1,y
        iny2
        dec     $25
        bne     @dc50
        rts
@dc8c:  lda     $24
@dc8e:  cmp     $23
        bcc     @dc99
        sec
        sbc     $23
        dec     $1e
        bra     @dc8e
@dc99:  clc
        adc     $22
        sta     $24
        longa
        lda     $1e
        clc
        adc     $10
        cmp     #$0009
        bcc     @dcaf
        cmp     #$00f8
        bcc     @dcb1
@dcaf:  lda     $14
@dcb1:  sta     $12
        shorta0
        lda     $12
        cmp     near w7e961f,y
        bne     @dcbe
        dec
@dcbe:  sta     near w7e961f+1,y
        iny2
        dec     $25
        bne     @dc8c
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2dcc8:
one_line_init:
@dcc8:  clr_ax
        stx     near w7e6150
        stx     near w7e6152
        lda     near w7e614c
        cmp     near w7e614e
        beq     @dcf6
        bcc     @dce9
        dec     near w7e6150
        lda     near w7e614c
        sec
        sbc     near w7e614e
        sta     near w7e6152
        bra     @dcf6
@dce9:  inc     near w7e6150
        lda     near w7e614e
        sec
        sbc     near w7e614c
        sta     near w7e6152
@dcf6:  lda     near w7e614d
        cmp     near w7e614f
        beq     @dd1c
        bcc     @dd0f
        dec     near w7e6151
        lda     near w7e614d
        sec
        sbc     near w7e614f
        sta     near w7e6153
        bra     @dd1c
@dd0f:  inc     near w7e6151
        lda     near w7e614f
        sec
        sbc     near w7e614d
        sta     near w7e6153
@dd1c:  rtl

; ------------------------------------------------------------------------------

; [  ]

CalcSine8_near:
@dd1d:  tax
        lda     f:SineTbl8,x
        bpl     @dd3e
        not_a
        sta     f:hWRMPYA
        lda     $24
        sta     f:hWRMPYB
        lda     #$ff
        sta     z67
        sta     z67
        lda     f:hRDMPYH
        neg_a
        rts
@dd3e:  sta     f:hWRMPYA
        lda     $24
        sta     f:hWRMPYB
        lda     #$00
        sta     z67
        sta     z67
        lda     f:hRDMPYH
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$70: copy bg3 v-scroll position to hdma data ]

; this makes the bg3 hdma data follow the vertical position of the bg3 thread

AnimCmd_00_70_far:
        longa
        clr_ax
        shorti
        lda     near w7e7b24
        sec
        sbc     near w7e7b2b
@dd60:  sta     near wBG3ScrollData::Vert,x
        inx4
        cpx     #$80
        bne     @dd60
        shorta0
        longi
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6e:  ]

AnimCmd_00_6e_far:
        clr_ax
        stz     $22
@dd75:  lda     near w7e63b0::Horz,x
        clc
        adc     $23
        sta     near w7e63b0::Horz,x
        lda     $22
        clc
        adc     $26
        sta     $22
        inx4
        bne     @dd75
        rtl

; ------------------------------------------------------------------------------
