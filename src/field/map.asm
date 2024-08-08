; ------------------------------------------------------------------------------

.include "gfx/map_gfx.inc"
.include "gfx/map_gfx_bg3.inc"
.include "gfx/map_pal.inc"

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ calculate bg scroll positions ]

InitScrollPos:
@1b7b:  longa
        lda     $0541       ; bg1 scroll position
        and     #$00ff
        sec
        sbc     #$0007
        asl4
        sta     $5c
        lda     $0542
        and     #$00ff
        sec
        sbc     #$0007
        asl4
        sta     $60
        shorta0
        lda     $0553
        sta     hWRMPYA
        lda     $0541
        sta     hWRMPYB
        lda     $88
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0532
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $88
        sta     $0543
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $64
        shorta0
        lda     $0554
        sta     hWRMPYA
        lda     $0542
        sta     hWRMPYB
        lda     $89
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0533
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $89
        sta     $0544
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $68
        shorta0
        lda     $0555
        sta     hWRMPYA
        lda     $0541
        sta     hWRMPYB
        lda     $8a
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0534
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $8a
        sta     $0545
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $6c
        shorta0
        lda     $0556
        sta     hWRMPYA
        lda     $0542
        sta     hWRMPYB
        lda     $8b
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0535
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $8b
        sta     $0546
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $70
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load map properties ]

LoadMapProp:
@1cad:  longa
        lda     $82         ; map index
        asl5                ; multiply by 33
        clc
        adc     $82
        tax
        shorta0
        ldy     $00
@1cbf:  lda     f:MapProp,x   ; map properties
        sta     $0520,y
        inx
        iny
        cpy     #33
        bne     @1cbf
        rts

; ------------------------------------------------------------------------------

.pushseg
.segment "map_prop"

; ed/8f00
MapProp:
        fixed_block $3580
        .incbin "map_prop.dat"
        end_fixed_block

.popseg

; ------------------------------------------------------------------------------

; [ load tile properties ]

LoadTileProp:
@1cce:  lda     $0524
        asl
        tax
        longa_clc
        lda     f:MapTilePropPtrs,x
        adc     #.loword(MapTileProp)
        sta     $f3
        shorta0
        lda     #^MapTileProp
        sta     $f5
        ldx     #$7600
        stx     $f6
        lda     #$7e
        sta     $f8
        jsl     Decompress
        rts

; ------------------------------------------------------------------------------

; [ copy bg1 map to vram (top half) ]

TfrBG1TopTiles:
@1cf3:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $91
        stx     hVMADDL
        lda     #$41
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$d9c0
        stx     hDMA0::ADDR
        lda     #$7f
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B           ; not needed for normal DMA
        ldx     #$0400
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg1 map to vram (bottom half) ]

TfrBG1BtmTiles:
@1d24:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        longa
        lda     a:$0091
        clc
        adc     #$0200
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$ddc0
        stx     hDMA0::ADDR
        lda     #$7f
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B           ; not needed for normal DMA
        ldx     #$0400
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg2 map to vram (top half) ]

TfrBG2TopTiles:
@1d5f:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $97
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e1c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg2 map to vram (bottom half) ]

TfrBG2BtmTiles:
@1d90:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        longa
        lda     a:$0097
        clc
        adc     #$0200
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e5c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg3 map to vram (top half) ]

TfrBG3TopTiles:
@1dcb:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $9d
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e9c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg3 map to vram (bottom half) ]

TfrBG3BtmTiles:
@1dfc:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        longa
        lda     a:$009d
        clc
        adc     #$0200
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$edc0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy map changes to vram ]

TfrMapTiles:
@1e37:  lda     $055a       ; bg1 map data update status
        beq     @1e59       ; skip if not 1 or 2
        cmp     #$03
        bcs     @1e59
        dec
        bne     @1e51       ; branch if 2
        jsr     TfrBG1BtmTiles
        lda     $5a
        ora     #$01        ; enable bg1 map flip
        sta     $5a
        stz     $055a
        bra     @1e9b
@1e51:  jsr     TfrBG1TopTiles
        dec     $055a
        bra     @1e9b
@1e59:  lda     $055b
        beq     @1e7b
        cmp     #$03
        bcs     @1e7b
        dec
        bne     @1e73
        jsr     TfrBG2BtmTiles
        lda     $5a
        ora     #$02
        sta     $5a
        stz     $055b
        bra     @1e9b
@1e73:  jsr     TfrBG2TopTiles
        dec     $055b
        bra     @1e9b
@1e7b:  lda     $055c
        beq     @1e9b
        cmp     #$03
        bcs     @1e9b
        dec
        bne     @1e95
        jsr     TfrBG3BtmTiles
        lda     $5a
        ora     #$04
        sta     $5a
        stz     $055c
        bra     @1e9b
@1e95:  jsr     TfrBG3TopTiles
        dec     $055c
