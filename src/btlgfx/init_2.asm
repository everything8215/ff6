; ------------------------------------------------------------------------------

; [ init bg scroll hdma data ]

_c2b6f7:
line_init_long:

; init offset-per-tile data for slot window
@b6f7:  longa
        clr_ax
        lda     #$2000                  ; affect bg1, scroll value = 0
@b6fe:  sta     near wOffsetPerTile,x
        inx2
        cpx     #wOffsetPerTile::SIZE
        bne     @b6fe

; clear bg scroll hdma data
        clr_ax
@b70a:  sta     near wBG1ScrollData,x     ; clear bg1 scroll hdma data
        sta     near wBG2ScrollData,x     ; clear bg2 scroll hdma data
        sta     near wBG3ScrollData,x     ; clear bg3 scroll hdma data
        inx2
        cpx     #$0380
        bne     @b70a

        ldx     #$025c
        lda     #$ffa9
        sta     $12
        lda     #$ff66
        sta     $14
@b727:  lda     $12
        sta     near wBG2ScrollData::Vert,x     ; bg2 vertical scroll hdma data (menu region)
        lda     $14
        sta     near wBG3ScrollData::Vert,x     ; bg3 vertical scroll hdma data (menu region)
        dec     $12
        dec     $14
        inx4
        cpx     #$0380
        bne     @b727
        ldx     #$027c
        lda     #$0064
        sta     $10
        lda     #$000c
        sta     $12
@b74b:  lda     $10
        sta     near wBG3ScrollData::Vert,x
        dec     $12
        bne     @b761
        lda     #$000c
        sta     $12
        lda     $10
        clc
        adc     #$0004
        sta     $10
@b761:  inx4
        cpx     #$033c
        bne     @b74b
        ldx     #$025c
        lda     #$0068
@b770:  sta     near wBG2ScrollData::Vert,x
        inx4
        cpx     #$035c
        bne     @b770

; init bg3 h-scroll hdma data
        clr_ax
@b77e:  lda     near wBG3ScrollData::_151::Horz,x
        sta     near wCmdTextScrollData::Horz,x
        sta     near wRowDefTextScrollData::Horz,x
        sta     near wCharStatusTextScrollData::Horz,x
        inx2
        cpx     #$0100
        bne     @b77e
@b791:  lda     near wBG3ScrollData::_151::Horz,x
        sta     near wRowDefTextScrollData::Horz,x
        sta     near wCharStatusTextScrollData::Horz,x
        inx2
        cpx     #$0120
        bne     @b791
@b7a1:  lda     near wBG3ScrollData::_151::Horz,x
        sta     near wCharStatusTextScrollData::Horz,x
        inx2
        cpx     #$0140
        bne     @b7a1

; init bg3 v-scroll hdma data
        clr_ax
@b7b0:  lda     near wBG3ScrollData::_159::Vert,x
        clc
        adc     #$0040
        sta     near wCmdTextScrollData::_8::Vert,x
        clc
        adc     #$0040
        sta     near wRowDefTextScrollData::_8::Vert,x
        sec
        sbc     #$0008
        sta     near wCharStatusTextScrollData::_8::Vert,x
        inx4
        cpx     #$00c0
        bne     @b7b0

; init bg3 v-scroll hdma data (item/magic character select)
        clr_ax
@b7d3:  lda     near wBG3ScrollData::_151::Vert,x
        sec
        sbc     #$0008
        sta     near wCharStatusTextScrollData::Vert,x
        lda     near wBG3ScrollData::_207::Vert,x
        sec
        sbc     #$0008
        sta     near wCharStatusTextScrollData::_56::Vert,x
        inx4
        cpx     #$0020
        bne     @b7d3

; init bg3 scroll hdma data (esper)
        clr_ax
@b7f2:  stz     near wGenjuTextScrollData::Horz,x
        lda     #$013c
        sta     near wGenjuTextScrollData::Vert,x
        inx4
        cpx     #$00a0
        bne     @b7f2

; init bg3 scroll hdma data (equip)
        clr_ax
        lda     #$0018
        sta     $12
        lda     #$00dc
        sta     $10
@b810:  lda     #$0100
        sta     near wEquipTextScrollData::Horz,x
        lda     $10
        sta     near wEquipTextScrollData::Vert,x
        dec     $12
        bne     @b827
        lda     $10
        clc
        adc     #$0004
        sta     $10
@b827:  inx4
        cpx     #$00c0
        bne     @b810

; init bg3 scroll hdma data (list)
        clr_ax
        lda     #$0060
        sta     $10
        lda     #$0014
        sta     $12
@b83c:  lda     #$0100
        sta     near wListTextScrollData::Horz,x
        lda     $10
        sta     near wListTextScrollData::Vert,x
        dec     $12
        bne     @b858
        lda     #$000c
        sta     $12
        lda     $10
        clc
        adc     #$0004
        sta     $10
@b858:  inx4
        cpx     #$00e0
        bne     @b83c
        clr_a
@b862:  sta     near wListTextScrollData::Horz,x
        sta     near wListTextScrollData::Vert,x
        inx2
        cpx     #$0100
        bne     @b862

; init generic hdma data for bg3 text
        clr_ax
        lda     #$0060
        sta     $10
        lda     #12
        sta     $12
