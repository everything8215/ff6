; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ begin fixed color addition ]

InitFixedColorAdd:
@102b:  pha
        lda     $4e                     ; save color add/sub settings
        sta     $4f
        lda     $52                     ; save subscreen designation
        sta     $53
        stz     $52                     ; disable all layers in subscreen
        lda     #$07
        sta     $4e                     ; set color add/sub settings
        pla
        bra     _104d

; ------------------------------------------------------------------------------

; [ begin fixed color subtraction ]

InitFixedColorSub:
@103d:  pha
        lda     $4e
        sta     $4f
        lda     $52
        sta     $53
        stz     $52
        lda     #$87
        sta     $4e
        pla
_104d:  jsr     CalcFixedColor
        stz     $4d
        rts

; ------------------------------------------------------------------------------

; [ update fixed color add/sub hdma data ]

UpdateFixedColor:
@1053:  lda     $4b
        bpl     @1072                   ; branch if fading out
        and     #$7f
        clc
        adc     $4d                     ; add speed to current intensity
        sta     $4d
        lda     $54                     ; branch if not past target intensity
        and     #$1f
        asl3
        cmp     $4d
        bcs     @1087
        lda     $4d                     ; clear lower 3 bits (target intensity reached)
        and     #$f8
        sta     $4d
        jmp     @1087
@1072:  lda     $4d
        beq     @107d
        sec
        sbc     $4b                     ; subtract speed from current intensity
        sta     $4d
        bra     @1087
@107d:  lda     $4f
        sta     $4e
        lda     $53
        sta     $52
        stz     $4b
@1087:  lda     $4d                     ; color intensity
        lsr3
        sta     $0e
        beq     @109a                   ; branch if intensity is zero
        lda     $54
        and     #$e0                    ; color components
        beq     @109a                   ; use white if there are no colors
        ora     $0e
        bra     @109c
@109a:  lda     #$e0                    ; set to white
@109c:  sta     $7e8753                 ; set fixed color hdma data ($2132)
        sta     $7e8755
        sta     $7e8757
        sta     $7e8759
        sta     $7e875b
        sta     $7e875d
        sta     $7e875f
        sta     $7e8761
        lda     $4e                     ; fixed color add/sub settings ($2131)
        sta     $7e8c64
        sta     $7e8c66
        sta     $7e8c68
        sta     $7e8c6a
        sta     $7e8c6c
        sta     $7e8c6e
        sta     $7e8c70
        sta     $7e8c72
        lda     $50                     ; color addition select ($2130)
        sta     $7e8c63
        sta     $7e8c65
        sta     $7e8c67
        sta     $7e8c69
        sta     $7e8c6b
        sta     $7e8c6d
        sta     $7e8c6f
        sta     $7e8c71
        lda     $52                     ; subscreen designation ($212d)
        sta     $7e8164
        sta     $7e8166
        sta     $7e8168
        sta     $7e816a
        sta     $7e816c
        sta     $7e816e
        sta     $7e8170
        sta     $7e8172
        rts

; ------------------------------------------------------------------------------

; [ init fixed color add/sub ]

; a = bgrssiii
;     b: affect blue
;     g: affect green
;     r: affect red
;     s: speed
;     i: intensity

CalcFixedColor:
@1123:  pha
        pha
        and     #$e0                    ; colors affected
        sta     $1a
        pla
        and     #$07                    ; intensity
        asl2
        clc
        adc     #$03
        ora     $1a
        sta     $54
        pla
        and     #$18                    ; speed
        lsr3
        tax
        lda     f:FixedColorRateTbl,x
        sta     $4b
        rts

; ------------------------------------------------------------------------------

; fixed color speeds
FixedColorRateTbl:
@1143:  .byte   $81,$82,$84,$84

; ------------------------------------------------------------------------------

