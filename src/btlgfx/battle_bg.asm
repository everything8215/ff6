.include "src/gfx/battle_bg.inc"

.import BattleBGProp

; ------------------------------------------------------------------------------

; [ change battle bg (final battle) ]

; final battle scroll step 1 (load new bg palette)
_c11bd1:
last_land_chg:
@1bd1:  stz     near w7ee9df
        stz     near w7ee9de
        inc     near w7ee9de
        bra     _1be2

; ------------------------------------------------------------------------------

; [ change battle bg (dance and final battle) ]

; final battle scroll step 3 (load as current bg)
ReloadBattleBG:
_c11bdc:
wait_land_chg:
@1bdc:  stz     near w7ee9df

; final battle scroll step 2 (load new bg tiles)
_c11bdf:
wait_land_chg2:
@1bdf:  stz     near w7ee9de

wait_land_chg_main:
_1be2:  stz     near w7ee9dc
        inc     near w7ee9dc
        stz     near w7ee9dd
        cmp     #$ff
        jeq     @1c77
        sta     $22
        lda     #$06
        sta     $24
        jsr     Mult8
        ldx     $26
        ldy     #$1000
        jsr     TfrBattleBGGfx
        inx
        ldy     #$1800
        jsr     TfrBattleBGGfx
        inx
        inc     near w7ee9dd
        ldy     #$4800
        jsr     TfrBattleBGGfx
        inx
        ldy     #$6000
        jsr     TfrBattleBGTiles        ; transfer battle bg tiles to $6000
        inx
        lda     near w7ee9df
        bne     @1c2c
        lda     near w7ee9de
        bne     @1c2c
        ldy     #$6400
        jsr     TfrBattleBGTiles        ; transfer next battle bg tiles to $6400
@1c2c:  inx
        lda     f:BattleBGProp,x
        and     #$80
        sta     near w7e6283       ; wavy battle bg (desert)
        lda     f:BattleBGProp,x   ; battle bg palette index
        and     #$7f
        longa
        asl5
        sta     $22
        asl
        clc
        adc     $22
        tax
        shorta0
        tay
        lda     near w7ee9de
        beq     @1c66
@1c53:  lda     f:BattleBGPal,x
        sta     near w7e7e00::_3,y                   ; use animation palettes for scrolling bg
        sta     near w7e7c00::_3,y
        inx
        iny
        cpy     #$0040
        bne     @1c53
        bra     @1c77
@1c66:  lda     f:BattleBGPal,x
        sta     near w7e7e00::_5,y
        sta     near w7e7c00::_5,y
        inx
        iny
        cpy     #$0060
        bne     @1c66
@1c77:  jsr     _c103e2
        rts

; ------------------------------------------------------------------------------

; [ copy battle bg tile data to vram ]

; +X: pointer to battle bg data
; +Y: destination address (vram)

TfrBattleBGTiles:
@1c7b:  phx
        phy
        lda     f:BattleBGProp,x   ; battle bg ($ff = none)
        cmp     #$ff
        beq     @1cf2
        asl
        tax
        lda     f:BattleBGTilesPtrs,x   ; pointer to battle bg tile data
        sta     $f3
        lda     f:BattleBGTilesPtrs+1,x
        sta     $f4
        lda     #^BattleBGTiles
        sta     $f5
        jsr     _c11e2f
        phy
        jsl     Decompress_ext
        ply
        lda     near w7ee9de
        beq     @1cd1
        phb
        lda     #$7f
        pha
        plb
        clr_ax
@1cac:  lda     $c401,x
        inc2
        sec
        sbc     #$08
        sta     $c401,x
        inx2
        cpx     #$0800
        bne     @1cac
        plb
        ldx     #$04c0
        stx     $10
        lda     #$7f
        ldx     #$c400
        ldy     #$65a0
        jsr     WaitTfrVRAM
        bra     @1cf2
@1cd1:  lda     near w7ee9dc
        bne     @1ce5
        ldx     #$0800
        stx     $36
        lda     #$7f
        ldx     #$c400
        jsr     TfrVRAM
        bra     @1cf2
@1ce5:  ldx     #$0800
        stx     $10
        lda     #$7f
        ldx     #$c400
        jsr     WaitTfrVRAM
