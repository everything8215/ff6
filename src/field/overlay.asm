
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: overlay.asm                                                          |
; |                                                                            |
; | description: sprite overlay routines                                       |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.include "field/overlay_prop.inc"

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ init sprite overlays ]

InitOverlay:
@c723:  jsr     LoadOverlayData
        jsr     LoadOverlayGfx
        rts

; ------------------------------------------------------------------------------

; [ load sprite overlay graphics ]

LoadOverlayGfx:
@c72a:  lda     #$80                    ; vram settings
        sta     hVMAINC
        ldx     #.loword(OverlayVRAMTbl)
        stx     $2d
        lda     #^OverlayVRAMTbl
        sta     $2f
        ldy     $00
@c73a:  phy
        lda     $0633,y                 ; overlay tile number (8 bytes per tile)
        longa
        asl3
        clc
        adc     #.loword(OverlayTilemap)
        sta     $2a                     ; ++$2a = source address
        shorta0
        lda     #^OverlayTilemap
        sta     $2c
        ldy     $00
@c752:  longa_clc
        lda     [$2d]                   ; set vram destination
        sta     hVMADDL
        lda     [$2a],y                 ; pointer to graphics
        tax
        shorta0
        .repeat 8, i
        lda     f:OverlayGfx+i,x        ; set low 8 bits only (1bpp -> 4bpp)
        sta     hVMDATAL
        stz     hVMDATAH
        .endrep
        .repeat 8
        stz     hVMDATAL                ; clear high 16 bits
        stz     hVMDATAH
        .endrep
        longa_clc
        lda     $2d                     ; next 8x8 tile
        adc     #2
        sta     $2d
        shorta0
        iny2
        cpy     #8
        jne     @c752
        ply                             ; next 16x16 tile
        iny
        cpy     #$0010
        jne     @c73a
        rts

; ------------------------------------------------------------------------------

; vram destination for overlay graphics (4 per 16x16 tile)
OverlayVRAMTbl:
@c800:  .word   $6c00,$6c10,$6d00,$6d10
        .word   $6c20,$6c30,$6d20,$6d30
        .word   $6c40,$6c50,$6d40,$6d50
        .word   $6c60,$6c70,$6d60,$6d70
        .word   $6c80,$6c90,$6d80,$6d90
        .word   $6ca0,$6cb0,$6da0,$6db0
        .word   $6cc0,$6cd0,$6dc0,$6dd0
        .word   $6ce0,$6cf0,$6de0,$6df0
        .word   $6e00,$6e10,$6f00,$6f10
        .word   $6e20,$6e30,$6f20,$6f30
        .word   $6e40,$6e50,$6f40,$6f50
        .word   $6e60,$6e70,$6f60,$6f70
        .word   $6e80,$6e90,$6f80,$6f90
        .word   $6ea0,$6eb0,$6fa0,$6fb0
        .word   $6ec0,$6ed0,$6fc0,$6fd0
        .word   $6ee0,$6ef0,$6fe0,$6ff0

.pushseg
.segment "overlay_gfx"

; c0/e2a0
OverlayGfx:
        fixed_block $0c00
        .incbin "src/gfx/map_overlay.1bpp"
        end_fixed_block

; c0/eea0
OverlayTilemap:
        .incbin "overlay_tilemap.dat"

.popseg

; ------------------------------------------------------------------------------

; [ load sprite overlay data ]

LoadOverlayData:
@c880:  lda     $0531                   ; overlay index
        asl
        tax
        longa_clc
        lda     f:OverlayPropPtrs,x
        adc     #.loword(OverlayProp)
        sta     $f3
        shorta0
        lda     #^OverlayProp
        sta     $f5
        ldx     #$0633                  ; destination address = $000633
        stx     $f6
        lda     #$00
        sta     $f8
        jsl     Decompress
        rts

.pushseg
.segment "overlay_prop"

; c0/f4a0
OverlayPropPtrs:
        fixed_block $60
        ptr_tbl OverlayProp
        end_fixed_block

.macro inc_overlay_prop id, file
        array_label OverlayProp, OVERLAY_PROP::id
        .incbin .sprintf("overlay_prop/%s.dat.lz", file)
