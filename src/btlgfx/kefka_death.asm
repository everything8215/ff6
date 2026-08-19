; ------------------------------------------------------------------------------

; [  ]

_c2a88f:
auto_last_tfr:
@a88f:  lda     z9a
        beq     @a8d1
        lda     z0e
        and     #%111
        tax
        lda     f:_c2e4e3,x
        sta     f:hDMA7::ADDR_B
        txa
        asl
        tax
        longa
        lda     f:_c2e4c3,x
        sta     f:hVMADDL
        lda     f:_c2e4d3,x
        sta     f:hDMA7::ADDR
        lda     #$0800
        sta     f:hDMA7::SIZE
        shorta0
        lda     #$01
        sta     f:hDMA7::CTRL
        lda     #<hVMDATAL
        sta     f:hDMA7::HREG
        lda     #BIT_7
        sta     f:hMDMAEN
@a8d1:  rtl

; ------------------------------------------------------------------------------

; bitmasks for final kefka death animation
and_data:
_c2a8d2:
@a8d2:  .word   $ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
        .word   $ff7f,$fffb,$ffef,$ffdf,$fffd,$fff7,$fffe,$ffbf
        .word   $fdff,$efff,$f7ff,$bfff,$feff,$7fff,$dfff,$fbff
        .word   $ff7f,$fffb,$ffef,$ffdf,$fffd,$fff7,$fffe,$ffbf
        .word   $fdff,$efff,$f7ff,$bfff,$feff,$7fff,$dfff,$fbff
        .word   $ff7f,$fffb,$ffef,$ffdf,$fffd,$fff7,$fffe,$ffbf
        .word   $fdff,$efff,$f7ff,$bfff,$feff,$7fff,$dfff,$fbff

; ------------------------------------------------------------------------------

; [  ]

_c2a942:
inc_scr_poi:
@a942:  ldx     near w7eecec
        cpx     #$000c
        bcc     @a960
        dec     near w7eecee
        bne     @a955
        lda     #4
        sta     near w7eecee
        rts
@a955:  longa
        dec     near w7e64b6
        inc     near w7e80cf
        shorta0
@a960:  rts

; ------------------------------------------------------------------------------

; [ wait A frames (final Kefka death animation) ]

WaitKefkaDeath:
@a961:  pha
        jsl     WaitFrame_far
        pla
        dec
        bne     @a961
        rts

; ------------------------------------------------------------------------------

; [ final kefka death animation ]

KefkaDeathAnim:
@a96b:  inc     z9a
        inc     near w7e628b
        ldx     #$ffff
        stx     near wMenuQueue
        stx     near wMenuQueue + 2
        lda     #1
        sta     near w7eecee
        inc     near wDrawOrderInvalid       ; force character/monster draw order to update
        lda     #$16                    ; disable bg1 in main screen
        sta     near w7e898d
        clr_ax
@a988:  lda     near w7e7e00::_8,x
        sta     near w7e7e00::_3,x
        inx
        cpx     #$0020
        bne     @a988
        clr_ax
        phb
        lda     #$7f
        pha
        plb
        longa
@a99d:  stz     $c400,x
        inx2
        cpx     #$1000
        bne     @a99d
        clr_ax
        lda     #$2c00
        sta     $12
@a9ae:  lda     #$0010
        sta     $10
        lda     $12
@a9b5:  sta     $c400,x
        inx2
        inc
        dec     $10
        bne     @a9b5
        sta     $12
        txa
        clc
        adc     #$0020
        tax
        cpx     #$0400
        bne     @a9ae
        lda     #$fff0
        sta     w7e64b4
        sta     w7e7b16
        sta     w7e64b6
        sta     w7e7b18
        clr_a
        sta     w7e7b1d
        sta     w7e7b1f
        shorta
        plb
        ldx     #$1000
        stx     $10
        ldx     #$c400
        ldy     #$4800
        lda     #$7f
        jsl     WaitTfrVRAM_far
        lda     near w7e896f
        and     #$af
        sta     near w7e896f
        lda     #$4a
        sta     near w7e8971
        clr_ax
        stx     near w7eecec
        phb
        lda     #$7f
        pha
        plb
        longa
