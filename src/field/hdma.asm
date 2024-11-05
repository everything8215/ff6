
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: hdma.asm                                                             |
; |                                                                            |
; | description: hdma routines                                                 |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ init hdma data ]

InitHDMA:
@3821:  lda     #$43                    ; channel #0: bg2 scroll ($210f & $2110)
        sta     hDMA0::CTRL             ; 2 address, write twice
        lda     #<hBG2HOFS
        sta     hDMA0::HREG
        ldx     #$7c51
        stx     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        lda     #$44                    ; channel #7: mosaic & bg1-3 data location in vram ($2106, $2107, $2108, $2109)
        sta     hDMA7::CTRL             ; 4 address
        lda     #<hMOSAIC
        sta     hDMA7::HREG
        ldx     #$7b9b
        stx     hDMA7::ADDR
        lda     #$7e
        sta     hDMA7::ADDR_B
        sta     hDMA7::HDMA_B
        lda     #$43                    ; channel #4: bg1 scroll ($210d & $210e)
        sta     hDMA4::CTRL             ; 2 address, write twice
        lda     #<hBG1HOFS
        sta     hDMA4::HREG
        ldx     #$7bf6
        stx     hDMA4::ADDR
        lda     #$7e
        sta     hDMA4::ADDR_B
        sta     hDMA4::HDMA_B
        lda     #$43                    ; channel #3: bg3 scroll ($2111 & $2112)
        sta     hDMA3::CTRL             ; 2 address, write twice
        lda     #<hBG3HOFS
        sta     hDMA3::HREG
        ldx     #$7cac
        stx     hDMA3::ADDR
        lda     #$7e
        sta     hDMA3::ADDR_B
        sta     hDMA3::HDMA_B
        lda     #$42                    ; channel #2: fixed color add/sub values ($2132)
        sta     hDMA2::CTRL             ; 1 address, write twice
        lda     #$32
        sta     hDMA2::HREG
        ldx     #$7d07
        stx     hDMA2::ADDR
        lda     #$7e
        sta     hDMA2::ADDR_B
        sta     hDMA2::HDMA_B
        lda     #$41                    ; channel #5: window 2 position ($2128 & $2129)
        sta     hDMA5::CTRL             ; 2 address
        lda     #<hWH2
        sta     hDMA5::HREG
        ldx     #$7d62
        stx     hDMA5::ADDR
        lda     #$7e
        sta     hDMA5::ADDR_B
        sta     hDMA5::HDMA_B
        lda     #$41                    ; channel #6: main/sub screen designation ($212c & $212d)
        sta     hDMA6::CTRL             ; 2 address
        lda     #<hTM
        sta     hDMA6::HREG
        ldx     #$7dbd
        stx     hDMA6::ADDR
        lda     #$7e
        sta     hDMA6::ADDR_B
        sta     hDMA6::HDMA_B
        lda     #$41                    ; channel #1: color add/sub settings ($2130 & $2131)
        sta     hDMA1::CTRL             ; 2 address
        lda     #<hCGSWSEL
        sta     hDMA1::HREG
        ldx     #$7e18
        stx     hDMA1::ADDR
        lda     #$7e
        sta     hDMA1::ADDR_B
        sta     hDMA1::HDMA_B
        lda     #$7e
        pha
        plb
        ldx     $00         ; set up hdma tables
        lda     #$88        ; 27 strips @ 8 scanlines each
