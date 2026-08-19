.include "src/gfx/monster_gfx.inc"

.import MonsterStencil

; ------------------------------------------------------------------------------

; [ check bg1 monsters ]

; $24: bg1 monsters (out)

CheckBG1Monsters:
@1e3c:  clr_ax
        stz     $24
@1e40:  lda     near w7e80f3+1,x     ; bg1 monster (from battle data)
        lsr
        ora     $24
        ror
        sta     $24
        inx2                ; next monster
        cpx     #$000c
        bne     @1e40
        lsr2
        sta     $24
        rts

; ------------------------------------------------------------------------------

; [ clear bg1 tile data in vram (long access) ]

ClearBG1Tiles_far:
@1e55:  jsr     ClearBG1Tiles
        rtl

; ------------------------------------------------------------------------------

; [ clear bg1 tile data in vram ]

ClearBG1Tiles:
@1e59:  jsr     ClearBG1TileBuf
        jmp     TfrBG1Tiles

; ------------------------------------------------------------------------------

; [ copy monsters to bg1 (long access) ]

MonstersToBG1_far:
@1e5f:  jsr     MonstersToBG1
        rtl

; ------------------------------------------------------------------------------

; [ copy monsters to bg1 ]

; A: monsters affected

MonstersToBG1:
@1e63:  pha
        jsr     _c10f00       ; clear bg1 vertical scroll hdma data (battlefield region)
        jsr     ClearBG1TileBuf
        pla

.if ROM_VERSION >= 1
; **** added in rev 1 ****
        bra     _1e6b

; ------------------------------------------------------------------------------

; [ copy bg1 monsters to bg1 ]

_c11e6d:
back_mon_set:
@1e6d:  jsr     _c10f00       ; clear bg1 vertical scroll hdma data (battlefield region)
        jsr     ClearBG1TileBuf
        jsr     CheckBG1Monsters
        lda     $24
        and     near w7e6191                 ; remove monsters that are newly entering
; ************************
.endif

target_mon_set2:
_1e6b:  and     near w7e201e
        and     near w7e61ab
        and     near w7ee9e6
        sta     $24
        jmp     _c11e95       ; copy monster palettes & tile data to bg1

; ------------------------------------------------------------------------------

; [ copy bg1 monsters to bg1 ]

; has no effect

_c11e79:
.if ROM_VERSION < 1
; *** removed in rev 1 ***
@1e79:  jsr     _c10f00       ; clear bg1 vertical scroll hdma data (battlefield region)
        jsr     ClearBG1TileBuf
        jsr     CheckBG1Monsters
        lda     $24
        and     near w7e201e       ; monsters shown
        and     near w7e61ab       ; monsters shown
        and     near w7ee9e6       ; monsters that are visible (no clear status)
        and     near w7e6191       ; remove monsters that are newly entering
        sta     $24
        jmp     _c11e95       ; copy monster palettes & tile data to bg1
; ************************
.endif

; ------------------------------------------------------------------------------

; [ copy monster palettes and tile data to bg1 ]

; $24: monsters affected

_c11e95:
mon_scr_set_main:
@1e95:  lda     $24
        sta     $22
        clr_ax
        stz     $10
@1e9d:  lsr     $22
        bcc     @1eca       ; branch if monster is not affected
        phx
        lda     $10
        sta     near w7e80ff,x     ; monster palette copied to animation palette
        asl5
        tay
        lda     near w7e80db,x     ; monster palette
        lsr
        asl5
        tax
        lda     #$20
        sta     $12
@1ebb:  lda     near w7e7e00::_8,x     ; copy monster palette to animation palette
        sta     near w7e7e00::_3,y
        inx
        iny
        dec     $12         ; next color
        bne     @1ebb
        inc     $10         ; next palette
        plx
@1eca:  inx2                ; next monster
        cpx     #$000c
        bne     @1e9d
        clr_ax