@b87b:  lda     #$0100
        sta     near wBufferTextScrollData::Horz,x
        lda     $10
        sta     near wBufferTextScrollData::Vert,x
        dec     $12
        bne     @b897
        lda     #12
        sta     $12
        lda     $10
        clc
        adc     #4
        sta     $10
@b897:  inx4
        cpx     #$00f0
        bne     @b87b
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ update screen fade in ]

UpdateFadeIn:

; return if not fading in
        lda     near w7ee9f6
        beq     @b8f0

; increment screen brightness
        lda     near w7ee9f9
        and     #$0f
        cmp     #$0f
        beq     @b8b6
        inc
        sta     near w7ee9f9

; update hdma for fade bars
@b8b6:  shorti
        lda     near w7ee9f7
        asl
        tay
        lda     near w7ee9f8
        asl
        tax
        lda     #$e0                    ; black
@b8c4:  sta     near w7eea32-1,y
        sta     near w7eea32+1,y
        sta     near w7eea32+$99,x
        sta     near w7eea32+$9b,x
        cmp     #$ff
        beq     @b8d5
        inc
@b8d5:  inx4
        dey4
        bne     @b8c4
        inc     near w7ee9f8
        inc     near w7ee9f8
        dec     near w7ee9f7
        dec     near w7ee9f7
        bne     @b8f0
        stz     near w7ee9f6                 ; fade in is complete
@b8f0:  longi
        rtl

; ------------------------------------------------------------------------------

; [ divide ]

; +$30 = +$2c / +$2e, R -> +$32

Div16:
        phx
        longa
        stz     $30
        stz     $32
        lda     $2c
        beq     @b91e
        lda     $2e
        beq     @b91e
        ldx     #16
@b905:  rol     $2c
        rol     $32
        lda     $32
        sec
        sbc     $2e
        sta     $32
        bcs     @b919
        lda     $32
        adc     $2e
        sta     $32
        clc
@b919:  rol     $30
        dex
        bne     @b905
@b91e:  lda     #0
        shorta
        plx
        rts

; ------------------------------------------------------------------------------

; [ update timer tile data ]

DrawTimer:
        lda     near w7eecef                 ; return if timer is not shown
        and     #$40
        bne     @b92d
        rtl

; decrement timer frame counter
@b92d:  lda     near w7e628f
        beq     @b936
        dec     near w7e628f
        rtl

; determine tiles to draw
@b936:  lda     #60                     ; reset timer frame counter to 60
        sta     near w7e628f
        lda     f:$001189
        sta     $2c
        lda     f:$00118a
        sta     $2d
        ldx     #60
        stx     $2e
        jsr     Div16
        ldx     $30
        stx     $2c
        ldx     #60
        stx     $2e
        jsr     Div16
        clr_ax
        lda     $30                     ; dividend is minutes
@b95f:  sec
        sbc     #10
        bcc     @b967
        inx
        bra     @b95f
@b967:  clc
        adc     #ZERO_CHAR+10
        sta     near w7e6292
        txa
        bne     @b974
        lda     #$ff
        bra     @b977
@b974:  clc
        adc     #ZERO_CHAR
@b977:  sta     near w7e6290
        clr_ax
        lda     $32                     ; remainder is seconds
@b97e:  sec
        sbc     #10
        bcc     @b986
        inx
        bra     @b97e
@b986:  clc
        adc     #ZERO_CHAR+10
        sta     near w7e6298
        txa
        clc
        adc     #ZERO_CHAR
        sta     near w7e6296
        lda     #COLON_CHAR
        sta     near w7e6294
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6b: re-align animation with center of target ]

; only used by L? Pearl

AnimCmd_00_6b_far:
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetHeight,x
        longa
        asl2
        sta     $10                     ; target height * 4
        lda     near wAnimThread::FrameHeight,x
        and     #$00ff
        asl3
        sta     $12                     ; frame height * 8
        lda     near wAnimThread::ThreadPosY,x
        clc
        adc     $12                     ; y position += frame height * 8 - target height * 4
        sec
        sbc     $10
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6a: align bottom of thread with bottom of target ]

; used by ice 3 only

AnimCmd_00_6a_far:
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetHeight,x     ; target height (in 8x8 tiles)
        longa
        asl2
        sta     $10         ; +$10 = target height / 2 (in pixels)
        lda     near wAnimThread::FrameHeight,x     ; frame height
        and     #$00ff
        asl3
        sta     $12         ; +$12 = frame height (in pixels)
        lda     near wAnimThread::ThreadPosY,x     ; thread y position
        clc
        adc     $10
        sec
        sbc     $12
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rtl

; ------------------------------------------------------------------------------

; sprite data for monsters
_c2b9e7:
@b9e7:  .byte $00,$00,$00,$01
        .byte $20,$00,$04,$01
        .byte $40,$00,$08,$01
        .byte $60,$00,$0c,$01

        .byte $00,$20,$40,$01
        .byte $20,$20,$44,$01
        .byte $40,$20,$48,$01
        .byte $60,$20,$4c,$01

        .byte $00,$40,$80,$01
        .byte $20,$40,$84,$01
        .byte $40,$40,$88,$01
        .byte $60,$40,$8c,$01

        .byte $00,$60,$c0,$01
        .byte $20,$60,$c4,$01
        .byte $40,$60,$c8,$01
        .byte $60,$60,$cc,$01

; ------------------------------------------------------------------------------
