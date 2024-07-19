; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ update window mask settings ]

SetWindowSelect:
@063c:  lda     $077b
        bne     @064f
        lda     $0781
        bne     @064f
        lda     $0521
        and     #$20
        bne     @064f                   ; branch if spotlights are enabled
        bra     @066d
@064f:  lda     $0526                   ; window mask
        and     #$03
        asl2
        tax
        lda     f:WindowSelectTbl,x
        sta     hW12SEL
        lda     f:WindowSelectTbl+1,x
        sta     hW34SEL
        lda     f:WindowSelectTbl+2,x
        sta     hWOBJSEL
        rts
@066d:  lda     #$33                    ; use default settings
        sta     hW12SEL
        lda     #$03
        sta     hW34SEL
        lda     #$f3
        sta     hWOBJSEL
        rts

; ------------------------------------------------------------------------------

; window mask settings
WindowSelectTbl:
@067d:  .byte   $33,$03,$f3,$00
        .byte   $b3,$03,$f3,$00
        .byte   $ff,$0f,$ff,$00
        .byte   $33,$0f,$f3,$00

; ------------------------------------------------------------------------------

; [ reset window mask hdma data ]

ClearWindowPos:
@068d:  inc     $0566
        lda     $0566
        lsr
        bcs     @069e
        ldx     #$8cb3
        stx     hWMADDL
        bra     @06a4
@069e:  ldx     #$8e53
        stx     hWMADDL
@06a4:  lda     #$7e
        sta     hWMADDH
        lda     #$d0
        jsr     ResetWindowPos
        rts

; ------------------------------------------------------------------------------

; [ update flashlight ]

; use bresenham's circle algorithm (i think...) through 90 degrees to
; find the points of the flashlight circle

UpdateFlashlight:
@06af:  lda     $077b                   ; return if flashlight is not enabled
        bmi     @06b5
        rts
@06b5:  and     #$1f                    ; target flashlight size * 2
        asl
        cmp     $077c                   ; compare to current flashlight size
        beq     @06cd
        bcs     @06c7
        dec     $077c
        dec     $077c
        bra     @06cd
@06c7:  inc     $077c
        inc     $077c
@06cd:  ldy     $0803                   ; party object
        lda     $086a,y                 ; x position
        sec
        sbc     $5c                     ; subtract bg1 scroll pos to get screen pos
        clc
        adc     #$10                    ; add $10
        sta     $077d                   ; set flashlight x position
        lda     $086d,y                 ; y position
        sec
        sbc     $60                     ; subtract bg1 scroll pos to get screen pos
        sec
        sbc     #$08                    ; subtract 8
        sta     $077e                   ; set flashlight y position
        inc     $0566                   ; window 2 frame counter
        lda     $0566
        lsr
        bcs     @06f9
        ldx     #$8cb3                  ; even frame
        stx     hWMADDL
        bra     @06ff
@06f9:  ldx     #$8e53                  ; odd frame
        stx     hWMADDL
@06ff:  lda     #$7e
        sta     hWMADDH
        lda     $077c                   ; $1a = current radius (in pixels)
        sta     $1a
        bne     @0714
        lda     #$d0                    ; radius 0, close window 2 in all lines
        jsr     ResetWindowPos
        stz     $077b
        rts
@0714:  ldx     #$0100                  ; $0100 / flashlight radius
        stx     hWRDIVL
        lda     $1a
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        sta     hWRMPYA                 ; 1 / r
        lda     $1a
        sta     $27                     ; +$26: x = r + 0.5
        lda     #$80
        sta     $26
        stz     $28                     ; +$28: y = 0
        stz     $29
        shorti
        longa
@073c:  ldx     $29
        stx     hWRMPYB
        lda     $26                     ; x -= y / r
        sec
        sbc     hRDMPYL
        sta     $26
        bmi     @075f                   ; exit loop when x goes negative
        xba
        sta     $7e7b00,x
        ldy     $27                     ; y += x / r
        sty     hWRMPYB
        lda     $28
        clc
        adc     hRDMPYL
        sta     $28
        bra     @073c