@1e9b:  lda     $055a       ; return if no maps need to be flipped
        ora     $055b
        ora     $055c
        bne     @1ec3
        lda     $5a
        and     #$01
        beq     @1eaf
        jsr     FlipBG1
@1eaf:  lda     $5a
        and     #$02
        beq     @1eb8
        jsr     FlipBG2
@1eb8:  lda     $5a
        and     #$04
        beq     @1ec1
        jsr     FlipBG3
@1ec1:  stz     $5a
@1ec3:  rts

; ------------------------------------------------------------------------------

; [ change map data ]

;  +$2a = pointer to map data ($0000 for bg1, $4000 for bg2, $8000 for bg3)
;  +$8f = destination offset (+$7f0000)
; ++$8c = source pointer (source format: width [1 byte], height [1 byte], tile data [1 byte each])

ModifyMap:
@1ec4:  lda     #$7f
        sta     $2f         ; ++$2d = destination
        lda     $8f
        sta     $2a
        lda     $90
        clc
        adc     $2b
        sta     $2b
        sta     $2e
        ldy     $00
        lda     [$8c],y     ; +$26 = width
        sta     $26
        stz     $27
        iny
        lda     [$8c],y     ; $28 = height
        sta     $28
        sta     $29
        iny
@1ee5:  ldx     $26         ; copy tile data
        lda     $2a
        sta     $2d
@1eeb:  lda     [$8c],y
        sta     [$2d]
        iny                 ; next tile
        inc     $2d
        dex
        bne     @1eeb
        inc     $2e         ; next row
        dec     $29
        bne     @1ee5
        longa
        lda     $2a
        and     #$3fff
        sta     $2a
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update bg1 map changes ]

;  $1b = x tile counter (16 tiles per line)
; +$1e = pointer to bg1 map (+$7fd9c0)
;  $20 = x start tile
;  $28 = y tile counter (8 lines per frame)
; +$2a = pointer to bg1 map data (+$7f0000)

UpdateBG1:
@1f08:  lda     $055a       ; return unless waiting for update in ram
        cmp     #$05
        beq     @1f13
        cmp     #$03
        bcs     @1f14
@1f13:  rts
@1f14:  cmp     #$04
        bne     @1f20
        lda     $0542       ; bg1 map update status = 04: top half
        sec
        sbc     #$07        ; bg1 center (y - 7)
        bra     @1f24
@1f20:  lda     $0542       ; bg1 map update status = 03: bottom half
        inc                 ; bg1 center (y + 1)
@1f24:  and     $87         ; bg1 vertical clip
        sta     $2b
        lda     $0541
        sec
        sbc     #$07        ; bg1 center (x - 7)
        and     $86         ; bg1 horizontal clip
        sta     $2a
        sta     $20         ; x start
        lda     $058c       ; flip map data in vram
        eor     #$04
        sta     $92
        stz     $91
        shorta0
        lda     $2a         ;
        and     #$0f
        asl2
        sta     $1e
        stz     $1f
        lda     $2b
        and     #$0f
        xba
        longa
        lsr
        ora     $1e
        sta     $1e
        shorta0
        lda     #$08        ; set y tile counter to 8
        sta     $28
        lda     #$7f
        pha
        plb
@1f61:  lda     #$10        ; set x tile counter to 16
        sta     $1b
        ldy     $1e
        lda     $20
        sta     $2a
@1f6b:  lda     ($2a)       ; get tile index
        longa
        asl
        tax
        lda     $c000,x     ; copy bg1 tile formation to bg1 map
        sta     $d9c0,y
        lda     $c200,x
        sta     $d9c2,y
        lda     $c400,x
        sta     $da00,y
        lda     $c600,x
        sta     $da02,y
        tya
        clc
        adc     #$0004
        and     #$ffbf
        tay
        shorta0
        lda     $2a         ; increment pointer to map data (x)
        inc
        and     $86         ; bg1 horizontal mask
        sta     $2a
        dec     $1b         ; decrement x tile counter
        bne     @1f6b       ; next tile
        lda     $2b         ; increment pointer to map data (y)
        inc
        and     $87         ; bg1 vertical mask
        sta     $2b
        longa_clc
        lda     $1e         ; increment pointer to map (y)
        adc     #$0080
        and     #$07ff
        sta     $1e
        shorta0
        dec     $28         ; decrement y tile counter
        bne     @1f61       ; next line
        lda     #$00
        pha
        plb
        dec     $055a       ; decrement bg1 map update status
        rts

; ------------------------------------------------------------------------------

; [ update bg2 map changes ]

UpdateBG2:
@1fc2:  lda     $055b
        cmp     #$05
        beq     @1fcd
        cmp     #$03
        bcs     @1fce
@1fcd:  rts
@1fce:  cmp     #$04
        bne     @1fda
        lda     $0544
        sec
        sbc     #$07
        bra     @1fde
@1fda:  lda     $0544
        inc