@aa15:  stz     $c400,x
        inx2
        cpx     #$2000
        bne     @aa15
        shorta0
        plb
        clr_ax
@aa25:  sta     near w7eecbc,x
        stz     near w7eeccc,x
        clc
        adc     #$04
        inx
        cpx     #$0010
        bne     @aa25
        lda     #$08
        jsr     WaitKefkaDeath
        lda     #$17
        sta     near w7e898d
@aa3e:  jsl     WaitFrame_far
        jsr     _c2a942
        jsr     _c2aaf8
        jsl     WaitFrame_far
        jsr     _c2aaf8
        jsl     WaitFrame_far
        jsr     _c2a942
        jsr     _c2aaf8
        jsl     WaitFrame_far
        jsr     _c2aaf8
        ldx     #near w7ebe3f+$0e00
        stx     $10
        ldx     #$e200
        stx     $12
        lda     #$7f
        sta     $14
        clr_ax
@aa70:  lda     near w7eecbc,x
        beq     @aa7a
        dec     near w7eecbc,x
        bra     @aa9b
@aa7a:  lda     near w7eeccc,x
        cmp     #$18
        bcs     @aa9b
        asl
        phx
        tax
        clr_ay
@aa86:  lda     f:_c2a8d2,x
        sta     near w7eecdc,y
        inx
        iny
        cpy     #$0010
        bne     @aa86
        plx
        jsr     _c2ab5a
        inc     near w7eeccc,x
@aa9b:  longa
        lda     $10
        sec
        sbc     #$0200
        sta     $10
        lda     $12
        sec
        sbc     #$0200
        sta     $12
        shorta0
        inx
        cpx     #$0010
        bne     @aa70
        ldx     near w7eecec
        inx
        stx     near w7eecec
        cpx     #$004a
        bne     @aadb
        phx
        inc     near wSfxDisabled       ; disable sound effects
        lda     #$82        ; spc command $82 (set sound effect volume)
        sta     $1300
        lda     #$c0        ; set sound effect volume to $c0
        sta     $1301
        stz     $1302
        jsl     ExecSound_ext
        stz     near wSfxDisabled       ; enable sound effects
        plx
@aadb:  cpx     #$005a
        jne     @aa3e
        lda     #$80
        jsr     WaitKefkaDeath
        lda     near w7ee9f9
        beq     @aaf7
@aaed:  lda     #$10
        jsr     WaitKefkaDeath
        dec     near w7ee9f9
        bne     @aaed
@aaf7:  rtl

; ------------------------------------------------------------------------------

; [  ]

_c2aaf8:
last_chr_sift:
@aaf8:  phb
        lda     #$7f
        pha
        plb
        longa
        clr_ax
        stz     $18
@ab03:  lda     #$e200
        clc
        adc     $18
        sta     $10
        lda     #$e00e
        clc
        adc     $18
        sta     $14
        lda     #$0010
        sta     $16
@ab18:  lda     $10
        inc2
        sta     $12
        ldy     #$001c
@ab21:  lda     ($10),y
        sta     ($12),y
        dey2
        bpl     @ab21
        lda     ($14)
        sta     ($10)
        ldy     #$0010
        lda     ($14),y
        sta     ($10),y
        lda     $10
        sec
        sbc     #$0200
        sta     $10
        lda     $14
        sec
        sbc     #$0200
        sta     $14
        dec     $16
        bne     @ab18
        lda     $18
        clc
        adc     #$0020
        sta     $18
        cmp     #$0200
        bne     @ab03
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2ab5a:
last_one_line_clr:
@ab5a:  phx
        clr_axy
        longa
@ab60:  lda     near w7eecdc,x
        not_a
        sta     $1a
        lda     ($10),y
        and     $1a
        ora     [$12],y
        sta     [$12],y
        lda     ($10),y
        and     near w7eecdc,x
        sta     ($10),y
        inx2
        txa
        and     #$000f
        tax
        iny2
        cpy     #$0200
        bne     @ab60
        shorta0
        plx
        rts

; ------------------------------------------------------------------------------
