
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/rotate.asm                                                     |
; |                                                                            |
; | description: world map rotation routines                                   |
; |                                                                            |
; | created: 5/18/2023                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ update bg2 h-scroll hdma data (for backdrop) ]

UpdateBG2HScrollHDMA:
@37b6:  shorta
        phb
        lda     #$7e
        pha
        plb
        longa
        longi
        lda     $83
        jeq     @385e
        bmi     @3814

; positive rotation
        xba
        lsr3
        tax
        lda     #$00e0
        sec
        sbc     $87
        clc
        adc     #$0008
        lsr3
        sta     $66
        ldy     #$0000
@37e1:  lda     $7eb862,x
        and     #$00ff
        sta     $58
        lda     $70
        sec
        sbc     $58
        sta     $690e,y
        sta     $6910,y
        sta     $6912,y
        sta     $6914,y
        sta     $6916,y
        sta     $6918,y
        sta     $691a,y
        sta     $691c,y
        tya
        clc
        adc     #$0010
        tay
        inx
        dec     $66
        bne     @37e1
        bra     @3874

; negative rotation
@3814:  eor     #$ffff
        inc
        xba
        lsr3
        tax
        lda     #$00e0
        sec
        sbc     $87
        clc
        adc     #$0008
        lsr3
        sta     $66
        ldy     #$0000
@382f:  lda     $7eb862,x
        and     #$00ff
        clc
        adc     $70
        sta     $690e,y
        sta     $6910,y
        sta     $6912,y
        sta     $6914,y
        sta     $6916,y
        sta     $6918,y
        sta     $691a,y
        sta     $691c,y
        tya
        clc
        adc     #$0010
        tay
        inx
        dec     $66
        bne     @382f
        bra     @3874

; zero rotation
@385e:  lda     #$00e0
        sec
        sbc     $87
        beq     @3874
        tax
        ldy     #0
        lda     $70
@386c:  sta     $690e,y
        iny2
        dex
        bne     @386c
@3874:  lda     #$00e0
        sec
        sbc     $87
        ora     #$0080
        sta     a:$00bb                 ; number of lines for hdma
        lda     #$690e
        sta     a:$00bc                 ; hdma data address
        plb
        rts

; ------------------------------------------------------------------------------

; [ update gradient sprites ]

UpdateGradientSprites:
@3888:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     $83
        jeq     @39c7
        jmi     @3933

; positive rotation
        xba
        lsr3
        tax
        lda     #$00c0
        sec
        sbc     $87
        clc
        adc     $83
        sta     $58
        shorta
        lda     #$0f
        sta     $66
        ldy     #$0000
        lda     $7eb862,x
        inx
        sta     $5a
@38bf:  lda     $58
        sta     $6c01,y
        clc
        adc     #$10
        sta     $6c3d,y
        adc     #$10
        sta     $6c79,y
        adc     #$10
        sta     $6cb5,y
        adc     #$10
        sta     $6cf1,y
        lda     $7eb862,x
        cmp     $5a
        beq     @3900
        sta     $5a
        dec     $58
        lda     #$01
        sta     $6c02,y
        lda     #$05
        sta     $6c3e,y
        lda     #$09
        sta     $6c7a,y
        lda     #$0d
        sta     $6cb6,y
        lda     #$21
        sta     $6cf2,y
        bra     @3918
@3900:  tdc
        sta     $6c02,y
        lda     #$04
        sta     $6c3e,y
        lda     #$08
        sta     $6c7a,y
        lda     #$0c
        sta     $6cb6,y
        lda     #$20
        sta     $6cf2,y
@3918:  inx
        lda     $7eb862,x
        cmp     $5a
        beq     @3925
        sta     $5a
        dec     $58
@3925:  dec     $66
        beq     @3930
        iny4
        inx
        bra     @38bf
@3930:  jmp     @39fd

; negative rotation
        .a16
@3933:  eor     #$ffff
        inc
        xba
        lsr3
        tax
        lda     #$00c0
        sec
        sbc     $87
        sta     $58
        shorta
        lda     #$0f
        sta     $66
        ldy     #$0000
        lda     $7eb862,x
        inx
        sta     $5a
@3954:  lda     $7eb862,x
        cmp     $5a
        beq     @397b
        sta     $5a
        inc     $58
        lda     #$02
        sta     $6c02,y
        lda     #$06
        sta     $6c3e,y
        lda     #$0a
        sta     $6c7a,y
        lda     #$0e
        sta     $6cb6,y
        lda     #$22
        sta     $6cf2,y
        bra     @3993