@1ed3:  lsr     $24
        bcc     @1f1a       ; branch if monster is not affected
        lda     near w7e80c3,x     ; $14 = monster x position (in 8x8 tiles)
        lsr3
        sta     $14
        lda     near w7e80cf,x     ; $16 = monster y position (in 8x8 tiles)
        lsr3
        sta     $16
        lda     near w7e812f,x     ; $10 = monster width
        sta     $10
        lda     near w7e812f+1,x     ; $12 = monster height
        sta     $12
        lda     near w7e80ff,x     ; $22 = monster palette
        clc
        adc     #$03
        asl2
        sta     $22
        lda     near w7e80ff+1,x     ;
        ora     $22
        ora     #$03
        sta     $19         ; $19 = tile data
        lda     f:MonsterSpriteDataPtrs,x
        sta     $26
        lda     f:MonsterSpriteDataPtrs+1,x
        sta     $27
        ldy     #$0002
        lda     ($26),y     ; $18 = tile number
        sta     $18
        jsr     DrawBG1Monster
@1f1a:  inx2                ; next monster
        cpx     #$000c
        bne     @1ed3
        rts

; ------------------------------------------------------------------------------

; [ copy bg1 tile data to vram (long access) ]

TfrBG1Tiles_far:
@1f22:  jsr     TfrBG1Tiles
        rtl

; ------------------------------------------------------------------------------

; [ copy bg1 tile data to vram ]

TfrBG1Tiles:
@1f26:  ldx     #$04c0      ; size = $04c0
        stx     $10
        ldx     #near w7ea97f      ; source = $7ea97f (bg tile data buffer)
        lda     #^w7ea97f
        ldy     #$0c00      ; destination = $0c00 (vram)
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ calculate pointer to monster tile data buffer ]

; +$1a: pointer to bg1 tile data buffer (out)

GetBG1MonsterTilePtr:
@1f36:  phx
        lda     $10
        sta     $1e
        lda     $14
        clc
        adc     $10
        cmp     #$20
        bcc     @1f4b
        lda     #$20
        sec
        sbc     $14
        sta     $1e
@1f4b:  lda     $16
        clc
        adc     $12
        cmp     #$13
        bcc     @1f5b
        lda     #$13
        sec
        sbc     $16
        sta     $12
@1f5b:  stz     $11
        stz     $13
        stz     $15
        stz     $17
        stz     $1f
        stz     $21
        longa
        lda     $16
        asl6
        asl     $14
        clc
        adc     $14
        adc     #near w7ea97f
        sta     $1a
        asl     $10
        asl     $1e
        shorta
        plx
        rts

; ------------------------------------------------------------------------------

; [ copy monster tile data to bg1 ]

DrawBG1Monster:
@1f83:  phx
        jsr     GetBG1MonsterTilePtr
        lda     near w7e80f3,x
        eor     near w7e617e,x
        and     #$01
        bne     @1fb9       ; branch if horizontally flipped

; not flipped
        longa
@1f93:  clr_ay
        lda     $18
@1f97:  sta     ($1a),y
        inc                 ; next tile
        iny2
        cpy     $1e
        bne     @1f97
        lda     $18         ; next row of tiles
        clc
        adc     #$0010
        sta     $18
        lda     $1a
        clc
        adc     #$0040
        sta     $1a
        dec     $12
        bne     @1f93
        shorta0
        plx
        rts

; horizontally flipped
@1fb9:  longa
        lda     $10         ; start at width - 1
        lsr
        dec
        clc
        adc     $18
        ora     #$4000      ; horizontal flip
        sta     $18
@1fc7:  clr_ay
        lda     $18
@1fcb:  sta     ($1a),y
        dec                 ; next tile (go left to right)
        iny2
        cpy     $1e
        bne     @1fcb
        lda     $18         ; next row of tiles
        clc
        adc     #$0010
        sta     $18
        lda     $1a
        clc
        adc     #$0040
        sta     $1a
        dec     $12
        bne     @1fc7
        shorta0
        plx
        rts

; ------------------------------------------------------------------------------

; [ clear bg tile data buffer ($01ee) ]

ClearBG3TileBuf:
@1fed:  longa
        clr_ax
        lda     #$01ee
        bra     _1ffd

; ------------------------------------------------------------------------------

; [ clear bg tile data buffer ($02ee) ]

ClearBG1TileBuf:
@1ff6:  longa
        clr_ax
        lda     #$02ee

mon_screen_clr_main:
_1ffd:  .repeat 8, i
        sta     near w7ea97f + i * 152,x
        .endrep
        inx2
        cpx     #152
        bne     _1ffd
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ clear monster graphics buffer ]