@075f:  shorta0
        lda     $077e                   ; flashlight y position
        sec
        sbc     $1a                     ; subtract radius
        bcc     @076d
        jsr     ResetWindowPos
@076d:  ldy     $077d                   ; do top half of flashlight first
        ldx     $1a
        cpx     $077e
        bcc     @077a
        ldx     $077e
@077a:  dex
@077b:  tya                             ; flashlight x position
        sec
        sbc     $7e7b00,x               ; subtract width
        bcs     @0784
        tdc                             ; min value is 0
@0784:  sta     hWMDATA                 ; set left side of window
        tya
        clc
        adc     $7e7b00,x               ; add width
        bcc     @0791
        lda     #$ff                    ; max value is $ff
@0791:  sta     hWMDATA                 ; set right side of window
        dex                             ; next line
        bne     @077b
        ldy     $077d                   ; then do bottom half of flashlight
        ldx     $1a
        lda     $077e
        cmp     #$d0
        bcs     @07df
        clc
        adc     $1a
        cmp     #$d0
        bcc     @07b1
        lda     #$d0
        sec
        sbc     $077e
        tax
@07b1:  stx     $2a
        ldx     $00
@07b5:  tya
        sec
        sbc     $7e7b00,x
        bcs     @07be
        tdc
@07be:  sta     hWMDATA
        tya
        clc
        adc     $7e7b00,x
        bcc     @07cb
        lda     #$ff
@07cb:  sta     hWMDATA
        inx
        cpx     $2a
        bne     @07b5
        lda     #$d1                    ; a = 209 - (radius + y position)
        sec
        sbc     $1a
        sec
        sbc     $077e
        jsr     ResetWindowPos
@07df:  longi
        rts

; ------------------------------------------------------------------------------

; [ sine ]

; a = $1a * sin($1b)

CalcSine:
@07e2:  lda     $1a
        sta     hWRMPYA
        lsr
        sta     $1a
        lda     $1b
        tax
        lda     f:SineTbl8,x             ; sin/cos table
        clc
        adc     #$80
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        sec
        sbc     $1a
        rts

; ------------------------------------------------------------------------------

; [ cosine ]

; a = $1a * cos($1b)

CalcCosine:
@0801:  lda     $1a
        sta     hWRMPYA
        lsr
        sta     $1a
        lda     $1b
        clc
        adc     #$40
        tax
        lda     f:SineTbl8,x               ; sin/cos table
        clc
        adc     #$80
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        sec
        sbc     $1a
        rts

; ------------------------------------------------------------------------------

; [ update pyramid ]

UpdatePyramid:
@0823:  lda     $0781
        bne     @0829
        rts
@0829:  ldy     $077f
        lda     $086a,y
        sec
        sbc     $5c
        clc
        adc     #$10
        sta     $077d
        lda     $086d,y
        sec
        sbc     $60
        sta     $077e
        longa_clc
        lda     $0790
        clc
        adc     #$0040
        sta     $0790
        shorta0
        lda     $0790
        and     #$c0
        sta     $1b
        lda     $0791
        asl
        clc
        adc     $1b
        sta     $1b
        stz     $1a
        jsr     CalcSine
        clc
        adc     $077e
        sec
        sbc     #$30
        sta     $075d
        stz     $1a
        jsr     CalcCosine
        clc
        adc     $077d
        sta     $075c
        lda     $0790
        and     #$c0
        sta     $1b
        lda     $0791
        asl
        clc
        adc     $1b
        sec
        sbc     #$20
        sta     $1b
        lda     #$20
        sta     $1a
        jsr     CalcSine
        clc
        adc     $077e
        sta     $075f
        lda     #$40
        sta     $1a
        jsr     CalcCosine
        clc
        adc     $077d
        sta     $075e
        lda     $0790
        and     #$c0
        sta     $1b
        lda     $0791
        asl
        clc
        adc     $1b
        clc
        adc     #$20
        sta     $1b
        lda     #$20
        sta     $1a
        jsr     CalcSine
        clc
        adc     $077e
        sta     $0761
        lda     #$40
        sta     $1a
        jsr     CalcCosine
        clc
        adc     $077d
        sta     $0760
        inc     $0566
        lda     $0566
        lsr
        bcs     @08ea
        ldx     #$8cb3
        stx     hWMADDL
        bra     @08f0
