; ------------------------------------------------------------------------------

; [ load swdtech or esper attack name ]

_c2bb11:
set_s_mess_poi:
@bb11:  and     #$0f
        asl
        tax
        jmp     (near _c2bb18,x)

_c2bb18:
@bb18:  .addr   _c2bb46,_c2bb1c

; ------------------------------------------------------------------------------

; [ load swdtech name ]

_c2bb1c:
@bb1c:  ldy     #2
        lda     (z76),y
        sta     $22
        lda     #BUSHIDO_NAME::ITEM_SIZE
        sta     $24
        jsl     Mult8_far
        ldx     $26
        clr_ay
.if LANG_EN
@bb2f:  lda     f:BushidoName,x
        cmp     #$ff
        beq     @bb41
        sta     near w7e57d5,y
        inx
        iny
        cpy     #BUSHIDO_NAME::ITEM_SIZE
        bne     @bb2f
.else
@bacf:  lda     #$1e
        sta     near w7e57d5,y
        lda     f:$001cf8,x
        sta     near w7e57d5+1,y
        inx
        iny2
        cpy     #BUSHIDO_NAME::ITEM_SIZE*2
        bne     @bacf
.endif
@bb41:  clr_a
        sta     near w7e57d5,y
        rtl

; ------------------------------------------------------------------------------

; [ load esper attack name ]

_c2bb46:
@bb46:  ldy     #2
        lda     (z76),y
        sta     $22
        lda     #GENJU_ATTACK_NAME::ITEM_SIZE
        sta     $24
        jsl     Mult8_far
        ldx     $26
        clr_ay
@bb59:  lda     f:GenjuAttackName,x
        cmp     #$ff
        beq     @bb6b
        sta     near w7e57d5,y
        inx
        iny
        cpy     #GENJU_ATTACK_NAME::ITEM_SIZE
        bne     @bb59
@bb6b:  clr_a
        sta     near w7e57d5,y
        rtl

; ------------------------------------------------------------------------------