ClearMonsterGfxBuf:
@2020:  clr_ax
@2022:  sta     near w7eae3f,x     ; clear monster graphics buffer
        sta     near w7ebe3f,x
        inx
        cpx     #$1000
        bne     @2022
        rts

; ------------------------------------------------------------------------------

; [ set monster to use imp size ]

SetImpMonsterSize:
@202f:  lda     near w7e81a7
        asl
        tay
        longa
        lda     near w7e812f,y
        sta     $22
        and     #$00ff
        asl
        tax
        lda     f:_c2bb70,x
        sta     $26
        lda     $23
        and     #$00ff
        asl
        tax
        lda     f:_c2bb92,x
        clc
        adc     $26
        sta     $26
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init monster graphics loader ]

; A: monster slot

LoadMonsterGfxProp:
@205a:  sta     near w7e81a7       ; monster slot
        asl
        tax
        phx
        longa
        stz     $26
        lda     near w7e2001,x     ; monster number
        asl2
        clc
        adc     near w7e2001,x     ; multiply by 5 to get pointer to monster graphics data
        tax
        lda     f:MonsterGfxProp+2,x   ; +$16 = monster palette number
        xba                 ; bytes are stored backwards for some reason ...
        and     #$03ff
        sta     $16
        shorta0
        lda     near w7e81a7       ; monster slot
        tay
        lda     near w7e62c2,y     ; imp graphics
        beq     @208a       ; branch if not imp
        jsr     SetImpMonsterSize
        ldx     #5 * GENJU_GFX::IMP
@208a:  longa
        lda     f:MonsterGfxProp,x   ; monster graphics index
        and     #$7fff
        sta     near w7e81a8       ; set graphics pointer
        shorta0
        lda     f:MonsterGfxProp+1,x   ; 3bpp flag
        and     #$80
        sta     near w7e81ac
        lda     f:MonsterGfxProp+2,x   ; large map flag
        lsr
        ora     near w7e81ac
        sta     near w7e81ac
        lsr5
        and     #$01
        sta     near w7e81ab
        lda     f:MonsterGfxProp+4,x   ; graphic map number
        sta     near w7e81aa
        lda     near w7e81a7       ; monster slot
        asl2
        tax
        stx     $10         ; $10 = monster slot * 4
        lda     #^MonsterVRAMMapPtrs
        sta     $14
        lda     near w7e2000       ; vram map
        asl
        tax
        longa
        lda     f:MonsterVRAMMapPtrs,x
        clc
        adc     $10         ; add monster slot * 4
        sta     $12
        lda     [$12]       ; monster graphics buffer pointer
        clc
        adc     #near w7eae3f
        adc     $26
        sta     z61         ; set pointer
        inc     $12
        inc     $12
        lda     [$12]       ; graphics box size
        sta     near w7e8256
        lda     near w7e81a8       ; graphics pointer * 8
        asl3
        sta     z64
        stz     near w7e8254       ;
        plx
        lda     $16         ; palette number
        sta     near w7e8117,x
        shorta0
        lda     near w7e81a8+1       ; high bits of graphics pointer
        lsr5
        sta     z64_B         ; set graphics pointer
; fallthrough

; ------------------------------------------------------------------------------

; [ add monster graphics offset ]

AddMonsterGfxOffset:
@210b:  lda     z64
        clc
        adc     #<MonsterGfx
        sta     z64
        lda     z64 + 1
        adc     #>MonsterGfx
        sta     z64 + 1
        lda     z64_B
        adc     #^MonsterGfx
        sta     z64_B
        rts

; ------------------------------------------------------------------------------

; [ load monster graphics map ]

LoadMonsterStencil:
@211f:  jsr     InitStencil
        lda     near w7e8258       ; monster slot
        tax
        lda     near w7e62c2,x     ; return if monster is an imp
        bne     @215e
        lda     near w7e8258       ; monster slot
        asl
        tax
        lda     near w7e8251       ; monster width
        sta     near w7e812f,x
        lda     near w7e8253       ; monster height
        sta     near w7e812f+1,x
        phx
        longa
        lda     near w7e2001,x     ; monster index
        cmp     #$0106
        bne     @214f       ; branch if not ghost train
        pha
        lda     #$0e10
        sta     near w7e812f,x     ; width = $10, height = $0e
        pla