.endmac

; c0/f500
OverlayProp:
        fixed_block $0800
        inc_overlay_prop NONE, "none"
        inc_overlay_prop TOWN_EXT, "town_ext"
        inc_overlay_prop CAVES, "caves"
        inc_overlay_prop TOWN_INT, "town_int"
        inc_overlay_prop NARSHE_EXT, "narshe_ext"
        inc_overlay_prop CAVES_FURNITURE, "caves_furniture"
        inc_overlay_prop MOUNTAINS_EXT_1, "mountains_ext_1"
        inc_overlay_prop TRAIN_EXT, "train_ext"
        inc_overlay_prop ZOZO_EXT, "zozo_ext"
        inc_overlay_prop TRAIN_INT, "train_int"
        inc_overlay_prop IMP_CAMP, "imp_camp"
        inc_overlay_prop FOREST, "forest"
        inc_overlay_prop OPERA_HOUSE, "opera_house"
        inc_overlay_prop DESTROYED_TOWN, "destroyed_town"
        inc_overlay_prop MAGITEK_FACTORY, "magitek_factory"
        inc_overlay_prop FIGARO_CASTLE_EXT, "figaro_castle_ext"
        inc_overlay_prop DOMA_EXT, "doma_ext"
        inc_overlay_prop VILLAGE_EXT_1, "village_ext_1"
        inc_overlay_prop CASTLE_INT, "castle_int"
        inc_overlay_prop CASTLE_BASEMENT, "castle_basement"
        inc_overlay_prop VILLAGE_EXT_2, "village_ext_2"
        inc_overlay_prop FLOATING_ISLAND, "floating_island"
        inc_overlay_prop AIRSHIP_EXT, "airship_ext"
        inc_overlay_prop AIRSHIP_INT, "airship_int"
        inc_overlay_prop IMP_CASTLE_INT, "imp_castle_int"
        inc_overlay_prop VECTOR_EXT, "vector_ext"
        inc_overlay_prop OVERLAY_26, "overlay_26"
        inc_overlay_prop MOUNTAINS_INT, "mountains_int"
        inc_overlay_prop IMP_CASTLE_EXT, "imp_castle_ext"
        inc_overlay_prop MAGITEK_LAB, "magitek_lab"
        inc_overlay_prop DARILLS_TOMB, "darills_tomb"
        inc_overlay_prop KEFKAS_TOWER, "kefkas_tower"
        inc_overlay_prop OVERLAY_32, "overlay_32"
        inc_overlay_prop MOUNTAINS_EXT_2, "mountains_ext_2"
        inc_overlay_prop SNOWFIELDS, "snowfields"
        inc_overlay_prop OVERLAY_35, "overlay_35"
        inc_overlay_prop OVERLAY_36, "overlay_36"
        inc_overlay_prop OVERLAY_37, "overlay_37"
        inc_overlay_prop OVERLAY_38, "overlay_38"
        inc_overlay_prop OVERLAY_39, "overlay_39"
        inc_overlay_prop OVERLAY_40, "overlay_40"
        inc_overlay_prop OVERLAY_41, "overlay_41"
        inc_overlay_prop OVERLAY_42, "overlay_42"
        inc_overlay_prop OVERLAY_43, "overlay_43"
        inc_overlay_prop OVERLAY_44, "overlay_44"
        end_fixed_block

.popseg

; ------------------------------------------------------------------------------

; [ update overlay data ]

UpdateOverlay:
@c8a5:  ldy     $0803
        lda     $087c,y                 ; return if player doesn't have control
        and     #$0f
        cmp     #$02
        beq     @c8b2
        rts
@c8b2:  longa
        lda     $086d,y                 ; get party xy position on screen
        clc
        sbc     $60
        sta     $28
        lda     $086a,y
        sec
        sbc     $5c
        clc
        adc     #$0008
        sta     $26
        shorta0
        lda     $27
        lda     $29
        lda     #$7e                    ; set wram address to overlay data ($7e0763)
        sta     hWMADDH
        ldx     #$0763
        stx     hWMADDL
        lda     $b8                     ; branch if not on a stairs tile
        and     #$c0
        beq     @c8ec
        lda     $b8
        and     #$04
        beq     @c8ef
        lda     $b2
        cmp     #$01
        beq     @c8ec                   ; this branch does nothing
