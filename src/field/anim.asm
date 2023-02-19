
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: anim.asm                                                             |
; |                                                                            |
; | description: bg animation routines                                         |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.include "assets/map_bg_anim_prop.inc"
.include "assets/map_bg3_anim_prop.inc"
.include "assets/map_pal_anim_prop.inc"

; ------------------------------------------------------------------------------

; [ init palette animation ]

InitPalAnim:
@8d17:  lda     $053a
        bne     @8d1d
        rts
@8d1d:  dec
        sta     hWRMPYA
        lda     #12
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
@8d2e:  lda     f:MapPalAnimProp,x
        sta     $10ea,y
        lda     f:MapPalAnimProp+1,x
        sta     $10e8,y
        lda     f:MapPalAnimProp+2,x
        sta     $10eb,y
        lda     f:MapPalAnimProp+3,x
        sta     $10ec,y
        lda     f:MapPalAnimProp+4,x
        sta     $10ed,y
        lda     f:MapPalAnimProp+5,x
        sta     $10ee,y
        lda     #$00
        sta     $10e7,y
        sta     $10e9,y
        longa_clc
        txa
        adc     #6
        tax
        shorta0
        tya
        clc
        adc     #8
        tay
        cmp     #16
        bne     @8d2e
        rts

; ------------------------------------------------------------------------------

; [ update palette animation ]

UpdatePalAnim:
@8d74:  lda     $053a                   ; palette animation index
        beq     @8dc7
        ldy     $00
@8d7b:  lda     $10ea,y                 ; palette animation type
        bmi     @8dbb
        and     #$f0
        lsr4
        bne     @8d92

; 0 (counter only)
        jsr     IncPalAnimCounter
        cmp     #0
        bne     @8dbb                   ; branch if no reset
        jmp     @8dbb                   ; branch anyway
@8d92:  dec
        bne     @8da2

; 1 (cycle)
        jsr     IncPalAnimCounter
        cmp     #0
        bne     @8dbb
        jsr     UpdatePalAnimCycle
        jmp     @8dbb

; 2 (rom)
@8da2:  dec
        bne     @8db0
        jsr     IncPalAnimCounter
        phy
        jsr     LoadPalAnimColors
        ply
        jmp     @8dbb
@8db0:  dec
        bne     @8dbb

; 3 (pulse)
        jsr     IncPalAnimCounter
        phy
        jsr     UpdatePalAnimPulse
        ply
@8dbb:  tya
        clc
        adc     #8
        tay
        cmp     #16
        jne     @8d7b
@8dc7:  rts

; ------------------------------------------------------------------------------

; [ update palette animation counters ]

IncPalAnimCounter:
@8dc8:  lda     $10e7,y                 ; increment frame counter
        inc
        sta     $10e7,y
        cmp     $10e8,y
        bne     @8def
        lda     #$00
        sta     $10e7,y
        lda     $10e9,y                 ; increment color counter
        inc
        sta     $10e9,y
        lda     $10ea,y
        and     #$0f
        cmp     $10e9,y
        bne     @8def
        tdc                             ; return 0 for reset
        sta     $10e9,y
        rts
@8def:  lda     #1                      ; return 1 for no reset
        rts

; ------------------------------------------------------------------------------

_c08df2:
@8df2:  .byte   $70,$80,$90,$a0,$b0,$c0,$d0,$e0,$f0
        .byte   $e0,$d0,$c0,$b0,$a0,$90,$80,$70,$60

; ------------------------------------------------------------------------------

; [ update palette animation (pulse) ]

UpdatePalAnimPulse:
@8e04:  lda     $10e9,y
        tax
        lda     f:_c08df2,x
        sta     hWRMPYA
        lda     $10eb,y
        tax
        lda     $10ec,y
        inc2
        tay
@8e19:  lda     $7e7200,x
        and     #$1f
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        and     #$1f
        sta     $1e
        lda     $7e7201,x
        and     #$7c
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        and     #$7c
        sta     $1f
        longa
        lda     $7e7200,x
        and     #$03e0
        lsr2
        shorta
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        and     #$f8
        longa
        asl2
        ora     $1e
        sta     $7e7400,x
        shorta0
        inx2
        dey2
        bne     @8e19
        rts

; ------------------------------------------------------------------------------

; [ load colors from ROM for palette animation ]

LoadPalAnimColors:
@8e6b:  lda     $10eb,y
        clc
        adc     #$00
        sta     $2a
        lda     #$74
        sta     $2b
        lda     #$7e
        sta     $2c
        lda     $10e9,y
        longa
        asl5
        clc
        adc     $10ed,y                 ; rom color offset
        tax
        shorta0
        lda     $10ec,y
        tay
        iny2
        longa