; [ bg color math $01: increment colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

BGColorInc:
@1147:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df                       ; first color
@114f:  lda     $7400,y                   ; red component (active color palette)
        and     #$1f
        cmp     $1a                       ; branch if greater than red constant
        bcs     @1159
        inc                               ; add 1
@1159:  sta     $1e
        lda     $7401,y                   ; blue component
        and     #$7c
        cmp     $1b                       ; branch if greater than blue constant
        bcs     @1166
        adc     #$04                      ; add 1
@1166:  sta     $1f
        longa
        lda     $7400,y                   ; green component
        and     #$03e0
        cmp     $20
        bcs     @1177
        adc     #$0020
@1177:  ora     $1e                       ; +$1e = modified color
        sta     $7400,y
        tdc                               ; next color
        shorta
        iny2
        cpy     $e0                       ; end of color range
        bne     @114f
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $03: decrement colors (restore to normal) ]

BGColorUnInc:
@118b:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1193:  lda     $7200,y                   ; unmodified red component
        and     #$1f
        sta     $1a
        lda     $7400,y                   ; active red component
        and     #$1f
        cmp     $1a
        beq     @11a4
        dec
@11a4:  sta     $1e
        lda     $7201,y                   ; unmodified blue component
        and     #$7c
        sta     $1b
        lda     $7401,y                   ; active blue component
        and     #$7c
        cmp     $1b
        beq     @11b8
        sbc     #$04
@11b8:  sta     $1f
        longa
        lda     $7200,y                   ; unmodified green component
        and     #$03e0
        sta     $20
        lda     $7400,y                   ; active green component
        and     #$03e0
        cmp     $20
        beq     @11d1
        sbc     #$0020
@11d1:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @1193
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $04: decrement colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

BGColorDec:
@11e5:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@11ed:  lda     $7400,y
        and     #$1f
        cmp     $1a
        beq     @11f9
        bcc     @11f9
        dec
@11f9:  sta     $1e
        lda     $7401,y
        and     #$7c
        cmp     $1b
        beq     @1208
        bcc     @1208
        sbc     #$04
@1208:  sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        cmp     $20
        beq     @121b
        bcc     @121b
        sbc     #$0020
@121b:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @11ed
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $06: increment colors (restore to normal) ]

BGColorUnDec:
@122f:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1237:  lda     $7200,y
        and     #$1f
        sta     $1a
        lda     $7400,y
        and     #$1f
        cmp     $1a
        beq     @1248
        inc
@1248:  sta     $1e
        lda     $7201,y
        and     #$7c
        sta     $1b
        lda     $7401,y
        and     #$7c
        cmp     $1b
        beq     @125c
        adc     #$04
@125c:  sta     $1f
        longa
        lda     $7200,y
        and     #$03e0
        sta     $20
        lda     $7400,y
        and     #$03e0
        cmp     $20
        beq     @1275
        adc     #$0020
@1275:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @1237
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $02: add color ]

BGColorIncFlash:
@1289:  lda     #$1f
        sta     $1a
        lda     #$7c
        sta     $1b
        ldx     #$03e0
        stx     $20
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@129e:  lda     $7400,y
        and     #$1f
        clc
        adc     $1a
        cmp     #$1f
        bcc     @12ac
        lda     #$1f
@12ac:  sta     $1e
        lda     $7401,y
        and     #$7c
        clc
        adc     $1b
        cmp     #$7c
        bcc     @12bc
        lda     #$7c
@12bc:  sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        clc
        adc     $20
        cmp     #$03e0
        bcc     @12d1
        lda     #$03e0
@12d1:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @129e
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $05: subtract color ]

BGColorDecFlash:
@12e5:  lda     $1a
        clc
        adc     #$04
        sta     $1a
        lda     $1b
        clc
        adc     #$10
        sta     $1b
        longa
        lda     $20
        clc
        adc     #$0080
        sta     $20
        shorta0
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1308:  lda     $7400,y
        and     #$1f
        sec
        sbc     $1a
        bpl     @1313
        tdc
@1313:  sta     $1e
        lda     $7401,y
        and     #$7c
        sec
        sbc     $1b
        bpl     @1320
        tdc
@1320:  sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        sec
        sbc     $20
        bpl     @1330
        tdc
@1330:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @1308
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $00/$07: restore all colors to normal ]

BGColorRestore:
@1344:  lda     #$7e
        pha
        plb
        longa
        shorti
        ldx     $00