@1fde:  and     $89
        clc
        adc     #$40
        sta     $2b
        lda     $0543
        sec
        sbc     #$07
        and     $88
        sta     $2a
        sta     $20
        lda     $058e
        eor     #$04
        sta     $98
        stz     $97
        shorta0
        lda     $2a
        and     #$0f
        asl2
        sta     $1e
        stz     $1f
        lda     $2b
        and     #$0f
        xba
        longa
        lsr
        ora     $1e
        sta     $1e
        shorta0
        lda     #$08
        sta     $28
        lda     #$7f
        pha
        plb
@201e:  lda     #$10
        sta     $1b
        ldy     $1e
        lda     $20
        sta     $2a
@2028:  lda     ($2a)
        longa
        asl
        tax
        lda     $c800,x
        sta     $e1c0,y
        lda     $ca00,x
        sta     $e1c2,y
        lda     $cc00,x
        sta     $e200,y
        lda     $ce00,x
        sta     $e202,y
        tya
        clc
        adc     #$0004
        and     #$ffbf
        tay
        shorta0
        lda     $2a
        inc
        and     $88
        sta     $2a
        dec     $1b
        bne     @2028
        lda     $2b
        inc
        and     $89
        ora     #$40
        sta     $2b
        longa_clc
        lda     $1e
        adc     #$0080
        and     #$07ff
        sta     $1e
        shorta0
        dec     $28
        bne     @201e
        lda     #$00
        pha
        plb
        dec     $055b
        rts

; ------------------------------------------------------------------------------

; [ update bg3 map changes ]

UpdateBG3:
@2081:  lda     $055c
        cmp     #$05
        beq     @208c
        cmp     #$03
        bcs     @208d
@208c:  rts
@208d:  cmp     #$04
        bne     @2099
        lda     $0546
        sec
        sbc     #$07
        bra     @209d
@2099:  lda     $0546
        inc
@209d:  and     $8b
        clc
        sta     $2b
        lda     $0545
        sec
        sbc     #$07
        and     $8a
        sta     $2a
        sta     $24
        lda     $0590
        eor     #$04
        sta     $9e
        stz     $9d
        shorta0
        lda     $2a
        and     #$0f
        asl2
        sta     $1e
        stz     $1f
        lda     $2b
        and     #$0f
        xba
        longa
        lsr
        ora     $1e
        sta     $1e
        shorta0
        lda     #$08
        sta     $28
@20d7:  lda     #$10
        sta     $1b
        ldy     $1e
        lda     $24
        sta     $2a
        jsr     _c0249a
        lda     $2b
        inc
        and     $8b
        sta     $2b
        longa_clc
        lda     $1e
        adc     #$0080
        and     #$07ff
        sta     $1e
        shorta0
        dec     $28
        bne     @20d7
        dec     $055c
        rts

; ------------------------------------------------------------------------------

; [ update bg for scrolling ]

UpdateScroll:
@2102:  lda     $0589       ; bg3 vertical scroll
        cmp     #$01
        bne     @2111
        jsr     UpdateBG3VScroll
        inc     $0589
        bra     @211e
@2111:  lda     $058a       ; bg3 horizontal scroll
        cmp     #$01
        bne     @211e
        jsr     UpdateBG3HScroll
        inc     $058a
@211e:  lda     $0586       ; bg1 horizontal scroll
        cmp     #$01
        bne     @212b
        jsr     UpdateBG1HScroll
        inc     $0586
@212b:  lda     $0588       ; bg2 horizontal scroll
        cmp     #$01
        bne     @2139
        jsr     UpdateBG2HScroll
        inc     $0588
        rts
@2139:  lda     $0585       ; bg1 vertical scroll
        cmp     #$01
        bne     @2146
        jsr     UpdateBG1VScroll
        inc     $0585
@2146:  lda     $0587       ; bg2 vertical scroll
        cmp     #$01
        bne     @2153
        jsr     UpdateBG2VScroll
        inc     $0587
@2153:  rts

; ------------------------------------------------------------------------------

; [ update bg1 for scrolling (vertical) ]

UpdateBG1VScroll:
@2154:  longa_clc
        lda     $75
        adc     $0549
        bmi     _2168

InitBG1VScroll:
@215d:  shorta0
        lda     $0542
        clc
        adc     #$08
        bra     _2171

_2168:  shorta0
        lda     $0542
        sec
        sbc     #$07
_2171:  and     $87
        clc
        adc     #$00
        sta     $2b
        and     #$0f
        longa
        xba
        lsr2
        clc
        adc     $058b
        sta     $91
        shorta0
        lda     $0541
        sec
        sbc     #$07
        and     $86
        sta     $2a
        lda     $2a
        and     #$0f
        asl2
        tay
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@21a3:  lda     ($2a)
        bmi     @21d9
        asl
        tax
        longa
        lda     $c000,x
        sta     $d9c0,y
        lda     $c200,x
        sta     $d9c2,y
        lda     $c400,x
        sta     $da00,y
        lda     $c600,x
        sta     $da02,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $86
        sta     $2a
        dec     $1b
        bne     @21a3
        bra     @2209