@08ea:  ldx     #$8e53
        stx     hWMADDL
@08f0:  lda     #$7e
        sta     hWMADDH
        lda     $075d
        cmp     $075f
        bcc     @0909
        ldx     $075c
        ldy     $075e
        stx     $075e
        sty     $075c
@0909:  lda     $075f
        cmp     $0761
        bcc     @091d
        ldx     $075e
        ldy     $0760
        stx     $0760
        sty     $075e
@091d:  lda     $075d
        cmp     $075f
        bcc     @0931
        ldx     $075c
        ldy     $075e
        stx     $075e
        sty     $075c
@0931:  lda     $075d
        cmp     $075f
        bne     @0950
        lda     $075c
        cmp     $075e
        bcc     @094d
        ldx     $075c
        ldy     $075e
        stx     $075e
        sty     $075c
@094d:  jmp     @0a24
@0950:  lda     $075e
        cmp     $0760
        bcc     @0964
        ldx     $075e
        ldy     $0760
        stx     $0760
        sty     $075e
@0964:  lda     $075f
        cmp     $0761
        jeq     @0a78
        lda     $075d
        sta     $2c
        lda     $075f
        sec
        sbc     $075d
        sta     $28
        lda     $075e
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sta     $1a
        sty     $2a
        lda     $0761
        sec
        sbc     $075d
        sta     $28
        lda     $0760
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2d
        cmp     $1a
        bne     @09c4
        ldy     $2a
        cpy     $2d
        bcc     @09c4
        ldx     $075e
        ldy     $0760
        stx     $0760
        sty     $075e
        ldx     $2a
        ldy     $2d
        stx     $2d
        sty     $2a
@09c4:  lda     $0761
        sec
        sbc     $075f
        bcc     @09f7
        sta     $28
        lda     $0760
        sta     $26
        sec
        lda     $075e
        sta     $27
        jsr     CalcWindowPos
        sty     $30
        lda     $075f
        sta     $32
        lda     $0761
        sta     $2f
        lda     $075c
        longa
        xba
        tax
        tay
        shorta0
        jmp     @0ac2
@09f7:  neg_a
        sta     $28
        lda     $075e
        sta     $26
        sec
        lda     $0760
        sta     $27
        jsr     CalcWindowPos
        sty     $30
        lda     $0761
        sta     $32
        lda     $075f
        sta     $2f
        lda     $075c
        longa
        xba
        tax
        tay
        shorta0
        jmp     @0b18
@0a24:  lda     $0761
        sec
        sbc     $075d
        sta     $28
        lda     $0760
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2a
        lda     $0761
        sec
        sbc     $075f
        sta     $28
        lda     $0760
        sta     $26
        lda     $075e
        sta     $27
        jsr     CalcWindowPos
        sty     $2d
        lda     $075d
        sta     $2c
        lda     $0761
        sta     $32
        sta     $2f
        longa
        lda     $075c
        and     #$00ff
        xba
        tax
        lda     $075e
        and     #$00ff
        xba
        tay
        shorta0
        jmp     @0ac2
@0a78:  lda     $075f
        sec
        sbc     $075d
        sta     $28
        lda     $075e
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2a
        lda     $0761
        sec
        sbc     $075d
        sta     $28
        lda     $0760
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2d
        lda     $075d
        sta     $2c
        lda     $0761
        sta     $2f
        sta     $32
        lda     $075c
        longa
        xba
        tax
        tay
        shorta0
        jmp     @0ac2
@0ac2:  lda     $2c
        jsr     ResetWindowPos
        lda     $32
        sec
        sbc     $2c
        beq     @0aeb
        sta     $22
        stz     $23
        longa_clc
@0ad4:  txa
        clc
        adc     $2a
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $2d
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0ad4
        shorta0
@0aeb:  lda     $2f
        sec
        sbc     $32
        beq     @0b0f
        sta     $22
        stz     $23
        longa_clc