@134e:  lda     $7200,x     ; copy unmodified palette to active palette
        sta     $7400,x
        lda     $7202,x
        sta     $7402,x
        lda     $7204,x
        sta     $7404,x
        lda     $7206,x
        sta     $7406,x
        lda     $7208,x
        sta     $7408,x
        lda     $720a,x
        sta     $740a,x
        lda     $720c,x
        sta     $740c,x
        lda     $720e,x
        sta     $740e,x
        txa
        clc
        adc     #$0010
        tax
        bne     @134e
        shorta0
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $01: increment colors ]

;  $1a = ---rrrrr red color target
;  $1b = -bbbbb-- blue color target
; +$20 = ------gg ggg----- green color target

SpriteColorInc:
@138f:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1397:  lda     $7500,y
        and     #$1f
        cmp     $1a
        bcs     @13a1
        inc
@13a1:  sta     $1e
        lda     $7501,y
        and     #$7c
        cmp     $1b
        bcs     @13ae
        adc     #$04
@13ae:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        cmp     $20
        bcs     @13bf
        adc     #$0020
@13bf:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @1397
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $03: decrement colors (back to normal) ]

SpriteColorUnInc:
@13d3:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@13db:  lda     $7300,y
        and     #$1f
        sta     $1a
        lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     @13ec
        dec
@13ec:  sta     $1e
        lda     $7301,y
        and     #$7c
        sta     $1b
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     @1400
        sbc     #$04
@1400:  sta     $1f
        longa
        lda     $7300,y
        and     #$03e0
        sta     $20
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     @1419
        sbc     #$0020
@1419:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @13db
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $04: decrement colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

SpriteColorDec:
@142d:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1435:  lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     @1441
        bcc     @1441
        dec
@1441:  sta     $1e
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     @1450
        bcc     @1450
        sbc     #$04
@1450:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     @1463
        bcc     @1463
        sbc     #$0020
@1463:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @1435
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $06: increment colors (back to normal) ]

SpriteColorUnDec:
@1477:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@147f:  lda     $7300,y
        and     #$1f
        sta     $1a
        lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     @1490
        inc
@1490:  sta     $1e
        lda     $7301,y
        and     #$7c
        sta     $1b
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     @14a4
        adc     #$04
@14a4:  sta     $1f
        longa
        lda     $7300,y
        and     #$03e0
        sta     $20
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     @14bd
        adc     #$0020
@14bd:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @147f
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $02: add colors (doesn't work) ]

SpriteColorIncFlash:
@14d1:  lda     #$1f
        sta     $1a
        lda     #$7c
        sta     $1b
        ldx     #$03e0
        stx     $20
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@14e6:  lda     $7500,y
        and     #$1f
        clc
        adc     $1a
        cmp     #$1f
        bcc     @14f4
        lda     #$1f
@14f4:  sta     $1e
        lda     $7501,y
        and     #$7c
        clc
        adc     $1b
        cmp     #$7c
        bcc     @1504
        lda     #$7c
@1504:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        clc
        adc     $20
        cmp     #$03e0
        bcc     @1519
        lda     #$03e0
@1519:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @14e6
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $05: subtract colors ]

SpriteColorDecFlash:
@152d:  lda     $1a
        clc
        adc     #$04
        sta     $1a
        lda     $1b
        clc
        adc     #$10
        sta     $1b
        longa
        lda     $20
        clc
        adc     #$0080
        sta     $20
        shorta0
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1550:  lda     $7500,y
        and     #$1f
        sec
        sbc     $1a
        bpl     @155b
        tdc
@155b:  sta     $1e
        lda     $7501,y
        and     #$7c
        sec
        sbc     $1b
        bpl     @1568
        tdc
@1568:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        sec
        sbc     $20
        bpl     @1578
        tdc
@1578:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @1550
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $00/$07: restore all colors to normal ]

SpriteColorRestore:
@158c:  lda     #$7e
        pha
        plb
        longa
        shorti
        ldx     $00
@1596:  lda     $7300,x
        sta     $7500,x
        lda     $7302,x
        sta     $7502,x
        lda     $7304,x
        sta     $7504,x
        lda     $7306,x
        sta     $7506,x
        lda     $7308,x
        sta     $7508,x
        lda     $730a,x
        sta     $750a,x
        lda     $730c,x
        sta     $750c,x
        lda     $730e,x
        sta     $750e,x
        txa
        clc
        adc     #$0010
        tax
        bne     @1596
        shorta0
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------
