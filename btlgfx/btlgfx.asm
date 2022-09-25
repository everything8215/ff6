
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: btlgfx.asm                                                           |
; |                                                                            |
; | description: battle graphics program                                       |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.export Decompress_ext

; ------------------------------------------------------------------------------

.segment "btlgfx_code"
.a8
.i16

; ------------------------------------------------------------------------------

.segment "decompress_code"

; ------------------------------------------------------------------------------

; sin/cos table (16-bit, signed)
SineTbl16:
@fc6d:  .word   $0000,$0324,$0648,$096a,$0c8c,$0fab,$12c8,$15e2
        .word   $18f9,$1c0b,$1f1a,$2223,$2528,$2826,$2b1f,$2e11
        .word   $30fb,$33df,$36ba,$398c,$3c56,$3f17,$41ce,$447a
        .word   $471c,$49b3,$4c3f,$4ebf,$5133,$539b,$55f5,$5842
        .word   $5a82,$5cb3,$5ed7,$60eb,$62f1,$64e8,$66cf,$68a6
        .word   $6a6d,$6c23,$6dc9,$6f5e,$70e2,$7254,$73b5,$7504
        .word   $7641,$776b,$7884,$7989,$7a7c,$7b5c,$7c29,$7ce3
        .word   $7d89,$7e1d,$7e9c,$7f09,$7f61,$7fa6,$7fd8,$7ff5
        .word   $7fff,$7ff5,$7fd8,$7fa6,$7f61,$7f09,$7e9c,$7e1d
        .word   $7d89,$7ce3,$7c29,$7b5c,$7a7c,$7989,$7884,$776b
        .word   $7641,$7504,$73b5,$7254,$70e2,$6f5e,$6dc9,$6c23
        .word   $6a6d,$68a6,$66cf,$64e8,$62f1,$60eb,$5ed7,$5cb3
        .word   $5a82,$5842,$55f5,$539a,$5133,$4ebf,$4c3f,$49b3
        .word   $471c,$447a,$41ce,$3f17,$3c56,$398c,$36ba,$33de
        .word   $30fb,$2e11,$2b1f,$2826,$2528,$2223,$1f1a,$1c0b
        .word   $18f8,$15e2,$12c8,$0fab,$0c8c,$096a,$0648,$0324
        .word   $0000,$fcdc,$f9b8,$f695,$f374,$f055,$ed38,$ea1e
        .word   $e707,$e3f5,$e0e6,$dddc,$dad8,$d7d9,$d4e1,$d1ef
        .word   $cf04,$cc21,$c946,$c673,$c3aa,$c0e9,$be32,$bb86
        .word   $b8e3,$b64c,$b3c1,$b141,$aecd,$ac65,$aa0b,$a7be
        .word   $a57e,$a34c,$a129,$9f14,$9d0f,$9b18,$9931,$975a
        .word   $9593,$93dd,$9237,$90a2,$8f1e,$8dac,$8c4b,$8afc
        .word   $89bf,$8895,$877c,$8677,$8584,$84a4,$83d7,$831d
        .word   $8277,$81e3,$8164,$80f7,$809f,$805a,$8028,$800b
        .word   $8001,$800b,$8028,$805a,$809f,$80f7,$8164,$81e3
        .word   $8277,$831d,$83d7,$84a4,$8584,$8677,$877d,$8895
        .word   $89bf,$8afc,$8c4b,$8dac,$8f1e,$90a2,$9237,$93dd
        .word   $9593,$975a,$9932,$9b18,$9d0f,$9f15,$a12a,$a34d
        .word   $a57e,$a7be,$aa0b,$ac66,$aecd,$b141,$b3c1,$b64d
        .word   $b8e4,$bb86,$be33,$c0ea,$c3aa,$c674,$c947,$cc22
        .word   $cf05,$d1f0,$d4e2,$d7da,$dad9,$dddd,$e0e7,$e3f5
        .word   $e708,$ea1f,$ed39,$f055,$f375,$f696,$f9b9,$fcdc

