; ------------------------------------------------------------------------------

; [ transfer world map bg graphics to vram ]

; combine pixel and palette data and transfer to vram

TfrWorldMapGfx:
@3f4f:  php
        phb
        shorta
        lda     #$00
        pha
        plb
        longa
        lda     #$7350
        sta     hWMADDL
        stz     hVMADDL
        shorta
        stz     hWMADDH
        lda     #$80
        sta     hVMAINC
        shorti
        ldx     #0

; first tile
@3f70:  lda     $7e9350,x               ; palette (high nybble of color index)
        and     #$0f                    ; i think this line is unnecessary
        asl4
        sta     $58
        phx
        ldx     #$20                    ; 64 pixels per tile, 2 pixels per byte
@3f7f:  lda     hWMDATA                 ; 1st pixel
        tay
        and     #$0f
        ora     $58
        sta     hVMDATAH                ; store high byte only
        tya
        lsr4                            ; 2nd pixel
        ora     $58
        sta     hVMDATAH
        dex
        bne     @3f7f
        plx

; 2nd tile
        lda     $7e9350,x               ; palette
        and     #$f0
        sta     $58
        phx
        ldx     #$20
@3fa3:  lda     hWMDATA
        tay
        and     #$0f
        ora     $58
        sta     hVMDATAH
        tya
        lsr4
        ora     $58
        sta     hVMDATAH
        dex
        bne     @3fa3

; next pair of tiles
        plx
        inx
        cpx     #$80                    ; 256 tiles total
        bne     @3f70
        plb
        plp
        rts

; ------------------------------------------------------------------------------

