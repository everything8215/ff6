; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

zFixedColorRate := $4b
zFixedColorCounter := $4d
zFixedColorTarget := $54

; ------------------------------------------------------------------------------

; [ begin fixed color addition ]

.proc InitFixedColorAdd
        pha
        lda     $4e                     ; save color add/sub settings
        sta     $4f
        lda     $52                     ; save subscreen designation
        sta     $53
        stz     $52                     ; disable all layers in subscreen
        lda     #$07
        sta     $4e                     ; set color add/sub settings
        pla
        bra     :+
.endproc

; ------------------------------------------------------------------------------

; [ begin fixed color subtraction ]

.proc InitFixedColorSub
        pha
        lda     $4e
        sta     $4f
        lda     $52
        sta     $53
        stz     $52
        lda     #$87
        sta     $4e
        pla
:       jsr     CalcFixedColor
        stz     zFixedColorCounter
        rts
.endproc

; ------------------------------------------------------------------------------

; [ update fixed color add/sub hdma data ]

.proc UpdateFixedColor
        lda     zFixedColorRate
        bpl     dec_fixed_color
        and     #$7f
        clc
        adc     zFixedColorCounter      ; add speed to current intensity
        sta     zFixedColorCounter
        lda     zFixedColorTarget       ; branch if not at target intensity
        and     #$1f
        asl3
        cmp     zFixedColorCounter
        bcs     set_color
        lda     zFixedColorCounter      ; clear lower 3 bits (target intensity reached)
        and     #$f8
        sta     zFixedColorCounter
        jmp     set_color

dec_fixed_color:
        lda     zFixedColorCounter
        beq     restore_color
        sec
        sbc     zFixedColorRate         ; subtract speed from current intensity
        sta     zFixedColorCounter
        bra     set_color

restore_color:
        lda     $4f
        sta     $4e
        lda     $53
        sta     $52
        stz     zFixedColorRate

set_color:
        lda     zFixedColorCounter
        lsr3
        sta     $0e
        beq     default_color
        lda     zFixedColorTarget
        and     #FIXED_CLR::MASK
        beq     default_color
        ora     $0e
        bra     set_hdma

default_color:
        lda     #FIXED_CLR::WHITE       ; default value

set_hdma:
        sta     $7e8753                 ; set fixed color hdma data ($2132)
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
.endproc

; ------------------------------------------------------------------------------

; [ init fixed color add/sub ]

; a = bgrssiii
;     b: affect blue
;     g: affect green
;     r: affect red
;     s: speed
;     i: intensity

.proc CalcFixedColor
        pha
        pha

; get colors affected
        and     #FIXED_CLR::MASK
        sta     $1a

; get target intensity
        pla
        and     #$07
        asl2
        clc
        adc     #$03
        ora     $1a
        sta     zFixedColorTarget

; get speed
        pla
        and     #$18
        lsr3
        tax
        lda     f:FixedColorRateTbl,x
        sta     zFixedColorRate
        rts
.endproc

; ------------------------------------------------------------------------------

; fixed color speeds
FixedColorRateTbl:
        .byte   $81,$82,$84,$84

; ------------------------------------------------------------------------------

; [ bg color math $01: increment colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

.proc BGColorInc
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df                     ; first color
loop:   lda     $7400,y                 ; red component (active color palette)
        and     #$1f
        cmp     $1a                     ; branch if greater than red constant
        bcs     :+
        inc                             ; add 1
:       sta     $1e
        lda     $7401,y                 ; blue component
        and     #$7c
        cmp     $1b                     ; branch if greater than blue constant
        bcs     :+
        adc     #$04                    ; add 1
:       sta     $1f
        longa
        lda     $7400,y                 ; green component
        and     #$03e0
        cmp     $20
        bcs     :+
        adc     #$0020
:       ora     $1e                     ; +$1e = modified color
        sta     $7400,y
        shorta0                         ; next color
        iny2
        cpy     $e0                     ; end of color range
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ bg color math $03: decrement colors (restore to normal) ]

.proc BGColorUnInc
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
loop:   lda     $7200,y                   ; unmodified red component
        and     #$1f
        sta     $1a
        lda     $7400,y                   ; active red component
        and     #$1f
        cmp     $1a
        beq     :+
        dec
:       sta     $1e
        lda     $7201,y                   ; unmodified blue component
        and     #$7c
        sta     $1b
        lda     $7401,y                   ; active blue component
        and     #$7c
        cmp     $1b
        beq     :+
        sbc     #$04
:       sta     $1f
        longa
        lda     $7200,y                   ; unmodified green component
        and     #$03e0
        sta     $20
        lda     $7400,y                   ; active green component
        and     #$03e0
        cmp     $20
        beq     :+
        sbc     #$0020
:       ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ bg color math $04: decrement colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

.proc BGColorDec
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
loop:   lda     $7400,y
        and     #$1f
        cmp     $1a
        beq     :+
        bcc     :+
        dec
:       sta     $1e
        lda     $7401,y
        and     #$7c
        cmp     $1b
        beq     :+
        bcc     :+
        sbc     #$04