@214f:  tax
        lda     f:MonsterOverlap,x   ; y shift for sprite priority
        plx
        and     #$00ff
        sta     near w7e8057,x
        shorta0
@215e:  rts

; ------------------------------------------------------------------------------

; [ init monster graphics map ]

InitStencil:
@215f:  clr_ax
@2161:  sta     near w7e822d,x     ; clear monster graphics map
        inx
        cpx     #$0020
        bne     @2161
        lda     near w7e81ac       ; large map flag
        and     #$40
        bne     @2195       ; branch if large map

; small map (8x8)
        longa
        lda     near w7e81aa       ; map number
        asl3
        clc
        adc     f:MonsterStencil     ; pointer to small maps
        tax
        shorta0
        ldy     zZero
@2184:  lda     f:bank_start MonsterStencil,x
        sta     near w7e822d,y
        iny2
        inx
        cpy     #$0010
        bne     @2184
        bra     @21b8

; large map (16x16)
@2195:  longa
        lda     near w7e81aa       ; map number
        asl5
        clc
        adc     f:MonsterStencil+2     ; pointer to large maps
        tax
        shorta0
        ldy     zZero
@21aa:  lda     f:bank_start MonsterStencil,x
        sta     near w7e822d,y
        iny
        inx
        cpy     #$0020
        bne     @21aa
@21b8:  ldx     zZero
        longa
        stz     $10
@21be:  lda     near w7e822d,x     ; one row of map bits
        beq     @21ce       ; branch if no bits are set
        ora     $10
        sta     $10
        inx2
        cpx     #$0020
        bne     @21be
@21ce:  ldy     zZero
        lda     $10
        xba
        sta     $10
@21d5:  asl     $10
        bcc     @21db
        sty     $12
@21db:  iny
        cpy     #$0010
        bne     @21d5
        shorta0
        txa
        lsr
        cmp     near w7e8257
        bcc     @21ee
        lda     near w7e8257
@21ee:  sta     near w7e8253       ; monster width
        lda     $12
        inc
        cmp     near w7e8256
        bcc     @21fc
        lda     near w7e8256
@21fc:  sta     near w7e8251       ; monster height
        sta     near w7e8252
        stz     near w7e824d
        stz     near w7e824e
        rts

; ------------------------------------------------------------------------------

; [ check next bit of monster stencil ]

CheckMonsterStencilBit:
@2209:  lda     near w7e824d
        bne     @2229
        lda     #$10
        sta     near w7e824d
        lda     near w7e824e
        tax
        lda     near w7e822d,x
        sta     near w7e8250
        lda     near w7e822d+1,x
        sta     near w7e824f
        inc     near w7e824e
        inc     near w7e824e
@2229:  dec     near w7e824d
        asl     near w7e824f
        rol     near w7e8250
        rts

; ------------------------------------------------------------------------------

; [ load one tile of monster graphics ]

LoadMonsterGfxTile:
@2233:  phy
        longa
        tya
        clc
        adc     z61
        sta     $10
        shorta0
        lda     near w7e81ac
        bpl     @227b
        longa
        lda     near w7e8254
        tay
        clc
        adc     #$0018
        sta     near w7e8254
        lda     #$0008
        sta     $12
@2256:  lda     [z64],y
        sta     ($10)
        inc     $10
        inc     $10
        iny2
        dec     $12
        bne     @2256
        lda     #$0008
        sta     $12
@2269:  lda     [z64],y
        and     #$00ff
        sta     ($10)
        inc     $10
        inc     $10
        iny
        dec     $12
        bne     @2269
        bra     @229b
@227b:  longa
        lda     near w7e8254
        tay
        clc
        adc     #$0020
        sta     near w7e8254
        lda     #$0010
        sta     $12
@228d:  lda     [z64],y
        sta     ($10)
        inc     $10
        inc     $10
        iny2
        dec     $12
        bne     @228d
@229b:  pla
        clc
        adc     #$0020
        tay
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load monster graphics ]

LoadMonsterGfx:
@22a5:  ldy     zZero
@22a7:  jsr     CheckMonsterStencilBit
        bcc     @22b1
        jsr     LoadMonsterGfxTile
        bra     @22bc
@22b1:  longa
        tya
        clc
        adc     #$0020
        tay
        shorta0
