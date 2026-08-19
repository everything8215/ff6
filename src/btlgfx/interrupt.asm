.scope HDMAProp
        COUNT = 11
.endscope

; ------------------------------------------------------------------------------

; [ update hdma #3 and #5 ]

_c102fa:
@02fa:  lda     near w7e7b95       ; branch if hdma #3 doesn't need to be updated
        beq     @0328
        cmp     #$01
        beq     @0308       ; branch if slot
        ldx     #array_offset HDMAProp, 3
        bra     @030b
@0308:  ldx     #array_offset HDMAProp, 7
@030b:  stz     near w7e7b95       ; disable hdma #3 update
        phb
        lda     #$00
        pha
        plb
        tay
@0314:  lda     f:HDMAProp,x
        sta     hDMA3,y
        iny
        inx
        cpy     #5
        bne     @0314
        lda     #$7e
        sta     hDMA3::HDMA_B
        plb
@0328:  lda     near w7e7b96       ; branch if hdma #5 doesn't need to be updated
        beq     @0346
        stz     near w7e7b96       ; disable hdma #5 update
        clr_ax
@0332:  lda     f:HDMAProp::_10,x
        sta     f:hDMA5,x   ; set hdma #5 registers
        inx
        cpx     #5
        bne     @0332
        lda     #$7e
        sta     f:hDMA5::HDMA_B
@0346:  rts

; ------------------------------------------------------------------------------

; [ update hdma #7 ]

_c10347:
@0347:  longa
        lda     f:HDMAProp::_9     ; set hdma #7 registers
        sta     f:hDMA7::CTRL
        lda     f:HDMAProp::_9 + 2
        sta     f:hDMA7::ADDR
        shorta0
        lda     f:HDMAProp::_9 + 4
        sta     f:hDMA7::ADDR_B
        lda     #$7e
        sta     f:hDMA7::HDMA_B
        lda     near w7e7bef       ; enable hdma channel #7
        ora     #BIT_7
        sta     near w7e7bef
        rts

; ------------------------------------------------------------------------------

; [ update hdma #6 ]

_c10373:
@0373:  lda     near w7e7b97       ; branch if hdma #6 doesn't need to be updated
        beq     @03a1
        cmp     #$01
        beq     @0381       ; branch if slot
        ldx     #array_offset HDMAProp, 6
        bra     @0384
@0381:  ldx     #array_offset HDMAProp, 8
@0384:  stz     near w7e7b97       ; disable hdma #6 update
        phb
        lda     #$00
        pha
        plb
        tay
@038d:  lda     f:HDMAProp,x
        sta     hDMA6,y     ; set hdma #6 registers
        iny
        inx
        cpy     #5
        bne     @038d
        lda     #$7e
        sta     hDMA6::HDMA_B
        plb
@03a1:  rts

; ------------------------------------------------------------------------------

; [ init hdma ]

InitHDMA:
@03a2:  phb
        lda     #$00
        pha
        plb

; load the initial hdma properties for channels #0 through #6
        clr_axy
@03aa:  lda     #5
        sta     $10
@03ae:  lda     f:HDMAProp,x
        sta     hDMA0,y
        inx
        iny
        dec     $10
        bne     @03ae
        lda     #$7e
        sta     hDMA0+2,y
        tya
        clc
        adc     #11
        tay
        cpx     #array_offset HDMAProp, 7
        bne     @03aa
        plb
        lda     #BG_SCROLL_HDMA::DEFAULT_BG1
        sta     near w7e800c
        lda     #BG_SCROLL_HDMA::DEFAULT_BG2
        sta     near w7e800d
        lda     #BG_SCROLL_HDMA::DEFAULT_BG3
        sta     near w7e800e
        jsr     _c103fb
        lda     #%01111111              ; enable hdma channels #0 through #6
        sta     near w7e7bef
; fallthrough

; ------------------------------------------------------------------------------

; [ set battle bg hdma scroll type ]

_c103e2:
@03e2:  lda     near w7eecb8
        cmp     #BATTLE_BG::TRAIN_EXT
        beq     @03f5
        cmp     #BATTLE_BG::MAGITEK_TRAIN
        beq     @03f5
        cmp     #BATTLE_BG::CYANS_DREAM
        bne     @03fa
        lda     #BG_SCROLL_HDMA::CYANS_DREAM_BG2
        bra     @03f7
@03f5:  lda     #BG_SCROLL_HDMA::TRAIN_BG2
@03f7:  sta     near w7e800d
@03fa:  rts

; ------------------------------------------------------------------------------

; [ update hdma #0, #1, and #2 ]

_c103fb:
hdma_line_data_set:
@03fb:  lda     near w7e800c
        bmi     @0419
        ora     #$80
        sta     near w7e800c
        and     #$7f
        asl
        tax
        lda     f:BGScrollHDMATbl,x
        sta     f:hDMA0::ADDR_L
        lda     f:BGScrollHDMATbl+1,x
        sta     f:hDMA0::ADDR_H
@0419:  lda     near w7e800d
        bmi     @0437
        ora     #$80
        sta     near w7e800d
        and     #$7f
        asl
        tax
        lda     f:BGScrollHDMATbl,x
        sta     f:hDMA1::ADDR_L
        lda     f:BGScrollHDMATbl+1,x
        sta     f:hDMA1::ADDR_H
@0437:  lda     near w7e800e
        bmi     @0459
        ora     #$80
        sta     near w7e800e
        clc
        adc     near w7e7b8a
        and     #$7f
        asl
        tax
        lda     f:BGScrollHDMATbl,x
        sta     f:hDMA2::ADDR_L
        lda     f:BGScrollHDMATbl+1,x
        sta     f:hDMA2::ADDR_H
@0459:  lda     near w7e7bef
        sta     f:hHDMAEN
        rts

; ------------------------------------------------------------------------------

_c10461:
@0461:  .addr   w7e9213,w7e9013,w7e9213,w7e9413

; ------------------------------------------------------------------------------

; [ load "short" menu window tile data ]

_c10469:
@0469:  lda     near w7e64b8       ; return if window mode is not short
        beq     @04c9
        lda     near w7e64b9       ;
        bne     @0478
        lda     #$08
        sta     near w7e64b9
@0478:  lda     z98         ; frame counter
        and     #%111
        asl
        tax
        longa
        lda     f:_c2d2a4,x
        sta     f:hVMADDL
        phx
        lda     near w7e64b8
        and     #$00ff
        asl
        tax
        lda     f:_c10461,x
        plx
        clc
        adc     f:_c2d2b4,x
        sta     f:hDMA7::ADDR
        lda     #$0040
        sta     f:hDMA7::SIZE
        shorta0
        lda     #$7e
        sta     f:hDMA7::ADDR_B
        lda     #$01
        sta     f:hDMA7::CTRL
        lda     #<hVMDATAL
        sta     f:hDMA7::HREG
        lda     #BIT_7
        sta     f:hMDMAEN
        dec     near w7e64b9
        bne     @04c9
        stz     near w7e64b8
@04c9:  rts

; ------------------------------------------------------------------------------

; [ copy menu window tile data to vram ]

UpdateMenuWindowTiles:
@04ca:  lda     near wEnableUpdateMenuWindowTiles
        beq     @050b                   ; return if menu window update is disabled
        inc     near w7e629b       ;
        lda     near w7e62aa       ; branch if copying a special number of strips
        bne     @04dc
        lda     #8              ; copy 8 strips (default)
        sta     near w7e62aa
@04dc:  lda     z98         ; frame counter
        and     #%111
        asl
        tax
        longa
        lda     near w7e7bbe       ; pointer to menu tile data in vram (bg2)
        clc
        adc     f:_c2d294,x   ; add strip offset
        tay
        lda     near w7e7bc0       ; pointer to menu tile data buffer in ram (bg2)
        clc
        adc     f:_c2d2b4,x   ; add strip offset
        tax
        lda     #$0040      ; size = 32 tiles (8x8)
        sta     $36
        shorta0
        lda     #$7e
        jsr     TfrVRAM
        dec     near w7e62aa       ; next strip
        bne     @050b
        stz     near wEnableUpdateMenuWindowTiles       ; disable menu window update
@050b:  rts

; ------------------------------------------------------------------------------

; [  ]

_c1050c:
nmi_player_mp_set:
@050c:  clr_ax
        lda     near w7e62ca
@0511:  cmp     near w7e64d6,x
        beq     @051e
        inx
        cpx     #4
        bne     @0511
        clr_ax
@051e:  lda     f:_c2d364,x
        tax
        clr_ay
@0525:  lda     near w7e5ca5,x
        cmp     #$15
        beq     @052f                   ; branch if slash
        clc
.if LANG_EN
        adc     #$54
.else
        adc     #$b5
.endif
@052f:  sta     near w7e5d15,y
        iny2
        inx2
        cpy     #7 * 2
        bne     @0525
        stz     $40
        stz     $41
        lda     near w7e6178
@0542:  sec
        sbc     #100
        bcc     @054b
        inc     $40
        bra     @0542
@054b:  clc
        adc     #100
@054e:  sec
        sbc     #10
        bcc     @0557
        inc     $41
        bra     @054e
@0557:  clc
        adc     #$12
.if LANG_EN
        sta     near w7e5d23 + 4
        lda     #$02
        sta     near w7e5d23 + 5
        sta     near w7e5d23 + 3
        sta     near w7e5d23 + 1
        lda     $41
        clc
        adc     #$08
        sta     near w7e5d23 + 2
        lda     $40
        clc
        adc     #$08
        sta     near w7e5d23
        cmp     #$08
        bne     @0584
        lda     #$ff
        sta     near w7e5d23
        stz     near w7e5d23 + 1
@0584:  lda     $41
        bne     @0590
        lda     #$ff
        sta     near w7e5d23 + 2
        stz     near w7e5d23 + 3
.else
        sta     near w7e5d23 + 8
        lda     $41
        clc
        adc     #$08
        sta     near w7e5d23 + 6
        lda     $40
        clc
        adc     #$08
        sta     near w7e5d23 + 4
        lda     #$02
        sta     near w7e5d23 + 9
        sta     near w7e5d23 + 7
        sta     near w7e5d23 + 5
.endif

@0590:  rts

; ------------------------------------------------------------------------------

; pointers to bg1 tile data in vram (4 quadrants of bg1, ???, ???, 2 quadrants of bg3)
_c10591:
@0591:  .word   $0c00,$0c10,$0e00,$0e10
        .word   $2800,$2000,$5400,$5410

; ------------------------------------------------------------------------------

; [ copy animation bg tile data to vram ]

_c105a1:
@05a1:  lda     near w7e7b15       ; branch if bg1 animation tile data doesn't need to be updated
        beq     @05e3
        stz     near w7e7b15       ; validate bg1 animation tile data
        lda     near w7e60a7       ; branch if bg1 animation is hidden
        bne     @05ca
        lda     near w7e62c8       ; tile data quadrant
        asl
        tax
        longa
        lda     f:_c10591,x   ; +$36 = pointer to tile data in vram
        sta     $36
        shorta0
        stz     near w7e62c8       ; clear quadrant (top-left)
        lda     near w7e7b1a_B       ; pointer to animation tile data buffer
        ldx     near w7e7b1a
        jsr     _c11a51       ; copy animation bg tile data to vram
@05ca:  longa
        lda     near w7e7b16       ; x position
        sec
        sbc     near w7e7b1d       ; x offset
        sta     near w7e64b4       ; bg1 horizontal scroll position
        lda     near w7e7b18       ; y position
        sec
        sbc     near w7e7b1f       ; y offset
        sta     near w7e64b6       ; bg1 vertical scroll position
        shorta0
@05e3:  lda     near w7e7b21       ; branch if bg3 animation tile data doesn't need to be updated
        beq     @063f
        stz     near w7e7b21       ; validate bg3 animation tile data
        lda     near w7e60a8       ; branch if bg3 animation is hidden
        bne     @061d
        lda     near w7e62c9       ; tile data quadrant
        beq     @060c       ; branch if top-left
        cmp     #$01
        beq     @0607       ; branch if top-right
        cmp     #$02
        beq     @0602       ; branch if bottom-left
        ldy     #$5610      ; bottom-right
        bra     @060f
@0602:  ldy     #$5600      ; bottom-left
        bra     @060f
@0607:  ldy     #$5410      ; top-right
        bra     @060f
@060c:  ldy     #$5400      ; top-left
@060f:  stz     near w7e62c9       ; clear quadrant
        lda     near w7e7b26_B       ; pointer to tile data buffer
        ldx     near w7e7b26
        sty     $36         ; vram destination
        jsr     _c11a51       ; copy animation bg tile data to vram
@061d:  lda     near w7e800e       ; bg3 scroll hdma index
        and     #$7f
        cmp     #BG_SCROLL_HDMA::DEFAULT_BG3        ; return if not 5
        bne     @063f
        longa
        lda     near w7e7b22       ; x offset
        sec
        sbc     near w7e7b29       ; subtract x position
        sta     near wBG3ScrollData::Horz       ; bg3 horizontal scroll position
        lda     near w7e7b24       ; y offset
        sec
        sbc     near w7e7b2b       ; subtract y position
        sta     near wBG3ScrollData::Vert       ; bg3 vertical scroll position
        shorta0
@063f:  rts

; ------------------------------------------------------------------------------

; [ copy damage numeral graphics to vram ]

_c10640:
@0640:  lda     near w7e6316       ; return if damage numeral graphics update is disabled
        beq     @0658
        stz     near w7e6316       ; disable damage numeral graphics update
        ldx     #$0080
        stx     $36         ; size = $0080 (4 8x8 tiles)
        ldx     #near w7e60b3
        lda     #^w7e60b3
        ldy     near w7e6317       ; source = $7e60b3 (graphics buffer)
        jmp     TfrVRAM
@0658:  rts

; ------------------------------------------------------------------------------

; [  ]

_c10659:
cur_poi_set:
@0659:  shorti
        stz     near w7e7b6b
        clr_ax
        longa
@0662:  lda     near w7e812f,x
        and     #$00ff
        asl3
        lsr
        clc
        adc     near w7e80c3,x
        sta     near w7e800f,x
        lda     near w7e812f+1,x
        and     #$00ff
        asl3
        sta     $36
        lsr
        clc
        adc     near w7e80cf,x
        sta     near w7e801b,x
        lda     $36
        clc
        adc     near w7e80cf,x
        sec
        sbc     #$0008
        sta     near w7e8027,x
        clc
        adc     near w7e8057,x
        sta     near w7e804b,x
        lda     near w7e80c3,x
        sec
        sbc     #$0008
        clc
        adc     near w7e807b,x
        sta     near w7e8063,x
        lda     near w7e812f+1,x
        and     #$00ff
        asl3
        lsr
        clc
        adc     near w7e80cf,x
        sta     near w7e806f,x
        inx2
        cpx     #$0c
        bne     @0662
        clr_axy
@06c2:  lda     near wCharGfxData::PosX,x
        clc
        adc     near wCharGfxData::OffsetX,x
        clc
        adc     near wCharGfxData::AnimOffsetX,x
        sta     $36
        sec
        sbc     #$0010
        clc
        adc     near w7e809f,y
        sta     near w7e8087,y
        lda     $36
        clc
        adc     #$0008
        sta     near w7e8033,y
        lda     near wCharGfxData::PosY,x
        clc
        adc     near wCharGfxData::OffsetY,x
        clc
        adc     #$0008
        sta     near w7e8093,y
        sta     near w7e803b,y
        adc     #$0008
        sta     near w7e8043,y
        txa
        clc
        adc     #$0020
        tax
        iny2
        cpy     #$08
        bne     @06c2
        shorta0
        longi
        lda     near w7e2f47
        not_a
        sta     near w7e6193
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e2f47
        beq     @078e
        jsr     GetBitNum
        asl
        tax
        lda     near w7e201f
        longa
        cmp     #BATTLE_TYPE::BACK
        bne     @0736
        lda     near w7e8087,x
        sec
        sbc     #$0020
        bra     @073d
@0736:  lda     near w7e8087,x
        clc
        adc     #$0020
@073d:  sta     near w7e8063+10
        lda     near w7e8093,x
        sta     near w7e806f+10
        lda     near w7e8033,x
        sta     near w7e800f+10
        lda     near w7e803b,x
        sta     near w7e801b+10
        lda     near w7e8043,x
        sta     near w7e8027+10
        lda     near w7e8033,x
        sec
        sbc     #$000c
        sta     near w7e80c3+10
        lda     near w7e803b,x
        sec
        sbc     #$0008
        sta     near w7e80cf+10
        lda     #$0032
        sta     near w7e812f+10
        lda     near w7e201f
        and     #1
        eor     #1
        sta     near w7e807b+10              ; 0 if back or side, 1 if normal or pincer
        shorta0
        lda     #$20
        sta     near w7e6195
        ora     near w7e7b79
        sta     near w7e7b79
        bra     @0791
@078e:  stz     near w7e6195
@0791:  lda     #$ff
        and     near w7e201e
        and     near w7e61ab
        and     near w7e2f46
        ora     near w7e6195
        sta     a:z92
        rts

; ------------------------------------------------------------------------------

; [ clear sprite data ]

; does not clear cursor sprites

ClearSpriteData:
@07a3:  shorti
        clr_ax
@07a7:  sta     $0501,x
        inx
        cpx     #$1b
        bne     @07a7
        lda     #$80
        sta     $051c
        longa
        clr_ax
        lda     #$e0e0
@07bb:  sta     $0320,x
        sta     $0354,x
        sta     $0388,x
        sta     $03bc,x
        sta     $03f0,x
        sta     $0424,x
        sta     $0458,x
        sta     $048c,x
        inx4
        cpx     #$34
        bne     @07bb
        sta     $04c0
        sta     $04c4
        sta     $04c8
        shorta0
        longi
        rts

; ------------------------------------------------------------------------------

; [ update window and bg scroll hdma data ]

UpdateScrollHDMA:
        lda     near w7e6283       ; wavy battle bg (desert)
        tax
        stx     $44

; update window 2 hdma data
        shorti
        longa
        lda     near w7e6197
        beq     @081e
        stz     near w7e6197
        clr_ax
@07fe:  .repeat 4, i
        lda     near w7e9a1f + 2 + 38 * 4 * i,x
        sta     near w7e9f1f + 2 + 38 * 4 * i,x
        .endrep
        inx4
        cpx     #38 * 4
        bne     @07fe

@081e:  stz     $34
        shorta0
        tax
        lda     near w7e800c       ; bg1 scroll hdma index
        and     #$7f
        cmp     #BG_SCROLL_HDMA::WAVE_32_BG1
        bne     @0831
        inc     $34
        bra     @0839
@0831:  cmp     #BG_SCROLL_HDMA::WAVE_64_BG1
        bne     @0839
        lda     #$80
        sta     $35
@0839:  longa
        lda     near w7e64b0                 ; battle bg scroll position
        sta     $36
        lda     near w7e64b2
        sta     $38
        lda     near w7e800c
        and     #$007f
        beq     @0878
        lda     near w7e62a9                 ; bg1 graphics vram offset
        and     #$00ff

; bg1 uses bg2 scroll position (50 Gs, Confuser, Revenger, Shadow Edge)
        beq     @0867
        lda     near w7e64b0
        sta     $3a
        sta     near wBG1ScrollData::Horz
        lda     near w7e64b2
        sta     $3c
        sta     near wBG1ScrollData::Vert
        bra     @0878

; normal bg1
@0867:  lda     near w7e64b4
        sta     $3a
        sta     near wBG1ScrollData::Horz
        lda     near w7e64b6
        dec
        sta     $3c
        sta     near wBG1ScrollData::Vert

; check if ignore battle bg scroll position (never used)
@0878:  lda     near w7e62c1
        and     #$00ff
        beq     @0884
        stz     $36
        stz     $38

; update bg1 scroll hdma data
@0884:  lda     $34
        bpl     @08d2
        .repeat 4, i
        lda     near {array_member w7e63b0, 16 * i, Horz},x
        clc
        adc     $3a
        sta     near {array_member wBG1ScrollData, 16 * i, Horz},x
        lda     near {array_member w7e63b0, 16 * i, Vert},x
        clc
        adc     $3c
        sta     near {array_member wBG1ScrollData, 16 * i, Vert},x
        .endrep
        bra     @08f8
@08d2:  beq     @08f8
        .repeat 2, i
        lda     near {array_member w7e63b0, 16 * i, Horz},x
        clc
        adc     $3a
        sta     near {array_member wBG1ScrollData, 16 * i, Horz},x
        lda     near {array_member w7e63b0, 16 * i, Vert},x
        clc
        adc     $3c
        sta     near {array_member wBG1ScrollData, 16 * i, Vert},x
        .endrep
; update bg2 scroll hdma data
@08f8:  lda     $44
        bne     @0920
        .repeat 2, i
        lda     near {array_member w7e6330, 16 * i, Horz},x
        clc
        adc     $36
        sta     near {array_member wBG2ScrollData, 16 * i, Horz},x
        lda     near {array_member w7e6330, 16 * i, Vert},x
        clc
        adc     $38
        sta     near {array_member wBG2ScrollData, 16 * i, Vert},x
        .endrep
@0920:  inx4
        cpx     #$40
        jne     @0884

; update wavy battle bg
        shorta0
        tay
        lda     z0e
        lsr
        and     #%00111110
        tax
        lda     $44
        beq     @0993                   ; return if no wavy battle bg
        lda     near w7eecb8
        cmp     #BATTLE_BG::CYANS_DREAM
        beq     @095d
        cmp     #BATTLE_BG::TENTACLES
        bne     @0976

; tentacles
        longa
@0946:  lda     near w7ee7ff,x               ; amplitude 2
        sta     near wBG2ScrollData::Vert,y             ; vertical only
        inx2
        txa
        and     #$003f
        tax
        iny4
        cpy     #$80
        bne     @0946
        bra     @0990

; cyan's dream
@095d:  longa
@095f:  lda     near w7ee83f,x               ; amplitude 4
        sta     near wBG2ScrollData::Vert,y             ; vertical only
        inx2
        txa
        and     #$003f
        tax
        iny4
        cpy     #$80
        bne     @095f
        bra     @0990

; desert
@0976:  longa
@0978:  lda     near w7ee7ff,x               ; amplitude 2
        sta     near wBG2ScrollData::Horz,y               ; horizontal and vertical
        sta     near wBG2ScrollData::Vert,y
        inx2
        txa
        and     #$003f
        tax
        iny4
        cpy     #$80
        bne     @0978
@0990:  shorta0
@0993:  longi
        rts

; ------------------------------------------------------------------------------

; [ check pause ]

CheckPause:
@0996:  lda     near wBattleIsPaused
        beq     @09b6                   ; branch if battle is not paused
        lda     near wSfxDisabled
        bne     @09da                   ; branch if sound effects are disabled
        lda     z08 + 1
        cmp     #>JOY_START
        bne     @09da                   ; branch if start button is pressed
        stz     near wBattleIsPaused         ; unpause battle
        clr_a                           ; 0 = unpause music
        sta     f:hAPUIO1
        lda     #$f5                    ; spc command $f5 (pause/unpause music)
        sta     f:hAPUIO0
        bra     @09da
@09b6:
.if LANG_EN
        lda     near wEnableFlashback
        bne     @09dc                   ; return if in flashback mode
.endif
        lda     near wSfxDisabled
        bne     @09dc                   ; return if sound effects are disabled
        lda     near wPauseNotAllowed
        bne     @09dc                   ; return if victory animation or background scrolling
        lda     z08 + 1
        cmp     #>JOY_START
        bne     @09dc                   ; branch if start button is pressed
        lda     #1                      ; 1 = pause music
        sta     near wBattleIsPaused         ; pause battle
        sta     f:hAPUIO1
        lda     #$f5                    ; spc command $f5 (pause/unpause music)
        sta     f:hAPUIO0
@09da:  sec
        rts
@09dc:  clc
        rts

; ------------------------------------------------------------------------------

; [ transfer character sprite graphics to vram ]

; A: character slot

TfrCharGfx:
@09de:  asl
        tax
        longa
        lda     f:CharTopGfxBufPtrs,x
        sta     hDMA7::ADDR
        lda     f:CharBtmGfxBufPtrs,x
        sta     hVMADDL
        ldy     #$0080
        sty     hDMA7::SIZE
        lda     #BIT_7
        sta     hMDMAEN
        lda     f:CharTopGfxVRAMPtrs,x
        sta     hDMA7::ADDR
        lda     f:CharBtmGfxVRAMPtrs,x
        sta     hVMADDL
        sty     hDMA7::SIZE
        lda     #BIT_7
        shorta
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update ppu ]

_c10a16:
@0a16:  clr_a
        pha
        plb
        sta     hHDMAEN       ; disable hdma
        sta     hDMA7::ADDR_B
        sta     hDMA7::HDMA_B
        tay
        lda     hSTAT78       ; latch counters
        lda     #$80
        sta     hINIDISP
        sty     hOAMADDL
        ldx     #$0400
        stx     hDMA7::CTRL       ; copy sprite data to ppu
        ldx     #$0300
        stx     hDMA7::ADDR
        ldx     #$0220
        stx     hDMA7::SIZE
        lda     #BIT_7
        sta     hMDMAEN

; copy bg palettes to ppu (non battle-bg)
        clr_a
        sta     hCGADD
        ldx     #$2202
        stx     hDMA7::CTRL
        ldx     #near w7e7e00
        stx     hDMA7::ADDR
        lda     #^w7e7e00
        sta     hDMA7::ADDR_B
        ldx     #$00a0
        stx     hDMA7::SIZE
        lda     #BIT_7
        sta     hMDMAEN

; copy battle bg palettes to ppu
        ldx     #near wBattleBGPal
        stx     hDMA7::ADDR
        lda     #^wBattleBGPal
        sta     hDMA7::ADDR_B
        ldx     #$0060
        stx     hDMA7::SIZE
        lda     #BIT_7
        sta     hMDMAEN

; copy sprite palettes to ppu
        ldx     #near w7e7e00::_8
        stx     hDMA7::ADDR
        lda     #^(w7e7e00::_8::Color0)
        sta     hDMA7::ADDR_B
        ldx     #$0100
        stx     hDMA7::SIZE
        lda     #BIT_7
        sta     hMDMAEN

; init dma for char and status sprite transfer
        lda     #$01
        sta     hDMA7::CTRL
        lda     #$18
        sta     hDMA7::HREG
        lda     w7e62bd
        bne     @0aec                   ; skip if chars hidden for esper attack

; transfer status gfx to vram (two tiles per frame)
        lda     z98
        and     #%11111
        asl
        tax
        longa
        lda     #$0080
        sta     hDMA7::SIZE
        lda     f:StatusGfxVRAMPtrs,x
        sta     hVMADDL
        lda     f:StatusGfxBufPtrs,x
        sta     hDMA7::ADDR
        shorta0
        lda     #$7f
        sta     hDMA7::ADDR_B
        lda     #BIT_7
        sta     hMDMAEN

; transfer character gfx to vram (one per frame)
        lda     z98
        and     #%11
        sta     $36
        jsr     TfrCharGfx

; forced character gfx transfer to vram
        lda     wForceMagitekGfxTfr
        bne     @0aec                   ; skip if magitek armor needs to be transfered
        lda     wForceCharGfxTfr
        bmi     @0aec
        cmp     $36
        beq     @0ae6
        jsr     TfrCharGfx
@0ae6:  lda     #$ff
        sta     wForceCharGfxTfr

; transfer vertical offset-per-tile data to vram (for slot menu)
@0aec:  ldx     #wOffsetPerTile::V::SIZE
        stx     hDMA7::SIZE
        ldx     #near wOffsetPerTile::V
        stx     hDMA7::ADDR
        ldx     #$4020
        stx     hVMADDL
        lda     #^wOffsetPerTile::V
        sta     hDMA7::ADDR_B
        lda     #BIT_7
        sta     hMDMAEN

; transfer magitek armor graphics to vram
        lda     wForceMagitekGfxTfr
        beq     @0b72
        lda     #^VehicleGfx
        sta     hDMA7::ADDR_B
        longa
        ldy     #$0080
        ldx     #BIT_7
        .repeat 4, i
        lda     wMagitekGfxSrcPtr + i * 2
        sta     hDMA7::ADDR
        lda     wMagitekGfxVRAMPtr + i * 2
        sta     hVMADDL
        sty     hDMA7::SIZE
        stx     hMDMAEN
        .endrep
        shorta0
        sta     wForceMagitekGfxTfr
@0b72:  rts

; ------------------------------------------------------------------------------

; [ update running/fade in/timers ]

_c10b73:
escape_set:
@0b73:  stz     near w7e2f45       ; disable characters running animation
        jsl     UpdateFadeIn
        lda     near w7e2f4b       ; can't run with L+R
        and     #$01
        ora     near w7e629a       ;
        ora     near w7ee9ef       ; battle time stopped
        bne     @0b92       ;
        lda     z0a         ; L+R buttons pressed
        and     #(JOY_L | JOY_R)
        cmp     #(JOY_L | JOY_R)
        bne     @0b92
        inc     near w7e2f45       ; enable characters running animation
@0b92:  ldx     z0e         ; increment frame counter
        inx
        stx     z0e
        jsl     DrawTimer
        stz     zVBlankState            ; mark done waiting for vblank
        lda     near wBattleIsPaused
        bne     @0ba6       ; branch if battle is paused
        jsl     DecTimersMenuBattle_ext
@0ba6:  rts

; ------------------------------------------------------------------------------

; [ battle nmi ]

BattleNMI:
@0ba7:  php
        longai
        pha
        phx
        phy
        phb
        phd
        ldx     #BTLGFX_ZP_START
        phx
        pld
        shorta0
        lda     f:hRDNMI
        lda     zNMIState
        jne     @0d42
        inc     zNMIState
        jsr     _c10a16       ; update ppu
        lda     #$7e
        pha
        plb
        jsr     _c10469       ; load "short" menu window tile data
        jsr     UpdateMenuWindowTiles
        jsr     UpdateMenuTextTiles
        jsr     _c105a1       ; copy animation bg tile data to vram
        jsr     _c10640       ; copy damage numeral graphics to vram
        jsr     PartialTfrVRAM
        jsl     _c2a88f
        lda     near w7eecef       ; branch if timer 0 is disabled
        and     #$40
        beq     @0c17
        longa
        lda     #$78e4      ; vram $78e4 (timer tile data)
        sta     f:hVMADDL
        lda     near w7e6290       ; copy timer tile data to vram
        sta     f:hVMDATAL
        lda     near w7e6292
        sta     f:hVMDATAL
        lda     near w7e6294
        sta     f:hVMDATAL
        lda     near w7e6296
        sta     f:hVMDATAL
        lda     near w7e6298
        sta     f:hVMDATAL
        shorta0
@0c17:  jsr     _c102fa       ; update hdma #3 and #5
        jsr     _c10373
        jsr     _c10347       ; update hdma #7
        jsr     _c103fb
        lda     near w7ee9c4
        sta     f:hM7A
        lda     near w7ee9c4+1
        sta     f:hM7A
        lda     near w7ee9c6
        sta     f:hM7B
        lda     near w7ee9c6+1
        sta     f:hM7B
        lda     near w7ee9c8
        sta     f:hM7C
        lda     near w7ee9c8+1
        sta     f:hM7C
        lda     near w7ee9ca
        sta     f:hM7D
        lda     near w7ee9ca+1
        sta     f:hM7D
        lda     near w7ee9cc
        sta     f:hM7X
        lda     near w7ee9cc+1
        sta     f:hM7X
        lda     near w7ee9ce
        sta     f:hM7Y
        lda     near w7ee9ce+1
        sta     f:hM7Y
        longa
        lda     #$f708
        sta     f:hWH0
        lda     #$00ff
        sta     f:hWH2
        shorta0
        lda     near wBattleIsPaused
        beq     @0c95       ; branch if battle is not paused
        lda     near w7ee9f9       ; screen brightness / 2
        lsr
        bra     @0c98
@0c95:  lda     near w7ee9f9       ; screen brightness
@0c98:  bne     @0c9c       ; branch if 0 brightness
        ora     #$80        ; screen off
@0c9c:  sta     f:hINIDISP
        jsr     UpdateScrollHDMA
        jsr     CheckPause
        bcs     @0d03       ; branch if battle is paused
        lda     near wMenuIsOpen
        beq     @0cbc       ; branch if menu is not open
        ldx     near w7e62ca       ; active character
        lda     near wMenuQueue,x     ; character menu order
        cmp     #$ff
        bne     @0cbc       ; branch if menu is open
        lda     #1
        sta     near wCloseMenu       ; close menu
@0cbc:  jsr     ClearSpriteData
        lda     #$08        ; next available sprite = 8
        sta     z71
        jsr     UpdateMonsterRoulette
        jsr     UpdateSprites
        jsr     _c10659       ; update character/monster positions
        jsr     DrawCursorSprites
        jsr     UpdateCharGfx
        jsr     _c1050c
        lda     near w7e62bf       ; branch if character color palettes are up to date
        bne     @0cdd
        jsr     UpdateCharPal
@0cdd:  jsr     _c15b14       ; update menu windows
        jsr     _c15a5c       ; update menu text
        lda     near w7e7b85       ; branch if menu doesn't open instantly
        beq     @0cf4
        jsr     _c15b14       ; update menu windows
        jsr     _c15a5c       ; update menu text
        jsr     _c15b14       ; update menu windows
        jsr     _c15a5c       ; update menu text
@0cf4:  jsr     UpdateMenuInput
        jsr     UpdateSfx
        jsr     _c10b73       ; update running/fade in/timers
        phb
        jsl     IncGameTime_ext
        plb

; update shaking screen (branch here if game is paused)
@0d03:  clr_a
        longa
        lda     a:z0e       ; frame counter
        and     #%1111
        tax
        lda     near w7e6285       ; branch if screen shaking is disabled
        and     #$00ff
        beq     @0d34
        cmp     #$0080
        beq     @0d27       ; branch if horizontal shaking only (final battle scrolling)
        lda     f:ScreenShakeTbl+1,x
        and     #$00ff
        ora     #$ff00
        sta     near w7e64b2
@0d27:  lda     f:ScreenShakeTbl,x
        and     #$00ff
        ora     #$ff00
        sta     near w7e64b0

; update battle bg
@0d34:  jsl     UpdateBattleBG

; update controller input
        shorta0
        jsr     UpdateCtrl

; increment frame counter
        inc     z98

; NMI complete
        stz     zNMIState
@0d42:  longai
        pld
        plb
        ply
        plx
        pla
        plp
; fallthrough

; ------------------------------------------------------------------------------

; [ battle irq (no effect) ]

BattleIRQ:
@0d4a:  rti                 ; battle irq jumps here
        .a8

; ------------------------------------------------------------------------------

; screen shaking data (17 bytes)
; horizontal shaking uses bytes 0-15
; vertical shaking uses bytes 1-16
ScreenShakeTbl:
        .lobytes -1,-3,-2,-3,-4,-2,-1,-3,-4,-2,-3,-1,-3,-2,-1,-2,-1

; ------------------------------------------------------------------------------