@397b:  tdc
        sta     $6c02,y
        lda     #$04
        sta     $6c3e,y
        lda     #$08
        sta     $6c7a,y
        lda     #$0c
        sta     $6cb6,y
        lda     #$20
        sta     $6cf2,y
@3993:  lda     $58
        sta     $6c01,y
        clc
        adc     #$10
        sta     $6c3d,y
        adc     #$10
        sta     $6c79,y
        adc     #$10
        sta     $6cb5,y
        adc     #$10
        sta     $6cf1,y
        inx
        lda     $7eb862,x
        cmp     $5a
        beq     @39ba
        sta     $5a
        inc     $58
@39ba:  dec     $66
        beq     @39c5
        iny4
        inx
        bra     @3954
@39c5:  bra     @39fd

; no rotation
        .a16
@39c7:  lda     #$00c0
        sec
        sbc     $87
        sta     $58
        shorta
        stz     $5a
        ldy     #$0000
@39d6:  ldx     #$000f                  ; 15 sprites per row
@39d9:  lda     $58
        sta     $6c01,y
        lda     $5a
        sta     $6c02,y
        iny4
        dex
        bne     @39d9
        clc                             ; next row
        adc     #$14                    ; tile 0, 4, 8, 12, 32
        and     #$2f
        sta     $5a
        lda     $58
        clc
        adc     #$10
        sta     $58
        cpy     #$012c                  ; 5 rows total
        bne     @39d6
@39fd:  plb
        rts

; ------------------------------------------------------------------------------

; [ transfer bg3 tilemap to vram (offset-per-tile data) ]

TfrBG3Tilemap:
@39ff:  longa
        longi
        stz     hVMAINC
        lda     #$4c20
        sta     hVMADDL
        lda     $83
        beq     @3a69
        bmi     @3a3e

; positive rotation
        sta     $5a
        xba
        lsr3
        tax
        lda     $87
        shorta
        sec
        sbc     #$64
        sec
        sbc     $5a
        sta     $58
        sta     hBG2VOFS
        stz     hBG2VOFS
        ldy     #$0020
@3a2e:  lda     $58
        clc
        adc     $7eb862,x
        sta     hVMDATAL
        inx
        dey
        bne     @3a2e
        bra     @3a7f

; negative rotation
        .a16
@3a3e:  eor     #$ffff
        inc
        xba
        lsr3
        tax
        lda     $87
        shorta
        sec
        sbc     #$64
        sta     $58
        sta     hBG2VOFS
        stz     hBG2VOFS
        ldy     #$0020
@3a59:  lda     $58
        sec
        sbc     $7eb862,x
        sta     hVMDATAL
        inx
        dey
        bne     @3a59
        bra     @3a7f

; zero rotation
@3a69:  lda     $87
        shorta
        sec
        sbc     #$64
        sta     hBG2VOFS
        stz     hBG2VOFS
        ldy     #$0020
@3a79:  sta     hVMDATAL
        dey
        bne     @3a79
@3a7f:  rts

; ------------------------------------------------------------------------------

; [ update mode 7 rotation ]

UpdateMode7Rot:
@3a80:  longa
        longi
        stz     $6b
        stz     $6e
        lda     $87
        cmp     #$e1
        bcc     @3a9c
        lda     #$01c0
        sec
        sbc     $87
        sta     $89
        lda     #$00e0
        bra     @3a9e
@3a9c:  sta     $89
@3a9e:  asl
        tax
        clc
        adc     #$0140
        sta     $a0
        sta     $b5
        adc     #$00f8
        sta     $a3
        sta     $b8
        txa
        adc     #$0300
        sta     $a7
        adc     #$00f8
        sta     $aa
        txa
        adc     #$04c0
        sta     $ae
        adc     #$00f8
        sta     $b1
        longa
        shorti
        ldx     $89
        lda     $8f
        sec
        sbc     $8d
        bcs     @3ad6
        eor     #$ffff
        inc
@3ad6:  php
        sta     hWRDIVL
        stx     hWRDIVB
        lda     a:$0073
        cmp     #180
        bcc     @3ae8
        sbc     #180
@3ae8:  tax
        lda     f:WorldSineTbl,x
        sta     $9b
        lda     f:WorldSineTbl+90,x
        sta     $9d
        plp
        lda     hRDDIVL
        bcs     @3aff
        eor     #$ffff
        inc
@3aff:  sta     $95
        lda     $89
        cmp     #$007e
        bcs     @3b0e
        sta     $66
        stz     $68
        bra     @3b19