@21d9:  asl
        tax
        longa
        lda     $c100,x
        sta     $d9c0,y
        lda     $c300,x
        sta     $d9c2,y
        lda     $c500,x
        sta     $da00,y
        lda     $c700,x
        sta     $da02,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $86
        sta     $2a
        dec     $1b
        bne     @21a3
@2209:  lda     #$00
        pha
        plb
        longi
        rts

; ------------------------------------------------------------------------------

; [ update bg1 for scrolling (horizontal) ]

UpdateBG1HScroll:
@2210:  longa_clc
        lda     $73
        adc     $0547
        bmi     @2224
        shorta0
        lda     $0541
        clc
        adc     #$08
        bra     @222d
@2224:  shorta0
        lda     $0541
        sec
        sbc     #$07
@222d:  and     $86
        sta     $2a
        lda     $0542
        sec
        sbc     #$07
        and     $87
        clc
        adc     #$00
        sta     $2b
        and     #$0f
        asl2
        tay
        ldx     $2a
        stx     $2d
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@2251:  lda     ($2a)
        bmi     @2287
        asl
        tax
        longa
        lda     $c000,x
        sta     $d840,y
        lda     $c400,x
        sta     $d842,y
        lda     $c200,x
        sta     $d880,y
        lda     $c600,x
        sta     $d882,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $87
        sta     $2b
        dec     $1b
        bne     @2251
        bra     @22b7
@2287:  asl
        tax
        longa
        lda     $c100,x
        sta     $d840,y
        lda     $c500,x
        sta     $d842,y
        lda     $c300,x
        sta     $d880,y
        lda     $c700,x
        sta     $d882,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $87
        sta     $2b
        dec     $1b
        bne     @2251
@22b7:  longi
        lda     #$00
        pha
        plb
        lda     $2d
        and     #$0f
        asl
        sta     $93
        inc
        sta     $95
        lda     $058c
        sta     $94
        sta     $96
        rts

; ------------------------------------------------------------------------------

; [ update bg2 for scrolling (vertical) ]

UpdateBG2VScroll:
@22cf:  longa_clc
        lda     $79
        adc     $054d
        bmi     _22e3

InitBG2VScroll:
@22d8:  shorta0
        lda     $0544
        clc
        adc     #$08
        bra     _22ec

_22e3:  shorta0
        lda     $0544
        sec
        sbc     #$07
_22ec:  and     $89
        clc
        adc     #$40
        sta     $2b
        and     #$0f
        longa
        xba
        lsr2
        clc
        adc     $058d
        sta     $97
        shorta0
        lda     $0543
        sec
        sbc     #$07
        and     $88
        sta     $2a
        lda     $2a
        and     #$0f
        asl2
        tay
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@231e:  lda     ($2a)
        bmi     @2354
        asl
        tax
        longa
        lda     $c800,x
        sta     $e1c0,y
        lda     $ca00,x
        sta     $e1c2,y
        lda     $cc00,x
        sta     $e200,y
        lda     $ce00,x
        sta     $e202,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $88
        sta     $2a
        dec     $1b
        bne     @231e
        bra     @2384
@2354:  asl
        tax
        longa
        lda     $c900,x
        sta     $e1c0,y
        lda     $cb00,x
        sta     $e1c2,y
        lda     $cd00,x
        sta     $e200,y
        lda     $cf00,x
        sta     $e202,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $88
        sta     $2a
        dec     $1b
        bne     @231e
@2384:  lda     #$00
        pha
        plb
        longi
        rts

; ------------------------------------------------------------------------------

; [ update bg2 for scrolling (horizontal) ]

UpdateBG2HScroll:
@238b:  longa_clc
        lda     $77
        adc     $054b
        bmi     @239f
        shorta0
        lda     $0543
        clc
        adc     #$08
        bra     @23a8
@239f:  shorta0
        lda     $0543
        sec
        sbc     #$07
@23a8:  and     $88
        sta     $2a
        lda     $0544
        sec
        sbc     #$07
        and     $89
        clc
        adc     #$40
        sta     $2b
        and     #$0f
        asl2
        tay
        ldx     $2a
        stx     $2d
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@23cc:  lda     ($2a)
        bmi     @2404
        asl
        tax
        longa
        lda     $c800,x
        sta     $d8c0,y
        lda     $cc00,x
        sta     $d8c2,y
        lda     $ca00,x
        sta     $d900,y
        lda     $ce00,x
        sta     $d902,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $89
        ora     #$40
        sta     $2b
        dec     $1b
        bne     @23cc
        bra     @2436
@2404:  asl
        tax
        longa
        lda     $c900,x
        sta     $d8c0,y
        lda     $cd00,x
        sta     $d8c2,y
        lda     $cb00,x
        sta     $d900,y
        lda     $cf00,x
        sta     $d902,y
        tdc
        shorta_sec
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $89
        ora     #$40
        sta     $2b
        dec     $1b
        bne     @23cc
