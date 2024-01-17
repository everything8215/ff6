
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/tilemap.asm                                                    |
; |                                                                            |
; | description: world map tilemap routines                                    |
; |                                                                            |
; | created: 5/18/2023                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ load partial tilemap (for scrolling) ]

; 256x256 map (WoB and WoR)
; the tilemap in vram is updated every frame so that a 64x64 region of the
; world map is loaded, with the player being at the center. when the player
; moves, additional horizontal and vertical strips of tiles are loaded so
; that the player remains at the center of the 64x64 region.

UpdateTilemap256:
@3363:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $34                     ; x position
        sec
        sbc     #$0200                  ; start 32 tiles left
        and     #$0fff
        sta     $5a
        lda     $38                     ; y position
        sec
        sbc     #$0200                  ; start 32 tiles up
        and     #$0fff
        sta     $5c

; check h-scroll
        longa
        lda     $5a
        lsr3
        and     #$007e
        tax
        lda     $40
        cmp     #$1000
        bpl     @33a7
        cmp     #$0000
        bmi     @33cf

; don't need h-scroll transfer
        lda     #$8000                  ; disable dma for h-scroll
        sta     $44
        jmp     @342a

; load a strip of tiles to the right
@33a7:  lda     $40
        sec
        sbc     #$1000
        sta     $40
        lda     $5c
        asl4
        clc
        adc     #$3f00
        and     #$ff00
        sta     $5e
        lda     $5c
        asl4
        sec
        sbc     #$0100
        and     #$3f00                  ; enable dma for h-scroll
        sta     $44
        bra     @33ed

; load a strip of tiles to the left
@33cf:  lda     $40
        clc
        adc     #$1000
        sta     $40
        lda     $5c
        asl4
        and     #$ff00
        sta     $5e
        lda     $5c
        asl4
        and     #$3f00                  ; enable dma for h-scroll
        sta     $44
@33ed:  lda     $5a
        lsr4
        and     #$00ff
        tay
        lda     #$0040
        sta     $66
@33fc:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y                 ; copy tiles to vram buffer
        sta     $6d50,x
        lda     $6f52,y
        sta     $6dd0,x
        pla
        inc
        and     #$00ff
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @33fc

; skip v-scroll transfer until next frame to wait for h-scroll transfer
        lda     #$8000                  ; disable dma for v-scroll
        sta     $46
        jmp     @34d3

; check v-scroll
@342a:  longa
        lda     $5c
        lsr3
        and     #$007e
        tax
        lda     $3c
        cmp     #$1000
        bpl     @3449
        cmp     #$0000
        bmi     @346e

; don't need v-scroll transfer
        lda     #$8000                  ; disable dma for v-scroll
        sta     $46
        jmp     @34d3

; load a strip of tiles to the south (down)
@3449:  lda     $3c
        sec
        sbc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        clc
        adc     #$003f
        and     #$00ff
        sta     $5e
        lda     $5a
        lsr3
        dec2
        and     #$007e                  ; enable dma for v-scroll
        sta     $46
        bra     @348b

; load a strip of tiles to the north (up)
@346e:  lda     $3c
        clc
        adc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        and     #$00ff
        sta     $5e
        lda     $5a
        lsr3
        and     #$007e                  ; enable dma for v-scroll
        sta     $46
@348b:  lda     $5c
        asl4
        and     #$ff00
        tay
        lda     #$0040
        sta     $66
@349a:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        shorta
        lda     $6f50,y                 ; copy tiles to vram buffer
        sta     $6e50,x
        lda     $6f51,y
        sta     $6ed0,x
        lda     $6f52,y
        sta     $6e51,x
        lda     $6f53,y
        sta     $6ed1,x
        longa
        pla
        clc
        adc     #$0100
        and     #$ff00
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @349a
@34d3:  plb
        rts

; ------------------------------------------------------------------------------

; [ load full tilemap (init) ]

; 256x256 map (WoB and WoR)
; note that the world maps are 256x256 in 16x16 tiles, but vram can only
; hold 128x128 8x8 tiles in mode 7, so only 1/16 of the map is loaded here

InitTilemap256:
@34d5:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $38                     ; y position
        sec
        sbc     #$0200
        sta     $5c
        asl4
        and     #$ff00
        sta     $5e
        and     #$3f00
        sta     $6a
        lda     $34                     ; x position
        sec
        sbc     #$0200
        and     #$0fff
        sta     $5a
        lsr3
        and     #$007e
        ora     $6a
        tax
        lda     $5a
        lsr4
        and     #$00ff
        tay
        lda     #$0040
        sta     $66
@351d:  lda     #$0040
        sta     $68