@38e9:  sta     $7b40,x
        sta     $7b9b,x
        sta     $7bf6,x
        sta     $7c51,x
        sta     $7cac,x
        sta     $7d07,x
        sta     $7d62,x
        sta     $7dbd,x
        sta     $7e18,x
        inx3
        cpx     #$0051
        bne     @38e9
        lda     #$87        ; 1 strip @ 7 scanlines
        sta     $7b40
        sta     $7b9b
        sta     $7bf6
        sta     $7c51
        sta     $7cac
        sta     $7d07
        sta     $7d62
        sta     $7dbd
        sta     $7e18
        lda     #$80        ; end of table (223 scanlines total)
        sta     $7b40,x
        sta     $7b9b,x
        sta     $7bf6,x
        sta     $7c51,x
        sta     $7cac,x
        sta     $7d07,x
        sta     $7d62,x
        sta     $7dbd,x
        sta     $7e18,x
        tdc
        pha
        plb
        jsr     InitFontColorHDMATbl
        jsr     InitScrollHDMATbl
        jsr     InitMosaicHDMATbl
        jsr     InitColorMathHDMATbl
        jsr     InitColorMathHDMAData
        jsr     InitWindowHDMATbl
        jsr     InitWindowHDMAData
        jsr     InitMaskHDMATbl
        jsr     InitMaskHDMAData
        jsr     InitFixedColorHDMATbl
        jsr     InitFixedColorHDMAData
        rts

; ------------------------------------------------------------------------------

; [ init unused hdma table ]

InitFontColorHDMATbl:
@396b:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3973:  lda     #$8143
        sta     $7b41,x
        inx3
        cpx     #$0051
        bne     @3973
        ldx     $00
@3983:  lda     f:FontColorTbl,x
        sta     $8143,x
        inx2
        cpx     #$0020
        bne     @3983
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; color palette for unused hdma data
FontColorTbl:
@3998:  .word   $4210,$4a52,$5294,$5ad6,$6318,$6b5a,$739c,$7bde

; ------------------------------------------------------------------------------

; [ load horizontal fade bars (from ending) ]

InitFadeBars:
@39a8:  lda     $1ed8
        and     #$01
        beq     @3a04
        lda     #$7e
        pha
        plb
        longa
        lda     #$8903
        sta     $7d0b
        lda     #$8913
        sta     $7d0e
        lda     #$8923
        sta     $7d3b
        lda     #$8933
        sta     $7d3e
        lda     #$8c93
        sta     $7e1c
        sta     $7e1f
        sta     $7e4c
        sta     $7e4f
        ldx     $00
@39de:  lda     #$81a3
        sta     $7df7,x
        lda     #$8733
        sta     $7ce6,x
        lda     #$8253
        sta     $7bd5,x
        lda     #$8c73
        sta     $7e52,x
        inx3
        cpx     #$0018
        bne     @39de
        shorta0
        tdc
        pha
        plb
@3a04:  rts

; ------------------------------------------------------------------------------

; [ init main/sub screen designation hdma table ]

InitMaskHDMATbl:
@3a05:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3a0d:  lda     #$8163
        sta     $7dbe,x
        inx3
        cpx     #$0051
        bne     @3a0d
        lda     #$8173
        sta     $7dbe
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init main/sub screen designation hdma data ]

InitMaskHDMAData:
@3a28:  ldx     #$8173
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        tdc
        .repeat 16
        sta     hWMDATA
        .endrep
        ldx     #$8183
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     #$05
        sta     hWMDATA
        .repeat 15
        xba
        sta     hWMDATA
        .endrep
        tdc
        ldx     #$8193
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     #$1f
        sta     hWMDATA
        .repeat 15
        xba
        sta     hWMDATA
        .endrep
        tdc
        ldx     #$8163
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     $51
        sta     hWMDATA
        xba
        lda     $52
        sta     hWMDATA
        .repeat 14
        xba
        sta     hWMDATA
        .endrep
        tdc
        ldx     #$81a3
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     #$04
        sta     hWMDATA
        .repeat 15
        xba
        sta     hWMDATA
        .endrep
        tdc
        rts

; ------------------------------------------------------------------------------

; [ update window 2 position hdma table ]

InitWindowHDMATbl:
@3b9b:  lda     $0566
        lsr
        bcs     @3bd0
        lda     #$7e
        pha
        plb
        longa
        ldx     $00
        lda     #$8cb3
@3bac:  ldy     $7d66,x
        cpy     #$8ca3
        beq     @3bb7
        sta     $7d66,x
@3bb7:  clc
        adc     #$0010
        inx3
        cpx     #$004e
        bne     @3bac
        lda     #$8ff3
        sta     $7d63
        shorta0
        tdc
        pha
        plb
        rts