@8e95:  lda     f:MapPalAnimColors,x    ; palette animation color palette
        sta     [$2a]
        inc     $2a
        inc     $2a
        inx2
        dey2
        bne     @8e95
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update palette animation (cycle) ]

UpdatePalAnimCycle:
@8ea9:  lda     $10eb,y
        tax
        clc
        adc     $10ec,y
        sta     $20
        stz     $21
        longa
        lda     $7e7400,x
        sta     $1e
@8ebd:  lda     $7e7402,x
        sta     $7e7400,x
        inx2
        cpx     $20
        bne     @8ebd
        lda     $1e
        sta     $7e7400,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init bg animation ]

InitBGAnim:
@8ed5:  jsr     InitBG12Anim
        jsr     InitBG3Anim
        rts

; ------------------------------------------------------------------------------

; [ init bg1/bg2 animation ]

InitBG12Anim:
@8edc:  lda     $053b                   ; bg1/bg2 animation index
        and     #$1f
        asl
        tax
        longa
        lda     f:MapBGAnimPropPtrs,x
        tax
        shorta0
        ldy     $00
@8eef:  lda     #$e6
        sta     $106d,y                 ; graphics bank = $e6
        longa_clc
        tdc
        sta     $1069,y                 ; clear animation counter
        lda     f:MapBGAnimProp,x       ; animation speed
        sta     $106b,y
        lda     f:MapBGAnimProp+2,x     ; frame 1 pointer
        sta     $106e,y
        lda     f:MapBGAnimProp+4,x     ; frame 2 pointer
        sta     $1070,y
        lda     f:MapBGAnimProp+6,x     ; frame 3 pointer
        sta     $1072,y
        lda     f:MapBGAnimProp+8,x     ; frame 4 pointer
        sta     $1074,y
        txa
        adc     #10                     ; next tile (8 tiles total)
        tax
        tya
        adc     #13
        tay
        shorta0
        cpy     #13*8
        bne     @8eef
        lda     #$10                    ; $1a = tile counter (16 tiles, last 8 don't get animated)
        sta     $1a
        ldy     #$9f00                  ; destination address = $7e9f00
        sty     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     $053b                   ; bg1/bg2 animation index
        and     #$1f
        asl
        tax
        longa
        lda     f:MapBGAnimPropPtrs,x
        tay
        shorta0
@8f4f:  tyx
        longa_clc
        lda     f:MapBGAnimProp+2,x     ; frame 1 pointer
        tax
        shorta0
        lda     #$80                    ; $1b = tile graphics counter (4 frames per tile, 32 bytes per frame)
        sta     $1b
@8f5e:  lda     f:MapAnimGfx,x          ; copy tile graphics to ram
        sta     hWMDATA
        inx
        dec     $1b
        bne     @8f5e
        longa
        tya
        clc
        adc     #10
        tay
        shorta0
        dec     $1a
        bne     @8f4f
        stz     hHDMAEN                 ; dma graphics to vram
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$2800                  ; destination = $2800 vram
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$9f00                  ; source = $7e9f00
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0800                  ; size = $0800
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ init bg3 animation ]

InitBG3Anim:
@8fb1:  lda     $053b                   ; bg3 animation index
        and     #$e0
        lsr5
        bne     @8fbe                   ; return if not valid
        rts
@8fbe:  dec
        tay
        asl
        tax
        longa
        lda     f:MapBG3AnimPropPtrs,x
        tax
        tdc
        sta     $10d1                   ; clear animation counter
        lda     f:MapBG3AnimProp,x      ; animation speed
        sta     $10d3
        lda     f:MapBG3AnimProp+2,x    ; size
        sta     $10d5
        lda     f:MapBG3AnimProp+4,x    ; frame 1 pointer
        sta     $10d7
        lda     f:MapBG3AnimProp+6,x    ; frame 2 pointer
        sta     $10d9
        lda     f:MapBG3AnimProp+8,x    ; frame 3 pointer
        sta     $10db
        lda     f:MapBG3AnimProp+10,x   ; frame 4 pointer
        sta     $10dd
        lda     f:MapBG3AnimProp+12,x   ; frame 5 pointer
        sta     $10df
        lda     f:MapBG3AnimProp+14,x   ; frame 6 pointer
        sta     $10e1
        lda     f:MapBG3AnimProp+16,x   ; frame 7 pointer
        sta     $10e3
        lda     f:MapBG3AnimProp+18,x   ; frame 8 pointer
        sta     $10e5
        shorta0
        tya
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longa_clc
        lda     f:MapAnimGfxBG3Ptrs,x
        clc
        adc     #.loword(MapAnimGfxBG3)
        sta     $f3
        shorta0
        lda     #^MapAnimGfxBG3
        sta     $f5
        ldx     #$bf00                  ; destination = $7ebf00
        stx     $f6
        lda     #$7e
        sta     $f8
        jsl     Decompress
        rts

