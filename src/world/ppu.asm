
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/ppu.asm                                                        |
; |                                                                            |
; | description: world map ppu and vram routines                               |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [  ]

UpdateMode7Circle:
@ac18:  php
        phb
        shortai
        lda     $59
        beq     @ac9e
        lda     #$7e
        pha
        plb
        longa
        stz     $6c
        stz     $6f
        lda     $58
        sta     $6a
        stz     $6d
        cmp     #$8000
        bcs     @ac3c
        cmp     #$4000
        bcs     @ac58
        bra     @ac7a
@ac3c:  longa_clc
        lda     $6d
        adc     $6b
        sta     $6d
        lda     $6a
        sec
        sbc     $6e
        bcc     @ac9e
        sta     $6a
        ldx     $6b
        shorta_sec
        lda     $6e
        sta     $bc62,x
        bra     @ac3c
@ac58:  longa_clc
        lda     $6b
        asl
        adc     $6d
        sta     $6d
        lda     $6e
        asl
        sta     $5a
        lda     $6a
        sec
        sbc     $5a
        bcc     @ac9e
        sta     $6a
        ldx     $6b
        shorta_sec
        lda     $6e
        sta     $bc62,x
        bra     @ac58
@ac7a:  longa_clc
        lda     $6b
        asl2
        adc     $6d
        sta     $6d
        lda     $6e
        asl2
        sta     $5a
        lda     $6a
        sec
        sbc     $5a
        bcc     @ac9e
        sta     $6a
        ldx     $6b
        shorta_sec
        lda     $6e
        sta     $bc62,x
        bra     @ac7a
@ac9e:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ update bomb window position hdma ]

; used for light of judgment and world of ruin cutscene

UpdateBombHDMA:
_eeaca1:
bomb:
@aca1:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longai
        lda     $5e
        jeq     @ad3f
        lda     $5a
        asl2
        clc
        adc     $5c
        tay
        ldx     #$0000
        lda     $5e
        cmp     $5a
        bcs     @acc9
        lda     $5e
        sta     $60
        bra     @accd
@acc9:  lda     $5a
        sta     $60
@accd:  shorta
        lda     $58
        sec
        sbc     $bc62,x
        bcs     @acd9
        lda     #$00
@acd9:  sta     $620e,y
        lda     $58
        clc
        adc     $bc62,x
        bcc     @ace6
        lda     #$ff
@ace6:  sta     $620f,y
        dey4
        inx
        cpx     $60
        bne     @accd
        longa
        lda     $5a
        asl2
        clc
        adc     $5c
        tay
        ldx     #$0000
        lda     #$00e0
        sec
        sbc     $5a
        sta     $62
        lda     $5e
        lsr
        cmp     $62
        bcs     @ad14
        lda     $5e
        sta     $60
        bra     @ad19
@ad14:  lda     $62
        asl
        sta     $60
@ad19:  shorta
        lda     $58
        sec
        sbc     $bc62,x
        bcs     @ad25
        lda     #$00
@ad25:  sta     $620e,y
        lda     $58
        clc
        adc     $bc62,x
        bcc     @ad32
        lda     #$ff
@ad32:  sta     $620f,y
        iny4
        inx2
        cpx     $60
        bcc     @ad19
@ad3f:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ copy color palettes to ppu ]

; only used for magitek train
; ++$6a: source address

TfrPal:
@ad42:  stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     $6a
        stx     $4302
        lda     $6c
        sta     $4304
        ldx     #$0200      ; size = $0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; copy palettes from ppu to wram
        stz     hCGADD
        ldx     #$3b80
        stx     $4300
        ldx     #$e000      ; destination = $7ee000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200      ; size = $0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy backdrop graphics to vram (BG2) ]

TfrBackdropGfx:
@ad80:  lda     #$80
        sta     hVMAINC
        ldx     #$5000      ; destination = $5000 (vram)
        stx     hVMADDL
        ldx     #$1801
        stx     $4300
        ldx     #$2000      ; source = $7e2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$2000      ; size = $2000
        stx     $4305
        lda     #$01
        sta     hMDMAEN       ; enable dma
        rts

; ------------------------------------------------------------------------------

; [ copy backdrop tile formation to vram ]

TfrBackdropTiles:
@ada8:  lda     #$80
        sta     hVMAINC
        ldx     #$4400      ; destination = $4400 (vram)
        stx     hVMADDL
        ldx     #$1801
        stx     $4300
        ldx     #$2000      ; source = $7e2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$1000      ; size = $1000
        stx     $4305
        lda     #$01
        sta     hMDMAEN       ; enable dma
        rts

; ------------------------------------------------------------------------------

; [ copy sprite graphics to vram ]

TfrSpriteGfx:
@add0:  lda     #$80
        sta     hVMAINC
        ldx     #$6000     ; destination = $6000 (vram)
        stx     hVMADDL
        ldx     #$1801
        stx     $4300
        ldx     #$2000     ; source = $7e2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$4000     ; size = $4000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ init magitek train ride tile map in vram ]

TfrTrainTiles:
@adf8:  lda     #$80
        sta     hVMAINC
        stz     hVMADDL
        stz     hVMADDH
        ldy     #$0000
@ae06:  sty     $58         ; tile index
        ldx     #$1908
        stx     $4300
        ldx     #$0058      ; source = $000058
        stx     $4302
        stz     $4304
        ldx     #$0040      ; size = $0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        iny                 ; next tile
        cpy     #$0100
        bne     @ae06
        rts

; ------------------------------------------------------------------------------

; [ copy pointers to magitek train ride tiles to vram ]

; for some reason it transfers this table to vram and then from there to wram

; ++$6a: source address

LoadTrainTilePtrs:
@ae29:  lda     #$80
        sta     hVMAINC
        ldx     #$0000      ; destination = $0000 (vram)
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     $6a
        stx     $4302
        lda     $6c
        sta     $4304
        ldx     #$02b8      ; size = $02b8
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$0000      ; source = $0000 (vram)
        stx     hVMADDL
        cmp     hRVMDATAH
        ldx     #$3a80
        stx     $4300
        ldx     #$0800      ; destination = $7f0800
        stx     $4302
        lda     #$7f
        sta     $4304
        ldx     #$02b8      ; size = $02b8
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ init animated water graphics in vram ]

InitWaterGfx:
@ae75:  lda     #$80
        sta     hVMAINC
        ldx     #$1100
        stx     hVMADDL
        cmp     hRVMDATAH
        ldx     #$3a80
        stx     $4300
        ldx     #$b750
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$1500
        stx     hVMADDL
        cmp     hRVMDATAH
        ldx     #$3a80
        stx     $4300
        ldx     #$b7d0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longa
        lda     #$0080
        sta     $7eb850
        lda     #$1040
        sta     $7eb852
        lda     #$60a0
        sta     $7eb854
        lda     #$b030
        sta     $7eb856
        lda     #$20f0
        sta     $7eb858
        lda     #$c070
        sta     $7eb85a
        lda     #$50d0
        sta     $7eb85c
        lda     #$e090
        sta     $7eb85e
        shorta
        rts

; ------------------------------------------------------------------------------