@3bd0:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
        lda     #$8e53
@3bdb:  ldy     $7d66,x
        cpy     #$8ca3
        beq     @3be6
        sta     $7d66,x
@3be6:  clc
        adc     #$0010
        inx3
        cpx     #$004e
        bne     @3bdb
        lda     #$8ff3
        sta     $7d63
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init window 2 position hdma data ]

InitWindowHDMAData:
@3bff:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3c07:  lda     #$00ff
        sta     $8ff3,x
        lda     #$ff00
        sta     $8ca3,x
        inx2
        cpx     #$0010
        bne     @3c07
        ldx     $00
@3c1c:  lda     #$ff00
        sta     $8cb3,x
        sta     $8e53,x
        inx2
        cpx     #$01a0
        bne     @3c1c
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init fixed color add/sub hdma table ]

InitFixedColorHDMATbl:
@3c33:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3c3b:  lda     #$8753
        sta     $7d08,x
        inx3
        cpx     #$0051
        bne     @3c3b
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init fixed color add/sub hdma data ]

InitFixedColorHDMAData:
@3c50:  ldx     #$8753      ; set wram address to $7e8753
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     $00
@3c5d:  lda     #$e0        ; set all 8 scanlines to black
        sta     hWMDATA
        lda     #$00
        sta     hWMDATA
        inx
        cpx     #$0008
        bne     @3c5d
        ldx     #$8943      ; set wram address to $7e8943
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     $00
@3c7a:  lda     f:DlgWindowFixedColorTbl,x
        sta     hWMDATA       ; each byte gets copied twice
        lda     f:DlgWindowFixedColorTbl,x
        sta     hWMDATA
        inx
        cpx     #$00c8
        bne     @3c7a
        ldx     #$8903      ; set wram address to $7e8903
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     $00
@3c9b:  lda     f:FadeBarsFixedColorTbl,x
        sta     hWMDATA       ; each byte gets copied twice
        sta     hWMDATA
        inx
        cpx     #$0010
        bne     @3c9b
        ldx     #$8923      ; repeat in reverse order
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     #$0010
@3cb9:  lda     f:FadeBarsFixedColorTbl-1,x
        sta     hWMDATA       ; each byte gets copied twice
        sta     hWMDATA
        dex
        bne     @3cb9
        rts

; ------------------------------------------------------------------------------

; fixed color data for horizontal fade bars, from ending
FadeBarsFixedColorTbl:
@3cc7:  .byte   $fc,$f8,$f4,$f0,$ee,$ec,$ea,$e9,$e8,$e7,$e6,$e5,$e4,$e3,$e2,$e1

; ------------------------------------------------------------------------------

; fixed color data for dialog window gradient
DlgWindowFixedColorTbl:
@3cd7:  .byte   $e7,$e7,$e7,$e6,$e6,$e6,$e6,$e6
        .byte   $e5,$e5,$e5,$e5,$e5,$e4,$e4,$e4
        .byte   $e4,$e4,$e3,$e3,$e3,$e3,$e3,$e2
        .byte   $e2,$e2,$e2,$e2,$e1,$e1,$e1,$e1
        .byte   $e1,$e0,$e0,$e0,$e0,$e0,$e1,$e1
        .byte   $e1,$e1,$e1,$e2,$e2,$e2,$e2,$e2
        .byte   $e3,$e3,$e3,$e3,$e3,$e4,$e4,$e4
        .byte   $e4,$e4,$e5,$e5,$e5,$e5,$e5,$e6
        .byte   $e6,$e6,$e6,$e6,$e7,$e7,$e7,$e7

@3d1f:  .byte   $e7,$e7,$e6,$e6,$e6,$e6,$e5,$e5
        .byte   $e5,$e5,$e4,$e4,$e4,$e4,$e3,$e3
        .byte   $e3,$e3,$e2,$e2,$e2,$e2,$e1,$e1
        .byte   $e1,$e1,$e0,$e0,$e0,$e0,$e1,$e1
        .byte   $e1,$e1,$e2,$e2,$e2,$e2,$e3,$e3
        .byte   $e3,$e3,$e4,$e4,$e4,$e4,$e5,$e5
        .byte   $e5,$e5,$e6,$e6,$e6,$e6,$e7,$e7