; sin/cos table (8-bit, signed)
SineTbl8:
@fe6d:  .byte   $00,$03,$06,$09,$0c,$10,$13,$16,$19,$1c,$1f,$22,$25,$28,$2b,$2e
        .byte   $31,$33,$36,$39,$3c,$3f,$41,$44,$47,$49,$4c,$4e,$51,$53,$55,$58
        .byte   $5a,$5c,$5e,$60,$62,$64,$66,$68,$6a,$6b,$6d,$6f,$70,$71,$73,$74
        .byte   $75,$76,$78,$79,$7a,$7a,$7b,$7c,$7d,$7d,$7e,$7e,$7e,$7f,$7f,$7f
        .byte   $7f,$7f,$7f,$7f,$7e,$7e,$7e,$7d,$7d,$7c,$7b,$7a,$7a,$79,$78,$76
        .byte   $75,$74,$73,$71,$70,$6f,$6d,$6b,$6a,$68,$66,$64,$62,$60,$5e,$5c
        .byte   $5a,$58,$55,$53,$51,$4e,$4c,$49,$47,$44,$41,$3f,$3c,$39,$36,$33
        .byte   $31,$2e,$2b,$28,$25,$22,$1f,$1c,$19,$16,$13,$10,$0c,$09,$06,$03
        .byte   $00,$fd,$fa,$f7,$f4,$f0,$ed,$ea,$e7,$e4,$e1,$de,$db,$d8,$d5,$d2
        .byte   $cf,$cd,$ca,$c7,$c4,$c1,$bf,$bc,$b9,$b7,$b4,$b2,$af,$ad,$ab,$a8
        .byte   $a6,$a4,$a2,$a0,$9e,$9c,$9a,$98,$96,$95,$93,$91,$90,$8f,$8d,$8c
        .byte   $8b,$8a,$88,$87,$86,$86,$85,$84,$83,$83,$82,$82,$82,$81,$81,$81
        .byte   $81,$81,$81,$81,$82,$82,$82,$83,$83,$84,$85,$86,$86,$87,$88,$8a
        .byte   $8b,$8c,$8d,$8f,$90,$91,$93,$95,$96,$98,$9a,$9c,$9e,$a0,$a2,$a4
        .byte   $a6,$a8,$ab,$ad,$af,$b2,$b4,$b7,$b9,$bc,$bf,$c1,$c4,$c7,$ca,$cd
        .byte   $cf,$d2,$d5,$d8,$db,$de,$e1,$e4,$e7,$ea,$ed,$f0,$f4,$f7,$fa,$fd

; ------------------------------------------------------------------------------

; [ decompress ]

Decompress_ext:
@ff6d:  phb
        phd
        ldx     #$0000
        phx
        pld
        longa
        lda     [$f3]
        sta     $fc
        lda     $f6
        sta     f:hWMADDL
        shorta
        lda     $f8
        and     #$01
        sta     f:hWMADDH
        lda     #1
        sta     $fe
        ldy     #2
        lda     #$7f
        pha
        plb
        ldx     #$f800
        tdc
@ff99:  sta     a:$0000,x
        inx
        bne     @ff99
        ldx     #$ffde
@ffa2:  dec     $fe
        bne     @ffaf
        lda     #8
        sta     $fe
        lda     [$f3],y
        sta     $ff
        iny
@ffaf:  lsr     $ff
        bcc     @ffc4
        lda     [$f3],y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @fff6
        ldx     #$f800
        bra     @fff6
@ffc4:  lda     [$f3],y
        xba
        iny
        sty     $f9
        lda     [$f3],y
        lsr3
        clc
        adc     #3
        sta     $fb
        lda     [$f3],y
        ora     #$f8
        xba
        tay
@ffda:  lda     $0000,y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @ffea
        ldx     #$f800
@ffea:  iny
        bne     @fff0
        ldy     #$f800
@fff0:  dec     $fb
        bne     @ffda
        ldy     $f9
@fff6:  iny
        cpy     $fc
        bne     @ffa2
        tdc
        xba
        pld
        plb
        rtl

; ------------------------------------------------------------------------------

.segment "btlgfx_code2"

; ------------------------------------------------------------------------------