@2436:  longi
        lda     #$00
        pha
        plb
        lda     $2d
        and     #$0f
        asl
        sta     $99
        inc
        sta     $9b
        lda     $058e
        sta     $9a
        sta     $9c
        rts

; ------------------------------------------------------------------------------

; [ update bg3 for scrolling (vertical) ]

UpdateBG3VScroll:
@244e:  longa_clc
        lda     $7d
        adc     $0551
        bmi     _2466

InitBG3VScroll:
@2457:  shorta0
        lda     $0546
        clc
        adc     #$08
        and     $8b
        sta     $2b
        bra     _2473

_2466:  shorta0
        lda     $0546
        sec
        sbc     #$07
        and     $8b
        sta     $2b
_2473:  lda     $0545
        sec
        sbc     #$07
        and     $8a
        sta     $2a
        lda     $2b
        and     #$0f
        longa
        xba
        lsr2
        clc
        adc     $058f
        sta     $9d
        shorta0
        lda     $2a
        and     #$0f
        asl2
        tay
        jsr     _c0249a
        rts

; ------------------------------------------------------------------------------

; [ update two rows of bg3 map data ]

; common code for bg3 vertical scrolling and bg3 map changes
; +$2a = pointer to source bg3 map data (+$7f8000)
;    y = pointer to destination in bg3 map (+$7fe9c0)

_c0249a:
@249a:  lda     $0522       ; bg3 foreground
        and     #$80
        lsr2
        sta     $36        ; +$36 = tile flags
        stz     $37
        ldx     $2a
        stx     $2d
        lda     #$10
        sta     $1b         ; $1b = tile counter (16)
        lda     #$7f
        pha
        plb
@24b1:  ldx     $2a
        lda     $8000,x
        longa
        sta     $20
        and     #$003f      ; tile index
        tax
        lda     $20
        and     #$00c0      ; x/y flip
        ora     $36
        sta     $20         ; $20 = tile flags (w/ x/y flip)
        lda     $d000,x     ; bg3 tile formation
        and     #$001c      ; palette
        ora     $20
        xba
        sta     $22         ; +$22 = tile flags (w/ palette)
        and     #$c000
        cmp     #$4000      ; branch if horizontal flip only
        beq     @24fa
        cmp     #$8000      ; branch if vertical flip only
        beq     @2510
        cmp     #$c000      ; branch if horizontal and vertical flip
        beq     @2526
        txa
        asl2
        ora     $22
        sta     $e9c0,y     ; no flip
        inc
        sta     $e9c2,y
        inc
        sta     $ea00,y
        inc
        sta     $ea02,y
        bra     @253a
@24fa:  txa
        asl2
        ora     $22
        sta     $e9c2,y     ; horizontal flip
        inc
        sta     $e9c0,y
        inc
        sta     $ea02,y
        inc
        sta     $ea00,y
        bra     @253a
@2510:  txa
        asl2
        ora     $22
        sta     $ea00,y     ; vertical flip
        inc
        sta     $ea02,y
        inc
        sta     $e9c0,y
        inc
        sta     $e9c2,y
        bra     @253a
@2526:  txa
        asl2
        ora     $22
        sta     $ea02,y     ; horizontal and vertical flip
        inc
        sta     $ea00,y
        inc
        sta     $e9c2,y
        inc
        sta     $e9c0,y
@253a:  tya                 ; next tile
        inc3
        inc
        and     #$ffbf      ;
        tay
        shorta0
        lda     $2a
        inc
        and     $8a
        sta     $2a
        dec     $1b
        jne     @24b1
        lda     #$00
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ update bg3 for scrolling (horizontal) ]

UpdateBG3HScroll:
@2559:  longa_clc
        lda     $7b
        adc     $054f
        bmi     @2571
        shorta0
        lda     $0545
        clc
        adc     #$08
        and     $8a
        sta     $2a
        bra     @257e
@2571:  shorta0
        lda     $0545
        sec
        sbc     #$07
        and     $8a
        sta     $2a
@257e:  lda     $0546
        sec
        sbc     #$07
        and     $8b
        sta     $2b
        and     #$0f
        asl2
        tay
        lda     $0522
        and     #$80
        lsr2
        sta     $36
        stz     $37
        ldx     $2a
        stx     $2d
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@25a4:  ldx     $2a
        lda     $8000,x
        longa
        sta     $20
        and     #$003f
        tax
        lda     $20
        and     #$00c0
        ora     $36
        sta     $20
        lda     $d000,x
        and     #$001c
        ora     $20
        xba
        sta     $22
        and     #$c000
        cmp     #$4000
        beq     @25ed
        cmp     #$8000
        beq     @2603
        cmp     #$c000
        beq     @2619
        txa
        asl2
        ora     $22
        sta     $d940,y
        inc
        sta     $d980,y
        inc
        sta     $d942,y
        inc
        sta     $d982,y
        bra     @262d
@25ed:  txa
        asl2
        ora     $22
        sta     $d980,y
        inc
        sta     $d940,y
        inc
        sta     $d982,y
        inc
        sta     $d942,y
        bra     @262d
