; ------------------------------------------------------------------------------

; pixels per tile (height * width)
_ee99d1:
dtsize:
@99d1:  .word   0*0,3*3,4*4,5*5,6*6,7*7,8*8,9*9
        .word   10*10,11*11,12*12,14*14,16*16

; ------------------------------------------------------------------------------

; tile height/width for each layer
_ee99eb:
chr_size:
@99eb:  .word   0,3,4,5,6,7,8,9,10,11,12,14,16

; ------------------------------------------------------------------------------

; [ init magitek train ride graphics ]

InitTrainGfx:

@hDP := hWMDATA & $ff00

@9a05:  php
        phb
        phd
        longai
        lda     #@hDP                   ; nonzero dp, don't use clr_a
        tcd
        shorta
        ldx     #$2000                  ; $7e2000
        stx     $81
        lda     #$7e
        sta     $83
        lda     #$7e
        pha
        plb
        ldy     #$0000
        lda     #$1d                    ; 29 tiles
        sta     a:$0066
@9a25:  ldx     #$0018
        stx     a:$0068                 ; 24 layers
@9a2b:  longa
        stz     a:$005a
        ldx     a:$0068                 ; layer
        lda     f:_ee99d1,x             ; pixels per tile
        bit     #$0001
        beq     @9a3f                   ; branch if an even number of pixels per tile
        inc     a:$005a                 ; $5a set if odd number of pixels per tile
@9a3f:  lsr
        tax
        shorta
        lda     $a000,y                 ; $58 = high nybble of pixel
        sta     a:$0058
        iny
@9a4a:  lda     $a000,y                 ; first pixel
        and     #$f0
        beq     @9a5c
        lsr4
        ora     a:$0058
        sta     $80
        bra     @9a5e
@9a5c:  stz     $80
@9a5e:  lda     $a000,y                 ; second pixel
        and     #$0f
        beq     @9a6c                   ; branch if pixel is transparent
        ora     a:$0058
        sta     $80
        bra     @9a6e
@9a6c:  stz     $80
@9a6e:  iny                             ; next pair of pixels
        dex
        bne     @9a4a
        lda     a:$005a
        beq     @9a8c                   ; branch if an even number of pixels per tile
        lda     $a000,y
        and     #$f0
        beq     @9a89                   ; branch if pixel is transparent
        lsr4
        ora     a:$0058
        sta     $80
        bra     @9a8b
@9a89:  stz     $80
@9a8b:  iny                             ; next size/layer
@9a8c:  dec     a:$0068
        dec     a:$0068
        bne     @9a2b
        dec     a:$0066                 ; next tile
        bne     @9a25
        longa
        lda     #$68d9                  ; $7e68d9
        sta     $81
        shorta
        ldy     #$0000
        ldx     #$000c                  ;
        stx     a:$0066
@9aab:  ldx     #$0018                  ; 24 layers
        stx     a:$0068
@9ab1:  ldx     a:$0068
        lda     f:_ee99eb,x             ; tile height/width
        sta     a:$0058
@9abb:  longa_clc
        ldx     a:$0068
        lda     f:_ee99eb,x             ; tile height/width
        sta     a:$005a
        tya
        adc     f:_ee99eb,x             ; tile height/width
        tax
        tay
        shorta
@9ad0:  lda     $1fff,x
        sta     $80
        dex
        dec     a:$005a                 ; next pixel
        bne     @9ad0
        dec     a:$0058                 ; next row
        bne     @9abb
        dec     a:$0068                 ; next
        dec     a:$0068
        bne     @9ab1
        dec     a:$0066                 ; next
        bne     @9aab
        pld
        plb
        plp
        rts

; ------------------------------------------------------------------------------