@1cf2:  ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ copy battle bg graphics to vram ]

; +X: pointer to battle bg data
; +Y: destination address (vram)

TfrBattleBGGfx:
@1cf5:  phx
        phy
        lda     f:BattleBGProp,x   ; battle bg
        cmp     #$ff
        jeq     @1dac
        phx
        and     #$7f
        sta     $f3
        asl
        clc
        adc     $f3
        tax
        lda     f:BattleBGGfxPtrs,x   ; pointer to battle bg graphics
        sta     $f3
        lda     f:BattleBGGfxPtrs+1,x
        sta     $f4
        lda     f:BattleBGGfxPtrs+2,x
        sta     $f5
        cmp     #^BattleBGGfx
        bcc     @1d24       ; branch if using map graphics (uncompressed)
        bra     @1d4c       ; branch if using battle bg graphics (compressed)
@1d24:  phy
        phb
        lda     #$7f
        pha
        plb
        longa
        clr_ay
@1d2e:  lda     [$f3],y
        sta     $c400,y
        iny2
        cpy     #$2000
        bne     @1d2e
        shorta0
        plb
        lda     #$7f
        sta     near w7ee9f2_B
        ldx     #$c400
        stx     near w7ee9f2
        ply
        bra     @1d60
@1d4c:  lda     #$7f
        sta     near w7ee9f2_B
        ldx     #$c400
        stx     near w7ee9f2
        jsr     _c11e2f
        phy
        jsl     Decompress_ext
        ply
@1d60:  plx
        lda     f:BattleBGProp,x
        bmi     @1d6c
        ldx     #$1000
        bra     @1d6f
@1d6c:  ldx     #$2000
@1d6f:  lda     near w7ee9dd
        beq     @1d7f
        longa
        txa
        sec
        sbc     #$0020
        tax
        shorta0
@1d7f:  lda     near w7ee9dc
        bne     @1d91
        stx     $36
        ldx     near w7ee9f2
        lda     near w7ee9f2_B
        jsr     TfrVRAM
        bra     @1dac
@1d91:  stx     $10
        lda     near w7ee9de
        beq     @1da3
        longa
        tya
        clc
        adc     #$2000
        tay
        shorta0
@1da3:  ldx     near w7ee9f2
        lda     near w7ee9f2_B
        jsr     WaitTfrVRAM
@1dac:  ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ load battle background ]

LoadBattleBG:
@1daf:  stz     near w7ee9dc
        stz     near w7ee9dd
        stz     near w7ee9de
        lda     near w7eecb8       ; battle bg index
        sta     $22
        lda     #6
        sta     $24
        jsr     Mult8
        ldx     $26
        ldy     #$1000
        jsr     TfrBattleBGGfx
        inx
        ldy     #$1800
        jsr     TfrBattleBGGfx
        inx
        ldy     #$4800
        jsr     TfrBattleBGGfx
        inx
        ldy     #$6000
        jsr     TfrBattleBGTiles
        inx
        ldy     #$6400
        jsr     TfrBattleBGTiles
        inx
        lda     f:BattleBGProp,x   ; wavy background (desert)
        and     #$80
        sta     near w7e6283
        lda     f:BattleBGProp,x   ; battle bg palette
        and     #$7f
        longa
        asl5
        sta     $22         ; multiply by 32, then by 3
        asl
        clc
        adc     $22
        tax
        shorta0
        tay
@1e0a:  lda     f:BattleBGPal,x   ; copy palette (48 colors)
        sta     near w7e7e00::_5,y
        inx
        iny
        cpy     #$0060
        bne     @1e0a
        longa
        lda     #$57f0      ; clear last 16 bytes of battlefield bg3 tile data
        sta     f:hVMADDL
        ldx     #$0010
        clr_a
@1e25:  sta     f:hVMDATAL
        dex
        bne     @1e25
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c11e2f:
set_tmp_buffer2_poi:
@1e2f:  lda     #$00        ; $7fc400 (bg1 animation tile data buffer)
        sta     $f6
        lda     #$c4
        sta     $f7
        lda     #$7f
        sta     $f8
        rts

; ------------------------------------------------------------------------------