@3d57:  .byte   $e7,$e6,$e6,$e6,$e5,$e5,$e5,$e4
        .byte   $e4,$e4,$e3,$e3,$e3,$e2,$e2,$e2
        .byte   $e1,$e1,$e1,$e0,$e0,$e0,$e1,$e1
        .byte   $e1,$e2,$e2,$e2,$e3,$e3,$e3,$e4
        .byte   $e4,$e4,$e5,$e5,$e5,$e6,$e6,$e6

@3d7f:  .byte   $e6,$e5,$e5,$e4,$e4,$e3,$e3,$e2
        .byte   $e2,$e1,$e1,$e0,$e0,$e1,$e1,$e2
        .byte   $e2,$e3,$e3,$e4,$e4,$e5,$e5,$e6

@3d97:  .byte   $e4,$e3,$e2,$e1,$e0,$e1,$e2,$e3

; ------------------------------------------------------------------------------

; [ init color add/sub settings hdma table ]

InitColorMathHDMATbl:
@3d9f:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3da7:  lda     #$8c63
        sta     $7e19,x
        inx3
        cpx     #$0051
        bne     @3da7
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init color add/sub settings hdma data ]

InitColorMathHDMAData:
@3dbc:  lda     #$7e
        pha
        plb
        ldx     $00
@3dc2:  lda     $50
        sta     $8c63,x
        sta     $8c73,x
        lda     $4e
        sta     $8c64,x
        tdc
        sta     $8c74,x
        lda     #$20
        sta     $8ad3,x
        sta     $8ae3,x
        sta     $8af3,x
        sta     $8b03,x
        sta     $8b13,x
        sta     $8b23,x
        sta     $8b33,x
        sta     $8b43,x
        sta     $8b53,x
        sta     $8b63,x
        sta     $8b73,x
        sta     $8b83,x
        sta     $8b93,x
        sta     $8ba3,x
        sta     $8bb3,x
        sta     $8bc3,x
        sta     $8bd3,x
        sta     $8be3,x
        sta     $8bf3,x
        sta     $8c03,x
        sta     $8c13,x
        sta     $8c23,x
        sta     $8c33,x
        sta     $8c43,x
        sta     $8c53,x
        sta     $8c83,x
        sta     $8c93,x
        inx2
        cpx     #$0010
        bne     @3dc2
        ldx     $00
@3e2f:  lda     #$01
        sta     $8ad4,x
        sta     $8adc,x
        sta     $8ae4,x
        sta     $8aec,x
        sta     $8af4,x
        sta     $8afc,x
        sta     $8b04,x
        sta     $8b0c,x
        sta     $8b14,x
        sta     $8b64,x
        sta     $8b6c,x
        sta     $8b74,x
        sta     $8b7c,x
        sta     $8b84,x
        sta     $8b8c,x
        sta     $8b94,x
        sta     $8bd4,x
        sta     $8bdc,x
        sta     $8be4,x
        sta     $8bec,x
        sta     $8bf4,x
        sta     $8c24,x
        sta     $8c2c,x
        sta     $8c34,x
        sta     $8c54,x
        lda     #$1f
        sta     $8c84,x
        sta     $8c8c,x
        lda     #$81
        sta     $8b1c,x
        sta     $8b24,x
        sta     $8b2c,x
        sta     $8b34,x
        sta     $8b3c,x
        sta     $8b44,x
        sta     $8b4c,x
        sta     $8b54,x
        sta     $8b5c,x
        sta     $8b9c,x
        sta     $8ba4,x
        sta     $8bac,x
        sta     $8bb4,x
        sta     $8bbc,x
        sta     $8bc4,x
        sta     $8bcc,x
        sta     $8bfc,x
        sta     $8c04,x
        sta     $8c0c,x
        sta     $8c14,x
        sta     $8c1c,x
        sta     $8c3c,x
        sta     $8c44,x
        sta     $8c4c,x
        sta     $8c5c,x
        lda     #$9f
        sta     $8c94,x
        sta     $8c9c,x
        inx2
        cpx     #8
        jne     @3e2f
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init mosaic/bg location hdma table and data ]

