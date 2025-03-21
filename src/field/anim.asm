
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

.include "gfx/map_anim_gfx_bg3.inc"

.import MapAnimGfx, MapPalAnimColors

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ init palette animation ]

.proc InitPalAnim
        lda     $053a
        bne     :+
        rts
:       dec
        sta     hWRMPYA
        lda     #12
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
Loop:   lda     f:MapPalAnimProp,x
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
        bne     Loop
        rts
.endproc  ; InitPalAnim

; ------------------------------------------------------------------------------

; [ update palette animation ]

.proc UpdatePalAnim
        lda     $053a                   ; palette animation index
        beq     Done
        ldy     $00
Loop:   lda     $10ea,y                 ; palette animation type
        bmi     Skip
        and     #$f0
        lsr4

; 0 (counter only)
        bne     :+
        jsr     IncPalAnimCounter
        cmp     #0
        bne     Skip                    ; branch if no reset
        jmp     Skip                    ; branch anyway

; 1 (cycle)
:       dec
        bne     :+
        jsr     IncPalAnimCounter
        cmp     #0
        bne     Skip
        jsr     UpdatePalAnimCycle
        jmp     Skip

; 2 (rom)
:       dec
        bne     :+
        jsr     IncPalAnimCounter
        phy
        jsr     LoadPalAnimColors
        ply
        jmp     Skip

; 3 (pulse)
:       dec
        bne     Skip
        jsr     IncPalAnimCounter
        phy
        jsr     UpdatePalAnimPulse
        ply

Skip:   tya
        clc
        adc     #8
        tay
        cmp     #16
        jne     Loop
Done:   rts
.endproc  ; UpdatePalAnim

; ------------------------------------------------------------------------------

; [ update palette animation counters ]

.proc IncPalAnimCounter
        lda     $10e7,y                 ; increment frame counter
        inc
        sta     $10e7,y
        cmp     $10e8,y
        bne     NoReset
        lda     #$00
        sta     $10e7,y
        lda     $10e9,y                 ; increment color counter
        inc
        sta     $10e9,y
        lda     $10ea,y
        and     #$0f
        cmp     $10e9,y
        bne     NoReset
        clr_a                           ; return 0 for reset
        sta     $10e9,y
        rts

NoReset:
        lda     #1                      ; return 1 for no reset
        rts
.endproc

; ------------------------------------------------------------------------------

PalAnimPulseTbl:
        .byte   $70,$80,$90,$a0,$b0,$c0,$d0,$e0,$f0
        .byte   $e0,$d0,$c0,$b0,$a0,$90,$80,$70,$60

; ------------------------------------------------------------------------------

; [ update palette animation (pulse) ]

.proc UpdatePalAnimPulse
        lda     $10e9,y
        tax
        lda     f:PalAnimPulseTbl,x
        sta     hWRMPYA
        lda     $10eb,y
        tax
        lda     $10ec,y
        inc2
        tay
Loop:   lda     $7e7200,x
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
        bne     Loop
        rts
.endproc  ; UpdatePalAnimPulse

; ------------------------------------------------------------------------------

; [ load colors from ROM for palette animation ]

.proc LoadPalAnimColors
        lda     $10eb,y
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
:       lda     f:MapPalAnimColors,x    ; palette animation color palette
        sta     [$2a]
        inc     $2a
        inc     $2a
        inx2
        dey2
        bne     :-
        shorta0
        rts
.endproc  ; LoadPalAnimColors

; ------------------------------------------------------------------------------

; [ update palette animation (cycle) ]

.proc UpdatePalAnimCycle
        lda     $10eb,y
        tax
        clc
        adc     $10ec,y
        sta     $20
        stz     $21
        longa
        lda     $7e7400,x
        sta     $1e
:       lda     $7e7402,x
        sta     $7e7400,x
        inx2
        cpx     $20
        bne     :-
        lda     $1e
        sta     $7e7400,x
        shorta0
        rts
.endproc  ; UpdatePalAnimCycle

; ------------------------------------------------------------------------------

; [ init bg animation ]

.proc InitBGAnim
        jsr     InitBG12Anim
        jsr     InitBG3Anim
        rts
.endproc  ; InitBGAnim

; ------------------------------------------------------------------------------

; [ init bg1/bg2 animation ]

.scope MapBGAnimProp
        ARRAY_LENGTH = 20
        Start := MapBGAnimProp
        AnimSpeed := Start
        Frame1 := Start + 2
        Frame2 := Start + 4
        Frame3 := Start + 6
        Frame4 := Start + 8
.endscope

.proc InitBG12Anim
        lda     $053b                   ; bg1/bg2 animation index
        and     #$1f
        asl
        tax
        longa
        lda     f:MapBGAnimPropPtrs,x
        tax
        shorta0
        ldy     $00
Loop1:  lda     #$e6
        sta     $106d,y                 ; graphics bank = $e6
        longa_clc
        clr_a
        sta     $1069,y                 ; clear animation counter
        lda     f:MapBGAnimProp::AnimSpeed,x
        sta     $106b,y
        lda     f:MapBGAnimProp::Frame1,x
        sta     $106e,y
        lda     f:MapBGAnimProp::Frame2,x
        sta     $1070,y
        lda     f:MapBGAnimProp::Frame3,x
        sta     $1072,y
        lda     f:MapBGAnimProp::Frame4,x
        sta     $1074,y
        txa
        adc     #10                     ; next tile (8 tiles total)
        tax
        tya
        adc     #13
        tay
        shorta0
        cpy     #13*8
        bne     Loop1
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
Loop2:  tyx
        longa_clc
        lda     f:MapBGAnimProp::Frame1,x
        tax
        shorta0
        lda     #$80                    ; $1b = tile graphics counter (4 frames per tile, 32 bytes per frame)
        sta     $1b