@0af8:  txa
        clc
        adc     $30
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $2d
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0af8
        shorta0
@0b0f:  lda     #$d0
        sec
        sbc     $2f
        jsr     ResetWindowPos
        rts
@0b18:  lda     $2c
        jsr     ResetWindowPos
        lda     $32
        sec
        sbc     $2c
        beq     @0b41
        sta     $22
        stz     $23
        longa_clc
@0b2a:  txa
        clc
        adc     $2a
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $2d
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0b2a
        shorta0
@0b41:  lda     $2f
        sec
        sbc     $32
        beq     @0b65
        sta     $22
        stz     $23
        longa_clc
@0b4e:  txa
        clc
        adc     $2a
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $30
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0b4e
        shorta0
@0b65:  lda     #$d0
        sec
        sbc     $2f
        jsr     ResetWindowPos
        rts

; ------------------------------------------------------------------------------

; [ set window 2 hdma lines to fully closed ]

; x = number of lines to set

ResetWindowPos:
@0b6e:  phx
        tax
        beq     @0b7d
        lda     #$ff                    ; left side if window = $ff
@0b74:  sta     hWMDATA
        stz     hWMDATA                 ; right side if window = $00
        dex                             ; left > right, so the window is empty
        bne     @0b74
@0b7d:  plx
        rts

; ------------------------------------------------------------------------------

; [  ]

CalcWindowPos:
@0b7f:  lda     $26
        sec
        sbc     $27
        bcc     @0b9b
        xba
        tay
        sty     hWRDIVL
        lda     $28
        sta     hWRDIVB
        tdc
        nop6
        ldy     hRDDIVL
        rts
@0b9b:  neg_a
        xba
        tay
        sty     hWRDIVL
        lda     $28
        sta     hWRDIVB
        tdc
        nop5
        longa
        lda     hRDDIVL
        eor     $02
        inc
        tay
        shorta0
        lda     #$01
        rts

; ------------------------------------------------------------------------------

; [ update spotlights ]

UpdateSpotlights:
@0bbd:  lda     $0521
        and     #$20
        bne     @0bc5                   ; return if spotlights are not enabled
        rts
@0bc5:  inc     $0566
        lda     $0566
        lsr
        bcs     @0bd6
        ldx     #$8cb3
        stx     hWMADDL
        bra     @0bdc
@0bd6:  ldx     #$8e53
        stx     hWMADDL
@0bdc:  lda     #$7e
        sta     hWMADDH
        stz     $26
        lda     $0790
        lsr
        bcs     @0c16
        longa
        lda     $0783
        clc
        adc     #$0032
        sta     $0783
        shorta0
        lda     $0784
        tax
        lda     f:SineTbl8,x               ; sin/cos table
        clc
        adc     #$80
        lsr
        sta     $27
        longa
        inc     $0790
        lda     $0790
        lsr
        and     #$00ff
        shorta
        bra     @0c4b
@0c16:  longa
        lda     $0785
        clc
        adc     #$001e
        sta     $0785
        shorta0
        lda     $0786
        clc
        adc     #$40
        tax
        lda     f:SineTbl8,x               ; sin/cos table
        clc
        adc     #$80
        lsr
        clc
        adc     #$70
        sta     $27
        longa
        inc     $0790
        lda     $0790
        lsr
        clc
        adc     #$0040
        and     #$00ff
        shorta
@0c4b:  tax
        lda     f:SineTbl8,x               ; sin/cos table
        bmi     @0c66
        longa
        asl
        sec
        sbc     #$0018
        sta     $20
        clc
        adc     #$0030
        sta     $24
        shorta0
        bra     @0c81
@0c66:  longa
        eor     $02
        inc
        asl
        eor     $02
        inc
        ora     #$fe00
        sec
        sbc     #$0018
        sta     $20
        clc
        adc     #$0030
        sta     $24
        shorta0
@0c81:  longa_clc
        lda     $26
        tax
        adc     #$0c00
        tay
        shorta0
        lda     $21
        bmi     @0c93
        bra     @0c9b
@0c93:  lda     $25
        bmi     @0c99
        bra     @0cd5