@2603:  txa
        asl2
        ora     $22
        sta     $d942,y
        inc
        sta     $d982,y
        inc
        sta     $d940,y
        inc
        sta     $d980,y
        bra     @262d
@2619:  txa
        asl2
        ora     $22
        sta     $d982,y
        inc
        sta     $d942,y
        inc
        sta     $d980,y
        inc
        sta     $d940,y
@262d:  shorta0
        lda     $2b
        inc
        and     $8b
        sta     $2b
        tya
        inc4
        and     #$3f
        tay
        dec     $1b
        jne     @25a4
        lda     #$00
        pha
        plb
        lda     $2d
        and     #$0f
        asl
        sta     $9f
        inc
        sta     $a1
        lda     $0590
        sta     $a0
        sta     $a2
        rts

; ------------------------------------------------------------------------------

; [ load map palette ]

LoadMapPal:
@265c:  lda     $0539
        longa
        xba
        tax
        shorta0
        lda     #$7e
        pha
        plb
        ldy     $00
@266c:  lda     f:MapPal,x
        sta     $7200,y
        sta     $7400,y
        inx
        iny
        cpy     #$0100
        bne     @266c
        stz     $7200
        stz     $7201
        stz     $7400
        stz     $7401
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load bg1/bg2 graphics ]

; each tileset copies $2000 bytes, but they overlap in vram,
; so only the first $1000 bytes is available for tilesets 2-4

LoadMapGfx:
@268d:  ldy     #$0000      ; first tileset, $2000 bytes -> vram $0000
        lda     $0527
        and     #$7f
        jsr     TfrBG12Gfx
        ldy     #$1000      ; second tileset, $1000 bytes -> vram $1000
        longa
        lda     $0527
        asl
        and     #$7f00
        xba
        shorta
        jsr     TfrBG12Gfx
        ldy     #$1800      ; third tileset, $1000 bytes -> vram $1800
        longa
        lda     $0528
        asl2
        and     #$7f00
        xba
        shorta
        sta     $1b         ; $1b = third tileset index
        jsr     TfrBG12Gfx
        ldy     #$2000      ; fourth tileset, $1000 bytes -> vram $2000
        longa
        lda     $0529
        asl3
        and     #$7f00
        xba
        shorta
        cmp     $1b         ; skip tileset 4 if it's the same as tileset 3
        beq     @26d7
        jsr     TfrBG12Gfx
@26d7:  rts

; ------------------------------------------------------------------------------

; [ copy bg1/bg2 graphics to vram ]

; a = tileset index
; y = vram destination address

TfrBG12Gfx:
@26d8:  sty     hVMADDL
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        longa
        lda     f:MapGfxPtrs,x   ; ++$2a = pointer to tileset
        clc
        adc     #.loword(MapGfx)
        sta     $2a
        sta     $4302
        shorta
        lda     f:MapGfxPtrs+2,x
        adc     #^MapGfx
        sta     $2c
        sta     $4304
        sta     $4307
        longa
        lda     $2a
        beq     @2750
        tdc                 ; check if tileset spans two banks
        sec
        sbc     $2a
        cmp     #$2000
        bcs     @2750
        sta     $4305       ; size in first bank
        sta     $1e
        lda     #$2000
        sec
        sbc     $1e         ; +$1e = remainder of tileset in the next bank
        sta     $1e
        shorta0
        lda     #$01        ; first bank dma
        sta     hMDMAEN
        lda     $2c         ; increment bank
        inc
        sta     $4304
        sta     $4307
        ldx     $00
        stx     $4302
        ldx     $1e         ; size is remainder of data
        stx     $4305
        lda     #$01        ; second bank dma
        sta     hMDMAEN
        rts
@2750:  tdc                 ; no overflow, only need one dma
        shorta
        ldx     #$2000      ; full size $2000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ load bg3 graphics ]

TfrBG3Gfx:
@275f:  longa
        lda     $052a
        lsr4
        and     #$003f
        shorta
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longa_clc
        lda     f:MapGfxBG3Ptrs,x
        adc     #.loword(MapGfxBG3)
        sta     $f3
        shorta0
        lda     #^MapGfxBG3
        sta     $f5
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        lda     #$7f
        pha
        plb
        ldx     $00
@2799:  lda     $d040,x
        sta     $d000,x
        inx
        cpx     #$0040
        bne     @2799
        tdc
        pha
        plb
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$3000      ; destination = $3000 (vram)
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$d080      ; source = $7fd080
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$1000      ; size = $1000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ load map tileset ]