InitMosaicHDMATbl:
@3ee7:  ldx     $00
        lda     #$7e
        pha
        plb
        longa
@3eef:  lda     #$8233
        sta     $7b9c,x
        inx3
        cpx     #$0051
        bne     @3eef
        shorta0
        ldx     $00
@3f02:  tdc
        sta     $81b3,x
        sta     $81d3,x
        sta     $8213,x
        sta     $8253,x
        lda     #$0f
        sta     $81f3,x
        sta     $8233,x
        lda     #$40
        sta     $81b4,x
        sta     $81f4,x
        lda     #$48
        sta     $8214,x
        sta     $8234,x
        sta     $81d4,x
        sta     $8254,x
        lda     #$50
        sta     $81d5,x
        sta     $8215,x
        sta     $8235,x
        sta     $8255,x
        lda     #$44
        sta     $81b6,x
        sta     $81d6,x
        sta     $81f6,x
        sta     $8256,x
        lda     #$58
        sta     $8216,x
        sta     $8236,x
        inx4
        cpx     #$0020
        bne     @3f02
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ flip bg1 map location ]

FlipBG1:
@3f5e:  ldx     $00
        lda     $058c
        eor     #$04
        sta     $058c
@3f68:  sta     $7e8214,x
        sta     $7e8234,x
        sta     $7e81d4,x
        inx4
        cpx     #$0020
        bne     @3f68
        rts

; ------------------------------------------------------------------------------

; [ flip bg2 map location ]

FlipBG2:
@3f7e:  ldx     $00
        lda     $058e
        eor     #$04
        sta     $058e
@3f88:  sta     $7e81d5,x
        sta     $7e8215,x
        sta     $7e8235,x
        inx4
        cpx     #$0020
        bne     @3f88
        rts

; ------------------------------------------------------------------------------

; [ flip bg3 map location ]

FlipBG3:
@3f9e:  ldx     $00
        lda     $0590
        eor     #$04
        sta     $0590
@3fa8:  sta     $7e8216,x
        sta     $7e8236,x
        inx4
        cpx     #$0020
        bne     @3fa8
        rts

; ------------------------------------------------------------------------------

; [ flip all bg map locations (unused) ]

_c03fba:
@3fba:  lda     $058c
        eor     #$04
        sta     $058c
        lda     $058e
        eor     #$04
        sta     $058e
        lda     $0590
        eor     #$04
        sta     $0590
        ldx     $00
@3fd4:  lda     $058c
        sta     $7e8214,x
        sta     $7e8234,x
        sta     $7e81d4,x
        lda     $058e
        sta     $7e81d5,x
        sta     $7e8215,x
        sta     $7e8235,x
        lda     $0590
        sta     $7e8216,x
        sta     $7e8236,x
        inx4
        cpx     #$0020
        bne     @3fd4
        rts

; ------------------------------------------------------------------------------

; [ random bg3 mosaic (unused) ]

_c04007:
@4007:  lda     #$7e
        pha
        plb
        lda     $46
        asl2
        tax
        ldy     $00
@4012:  lda     f:RNGTbl,x   ; random number table
        cmp     #$c0
        bcc     @4020       ; branch if less than 192 (3/4 chance)
        and     #$30        ; set mosaic size (0..3)
        ora     #$04        ; enable mosaic in bg3
        bra     @4021
@4020:  tdc
@4021:  sta     $81d3,y
        inx
        iny4
        cpy     #$0020
        bne     @4012
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init bg scroll hdma table and data ]

InitScrollHDMATbl:
@4032:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@403a:  lda     #$8273                  ; set hdma tables
        sta     $7bfa,x
        lda     #$8293
        sta     $7bfd,x
        lda     #$82b3
        sta     $7c55,x
        lda     #$82d3
        sta     $7c58,x
        lda     #$82f3
        sta     $7cb0,x
        sta     $7cb3,x
        inx6
        cpx     #$004e
        bne     @403a
        ldx     $00                     ; bg1 scroll hdma data for dialog window
        tdc