@0c99:  bra     @0d17
@0c9b:  lda     #$68
        sta     $22
        stz     $23
        longa_clc
@0ca3:  txa
        adc     $20
        tax
        bcs     @0cc3
@0ca9:  sta     hWMDATA-1
        tya
        adc     $24
        tay
        bcs     @0ccb
@0cb2:  sta     hWMDATA-1
        stx     hWMDATA-1
        sty     hWMDATA-1
        dec     $22
        bne     @0ca3
        shorta0
        rts
@0cc3:  lda     $02
        tax
        stz     $20
        clc
        bra     @0ca9
@0ccb:  lda     $02
        tay
        stz     $24
        stz     $25
        clc
        bra     @0cb2
@0cd5:  lda     #$68
        sta     $22
        stz     $23
        longa
        lda     $20
        eor     $02
        inc
        sta     $20
@0ce4:  txa
        sec
        sbc     $20
        tax
        bcc     @0d06
@0ceb:  sta     hWMDATA-1
        tya
        clc
        adc     $24
        tay
        bcs     @0d0d
@0cf5:  sta     hWMDATA-1
        stx     hWMDATA-1
        sty     hWMDATA-1
        dec     $22
        bne     @0ce4
        shorta0
        rts
@0d06:  ldx     $00
        stx     $20
        tdc
        bra     @0ceb
@0d0d:  lda     $02
        tay
        stz     $24
        stz     $25
        clc
        bra     @0cf5
@0d17:  lda     #$68
        sta     $22
        stz     $23
        longa
        lda     $20
        eor     $02
        inc
        sta     $20
        lda     $24
        eor     $02
        inc
        sta     $24
@0d2d:  txa
        sec
        sbc     $20
        tax
        bcc     @0d4f
@0d34:  sta     hWMDATA-1
        tya
        sec
        sbc     $24
        tay
        bcc     @0d56
@0d3e:  sta     hWMDATA-1
        stx     hWMDATA-1
        sty     hWMDATA-1
        dec     $22
        bne     @0d2d
        shorta0
        rts
@0d4f:  ldx     $00
        stx     $20
        tdc
        bra     @0d34
@0d56:  ldy     $00
        sty     $24
        tdc
        bra     @0d3e
        lda     #$7e
        pha
        plb
        longa
        ldy     $00
        tyx
@0d66:  lda     $7d08,y
        cmp     #$8753
        bne     @0d75
        lda     f:_c00d8d,x
        sta     $7d08,y
@0d75:  txa
        clc
        adc     #$0002
        and     #$0007
        tax
        iny3
        cpy     #$005a
        bne     @0d66
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

_c00d8d:
@0d8d:  .word   $8763,$8773,$8783,$8793

; ------------------------------------------------------------------------------

; [ unused ??? ]

; this seems to be an unused fixed color effect for the spotlights

EffectColor:
@0d95:  lda     #$20                    ; set bit for red
        sta     $0752
        lda     #$40                    ; set bit for green
        sta     $0753
        lda     #$80
        sta     hWRMPYA                 ; multiplicand
        ldx     #$8763
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     a:$0046                 ; frame counter
        and     #$1f
        tax
        stx     $1e
        lda     a:$0046                 ; frame counter
        asl
        and     #$1f
        tax
        stx     $20
        ldy     #$0020
@0dc3:  ldx     $1e
        lda     f:EffectColorRedTbl,x
        sta     hWRMPYB                 ; multiplier
        txa
        inc
        and     #$1f
        sta     $1e
        lda     hRDMPYH
        ora     $0752
        sta     hWMDATA
        ldx     $20
        lda     f:EffectColorGreenTbl,x
        sta     hWRMPYB                 ; multiplier
        txa
        inc
        and     #$1f
        sta     $20
        lda     hRDMPYH
        ora     $0753
        sta     hWMDATA
        dey
        bne     @0dc3
        rts

; ------------------------------------------------------------------------------

EffectColorRedTbl:
@0df7:  .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
        .byte   $1f,$1e,$1d,$1c,$1b,$1a,$19,$18,$17,$16,$15,$14,$13,$12,$11,$10