:       sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        cmp     $20
        beq     :+
        bcc     :+
        sbc     #$0020
:       ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ bg color math $06: increment colors (restore to normal) ]

.proc BGColorUnDec
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
loop:   lda     $7200,y
        and     #$1f
        sta     $1a
        lda     $7400,y
        and     #$1f
        cmp     $1a
        beq     :+
        inc
:       sta     $1e
        lda     $7201,y
        and     #$7c
        sta     $1b
        lda     $7401,y
        and     #$7c
        cmp     $1b
        beq     :+
        adc     #$04
:       sta     $1f
        longa
        lda     $7200,y
        and     #$03e0
        sta     $20
        lda     $7400,y
        and     #$03e0
        cmp     $20
        beq     :+
        adc     #$0020
:       ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ bg color math $02: add color ]

.proc BGColorIncFlash
        lda     #$1f
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
loop:   lda     $7400,y
        and     #$1f
        clc
        adc     $1a
        cmp     #$1f
        bcc     :+
        lda     #$1f
:       sta     $1e
        lda     $7401,y
        and     #$7c
        clc
        adc     $1b
        cmp     #$7c
        bcc     :+
        lda     #$7c
:       sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        clc
        adc     $20
        cmp     #$03e0
        bcc     :+
        lda     #$03e0
:       ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ bg color math $05: subtract color ]

.proc BGColorDecFlash
        lda     $1a
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
loop:   lda     $7400,y
        and     #$1f
        sec
        sbc     $1a
        bpl     :+
        clr_a
:       sta     $1e
        lda     $7401,y
        and     #$7c
        sec
        sbc     $1b
        bpl     :+
        clr_a
:       sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        sec
        sbc     $20
        bpl     :+
        clr_a
:       ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ bg color math $00/$07: restore all colors to normal ]

.proc BGColorRestore
        lda     #$7e
        pha
        plb
        longa
        shorti
        ldx     $00
loop:   lda     $7200,x     ; copy unmodified palette to active palette
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
        bne     loop
        shorta0
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ object color math $01: increment colors ]

;  $1a = ---rrrrr red color target
;  $1b = -bbbbb-- blue color target
; +$20 = ------gg ggg----- green color target

.proc SpriteColorInc
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
loop:   lda     $7500,y
        and     #$1f
        cmp     $1a
        bcs     :+
        inc
:       sta     $1e
        lda     $7501,y
        and     #$7c
        cmp     $1b
        bcs     :+
        adc     #$04
:       sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        cmp     $20
        bcs     :+
        adc     #$0020
:       ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ object color math $03: decrement colors (back to normal) ]

.proc SpriteColorUnInc
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
loop:   lda     $7300,y
        and     #$1f
        sta     $1a
        lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     :+
        dec
:       sta     $1e
        lda     $7301,y
        and     #$7c
        sta     $1b
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     :+
        sbc     #$04
:       sta     $1f
        longa
        lda     $7300,y
        and     #$03e0
        sta     $20
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     :+
        sbc     #$0020
:       ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ object color math $04: decrement colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

.proc SpriteColorDec
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
loop:   lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     :+
        bcc     :+
        dec
:       sta     $1e
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     :+
        bcc     :+
        sbc     #$04
:       sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     :+
        bcc     :+
        sbc     #$0020
:       ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ object color math $06: increment colors (back to normal) ]

.proc SpriteColorUnDec
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
loop:   lda     $7300,y
        and     #$1f
        sta     $1a
        lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     :+
        inc
:       sta     $1e
        lda     $7301,y
        and     #$7c
        sta     $1b
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     :+
        adc     #$04
:       sta     $1f
        longa
        lda     $7300,y
        and     #$03e0
        sta     $20
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     :+
        adc     #$0020
:       ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ object color math $02: add colors (doesn't work) ]

.proc SpriteColorIncFlash
        lda     #$1f
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
loop:   lda     $7500,y
        and     #$1f
        clc
        adc     $1a
        cmp     #$1f
        bcc     :+
        lda     #$1f
:       sta     $1e
        lda     $7501,y
        and     #$7c
        clc
        adc     $1b
        cmp     #$7c
        bcc     :+
        lda     #$7c
:       sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        clc
        adc     $20
        cmp     #$03e0
        bcc     :+
        lda     #$03e0
:       ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ object color math $05: subtract colors ]

.proc SpriteColorDecFlash
        lda     $1a
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
loop:   lda     $7500,y
        and     #$1f
        sec
        sbc     $1a
        bpl     :+
        clr_a
:       sta     $1e
        lda     $7501,y
        and     #$7c
        sec
        sbc     $1b
        bpl     :+
        clr_a
:       sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        sec
        sbc     $20
        bpl     :+
        clr_a
:       ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     loop
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ object color math $00/$07: restore all colors to normal ]

.proc SpriteColorRestore
        lda     #$7e
        pha
        plb
        longa
        shorti
        ldx     $00
loop:   lda     $7300,x
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
        bne     loop
        shorta0
        longi
        clr_a
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------