LoadTileset:
@27da:  longa
        lda     $052b
        lsr2
        and     #$007f
        shorta
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longa_clc
        lda     f:MapTilesetPtrs,x   ; pointers to tilesets
        adc     #.loword(MapTileset)
        sta     $f3
        shorta0
        lda     f:MapTilesetPtrs+2,x   ; bank byte
        adc     #^MapTileset
        sta     $f5
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$c000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     $00
@281d:  lda     $7fd040,x
        sta     hWMDATA
        lda     $7fd440,x
        sta     hWMDATA
        inx
        cpx     #$0400
        bne     @281d
        lda     $052c
        lsr
        and     #$7f
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longa_clc
        lda     f:MapTilesetPtrs,x
        adc     #.loword(MapTileset)
        sta     $f3
        shorta0
        lda     f:MapTilesetPtrs+2,x
        adc     #^MapTileset
        sta     $f5
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$c800
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     $00
@286e:  lda     $7fd040,x
        sta     hWMDATA
        lda     $7fd440,x
        sta     hWMDATA
        inx
        cpx     #$0400
        bne     @286e
        rts

; ------------------------------------------------------------------------------

; [ load map data ]

LoadMapTiles:
@2883:  longa
        lda     $052d       ; bg1 layout
        and     #$03ff
        sta     $1e
        asl
        clc
        adc     $1e
        tax
        lda     f:SubTilemapPtrs,x
        clc
        adc     #.loword(SubTilemap)
        sta     $f3
        shorta0
        lda     f:SubTilemapPtrs+2,x
        adc     #^SubTilemap
        sta     $f5
        cpx     $00
        beq     @28c2       ; branch if layout index is zero
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$0000
        lda     $86
        jsr     CopyMapTiles
        bra     @28d6
@28c2:  ldx     #$0000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     #$4000
@28d0:  stz     hWMDATA
        dex
        bne     @28d0
@28d6:  longa
        lda     $052e       ; bg2 layout
        lsr
        and     #$07fe
        sta     $1e
        lsr
        clc
        adc     $1e
        tax
        lda     f:SubTilemapPtrs,x
        clc
        adc     #.loword(SubTilemap)
        sta     $f3
        shorta0
        lda     f:SubTilemapPtrs+2,x
        adc     #^SubTilemap
        sta     $f5
        cpx     $00
        beq     @2916       ; branch if layout index is zero
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$4000
        lda     $88
        jsr     CopyMapTiles
        bra     @292a
@2916:  ldx     #$4000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     #$4000
@2924:  stz     hWMDATA
        dex
        bne     @2924
@292a:  longa
        lda     $052f       ; bg3 layout
        lsr3
        and     #$07fe
        sta     $1e
        lsr
        clc
        adc     $1e
        tax
        lda     f:SubTilemapPtrs,x
        clc
        adc     #.loword(SubTilemap)
        sta     $f3
        shorta0
        lda     f:SubTilemapPtrs+2,x
        adc     #^SubTilemap
        sta     $f5
        cpx     $00
        beq     @296b       ; branch if layout index is zero
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$8000
        lda     $8a
        jsr     CopyMapTiles
        rts
@296b:  ldx     #$8000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     #$4000
@2979:  stz     hWMDATA
        dex
        bne     @2979
        rts

; ------------------------------------------------------------------------------

; [ copy bg map data to buffer ]

; A: horizontal clip

CopyMapTiles:
@2980:  cmp     #$0f
        jeq     @29f5
        cmp     #$1f
        jeq     @29cc
        cmp     #$3f
        jeq     @29a3
        jmp     @2a1e
@2998:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@29a3:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@29ae:  tdc
        ldy     #$0040
@29b2:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @29b2
        longa_clc
        txa
        adc     #$00c0
        tax
        xba
        shorta
        and     #$3f
        bne     @29ae
        rts
@29cc:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@29d7:  tdc
        ldy     #$0020
@29db:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @29db
        longa_clc
        txa
        adc     #$00e0
        tax
        xba
        shorta
        and     #$3f
        bne     @29d7
        rts
@29f5:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@2a00:  tdc
        ldy     #$0010
@2a04:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @2a04
        longa_clc
        txa
        adc     #$00f0
        tax
        xba
        shorta
        and     #$3f
        bne     @2a00
        rts
@2a1e:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@2a29:  tdc
        ldy     #$0080
@2a2d:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @2a2d
        longa_clc
        txa
        adc     #$0080
        tax
        xba
        shorta
        and     #$3f
        bne     @2a29
        rts

; ------------------------------------------------------------------------------

; [ update bg1 map data in vram (vertical scroll) ]

TfrBG1TilesVScroll:
@2a47:  stz     hMDMAEN
        lda     #$80        ; vram address increments horizontally
        sta     hVMAINC
        ldx     $91
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$d9c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg1 map data in vram (horizontal scroll) ]

TfrBG1TilesHScroll:
@2a78:  stz     hMDMAEN
        lda     #$81        ; vram address increments vertically
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     $93
        stx     hVMADDL
        ldx     #$d840
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        ldx     $95
        stx     hVMADDL
        ldx     #$d880
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg2 map data in vram (vertical scroll) ]

TfrBG2TilesVScroll:
@2aca:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $97
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e1c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg2 map data in vram (horizontal scroll) ]