@4069:  sta     $8313,x                 ; clear horizontal scroll values
        inx2
        cpx     #$0220
        bne     @4069
        ldx     $00
        txy
@4076:  lda     f:DlgWindowBG1ScrollTbl,x
        and     #$00ff
        sta     $8335,y                 ; set vertical scroll values
        iny4
        inx
        cpx     #$0080
        bne     @4076
        ldx     $00                     ; bg3 scroll hdma data for dialog window
        txy
@408d:  tdc
        sta     $85f3,y                 ; clear horizontal scroll values
        lda     f:DlgWindowBG3ScrollTbl,x
        and     #$00ff
        sta     $85f5,y                 ; set vertical scroll values
        inx2
        iny4
        cpy     #$0120
        bne     @408d
        ldx     $00                     ; bg3 scroll hdma data for map name window
        txy
@40a9:  tdc
        sta     $8573,y                 ; clear horizontal scroll values
        lda     f:MapTitleBG3ScrollTbl,x
        and     #$00ff
        sta     $8575,y                 ; set vertical scroll values
        inx2
        iny4
        cpy     #$0080
        bne     @40a9
        ldx     $00                     ; bg1 scroll hdma data for map name window
        tdc
@40c5:  sta     $8533,x                 ; clear horizontal scroll values
        inx2
        cpx     #$0020
        bne     @40c5
        ldx     $00
        tdc
@40d2:  tdc
        sta     $8553,x
        lda     #$0028
        sta     $8555,x                 ; set vertical scroll values to $28
        inx4
        cpx     #$0020
        bne     @40d2
        ldx     $00                     ; bg3 scroll data (unused)
@40e7:  lda     #$00b0
        sta     $8715,x
        tdc
        sta     $8713,x
        inx4
        cpx     #$0020
        bne     @40e7
        ldx     $00                     ; bg3 scroll data for horizontal fade bars (from ending)
@40fc:  lda     #$00b8
        sta     $8735,x
        tdc
        sta     $8733,x
        inx4
        cpx     #$0020
        bne     @40fc
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll values for dialog window
bg3_mess_pos_tbl:
DlgWindowBG3ScrollTbl:
@4116:  .word   $fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc
        .word   $fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc
        .word   $fffc,$fffc,$fffc,$fffc,$fffd,$fffd,$fffd,$fffd
        .word   $fffd,$fffd,$fffd,$fffd,$fffd,$fffd,$fffd,$fffd
        .word   $fffd,$fffd,$fffd,$fffe,$fffe,$fffe,$fffe,$fffe
        .word   $fffe,$fffe,$fffe,$fffe,$fffe,$fffe,$fffe,$fffe
        .word   $fffe,$fffe,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
        .word   $ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
        .word   $ffff,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
        .word   $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
        .word   $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
        .word   $0001,$0001,$0001,$0001,$0001,$0001

; bg3 vertical scroll values for map name window
MapTitleBG3ScrollTbl:
@41f2:  .word   $fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa
        .word   $fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa
        .word   $fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000

; bg1 vertical scroll values for dialog window (compresses window while opening)
DlgWindowBG1ScrollTbl:
@4236:  .byte   $f8,$f8,$f9,$f9,$f9,$f9,$fa,$fa
        .byte   $fa,$fb,$fb,$fb,$fb,$fc,$fc,$fc
        .byte   $fd,$fd,$fd,$fd,$fe,$fe,$fe,$ff
        .byte   $ff,$ff,$ff,$00,$00,$01,$01,$01
        .byte   $01,$02,$02,$02,$03,$03,$03,$03
        .byte   $04,$04,$04,$05,$05,$05,$05,$06
        .byte   $06,$06,$07,$07,$07,$07,$08,$08

