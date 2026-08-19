; ------------------------------------------------------------------------------

; [ init ??? ]

; tornado

_c16b47:
sin_init:
@6b47:  ldy     zZero
@6b49:  clr_a
        sta     near w7e5f6d,y
        sta     near w7e5f8d,y
        sta     near w7e5f9d,y
        lda     #$40
        sta     near w7e5f7d,y
        iny
        cpy     #$0010
        bne     @6b49
        rts

; ------------------------------------------------------------------------------

; [  ]

; unused ???

sin_p_add:
@6b5f:  pha
        clc
        adc     near w7e5f6d,y
        sta     near w7e5f6d,y
        pla
        clc
        adc     near w7e5f7d,y
        sta     near w7e5f7d,y
        rts

; ------------------------------------------------------------------------------

; [  ]

; unused ???

_c16b70:
r_add:
@6b70:  pha
        clc
        adc     near w7e5f8d,y
        sta     near w7e5f8d,y
        pla
        clc
        adc     near w7e5f9d,y
        sta     near w7e5f9d,y
        rts

; ------------------------------------------------------------------------------

; [ get sine of vector ]

; unused ???

_c16b81:
sin_data_get:
@6b81:  lda     near w7e5f8d,y
        asl
        sta     $24
        lda     near w7e5f6d,y
        jmp     CalcSine8

; ------------------------------------------------------------------------------

; [ get cosine of vector ]

; unused ???

_c16b8d:
cos_get:
@6b8d:  lda     near w7e5f9d,y
        asl
        sta     $24
        lda     near w7e5f7d,y
        jmp     CalcSine8

; ------------------------------------------------------------------------------

; [ A = $24 * sin (A) ]

CalcSine8:
@6b99:  tax
        lda     f:SineTbl8,x
        bpl     @6bba
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
@6bba:  sta     f:hWRMPYA
        lda     $24
        sta     f:hWRMPYB
        lda     #$00
        sta     z67
        sta     z67
        lda     f:hRDMPYH
        rts

; ------------------------------------------------------------------------------

; [ ++$26 = +$22 * $24 * 2 ]

SineMult:
@6bcf:  shortai
        phb
        lda     #$00
        pha
        plb
        ldx     $24
        stx     hWRMPYA
        lda     $22
        sta     hWRMPYB
        longa
        ldy     $23
        nop
        lda     hRDMPYL       ; +$26 = $22 * $24
        stx     hWRMPYA
        sty     hWRMPYB
        sta     $26
        stz     $28
        longi
        lda     hRDMPYL       ; +a = $24 * $23
        clc
        adc     $27
        sta     $27
        asl     $26
        rol     $28
        plb
        rts

; ------------------------------------------------------------------------------

; [ +A = $24 * sin(+$16) * 2 ]

; 16-bit sine and scale
; +$16: phase (9 bits, must be even)

_c16c02:
sin_data_get_w2:
        .a16
@6c02:  longi
        lda     $16
        and     #$01ff
        tax
        lda     f:SineTbl16,x
        bpl     @6c3f

; sine is negative
        shorti
        not_a
        ldx     $24
        stx     hWRMPYA
        tax
        stx     hWRMPYB
        sta     $22
        xba
        tax
        lda     hRDMPYL
        stx     hWRMPYB
        sta     $26
        stz     $28
        clc
        lda     hRDMPYL
        adc     $27
        sta     $27
        asl     $26
        rol     $28
        lda     $28
        neg_a
        rts

; sine is positive
@6c3f:  shorti
        ldx     $24
        stx     hWRMPYA
        tax
        stx     hWRMPYB
        sta     $22
        xba
        tax
        lda     hRDMPYL
        stx     hWRMPYB
        sta     $26
        stz     $28
        clc
        lda     hRDMPYL
        adc     $27
        sta     $27
        asl     $26
        rol     $28
        lda     $28
        rts
        .i16

; ------------------------------------------------------------------------------

; [ +$28 = +$24 * sin (A) ]

CalcSine16:
@6c67:  longa
        and     #$00ff
        asl
        tax
        lda     f:SineTbl16,x
        bpl     @6c88
        not_a
        sta     $22
        jsr     SineMult
        lda     $28
        neg_a
        sta     $28
        shorta0
        rts
@6c88:  sta     $22
        jsr     SineMult
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ calculate hypotenuse & angle ]

;  $7d: x1
;  $7e: y1
;  $7f: x2
;  $80: y2
;  $85: arctan(dy/dx) (out)
; +$86: sqrt(dx^2 + dy^2) (out)
; +$88: |dx| (out)
; +$8a: |dy| (out)

.proc CalcVec

; calculate (dx,dy) and (|dx|,|dy|) using a pretty cool branchles absolute
; value algorithm
        lda     z7d
        sec
        sbc     z7f
        sta     z81                     ; +$81 = (x1 - x2) = -dx (signed)
        lda     #0
        sbc     #0
        sta     z81 + 1
        lda     z7e
        sec
        sbc     z80
        sta     z83                     ; +$83 = (y1 - y2) = -dy (signed)
        lda     #0
        sbc     #0
        sta     z83 + 1
        lda     z81
        eor     z81 + 1
        sec
        sbc     z81 + 1
        sta     z88                     ; +$88 = |delta x|
        stz     z88 + 1
        lda     z83
        eor     z83 + 1
        sec
        sbc     z83 + 1
        sta     z8a                     ; +$8a = |delta y|
        stz     z8a + 1

; get arctan/hypotenuse table offset ------yy yyyxxxxx
        longa
        lda     z88
        lsr3
        sta     z86
        lda     z8a
        and     #$fff8
        asl2
        clc
        adc     z86
        sta     z8c
        asl
        tax
        lda     $f800,x                 ; hypotenuse = sqrt(x^2 + y^2)
        sta     z86
        shorta0
        ldx     z8c
        lda     f:ArcTanTbl,x           ; angle = arctan(y/x)
        sta     z85
        lda     z81 + 1
        bmi     PosX
        lda     z83 + 1
        bmi     PosY

; 3rd quadrant (x < 0, y < 0)
        lda     #$80
        clc
        adc     z85
        sta     z85
        rts

; 2nd quadrant (x < 0, y >= 0)
PosY:   lda     #$80
        sec
        sbc     z85
        sta     z85
        rts

PosX:   lda     z83 + 1
        bmi     Done

; 4th quadrant (x >= 0, y < 0)
        lda     #$00
        sec
        sbc     z85
        sta     z85

; 1st quadrant (x >= 0, y >= 0)
Done:   rts
.endproc  ; CalcVec

; ------------------------------------------------------------------------------

; [ init hypotenuse length table ]

.proc InitHypotenuseTbl
        ldx     #near HypotenuseDataLz
        stx     $f3
        lda     #^HypotenuseDataLz
        sta     $f5
        ldx     #$a400                  ; destination = $7fa400
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress_ext
        ldx     #near wHypotenuseTbl
        stx     $10
        longa
        clr_ax

Loop1:  clr_a
        sta     $12
        tay

Loop2:  lda     $7fa400,x
        and     #$00ff
        clc
        adc     $12
        sta     $12
        sta     ($10),y
        iny2
        inx
        cpy     #$0040
        bne     Loop2
        lda     $10
        clc
        adc     #$0040
        sta     $10
        cpx     #$0400
        bne     Loop1
        shorta0
        rts
.endproc  ; InitHypotenuseTbl

; ------------------------------------------------------------------------------
