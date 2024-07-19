; ------------------------------------------------------------------------------

; [ decompress ]

; ++$d2 = source
; ++$d5 = destination

zDecompSrc := $d2
zDecompDest := $d5
zDecompPtr := $d8
zDecompRun := $da
zDecompSize := $db
zDecompCounter := $dd
zDecompHeader := $de

wDecompBuf := $7ef800

.proc Decompress
        phb
        phd
        ldx     #$0000
        phx
        pld
        longa
        lda     [zDecompSrc]
        sta     zDecompSize
        lda     zDecompDest
        sta     f:hWMADDL
        shorta
        lda     zDecompDest+2
        and     #BIT_0
        sta     f:hWMADDH
        lda     #1
        sta     zDecompCounter
        ldy     #2
        lda     #^wDecompBuf
        pha
        plb
        ldx     #.loword(wDecompBuf)
        clr_a
:       sta     a:0,x
        inx
        bne     :-
        ldx     #.loword(-34)
loop:   dec     zDecompCounter
        bne     :+
        lda     #8
        sta     zDecompCounter
        lda     [zDecompSrc],y
        sta     zDecompHeader
        iny
:       lsr     zDecompHeader
        bcc     :+
        lda     [zDecompSrc],y
        sta     f:hWMDATA
        sta     a:0,x
        inx
        bne     inc_ptr
        ldx     #.loword(wDecompBuf)
        bra     inc_ptr
:       lda     [zDecompSrc],y
        xba
        iny
        sty     zDecompPtr
        lda     [zDecompSrc],y
        lsr3
        clc
        adc     #3
        sta     zDecompRun
        lda     [zDecompSrc],y
        ora     #>wDecompBuf
        xba
        tay

cpy_buf:
@a4e3:  lda     a:0,y
        sta     f:hWMDATA
        sta     a:0,x
        inx
        bne     :+
        ldx     #.loword(wDecompBuf)
:       iny
        bne     :+
        ldy     #.loword(wDecompBuf)
:       dec     zDecompRun
        bne     cpy_buf
        ldy     zDecompPtr

inc_ptr:
        iny
        cpy     zDecompSize
        bne     loop
        clr_a
        xba
        pld
        plb
        rts
.endproc  ; Decompress

; ------------------------------------------------------------------------------