TfrBG2TilesHScroll:
@2afb:  stz     hMDMAEN
        lda     #$81
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     $99
        stx     hVMADDL
        ldx     #$d8c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        ldx     $9b
        stx     hVMADDL
        ldx     #$d900
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg3 map data in vram (vertical scroll) ]

TfrBG3TilesVScroll:
@2b4d:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $9d
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e9c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg3 map data in vram (horizontal scroll) ]

TfrBG3TilesHScroll:
@2b7e:  stz     hMDMAEN
        lda     #$81
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     $9f
        stx     hVMADDL
        ldx     #$d940
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        ldx     $a1
        stx     hVMADDL
        ldx     #$d980
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update scroll position ]

CalcScrollPos:
@2bd0:  longa
        shorti
        ldy     #$01
        lda     $73
        clc
        adc     $0547
        sta     $1e
        beq     @2c2e
        bmi     @2c08
        lda     $5b
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2bf9
        sty     $0586
        ldx     $0541
        inx
        stx     $0541
@2bf9:  lda     $5b
        clc
        adc     $1e
        sta     $5b
        lda     $5d
        adc     $00
        sta     $5d
        bra     @2c2e
@2c08:  eor     $02
        inc
        sta     $1e
        lda     $5b
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2c21
        sty     $0586
        ldx     $0541
        dex
        stx     $0541
@2c21:  lda     $5b
        sec
        sbc     $1e
        sta     $5b
        lda     $5d
        sbc     $00
        sta     $5d
@2c2e:  lda     $75
        clc
        adc     $0549
        sta     $1e
        bmi     @2c5e
        lda     $5f
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2c4f
        sty     $0585
        ldx     $0542
        inx
        stx     $0542
@2c4f:  lda     $5f
        clc
        adc     $1e
        sta     $5f
        lda     $61
        adc     $00
        sta     $61
        bra     @2c84
@2c5e:  eor     $02
        inc
        sta     $1e
        lda     $5f
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2c77
        sty     $0585
        ldx     $0542
        dex
        stx     $0542
@2c77:  lda     $5f
        sec
        sbc     $1e
        sta     $5f
        lda     $61
        sbc     $00
        sta     $61
@2c84:  lda     $77
        clc
        adc     $054b
        sta     $1e
        beq     @2cdc
        bmi     @2cb6
        lda     $63
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2ca7
        sty     $0588
        ldx     $0543
        inx
        stx     $0543
@2ca7:  lda     $63
        clc
        adc     $1e
        sta     $63
        lda     $65
        adc     $00
        sta     $65
        bra     @2cdc
@2cb6:  eor     $02
        inc
        sta     $1e
        lda     $63
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2ccf
        sty     $0588
        ldx     $0543
        dex
        stx     $0543
@2ccf:  lda     $63
        sec
        sbc     $1e
        sta     $63
        lda     $65
        sbc     $00
        sta     $65
@2cdc:  lda     $79
        clc
        adc     $054d
        sta     $1e
        bmi     @2d0c
        lda     $67
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2cfd
        sty     $0587
        ldx     $0544
        inx
        stx     $0544
@2cfd:  lda     $67
        clc
        adc     $1e
        sta     $67
        lda     $69
        adc     $00
        sta     $69
        bra     @2d32
@2d0c:  eor     $02
        inc
        sta     $1e
        lda     $67
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2d25
        sty     $0587
        ldx     $0544
        dex
        stx     $0544
@2d25:  lda     $67
        sec
        sbc     $1e
        sta     $67
        lda     $69
        sbc     $00
        sta     $69
@2d32:  lda     $7b
        clc
        adc     $054f
        sta     $1e
        beq     @2d8a
        bmi     @2d64
        lda     $6b
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2d55
        sty     $058a
        ldx     $0545
        inx
        stx     $0545
@2d55:  lda     $6b
        clc
        adc     $1e
        sta     $6b
        lda     $6d
        adc     $00
        sta     $6d
        bra     @2d8a
@2d64:  eor     $02
        inc
        sta     $1e
        lda     $6b
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2d7d
        sty     $058a
        ldx     $0545
        dex
        stx     $0545
@2d7d:  lda     $6b
        sec
        sbc     $1e
        sta     $6b
        lda     $6d
        sbc     $00
        sta     $6d
@2d8a:  lda     $7d
        clc
        adc     $0551
        sta     $1e
        bmi     @2dba
        lda     $6f
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2dab
        sty     $0589
        ldx     $0546
        inx
        stx     $0546
@2dab:  lda     $6f
        clc
        adc     $1e
        sta     $6f
        lda     $71
        adc     $00
        sta     $71
        bra     @2de0
@2dba:  eor     $02
        inc
        sta     $1e
        lda     $6f
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2dd3
        sty     $0589
        ldx     $0546
        dex
        stx     $0546
@2dd3:  lda     $6f
        sec
        sbc     $1e
        sta     $6f
        lda     $71
        sbc     $00
        sta     $71
@2de0:  longi
        shorta0
        rts

; ------------------------------------------------------------------------------