@c8ec:  jmp     _ca1a
@c8ef:  lda     $087e,y
        beq     @c8fe
        cmp     #$05
        jcc     _ca1a
        sec
        sbc     #$04
@c8fe:  sta     $1a
        asl3
        clc
        adc     $1a
        sta     $1a
        tax
        lda     $26
        clc
        adc     f:_c0c9ed,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0c9ed+1,x
        sta     hWMDATA
        lda     f:_c0c9ed+2,x
        tay
        phx
        lda     $00a3,y
        tax
        tay
        lda     $7e7600,x
        plx
        and     #$04
        beq     @c936
        lda     $b2
        dec
        beq     @c944
@c936:  lda     $0643,y
        cmp     #$ff
        beq     @c944
        and     #$3f
        clc
        adc     #$c0
        bra     @c945
@c944:  tdc
@c945:  sta     hWMDATA
        lda     $0643,y
        and     #$c0
        sta     hWMDATA
        lda     $26
        clc
        adc     f:_c0c9ed+3,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0c9ed+4,x
        sta     hWMDATA
        lda     f:_c0c9ed+5,x
        tay
        phx
        lda     $00a3,y
        tax
        tay
        lda     $7e7600,x
        plx
        and     #$04
        beq     @c97d
        lda     $b2
        dec
        beq     @c98b
@c97d:  lda     $0643,y
        cmp     #$ff
        beq     @c98b
        and     #$3f
        clc
        adc     #$c0
        bra     @c98c
@c98b:  tdc
@c98c:  sta     hWMDATA
        lda     $0643,y
        and     #$c0
        sta     hWMDATA
        lda     $26
        clc
        adc     f:_c0c9ed+6,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0c9ed+7,x
        sta     hWMDATA
        lda     f:_c0c9ed+8,x
        tay
        phx
        lda     $00a3,y
        tax
        tay
        lda     $7e7600,x
        plx
        and     #$04
        beq     @c9c4
        lda     $b2
        dec
        beq     @c9d2
@c9c4:  lda     $0643,y
        cmp     #$ff
        beq     @c9d2
        and     #$3f
        clc
        adc     #$c0
        bra     @c9d3
@c9d2:  tdc
@c9d3:  sta     hWMDATA
        lda     $0643,y
        and     #$c0
        sta     hWMDATA
        lda     #$ef
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; (5 * 9 bytes)
_c0c9ed:
@c9ed:  .byte   $00,$00,$07,$10,$f0,$05,$10,$00,$08
        .byte   $10,$00,$05,$00,$10,$07,$10,$10,$08
        .byte   $00,$00,$07,$00,$10,$0a,$10,$10,$0b
        .byte   $10,$00,$07,$10,$10,$0a,$00,$10,$09
        .byte   $10,$10,$07,$00,$00,$03,$00,$10,$06

; ------------------------------------------------------------------------------

; not on a stairs tile
_ca1a:  lda     $b8                     ; tile properties
        and     #$04
        beq     @ca27                   ; branch if not a bridge tile
        lda     $b2
        dec
        beq     @ca5e                   ; branch if party is on upper z-level
        bra     @ca42

; party is not on a bridge tile
@ca27:  lda     $aa                     ; tile number
        tay
        lda     $0643,y                 ; overlay tile formation
        cmp     #$ff
        beq     @ca5e                   ; branch if no overlay tile
        sta     $1a
        and     #$3f                    ; tile index bits
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0                    ; vh flip bits (lower z-level)
        sta     $1a
        bra     @ca64

; party is not on upper z-level
@ca42:  lda     $aa                     ; tile number
        tay
        lda     $0643,y                 ; overlay tile formation
        cmp     #$ff
        beq     @ca5e                   ; branch if no overlay tile
        sta     $1a
        and     #$3f                    ; tile index bits
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0                    ; vh flip bits
        inc                             ; upper z-level
        sta     $1a
        bra     @ca64

