; ------------------------------------------------------------------------------

; [ load ghost train graphics ]

LoadTrainGfx:
@b532:  longa
        lda     near w7e2001,x
        tax
        shorta0
        cpx     #$0106
        beq     @b541
        rtl
@b541:  ldx     #$012c
        stx     $26
        lda     f:BattleBGProp+3,x   ; battle bg tile formation index (in battle bg properties)
        asl
        tax
        lda     f:BattleBGTilesPtrs,x   ; pointer to tile formation
        sta     $f3
        lda     f:BattleBGTilesPtrs+1,x
        sta     $f4
        lda     #^BattleBGTiles
        sta     $f5
        lda     #$00        ; destination = $7fc400
        sta     $f6
        lda     #$c4
        sta     $f7
        lda     #$7f
        sta     $f8
        jsl     Decompress_ext
        ldx     $26
        lda     f:BattleBGProp,x   ; battle bg graphics index 1 (in battle bg properties)
        and     #$7f
        sta     $22
        asl
        clc
        adc     $22
        tax
        lda     f:BattleBGGfxPtrs,x   ; pointer to battle bg graphics 1
        sta     $f3
        lda     f:BattleBGGfxPtrs+1,x
        sta     $f4
        lda     f:BattleBGGfxPtrs+2,x
        sta     $f5
        ldx     $26
        lda     f:BattleBGProp+2,x   ; battle bg graphics index 3 (in battle bg properties)
        and     #$7f
        sta     $22
        asl
        clc
        adc     $22
        tax
        lda     f:BattleBGGfxPtrs,x   ; pointer to battle bg graphics 3
        sta     $f6
        lda     f:BattleBGGfxPtrs+1,x
        sta     $f7
        lda     f:BattleBGGfxPtrs+2,x
        sta     $f8
        longa
        stz     $10
        clr_ax
@b5b4:  lda     $7fc400,x   ; tile formation
        and     #$01ff
        cmp     #$0100
        bcc     @b5e4       ; branch if tile index < 256 (graphics 1)
        and     #$00ff
        sec
        sbc     #$0080
        asl5
        tay
        phx
        lda     #$0010
        sta     $12
        ldx     $10
@b5d5:  lda     [$f6],y     ; copy tile from graphics 3
        sta     near w7eae3f,x
        iny2
        inx2
        dec     $12
        bne     @b5d5
        bra     @b5ff
@b5e4:  asl5
        tay
        phx
        lda     #$0010
        sta     $12
        ldx     $10
@b5f2:  lda     [$f3],y     ; copy tile from graphics 1
        sta     near w7eae3f,x
        iny2
        inx2
        dec     $12
        bne     @b5f2
@b5ff:  stx     $10         ; next tile (256 tiles total)
        plx
        inx2
        cpx     #$0200
        bne     @b5b4
        shorta0
        rtl

; ------------------------------------------------------------------------------