EffectColorGreenTbl:
@0e17:  .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
        .byte   $0f,$0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00

; ------------------------------------------------------------------------------

; [ update mosaic hdma data ]

UpdateMosaic:
@0e37:  lda     $11f0
        beq     @0e61
        inc
        longa
        asl4
        sta     $10
        lda     $0796
        sec
        sbc     $10
        sta     $0796
        bpl     @0e56
        stz     $0796
        stz     $11f0
@0e56:  shorta0
        lda     $0797
        tax
        lda     f:MosaicTbl,x
@0e61:  sta     $7e8233
        sta     $7e8237
        sta     $7e823b
        sta     $7e823f
        sta     $7e8243
        sta     $7e8247
        sta     $7e824b
        sta     $7e824f
        rts

; ------------------------------------------------------------------------------

MosaicTbl:
@0e82:  .byte   $0f,$1f,$2f,$3f,$4f,$5f,$6f,$7f,$8f,$9f,$af,$bf,$cf,$df,$ef
        .byte   $ff,$ef,$df,$cf,$bf,$af,$9f,$8f,$7f,$6f,$5f,$4f,$3f,$2f,$1f

; ------------------------------------------------------------------------------

; [ update shake screen ]

UpdateShake:
@0ea0:  lda     $46
        lsr
        bcc     @0ec8
        lda     $074b
        sta     hWRMPYA
        lda     #$c0
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        sta     $074b
        ldx     $00
        stx     $074c
        stx     $074e
        stx     $0750
        stx     a:$007f
        rts
@0ec8:  lda     $074a
        and     #$03
        sta     $22
        beq     @0f07
        lda     $074a
        and     #$0c
        lsr2
        beq     @0ee6
        tax
        jsr     Rand
        and     f:ShakeAndTbl,x
        bne     @0f07
        bra     @0efa
@0ee6:  lda     $074a
        and     #$fc
        sta     $074a
        lda     $22
        tax
        lda     f:ShakeAndTbl,x
        sta     $074b
        bra     @0f07
@0efa:  lda     $22
        tax
        jsr     Rand
        and     f:ShakeAndTbl,x
        sta     $074b
@0f07:  stz     $074d
        stz     $074f
        stz     $0751
        stz     a:$0080
        lda     $074a
        and     #$10
        beq     @0f20
        lda     $074b
        sta     $074c
@0f20:  lda     $074a
        and     #$20
        beq     @0f2d
        lda     $074b
        sta     $074e
@0f2d:  lda     $074a
        and     #$40
        beq     @0f3a
        lda     $074b
        sta     $0750
@0f3a:  lda     $074a
        bpl     @0f44
        lda     $074b
        sta     $7f
@0f44:  rts

; ------------------------------------------------------------------------------

; screen shake data

ShakeAndTbl:
@0f45:  .byte   $00,$03,$06,$0c

ShakeRandTbl:
@0f49:  .byte   $00,$07,$0f,$1f

; ------------------------------------------------------------------------------

; [ begin fade in ]

FadeIn:
@0f4d:  lda     #$10
        sta     $4a
        lda     #$10
        sta     $4c
        rts

; ------------------------------------------------------------------------------

; [ begin fade out ]

FadeOut:
@0f56:  lda     #$90
        sta     $4a
        lda     #$f0
        sta     $4c
        rts

; ------------------------------------------------------------------------------

; [ update screen brightness ]

UpdateBrightness:
@0f5f:  lda     $4a
        bmi     @0f76
        lda     $4c
        and     #$f0
        cmp     #$f0
        beq     @0f89
        lda     $4a
        and     #$1f
        clc
        adc     $4c
        sta     $4c
        bra     @0f8b
@0f76:  lda     $4c
        beq     @0f89
        lda     $4a
        and     #$1f
        sta     $10
        lda     $4c
        sec
        sbc     $10
        sta     $4c
        bra     @0f8b
@0f89:  stz     $4a
@0f8b:  lda     $4c
        lsr4
        sta     hINIDISP
        rts

; ------------------------------------------------------------------------------