; party is on upper z-level
@ca5e:  lda     #$01                    ; +$1a = #$0001 (no overlay tile)
        sta     $1a
        stz     $1b
@ca64:  lda     a:$0074                 ; horizontal scroll speed
        bpl     @ca70
        lda     $26                     ; tile x position
        clc
        adc     #$10
        sta     $26
@ca70:  lda     $26
        sta     hWMDATA
        lda     a:$0076                 ; vertical scroll speed
        bpl     @ca81
        lda     $28                     ; tile y position
        clc
        adc     #$10
        sta     $28
@ca81:  lda     $28
        sta     hWMDATA
        lda     $1b                     ; tile index
        sta     hWMDATA
        lda     $1a                     ; vh flip and priority
        sta     hWMDATA
        lda     $b8                     ;
        and     #$04
        beq     @ca9d
        lda     $b2
        dec
        beq     @cb03
        bra     @cae7

;
@ca9d:  lda     $b8                     ; tile z-level
        and     #$03
        cmp     #$02
        beq     @cab6                   ; branch if lower
        cmp     #$03
        beq     @cac0                   ; branch if transition
        lda     $b6
        cmp     #$f7
        beq     @cacc
        and     #$07
        dec
        beq     @cacc
        bra     @cb03

;
@cab6:  lda     $b6                     ; top tile z-layer
        and     #$07
        cmp     #$01
        beq     @cb03                   ; branch if upper z-level
        bra     @cacc

;
@cac0:  lda     $b6
        cmp     #$f7
        beq     @cacc
        and     #$02
        bne     @cacc
        bra     @cb03

;
@cacc:  lda     $a7
        tay
        lda     $0643,y
        cmp     #$ff
        beq     @cb03
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        sta     $1a
        bra     @cb09

;
@cae7:  lda     $a7
        tay
        lda     $0643,y
        cmp     #$ff
        beq     @cb03
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        inc
        sta     $1a
        bra     @cb09

; no top overlay tile
@cb03:  lda     #$01
        sta     $1a
        stz     $1b
@cb09:  lda     $26
        sta     hWMDATA
        lda     $28
        sec
        sbc     #$10
        sta     hWMDATA
        lda     $1b
        sta     hWMDATA
        lda     $1a
        sta     hWMDATA
        ldy     $0803
        lda     $087e,y
        tax
        lda     f:_c0cc73,x
        tax
        stx     $2a
        lda     $087e,y
        beq     @cb94
        lda     f:_c0cc7d+2,x
        tax
        lda     $a3,x
        tax
        lda     $7e7600,x
        sta     $1e
        and     #$04
        beq     @cb5b
        lda     $b8
        and     #$04
        beq     @cb52
@cb4b:  lda     $b2
        dec
        beq     @cb94
        bra     @cb7b
@cb52:  lda     $b8
        and     #$03
        dec
        beq     @cb94
        bra     @cb7b

;
@cb5b:  lda     $b8
        and     #$04
        bra     @cb63

;
        bra     @cb4b

;
@cb63:  lda     $0643,x
        cmp     #$ff
        beq     @cb94
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        sta     $1a
        bra     @cb9a

;
@cb7b:  lda     $0643,x
        cmp     #$ff
        beq     @cb94
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        inc
        sta     $1a
        bra     @cb9a

;
@cb94:  lda     #$01
        sta     $1a
        stz     $1b
@cb9a:  ldx     $2a
        lda     $26
        clc
        adc     f:_c0cc7d,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0cc7d+1,x
        sta     hWMDATA
        lda     $1b
        sta     hWMDATA
        lda     $1a
        sta     hWMDATA
        ldy     $0803
        lda     $087e,y
        jeq     @cc4c
        lda     f:_c0cc7d+5,x
        tax
        lda     $a3,x
        tax
        lda     $1e
        and     #$04
        beq     @cbe6
        lda     $b8
        and     #$07
        cmp     #$01
        beq     @cc4c
        cmp     #$02
        beq     @cc33
        lda     $b2
        dec
        beq     @cc4c
        bra     @cc33