@22bc:  dec     near w7e8252
        bne     @22a7
        stz     near w7e824d
        lda     near w7e8251
        sta     near w7e8252
        longa
        lda     z61
        clc
        adc     #$0200
        sta     z61
        shorta0
        dec     near w7e8253
        bne     @22a5
        rts

; ------------------------------------------------------------------------------

; [ load monster palettes ]

LoadMonsterPal:
@22dd:  longa
        stz     $10
        ldx     zZero
@22e3:  lda     near w7e8117,x     ; monster palette
        cmp     #$ffff
        beq     @2302       ; branch if no palette
        ldy     zZero
@22ed:  cmp     near w7e8123,y     ; compare to already loaded palettes
        beq     @2302       ; branch if palette is already loaded
        iny2
        cpy     #$000c
        bne     @22ed
        ldy     $10
        sta     near w7e8123,y     ; add palette
        iny2
        sty     $10
@2302:  inx2                ; next monster
        cpx     #$000c
        bne     @22e3
        ldx     zZero
@230b:  lda     near w7e8117,x     ; monster palette
        ldy     zZero
@2310:  cmp     near w7e8123,y     ; find which palette it is (should be 0, 1, or 2)
        beq     @231e
        iny2
        cpy     #$0006
        bne     @2310
        ldy     zZero         ; use palette 0 if not found
@231e:  tya
        lsr
        asl
        sta     near w7e80db,x     ; set sprite data
        lda     #$0031
        sta     near w7e80db+1,x
        lda     #$0020
        sta     near w7e80ff+1,x     ;
        inx2
        cpx     #$000c
        bne     @230b
        lda     #near w7e7e00::_8
        sta     $10         ; +$10 = pointer to palette buffer
        ldy     zZero
@233e:  lda     near w7e8123,y     ; palette index
        asl4
        tax
        phy
        ldy     zZero
@2349:  lda     f:MonsterPal,x
        sta     ($10),y
        inx2
        iny2
        cpy     #$0020
        bne     @2349
        lda     $10         ; next palette
        clc
        adc     #$0020
        sta     $10
        ply
        iny2
        cpy     #$0006      ; only 3 palettes will get loaded
        bne     @233e
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1236c:
one_monster_chr_set_mode7:
@236c:  ldy     #$c500

_c1236f:
one_monster_chr_set_mode72:
@236f:  sty     $14
        lda     #$7f
        sta     $16
        stz     $18
        clr_ax
        stx     $1a
@237b:  ldy     zZero
        stz     $1c
@237f:  jsr     CheckMonsterStencilBit
        bcc     @2399
        jsr     LoadMonsterGfxTile
        phy
        ldy     $1a
        lda     $18
        sta     [$14],y
        iny2
        sty     $1a
        inc     $18
        inc     $1c
        ply
        bra     @23a5
@2399:  phy
        ldy     $1a
        lda     #$3f
        sta     [$14],y
        iny2
        sty     $1a
        ply
@23a5:  dec     near w7e8252
        bne     @237f
        stz     near w7e824d
        lda     near w7e8251
        sta     near w7e8252
        lda     $1c
        longa
        asl5
        sta     $1c
        lda     $14
        clc
        adc     #$0100
        sta     $14
        lda     z61
        clc
        adc     $1c
        sta     z61
        stz     $1a
        shorta0
        dec     near w7e8253
        bne     @237b
        rts

; ------------------------------------------------------------------------------

; [  ]

_c123d8:
get_mode7_poi:
@23d8:  stx     $10
        jsr     ClearMonsterGfxBuf
        jsr     LoadSummonGfxProp
        jmp     LoadSummonStencil

; ------------------------------------------------------------------------------

; [  ]

_c123e3:
tfr_mode7:
@23e3:  lda     #$3f
        sta     $14
        lda     #^w7eae3f
        ldx     #near w7eae3f
        jsl     _c2c027
        ldx     #$2000
        stx     $10
        ldx     #$c400
        ldy     #$0000
        lda     #$7f
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [  ]

_c12400:
summon_mode7_chr_set_long:
@2400:  jsr     _c123d8
        jsr     _c1236c
        jsr     _c123e3
        rtl

; ------------------------------------------------------------------------------

; [  ]

_c1240a:
jiha_bg_chr_set_long:
@240a:  jsr     _c123d8
        ldy     #$ca00
        jsr     _c1236f
        phb
        lda     #$7f
        pha
        plb
        clr_ax