; ------------------------------------------------------------------------------

; [ copy bg1/bg2 animation graphics to vram ]

; called every other frame during irq (30hz)

TfrBGAnimGfx:
@903f:  lda     $053b
        bne     @9050
        ldx     #8
@9047:  dex
        bne     @9047
        lda     #$80
        sta     hINIDISP
        rts
@9050:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$2800
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$1000                  ; nonzero dp, don't use clr_a
        phx
        pld
        shorti
        longa_clc
        ldy     #$01
        nop5
        ldx     #$80
        stx     hINIDISP
        lda     $69
        clc
        adc     $6b
        sta     $69
        and     #$0600
        xba
        tax
        lda     $6e,x                   ; graphics pointer
        sta     $4302
        ldx     $6d                     ; graphics bank
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $76
        clc
        adc     $78
        sta     $76
        and     #$0600
        xba
        tax
        lda     $7b,x
        sta     $4302
        ldx     $7a
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $83
        clc
        adc     $85
        sta     $83
        and     #$0600
        xba
        tax
        lda     $88,x
        sta     $4302
        ldx     $87
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $90
        clc
        adc     $92
        sta     $90
        and     #$0600
        xba
        tax
        lda     $95,x
        sta     $4302
        ldx     $94
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $9d
        clc
        adc     $9f
        sta     $9d
        and     #$0600
        xba
        tax
        lda     $a2,x
        sta     $4302
        ldx     $a1
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $aa
        clc
        adc     $ac
        sta     $aa
        and     #$0600
        xba
        tax
        lda     $af,x
        sta     $4302
        ldx     $ae
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $b7
        clc
        adc     $b9
        sta     $b7
        and     #$0600
        xba
        tax
        lda     $bc,x
        sta     $4302
        ldx     $bb
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $c4
        clc
        adc     $c6
        sta     $c4
        and     #$0600
        xba
        tax
        lda     $c9,x
        sta     $4302
        ldx     $c8
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        shorta
        longi
        ldx     #$0000
        phx
        pld
        tdc
        rts

; ------------------------------------------------------------------------------

; [ copy bg3 animation graphics to vram ]

; called every other frame during irq (30hz)

TfrBG3AnimGfx:
@9178:  stz     hMDMAEN                 ; disable dma
        lda     #$80
        sta     hVMAINC                 ; vram settings
        ldx     #$3000
        stx     hVMADDL                 ; destination = $3000 (vram)
        lda     #$41
        sta     $4300                   ; dma settings
        lda     #$18
        sta     $4301                   ; dma to $2118 (vram)
        ldx     #$0005
@9193:  dex
        bne     @9193                   ; wait
        lda     #$80
        sta     hINIDISP                ; screen off
        lda     $053b                   ; bg3 animation index
        and     #$e0
        beq     @91d4                   ; return if bg3 animation is disabled
        longa_clc
        lda     $10d5                   ; size
        sta     $4305
        lda     $10d1                   ; add animation speed to animation counter
        adc     $10d3
        sta     $10d1
        shorta0
        lda     $10d2                   ; frame index
        and     #$0e
        tax
        longa_clc
        lda     $10d7,x                 ; frame pointer
        adc     #$bf00
        sta     $4302
        shorta0
        lda     #$7e
        sta     $4304
        lda     #$01                    ; enable dma
        sta     hMDMAEN
@91d4:  rts

; ------------------------------------------------------------------------------

MapBGAnimPropPtrs:
@91d5:  make_ptr_tbl_rel MapBGAnimProp, MapBGAnimProp_ARRAY_LENGTH
        .addr   MapBGAnimPropEnd - MapBGAnimProp

@91ff:  .include "assets/map_bg_anim_prop.asm"
        MapBGAnimPropEnd := *

MapBG3AnimPropPtrs:
@979f:  make_ptr_tbl_rel MapBG3AnimProp, MapBG3AnimProp_ARRAY_LENGTH
        .addr   MapBG3AnimPropEnd - MapBG3AnimProp

@97ad:  .include "assets/map_bg3_anim_prop.asm"
        MapBG3AnimPropEnd := *

@9825:  .include "assets/map_pal_anim_prop.asm"

; ------------------------------------------------------------------------------