;
@cbe6:  lda     $1e
        and     #$03
        cmp     #$02
        beq     @cc01
        cmp     #$03
        beq     @cc0d
        lda     $7e7600,x
        cmp     #$f7
        beq     @cc1b
        and     #$07
        dec
        beq     @cc1b
        bra     @cc4c

;
@cc01:  lda     $7e7600,x
        and     #$07
        cmp     #$01
        beq     @cc4c
        bra     @cc1b

;
@cc0d:  lda     $7e7600,x
        cmp     #$f7
        beq     @cc1b
        and     #$02
        bne     @cc1b
        bra     @cc4c

;
@cc1b:  lda     $0643,x
        cmp     #$ff
        beq     @cc4c
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        sta     $1a
        bra     @cc52

;
@cc33:  lda     $0643,x
        cmp     #$ff
        beq     @cc4c
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        inc
        sta     $1a
        bra     @cc52

;
@cc4c:  lda     #$01
        sta     $1a
        stz     $1b
@cc52:  ldx     $2a
        lda     $26
        clc
        adc     f:_c0cc7d+3,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0cc7d+4,x
        sta     hWMDATA
        lda     $1b
        sta     hWMDATA
        lda     $1a
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

_c0cc73:
@cc73:  .byte   $00,$00,$06,$0c,$12,$18,$1e,$24,$2a,$30

; (4 * 6 bytes)
_c0cc7d:
@cc7d:  .byte   $00,$f0,$04,$00,$e0,$01
        .byte   $10,$00,$08,$10,$f0,$05
        .byte   $00,$10,$0a,$00,$00,$07
        .byte   $f0,$00,$06,$f0,$f0,$03

; ------------------------------------------------------------------------------

; [ update overlay sprite data ]

DrawOverlaySprites:
@cc95:  ldx     $00
        txy
@cc98:  lda     $74                     ; horizontal scroll speed
        beq     @cca8
        bmi     @cca8                   ; branch if not positive
        lda     $5c                     ; horizontal scroll position
        dec
        and     #$0f
        inc
        not_a
        bra     @ccae
@cca8:  lda     $5c
        and     #$0f
        not_a
@ccae:  sec
        adc     $0763,x                 ; add overlay tile x position
        sta     $1a
        lda     $76                     ; vertical scroll speed
        beq     @ccc4
        bmi     @ccc4                   ; branch if not positive
        lda     $60                     ; vertical scroll position
        dec
        and     #$0f
        inc
        not_a
        bra     @ccca
@ccc4:  lda     $60
        and     #$0f
        not_a
@ccca:  sec
        adc     $0764,x                 ; add overlay tile y position
        sec
        sbc     $7f                     ; subtract shake screen offset
        sta     $1b
        lda     $0765,x                 ; overlay tile number
        beq     @cd1b                   ; 0 = no tile
        lda     $0766,x
        and     #$01
        bne     @ccfe                   ; branch if lower z-level
        lda     $1a                     ; draw upper z-level overlay sprite
        sta     $03e0,y
        lda     $1b
        sta     $03e1,y
        lda     $0765,x
        sta     $03e2,y
        lda     $0766,x
        and     #$ce
        sta     $03e3,y
        lda     #$ef                    ; hide lower z-level overlay sprite
        sta     $04a1,y
        bra     @cd1b
@ccfe:  lda     $1a                     ; draw lower z-level overlay sprite
        sta     $04a0,y
        lda     $1b
        sta     $04a1,y
        lda     $0765,x
        sta     $04a2,y
        lda     $0766,x
        and     #$ce
        sta     $04a3,y
        lda     #$ef                    ; hide upper z-level overlay sprite
        sta     $03e1,y
@cd1b:  iny4                            ; next tile
        inx4
        cpx     #$0010
        jne     @cc98
        rts

; ------------------------------------------------------------------------------

; [ clear overlay tiles ]

ClearOverlayTiles:
@cd2c:  tdc
        sta     $0765
        sta     $0769
        sta     $076d
        sta     $0771
        rts

; ------------------------------------------------------------------------------