@241a:  lda     $ca10,x
        sta     $ce00,x
        lda     #$3f
        sta     $ca10,x
        lda     $cb10,x
        sta     $cf00,x
        lda     #$3f
        sta     $cb10,x
        lda     $cc10,x
        sta     $d000,x
        lda     #$3f
        sta     $cc10,x
        lda     $cd10,x
        sta     $d100,x
        lda     #$3f
        sta     $cd10,x
        inx2
        cpx     #$0010
        bne     @241a
        plb
        jsr     _c123e3
        rtl

; ------------------------------------------------------------------------------

; [ load esper graphics (bg1, long access) ]

LoadSummonGfxBG1_far:
@2452:  jsr     LoadSummonGfxBG1
        rtl

; ------------------------------------------------------------------------------

; [ load esper graphics (bg1) ]

; +X: graphics index

.if ROM_VERSION >= 1

LoadSummonGfxSprite:
@244d:  jsr     LoadSummonGfx
        ldy     #$2400
        ldx     #$1400
        bra     _245c

LoadSummonGfxBG1:
@2455:  jsr     LoadSummonGfx
        ldy     #$0000

.else

LoadSummonGfxBG1:
@2456:  jsr     LoadSummonGfx

.endif

        ldx     #$1800      ; size = $1800 (6 rows of 16x16 tiles)
_245c:  stx     $10
        ldx     #near w7eae3f      ; source = $7eae3f

.if ROM_VERSION < 1
; *** removed in rev 1 ***
        ldy     #$0000      ; destination = $0000-$0BFF (vram)
; ************************
.endif

        lda     #$7e
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ load crusader graphics (bg1) ]

; small part only

_c22469:
jiha_obj_chr_set_long:
@2469:  ldx     #GENJU_GFX::CRUSADER_1
        jsr     LoadSummonGfx
        ldx     #$0800      ; size = $0800
        stx     $10
        ldx     #near w7eae3f      ; source = $7eae3f
        ldy     #$2000      ; destination = $2000 (vram)
        lda     #^w7eae3f
        jsr     WaitTfrVRAM
        rtl

; ------------------------------------------------------------------------------

; [ load esper graphics (sprite, long access) ]

LoadSummonGfxSprite_far:
@2480:  jsr     LoadSummonGfxSprite
        rtl

; ------------------------------------------------------------------------------

; [ load esper graphics (sprite) ]

; +X: graphics index

.if ROM_VERSION < 1

LoadSummonGfxSprite:
@2484:  jsr     LoadSummonGfx
        ldx     #$1400      ; size = $1400 (5 rows of 16x16 tiles)
        stx     $10
        ldx     #near w7eae3f      ; source = $7eae3f
        ldy     #$2400      ; destination = $2400-$2DFF (vram)
        lda     #^w7eae3f
        jmp     WaitTfrVRAM

.endif

; ------------------------------------------------------------------------------

; [ copy esper graphics to buffer ]

; also used for sketched monster graphics
; +X: graphics index

LoadSummonGfx:

.if ROM_VERSION >= 1
; **** added in rev 1 ****
        phx
; ************************
.endif

@2497:  stx     $10
        jsr     ClearMonsterGfxBuf
        jsr     LoadSummonGfxProp
        jsr     LoadSummonStencil

.if ROM_VERSION < 1
; *** removed in rev 1 ***
        jmp     LoadMonsterGfx

.else
; **** added in rev 1 ****
        jsr     LoadMonsterGfx
        plx
        rts
; ************************
.endif

; ------------------------------------------------------------------------------

; [  ]

; unused

summon_obj_chr_set2_long:
@24a5:  jsr     _c124a9
        rtl

; ------------------------------------------------------------------------------

; unused

_c124a9:
summon_obj_chr_set2:
@24a9:  jsr     LoadSummonGfx
        clr_a
@24ad:  tax
        pha
        longa
        lda     #$0180
        sta     $10
        lda     f:_c2d471+2,x
        tay
        lda     f:_c2d471,x
        tax
        shorta0
        lda     #$7e
        jsr     WaitTfrVRAM
        pla
        clc
        adc     #$04
        cmp     #$28
        bne     @24ad
        rts

; ------------------------------------------------------------------------------

; [ load sketched monster graphics ]

