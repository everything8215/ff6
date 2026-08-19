; ------------------------------------------------------------------------------

; vertical scroll positions for magitek train car bg
tor_rnd_poi:
_c2b0c5:
@b0c5:  .addr   0,-1,-2,-3

; ------------------------------------------------------------------------------

; battle bg update jump table
UpdateBattleBGTbl:
land_prog_jmp:
@b0cd:  .addr   UpdateBattleBGNoEffect  ; $00
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBG_07
        .addr   UpdateBattleBGNoEffect  ; $08
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBG_0d
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBG_0f
        .addr   UpdateBattleBGNoEffect  ; $10
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect  ; $18
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBG_1f
        .addr   UpdateBattleBGNoEffect  ; $20
        .addr   UpdateBattleBG_21
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect  ; $28
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBG_2c
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBG_2e
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect  ; $30
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBGNoEffect
        .addr   UpdateBattleBG_36
        .addr   UpdateBattleBGNoEffect

; ------------------------------------------------------------------------------

; [ no battle bg update ]

UpdateBattleBGNoEffect:
@b13d:  rtl

; ------------------------------------------------------------------------------

; final kefka death animation scroll positions ???
_c2b13e:
@b13e:  .word   1,2,1,0,1,2,1,2

; ------------------------------------------------------------------------------

; [ update battle bg $36: final kefka ]

UpdateBattleBG_36:
        .a16
@b14e:  lda     z9a         ; return if death animation is not enabled
        beq     @b16f
        lda     z0e         ; frame counter
        and     #%111
        asl
        tax
        lda     f:_c2b13e,x   ;
        pha
        clc
        adc     #near -16
        sta     w7e64b4     ;
        pla
        clc
        adc     #$0010
        sta     near w7e80c3
        clr_a
@b16f:  rtl
        .a8

; ------------------------------------------------------------------------------

; [ update battle bg $2e: cyan's dream world ]

UpdateBattleBG_2e:
@b170:  .a16
        clr_ax
@b172:  lda     near wBattleBGPal::_0::Color1,x     ; copy first 8 colors of palette 1 and 3 to buffer
        sta     near wBattleBGPalBuf::_0::Color0,x
        sta     near wBattleBGPalBuf::_0::Color8,x
        lda     near wBattleBGPal::_2::Color1,x
        sta     near wBattleBGPalBuf::_1::Color0,x
        sta     near wBattleBGPalBuf::_1::Color8,x
        inx2
        cpx     #$0010
        bne     @b172
        lda     z0e         ; frame counter / 8
        lsr3
        and     #%111
        asl
        tax
        clr_ay
@b197:  lda     near wBattleBGPalBuf::_0::Color0,x     ; shift colors every 8 frames
        sta     near wBattleBGPal::_0::Color1,y
        lda     near wBattleBGPalBuf::_1::Color0,x
        sta     near wBattleBGPal::_2::Color1,y
        iny2
        inx2
        cpy     #$0010
        bne     @b197
        rtl
        .a8

; ------------------------------------------------------------------------------

; [ update battle bg $07: falling through the clouds ]

UpdateBattleBG_07:
        .a16
@b1ad:  lda     near w7e64b2       ; add 6 to vertical scroll position
        clc
        adc     #6
        sta     near w7e64b2
        rtl
        .a8

; ------------------------------------------------------------------------------

; [ update battle bg $0f/$21: top of train car/running on train tracks ]

UpdateBattleBG_0f:
UpdateBattleBG_21:
        .a16
@b1b8:  lda     near w7e64b0       ; subtract 4 from horizontal scroll position
        sec
        sbc     #4
        sta     near w7e64b0
        rtl
        .a8

; ------------------------------------------------------------------------------

; [ update battle bg $2c: magitek train car ]

UpdateBattleBG_2c:
        .a16
@b1c3:  lda     near w7e64b0       ; add 8 to horizontal scroll position
        sec
        sbc     #8
        sta     near w7e64b0
        shorta
        jsr     Rand_near
        longa
        and     #%11      ; (0..3)
        asl
        tax
        lda     f:_c2b0c5,x   ; vertical scroll position (0, -1, -2, -3)
        sta     near w7e64b2
        rtl
        .a8

; ------------------------------------------------------------------------------

; [ update battle bg $1f: waterfall ]

UpdateBattleBG_1f:
        .a16
@b1e1:  clr_ax
@b1e3:  lda     near wBattleBGPal::Color1,x     ; copy first 8 colors of palette 1 to buffer
        sta     near wBattleBGPalBuf,x
        sta     near wBattleBGPalBuf::Color8,x
        inx2
        cpx     #$0010
        bne     @b1e3
        lda     near w7e64b2       ; add 6 to vertical scroll position
        clc
        adc     #6
        sta     near w7e64b2
        lda     z0e         ; frame counter / 4
        lsr2
        and     #%111
        asl
        tax
        clr_ay
@b208:  lda     near wBattleBGPalBuf,x     ; shift colors every 4 frames
        sta     near wBattleBGPal::Color1,y
        iny2
        inx2
        cpy     #$0010
        bne     @b208
        rtl
        .a8

; ------------------------------------------------------------------------------

; [ update battle bg $0d: raft on a river ]

UpdateBattleBG_0d:
        .a16
@b218:  clr_ax
@b21a:  lda     near wBattleBGPal::Color1,x     ; copy colors 1 through 4 of palette 1 to buffer
        sta     near wBattleBGPalBuf::Color0,x
        sta     near wBattleBGPalBuf::Color4,x
        lda     near wBattleBGPal::Color5,x     ; copy colors 5 through 8 of palette 1 to buffer
        sta     near wBattleBGPalBuf::_0::Color8,x
        sta     near wBattleBGPalBuf::_0::Color12,x
        inx2
        cpx     #8
        bne     @b21a
        lda     z0e         ; frame counter / 8
        lsr3
        and     #%11
        eor     #%11      ; invert
        asl
        tax
        clr_ay
@b242:  lda     near wBattleBGPalBuf,x     ; shift colors backwards every 8 frames
        sta     near wBattleBGPal::Color1,y
        lda     near wBattleBGPalBuf::Color8,x
        sta     near wBattleBGPal::Color5,y
        iny2
        inx2
        cpy     #8
        bne     @b242
        rtl
        .a8

; ------------------------------------------------------------------------------

; [ update battle bg palette and scrolling ]

UpdateBattleBG:
        .a16
@b258:  shorti
        clr_ax
@b25c:  lda     near w7e7e00::_5,x     ; copy battle bg palettes
        sta     near wBattleBGPal::_0,x
        lda     near w7e7e00::_6,x
        sta     near wBattleBGPal::_1,x
        lda     near w7e7e00::_7,x
        sta     near wBattleBGPal::_2,x
        inx2
        cpx     #32
        bne     @b25c
        longi
        lda     near w7eecb8       ; battle bg index
        and     #$3f
        asl
        tax
        jmp     (near UpdateBattleBGTbl,x)
        .a8

; ------------------------------------------------------------------------------