@3522:  lda     [$5e],y                 ; from 7f/0000
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y
        sta     $2000,x
        lda     $6f52,y
        sta     $2080,x
        pla
        inc
        and     #$00ff
        tay
        txa
        inc2
        and     #$3f7f
        tax
        dec     $68
        bne     @3522
        tya
        sec
        sbc     #$0040
        and     #$00ff
        tay
        txa
        clc
        adc     #$0100
        and     #$3f7f
        tax
        lda     $5e
        adc     #$0100
        sta     $5e
        dec     $66
        bne     @351d
        plb
        stz     hVMAINC
        stz     hVMADDL
        lda     #$1800
        sta     $4300
        lda     #$2000
        sta     $4302
        lda     #$007e
        sta     $4304
        lda     #$4000                  ; transfer $4000 bytes
        sta     $4305
        lda     #$0100
        sta     hMDMAEN-1               ; also clears hVTIMEH
        rts

; ------------------------------------------------------------------------------

; [ load partial tilemap (for scrolling) ]

; 128x128 map (serpent trench)

UpdateTilemap128:
@358b:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $34
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5a
        lda     $38
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5c
        longa
        lda     $5a
        lsr3
        and     #$007e
        tax
        lda     $40
        cmp     #$1000
        bpl     @35cf
        cmp     #$0000
        bmi     @35f6
        lda     #$8000                  ; disable dma for h-scroll
        sta     $44
        jmp     @3650
@35cf:  lda     $40
        sec
        sbc     #$1000
        sta     $40
        lda     $5c
        asl3
        clc
        adc     #$1f80
        and     #$3f80
        sta     $5e
        lda     $5c
        asl4
        sec
        sbc     #$0100
        and     #$3f00                  ; enable dma for h-scroll
        sta     $44
        bra     @3613
@35f6:  lda     $40
        clc
        adc     #$1000
        sta     $40
        lda     $5c
        asl3
        and     #$3f80
        sta     $5e
        lda     $5c
        asl4
        and     #$3f00                  ; enable dma for h-scroll
        sta     $44
@3613:  lda     $5a
        lsr4
        and     #$007f
        tay
        lda     #$0040
        sta     $66
@3622:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y
        sta     $6d50,x
        lda     $6f52,y
        sta     $6dd0,x
        pla
        inc
        and     #$007f
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @3622
        lda     #$8000                  ; disable dma for v-scroll
        sta     $46
        jmp     @36f8
@3650:  longa
        lda     $5c
        lsr3
        and     #$007e
        tax
        lda     $3c
        cmp     #$1000
        bpl     @366f
        cmp     #$0000
        bmi     @3694
        lda     #$8000                  ; disable dma for v-scroll
        sta     $46
        jmp     @36f8
@366f:  lda     $3c
        sec
        sbc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        clc
        adc     #$003f
        and     #$007f
        sta     $5e
        lda     $5a
        lsr3
        dec2
        and     #$007e                  ; enable dma for v-scroll
        sta     $46
        bra     @36b1
@3694:  lda     $3c
        clc
        adc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        and     #$007f
        sta     $5e
        lda     $5a
        lsr3
        and     #$007e                  ; enable dma for v-scroll
        sta     $46
@36b1:  lda     $5c
        asl3
        and     #$3f80
        tay
        lda     #$0040
        sta     $66
@36bf:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        shorta
        lda     $6f50,y
        sta     $6e50,x
        lda     $6f51,y
        sta     $6ed0,x
        lda     $6f52,y
        sta     $6e51,x
        lda     $6f53,y
        sta     $6ed1,x
        longa
        pla
        clc
        adc     #$0080
        and     #$3f80
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @36bf
@36f8:  plb
        rts

; ------------------------------------------------------------------------------

; [ load full tilemap (init) ]

; 128x128 map (serpent trench)
; note that the serpent trench is 128x128 in 16x16 tiles, but vram can only
; hold 128x128 8x8 tiles in mode 7, so only 1/4 of the map is loaded here

InitTilemap128:
@36fa:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $38
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5c
        asl3
        and     #$3f80
        sta     $5e
        asl
        and     #$3f00
        sta     $6a
        lda     $34
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5a
        lsr3
        and     #$007e
        ora     $6a
        tax
        lda     $5a
        lsr4
        and     #$007f
        tay
        lda     #$0040                  ; 64 16x16 columns
        sta     $66
@3745:  lda     #$0040                  ; 64 16x16 rows
        sta     $68
@374a:  lda     [$5e],y                 ; tile id
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y                 ; top two 8x8 tiles
        sta     $2000,x
        lda     $6f52,y                 ; bottom two 8x8 tiles
        sta     $2080,x
        pla
        inc
        and     #$007f
        tay
        txa
        inc2
        and     #$3f7f
        tax
        dec     $68
        bne     @374a
        tya
        sec
        sbc     #$0040
        and     #$007f
        tay
        txa
        clc
        adc     #$0100
        and     #$3f7f
        tax
        lda     $5e
        adc     #$0080
        and     #$3f80
        sta     $5e
        dec     $66
        bne     @3745
        plb
        stz     hVMAINC
        stz     hVMADDL
        lda     #$1800
        sta     $4300
        lda     #$2000
        sta     $4302
        lda     #$007e
        sta     $4304
        lda     #$4000                  ; transfer $4000 bytes
        sta     $4305
        lda     #$0100
        sta     hMDMAEN-1               ; also clears hVTIMEH
        rts

; ------------------------------------------------------------------------------