LoadSketchMonsterGfx:
@24d1:  jsr     LoadSummonGfx

.if ROM_VERSION >= 1
; **** added in rev 1 ****
        cpx     #$ffff
        bne     @24d4
        jsr     ClearMonsterGfxBuf
; ************************
.endif

@24d4:  ldx     #$2000
        stx     $10
        ldx     #near w7eae3f
        ldy     #$0000
        lda     #^w7eae3f
        jsr     WaitTfrVRAM
        rtl

; ------------------------------------------------------------------------------

; [ load esper graphics map ]

LoadSummonStencil:
@24e5:  jsr     InitStencil
        lda     near w7e8251       ; graphics width
        sta     near w7e616b
        lda     near w7e8253       ; graphics height
        sta     near w7e616c
        rts

; ------------------------------------------------------------------------------

; [ load esper graphics properties ]

LoadSummonGfxProp:
@24f5:  longa
        lda     $10

.if ROM_VERSION >= 1
; **** added in rev 1 ****
        cmp     #$ffff
        bne     @24f9
        clr_a
; ************************
.endif

@24f9:  asl2
        clc
        adc     $10
        tax
        lda     f:MonsterGfxProp+2,x   ; pointer to esper palette
        xba
        and     #$03ff
        asl4
        sta     near w7e6169       ; pointer to esper palette
        lda     f:MonsterGfxProp,x
        and     #$7fff
        sta     near w7e81a8
        shorta0
        lda     f:MonsterGfxProp+1,x
        and     #$80
        sta     near w7e81ac
        lda     f:MonsterGfxProp+2,x
        lsr
        ora     near w7e81ac
        sta     near w7e81ac
        lsr5
        and     #$01
        sta     near w7e81ab
        lda     f:MonsterGfxProp+4,x
        sta     near w7e81aa
        lda     #^MonsterVRAMMapPtrs
        sta     $14
        lda     #$06
        asl
        tax
        longa
        lda     f:MonsterVRAMMapPtrs,x
        sta     $12
        lda     [$12]
        clc
        adc     #near w7eae3f
        sta     z61
        inc     $12
        inc     $12
        lda     [$12]
        sta     near w7e8256
        lda     near w7e81a8
        asl3
        sta     z64
        stz     near w7e8254
        shorta0
        lda     near w7e81a8+1
        lsr5
        sta     $66
        jmp     AddMonsterGfxOffset

; ------------------------------------------------------------------------------

; [ load monster graphics ]

InitMonsterGfx:
@257c:  jsr     ClearMonsterGfxBuf
        clr_ax
        lda     #$ff
@2583:  sta     near w7e8117,x     ; clear monster palettes, ???, and sizes
        sta     near w7e8123,x
        inx
        cpx     #$000c
        bne     @2583
        stz     near w7e8258       ; start with monster slot 0
@2592:  lda     near w7e8258       ; monster slot
        asl
        tax
        lda     near w7e2001 + 1,x     ; monster number
        cmp     #$ff
        beq     @25b2       ; branch if no monster
        phx
        phx
        lda     near w7e8258       ; monster slot
        jsr     LoadMonsterGfxProp
        plx
        jsr     LoadMonsterStencil
        jsr     LoadMonsterGfx
        plx
        jsl     LoadTrainGfx
@25b2:  inc     near w7e8258       ; next monster
        lda     near w7e8258
        cmp     #$06
        bne     @2592
        rts

; ------------------------------------------------------------------------------

; [ copy monster graphics to vram (long access) ]

; unused

WaitTfrMonsterGfx_far:
@25bd:  jsr     WaitTfrMonsterGfx
        rtl

; ------------------------------------------------------------------------------

; [ copy monster graphics to vram (at next vblank) ]

WaitTfrMonsterGfx:
@25c1:  ldx     #$2000
        stx     $10
        ldx     #near w7eae3f
        ldy     #$3000
        lda     #^w7eae3f
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ copy monster graphics to vram (immediately) ]

; used during battle init only

TfrMonsterGfx:
@25d1:  ldx     #$2000
        stx     $36
        ldx     #near w7eae3f
        ldy     #$3000
        lda     #^w7eae3f
        jmp     TfrVRAM

; ------------------------------------------------------------------------------

        .pushseg
        .include "monster_overlap.asm"
        .popseg

; ------------------------------------------------------------------------------