@426e:  .byte   $f0,$f1,$f2,$f2,$f3,$f4,$f5,$f6
        .byte   $f6,$f7,$f8,$f9,$fa,$fa,$fb,$fc
        .byte   $fd,$fe,$fe,$ff,$01,$02,$02,$03
        .byte   $04,$05,$06,$06,$07,$08,$09,$0a
        .byte   $0a,$0b,$0c,$0d,$0e,$0e,$0f,$10

@4296:  .byte   $e8,$ea,$ec,$ee,$f0,$f2,$f4,$f6
        .byte   $f8,$fa,$fc,$fe,$02,$04,$06,$08
        .byte   $0a,$0c,$0e,$10,$12,$14,$16,$18

@42ae:  .byte   $e0,$e8,$f0,$f8,$08,$10,$18,$20

; ------------------------------------------------------------------------------

; [ update bg scroll hdma data ]

UpdateScrollHDMA:
@42b6:  longa
        lda     $64
        sec
        sbc     #8
        shorta
        sta     hBG2HOFS
        xba
        sta     hBG2HOFS
        longa
        lda     $68
        clc
        adc     $074e
        shorta
        sta     hBG2VOFS
        xba
        sta     hBG2VOFS
        tdc
        lda     #$7e
        pha
        plb
        longa
        lda     $5c                     ; bg1 horizontal scroll position
        sec
        sbc     #8
        .repeat 16, i
        sta     $8273+i*4
        .endrep
        lda     $64                     ; bg2 horizontal scroll position
        sec
        sbc     #8
        .repeat 16, i
        sta     $82b3+i*4
        .endrep
        lda     $6c                     ; bg3 horizontal scroll position
        sec
        sbc     #8
        .repeat 8, i
        sta     $82f3+i*4
        .endrep
        lda     $60                     ; bg1 vertical scroll position
        clc
        adc     $074c
        .repeat 16,i
        sta     $8275+i*4
        .endrep

; bg1
        shorta0
        lda     $0521
        and     #$10
        jeq     @444a

; wavy bg1
        lda     $46
        lsr
        clc
        adc     $60                     ; bg1 vertical scroll position
        and     #$0f
        asl
        tax
        longa
        ldy     $60
        .repeat 16, i
        tya
        clc
        adc     f:WavyScrollTbl1+i*2,x
        sta     $8275+i*4
        .endrep

; bg2
@444a:  shorta0
        lda     $0521
        and     #$08
        jeq     @44f8

; wavy bg2
        lda     $46
        lsr
        clc
        adc     $68
        clc
        adc     #$08
        and     #$0f
        asl
        tax
        longa
        ldy     $68
        .repeat 16, i
        tya
        clc
        adc     f:WavyScrollTbl1+i*2,x
        sta     $82b5+i*4
        .endrep

; bg3
@44f8:  shorta0
        lda     $46
        lsr3
        clc
        adc     $70
        and     #$07
        asl
        tax
        lda     $0521
        and     #$04
        bne     @4511
        ldx     #$0020
@4511:  longa_clc
        lda     $70
        adc     $0750
        tay
        clc
        adc     f:WavyScrollTbl3,x
        sta     $82f5
        .repeat 7, i
        tya
        clc
        adc     f:WavyScrollTbl3+(i+1)*2,x
        sta     $82f5+(i+1)*4
        .endrep
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; scroll HDMA values for wavy BG1 and BG2
WavyScrollTbl1:
@4567:  .word   $0000,$0001,$0001,$0002,$0002,$0002,$0001,$0001
        .word   $0000,$ffff,$ffff,$fffe,$fffe,$fffe,$ffff,$ffff
        .word   $0000,$0001,$0001,$0002,$0002,$0002,$0001,$0001
        .word   $0000,$ffff,$ffff,$fffe,$fffe,$fffe,$ffff,$ffff

; unused scroll values for BG1 and BG2
WavyScrollTbl2:
@45a7:  .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; scroll HDMA values for wavy BG3
WavyScrollTbl3:
@45e7:  .word   $0000,$0001,$0001,$0001,$0000,$ffff,$ffff,$ffff
        .word   $0000,$0001,$0001,$0001,$0000,$ffff,$ffff,$ffff

; unused scroll values for BG3
WavyScrollTbl4:
@4607:  .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------