:       lda     f:MapAnimGfx,x          ; copy tile graphics to ram
        sta     hWMDATA
        inx
        dec     $1b
        bne     :-
        longa
        tya
        clc
        adc     #10
        tay
        shorta0
        dec     $1a
        bne     Loop2
        stz     hHDMAEN                 ; dma graphics to vram
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$2800                  ; destination = $2800 vram
        stx     hVMADDL
        lda     #$41
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$9f00                  ; source = $7e9f00
        stx     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0800                  ; size = $0800
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        stz     hMDMAEN
        rts
.endproc  ; InitBG12Anim

; ------------------------------------------------------------------------------

; [ init bg3 animation ]

.scope MapBG3AnimProp
        ARRAY_LENGTH = 6
        Start := MapBG3AnimProp
        AnimSpeed := Start
        GfxSize := Start + 2
        Frame1 := Start + 4
        Frame2 := Start + 6
        Frame3 := Start + 8
        Frame4 := Start + 10
        Frame5 := Start + 12
        Frame6 := Start + 14
        Frame7 := Start + 16
        Frame8 := Start + 18
.endscope

.proc InitBG3Anim
        lda     $053b                   ; bg3 animation index
        and     #$e0
        lsr5
        bne     :+                      ; return if not valid
        rts
:       dec
        tay
        asl
        tax
        longa
        lda     f:MapBG3AnimPropPtrs,x
        tax
        clr_a
        sta     $10d1                   ; clear animation counter
        lda     f:MapBG3AnimProp::AnimSpeed,x
        sta     $10d3
        lda     f:MapBG3AnimProp::GfxSize,x
        sta     $10d5
        lda     f:MapBG3AnimProp::Frame1,x
        sta     $10d7
        lda     f:MapBG3AnimProp::Frame2,x
        sta     $10d9
        lda     f:MapBG3AnimProp::Frame3,x
        sta     $10db
        lda     f:MapBG3AnimProp::Frame4,x
        sta     $10dd
        lda     f:MapBG3AnimProp::Frame5,x
        sta     $10df
        lda     f:MapBG3AnimProp::Frame6,x
        sta     $10e1
        lda     f:MapBG3AnimProp::Frame7,x
        sta     $10e3
        lda     f:MapBG3AnimProp::Frame8,x
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
        adc     #near MapAnimGfxBG3
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
.endproc  ; InitBG3Anim

; ------------------------------------------------------------------------------

; [ copy bg1/bg2 animation graphics to vram ]

; called every other frame during irq (30hz)

.proc TfrBGAnimGfx
        lda     $053b
        bne     DoTfr

; no animation graphics, wait a few cycles then return
        ldx     #8
:       dex
        bne     :-
        lda     #$80
        sta     hINIDISP
        rts

DoTfr:
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$2800
        stx     hVMADDL
        lda     #$41
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$1000                  ; nonzero dp, don't use clr_a
        phx
        pld
        shorti
        longa_clc
        ldy     #BIT_0
        nop5
        ldx     #$80
        stx     hINIDISP
        .repeat 8, i
        lda     $69 + i * 13
        clc
        adc     $6b + i * 13
        sta     $69 + i * 13
        and     #$0600
        xba
        tax
        lda     $6e + i * 13,x          ; graphics pointer
        sta     hDMA0::ADDR
        ldx     $6d + i * 13            ; graphics bank
        stx     hDMA0::ADDR_B
        ldx     #$80
        stx     hDMA0::SIZE
        sty     hMDMAEN
        .endrep
        shorta
        longi
        ldx     #$0000
        phx
        pld
        clr_a
        rts
.endproc  ; TfrBGAnimGfx

; ------------------------------------------------------------------------------

; [ copy bg3 animation graphics to vram ]

; called every other frame during irq (30hz)

.proc TfrBG3AnimGfx
        stz     hMDMAEN                 ; disable dma
        lda     #$80
        sta     hVMAINC                 ; vram settings
        ldx     #$3000
        stx     hVMADDL                 ; destination = $3000 (vram)
        lda     #$41
        sta     hDMA0::CTRL             ; dma settings
        lda     #<hVMDATAL
        sta     hDMA0::HREG             ; dma to $2118 (vram)
        ldx     #5
:       dex
        bne     :-                      ; wait
        lda     #$80
        sta     hINIDISP                ; screen off
        lda     $053b                   ; bg3 animation index
        and     #$e0
        beq     Done                    ; return if bg3 animation is disabled
        longa_clc
        lda     $10d5                   ; size
        sta     hDMA0::SIZE
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
        sta     hDMA0::ADDR
        shorta0
        lda     #$7e
        sta     hDMA0::ADDR_B
        lda     #BIT_0                  ; enable dma
        sta     hMDMAEN
Done:   rts
.endproc  ; TfrBG3AnimGfx

; ------------------------------------------------------------------------------

MapBGAnimPropPtrs:
@91d5:  ptr_tbl MapBGAnimProp
        end_ptr MapBGAnimProp

MapBGAnimProp:
@91ff:  .include "map_bg_anim_prop.asm"
MapBGAnimProp::End:

MapBG3AnimPropPtrs:
@979f:  ptr_tbl MapBG3AnimProp
        end_ptr MapBG3AnimProp

MapBG3AnimProp:
@97ad:  .include "map_bg3_anim_prop.asm"
MapBG3AnimProp::End:

MapPalAnimProp:
@9825:  .incbin "map_pal_anim_prop.dat"

; ------------------------------------------------------------------------------
