.segment "menu_code"

; ------------------------------------------------------------------------------

; unused menu state
MenuState_2f:

; ------------------------------------------------------------------------------

; [  ]

_c37ae5:
@7ae5:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        txa
        sta     $60
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     #$001a
        sta     $33ca,x
        shorta
        clr_a
        lda     $28
        jsr     _c37b0e
        clr_a
        sta     $344b,x
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37b0e:
@7b0e:  phx
        phx
        asl
        tax
        longa
        lda     f:PortraitAnimDataTbl,x
        ply
        sta     $32c9,y
        shorta
        lda     #^Portrait1AnimData
        sta     $35ca,y
        plx
        rts

; ------------------------------------------------------------------------------

; [ menu state $30-$32: unused ]

MenuState_30:
MenuState_31:
MenuState_32:

; ------------------------------------------------------------------------------

_c37b25:
@7b25:  clr_a
        lda     $7e9d89,x
        sta     $e1
        bmi     @7b41
        phx
        tax
        lda     $1850,x
        and     #$18
        lsr3
        tay
        lda     $e1
        sta     [$e7],y
        plx
        inx
        bra     @7b25
@7b41:  rts

; ------------------------------------------------------------------------------

; [ character icon task ]

CharIconTask:
@7b42:  tax
        jmp     (.loword(CharIconTaskTbl),x)

CharIconTaskTbl:
@7b46:  .addr   CharIconTask_00
        .addr   CharIconTask_01
        .addr   CharIconTask_02
        .addr   CharIconTask_03
        .addr   CharIconTask_04
        .addr   CharIconTask_05

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_00:
@7b52:  lda     #$01
        tsb     $47
        ldx     $2d
        lda     #$03
        sta     $3649,x
        jsr     InitAnimTask
        clr_a
        jsr     _c37bae
        bra     _7b7e

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_01:
@7b66:  ldx     $2d
        lda     #$04
        sta     $3649,x
        jsr     InitAnimTask
        bra     _7b8d

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_02:
@7b72:  ldx     $2d
        lda     #$05
        sta     $3649,x
        jsr     InitAnimTask
        bra     _7ba1

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_03:
_7b7e:  lda     $47
        and     #$01
        beq     @7b8b
        ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts
@7b8b:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_04:
_7b8d:  lda     $47
        and     #$02
        beq     _7b9a
        ldx     $2d
        jsr     UpdateAnimTask
        clc
        rts
_7b9a:  ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_05:
_7ba1:  lda     $47
        and     #$04
        beq     _7b9a
        ldx     $2d
        jsr     UpdateAnimTask
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37bae:
@7bae:  sta     $e6
        lda     $0200
        cmp     #$04
        bne     @7c0e
        ldx     $2d
        clr_a
        lda     $35c9,x
        bmi     @7c0e
        asl
        longa
        tax
        lda     f:_c37c0f,x
        sta     $e7
        lda     $0202
        and     $e7
        shorta
        beq     @7c0e
        lda     #$00
        pha
        plb
        lda     $e6
        bne     @7bdf
        ldy     #.loword(CharIconTask)
        bra     @7be2
@7bdf:  ldy     #.loword(_c37a5f)
@7be2:  lda     #3
        jsr     CreateTask
        lda     #$7e
        pha
        plb
        lda     #$ff
        sta     $35c9,x
        ldy     $374a,x
        longa
        lda     $33ca,y
        sta     $33ca,x
        lda     $344a,y
        sta     $344a,x
        lda     #.loword(PartyArrowAnim)
        sta     $32c9,x
        shorta
        lda     #^PartyArrowAnim
        sta     $35ca,x
@7c0e:  rts

; ------------------------------------------------------------------------------

_c37c0f:
@7c0f:  .word   $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        .word   $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

; ------------------------------------------------------------------------------

; [  ]

_c37c2f:
@7c2f:  ldy     #$2600
        sty     $1b
        ldy     #$0320
        sty     $19
        clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7e9d89,x
        bmi     @7ca4
        bra     @7c6e
        ldy     #$2600
        sty     $1b
        bra     @7c5f
        ldy     #$2800
        sty     $1b
        bra     @7c5f
        ldy     #$2800
        sty     $1b
        bra     @7ca4
@7c5f:  ldy     #$0320
        sty     $19
        clr_a
        lda     $4b
        tax
        lda     $7e9da9,x
        bmi     @7ca4
@7c6e:  asl
        tax
        longa
        lda     f:CharPropPtrs,x
        tay
        clr_a
        shorta
        lda     $0014,y
        and     #$20
        beq     @7c85
        lda     #$0f
        bra     @7c8f
@7c85:  lda     $0000,y
        cmp     #$01
        beq     @7c8f
        lda     $0001,y
@7c8f:  longa
        asl
        tax
        lda     f:PortraitGfxPtrs,x
        clc
        adc     #.loword(PortraitGfx)
        sta     $1d
        shorta
        lda     #^PortraitGfx
        sta     $1f
        rts
@7ca4:  ldy     #$9f51
        sty     $1d
        lda     #$7e
        sta     $1f
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37cae:
@7cae:  ldy     $00
        phy
        clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7e9d89,x
        bpl     @7cd6
        clr_a
        bra     @7cd6
        ldy     $00
        bra     @7cca
        ldy     #$0020
@7cca:  phy
        clr_a
        lda     $4b
        tax
        lda     $7e9da9,x
        bpl     @7cd6
        clr_a
@7cd6:  asl
        tax
        longa
        lda     f:CharPropPtrs,x
        tay
        clr_a
        shorta
        lda     #$10
        sta     $e3
        lda     $0014,y
        and     #$20
        beq     @7cf1
        lda     #$0f
        bra     @7cf4
@7cf1:  lda     $0001,y
@7cf4:  tax
        lda     f:CharPortraitPalTbl,x
        longa
        asl5
        tax
        ply
@7d02:  longa
        phx
        lda     f:PortraitPal,x
        tyx
        sta     $7e3149,x
        shorta
        plx
        inx2
        iny2
        dec     $e3
        bne     @7d02
        shorta
        rts

; ------------------------------------------------------------------------------

; unused menu states
MenuState_44:
MenuState_45:
MenuState_46:

; ------------------------------------------------------------------------------