@3b0e:  stz     $66
        ldx     #$7e
        stx     $66
        sbc     #$007e
        sta     $68
@3b19:  lda     $8b
        sta     $97
        lda     $8d
        sta     $99
        lda     a:$0073
        cmp     #180
        bcc     @3b34
        cmp     #270
        jcs     @3d8f
        jmp     @3cc6
@3b34:  cmp     #90
        jcs     @3bfd
        ldy     #$00
@3b3e:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $04be,y
        eor     #$ffff
        inc
        sta     $067e,y
        dec     $66
        bne     @3b3e
        ldy     #$00
@3b9c:  dec     $68
        bmi     @3bfa
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $05ba,y
        eor     #$ffff
        inc
        sta     $077a,y
        bra     @3b9c
@3bfa:  jmp     @3e50
@3bfd:  ldy     #$00
@3bff:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $04be,y
        eor     #$ffff
        inc
        sta     $067e,y
        dec     $66
        bne     @3bff
        ldy     #$00
@3c61:  dec     $68
        bmi     @3cc3
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $05ba,y
        eor     #$ffff
        inc
        sta     $077a,y
        bra     @3c61
@3cc3:  jmp     @3e50
@3cc6:  ldy     #$00
@3cc8:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $067e,y
        eor     #$ffff
        inc
        sta     $04be,y
        dec     $66
        bne     @3cc8
        ldy     #$00
@3d2a:  dec     $68
        bmi     @3d8c
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $077a,y
        eor     #$ffff
        inc
        sta     $05ba,y
        bra     @3d2a
@3d8c:  jmp     @3e50
@3d8f:  ldy     #$00
@3d91:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $067e,y
        eor     #$ffff
        inc
        sta     $04be,y
        dec     $66
        bne     @3d91
        ldy     #$00
@3def:  dec     $68
        bmi     @3e4d
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $077a,y
        eor     #$ffff
        inc
        sta     $05ba,y
        bra     @3def
@3e4d:  jmp     @3e50
@3e50:  rts

; ------------------------------------------------------------------------------

; [ update mode 7 variables ]

UpdateMode7Vars:
@3e51:  longa
        longi
        lda     $87
        cmp     #225
        bcc     @3e69
        lda     #$01c0
        sec
        sbc     $87
        sta     $89
        lda     #$00e0
        bra     @3e6b
@3e69:  sta     $89
@3e6b:  asl
        tax
        clc
        adc     #$0140
        sta     $a0
        adc     #$00f8
        sta     $a3
        txa
        adc     #$0300
        sta     $a7
        adc     #$00f8
        sta     $aa
        txa
        adc     #$04c0
        sta     $ae
        adc     #$00f8
        sta     $b1
        txa
        adc     #$0680
        sta     $b5
        adc     #$00f8
        sta     $b8
        shorti
        ldx     $89
        lda     $8f
        sec
        sbc     $8d
        bcs     @3ea8
        eor     #$ffff
        inc
@3ea8:  php
        sta     hWRDIVL
        stx     hWRDIVB
        lda     a:$0073
        cmp     #180
        bcc     @3eba
        sbc     #180
@3eba:  tax
        lda     f:WorldSineTbl,x
        sta     $9b
        lda     f:WorldSineTbl+90,x
        sta     $9d
        plp
        lda     hRDDIVL
        bcs     @3ed1
        eor     #$ffff
        inc
@3ed1:  sta     $95
        lda     $89
        cmp     #$007e
        bcs     @3ee0
        sta     $66
        stz     $68
        bra     @3ee9
@3ee0:  ldx     #$7e
        stx     $66
        sbc     #$007e
        sta     $68
@3ee9:  lda     $8b
        sta     $97
        lda     $8d
        sta     $99
        stz     hWRDIVH
        ldy     #$00
        ldx     $66
@3ef8:  lda     $97
        sta     hWRDIVL
        lda     $9a
        sta     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        lda     #$0000
        sta     $04c0,y
        sta     $0680,y
        lda     hRDDIVL
        sta     $0300,y
        sta     $0840,y
        iny2
        dex
        bne     @3ef8
        ldy     #$00
        ldx     $68
@3f24:  dex
        bmi     @3f4e
        lda     $97
        sta     hWRDIVL
        lda     $9a
        sta     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        lda     #$0000
        sta     $05bc,y
        sta     $077c,y
        lda     hRDDIVL
        sta     $03fc,y
        sta     $093c,y
        iny2
        bra     @3f24
@3f4e:  rts

; ------------------------------------------------------------------------------
