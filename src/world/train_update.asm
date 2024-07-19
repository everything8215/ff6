; ------------------------------------------------------------------------------

; [ update magitek train ride graphics ]

; this subroutine executes every 4 frames

; TODO: move these to a WRAM include file
        wMagitekTrainTile0 := $7f01e0
        wMagitekTrainTile1 := $7f0300
        wMagitekTrainTile2 := $7f03c0
        wMagitekTrainTile3 := $7f0420
        wMagitekTrainTile4 := $7f0480
        wMagitekTrainTile5 := $7f04e0
        wMagitekTrainTile6 := $7f0510
        wMagitekTrainTile7 := $7f0540
        wMagitekTrainTile8 := $7f0570
        wMagitekTrainTile9 := $7f05a0
        wMagitekTrainTile10 := $7f05d0
        wMagitekTrainTile11 := $7f0600

UpdateTrainGfx:

@hDP := hWMDATA & $ff00

@9f14:  phb
        php
        phd
        shorta
        lda     #$7f
        pha
        plb
        lda     #$00
        sta     f:hWMADDH
        lda     #0
        sta     f:$000024               ; clear vblank flag
        sta     f:$0000fa               ; clear 4 frame counter
        longai
        lda     #@hDP                   ; nonzero dp, don't use clr_a
        tcd
        ldx     #0
@9f36:
.repeat 40,i
        stz     $9618+i*2,x             ; clear graphics buffer
.endrep
        txa                             ; next tile
        clc
        adc     #$0100
        tax
        cmp     #$5000
        jne     @9f36

        ldy     #.loword(wMagitekTrainTile0)

; macro to draw each tile size
.macro update_train_tile tile_id

        .local tile_size, tile_start, temp1, temp2

        .if (tile_id = 10)
                tile_size = 16
        .elseif (tile_id = 9)
                tile_size = 14
        .else
                tile_size = tile_id + 4
        .endif

        temp1 = $8000-(tile_size-1)>>1
        temp2 = .loword(.ident(.sprintf("wMagitekTrainTile%d", tile_id+1)))

@9fbf:  ldx     a:2,y                   ; tile index
        lda     $0814-tile_id*2,x       ; pointer to tile graphics
        sta     <hWMADDL                ; $2181
        ldx     a:0,y                   ; tile position
        .if (tile_id < 10)
        beq     @9ffd
        .else
        jeq     @9ffd                   ; branch if tile is not shown
        .endif
        sty     $0c5c
        ldy     #tile_size
@9fd2:  shorta

.repeat tile_size,i
        lda     <hWMDATA
        beq     :+
        sta     temp1+i,x
:
.endrep

        longa_clc
        txa
        sbc     #$00ff
        tax
        dey
        bne     @9fd2
        ldy     $0c5c
@9ffd:  iny4                            ; next tile
        cpy     #temp2
        .if (tile_id < 9)
        bne     @9fbf
        .else
        jne     @9fbf
        .endif
.endmac

.repeat 11,i
        update_train_tile i
.endrep

@a46b:  lda     #1
        sta     f:$000024
        pld
        plp
        plb
        rts

; ------------------------------------------------------------------------------
