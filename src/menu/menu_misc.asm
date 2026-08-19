.segment "menu_code"

; ------------------------------------------------------------------------------

; unused menu state
        array_label MENU_STATE, MENU_STATE::MENU_STATE_2F

; ------------------------------------------------------------------------------

; [ create portrait task for party menu ]

CreatePartyPortraitTask:
@7ae5:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z60
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     #$001a
        sta     near wTaskProp::PosX_H,x
        shorta
        clr_a
        lda     zSelIndex
        jsr     LoadPartyPortraitAnimPtr
        clr_a
        sta     near wTaskProp::PosY + 2,x
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

LoadPartyPortraitAnimPtr:
@7b0e:  phx
        phx
        asl
        tax
        longa
        lda     f:PortraitAnimDataTbl,x
        ply
        sta     near wTaskProp::AnimPtr,y
        shorta
        lda     #^Portrait1AnimData
        sta     near wTaskProp::AnimBank,y
        plx
        rts

; ------------------------------------------------------------------------------

; [ menu state $30-$32: unused ]

        array_label MENU_STATE, MENU_STATE::MENU_STATE_30
        array_label MENU_STATE, MENU_STATE::MENU_STATE_31
        array_label MENU_STATE, MENU_STATE::MENU_STATE_32

; ------------------------------------------------------------------------------

_c37b25:
@7b25:  clr_a
        lda     $7e9d89,x
        sta     ze1
        bmi     @7b41
        phx
        tax
        lda     $1850,x
        and     #%00011000
        lsr3
        tay
        lda     ze1
        sta     [ze7],y
        plx
        inx
        bra     @7b25
@7b41:  rts

; ------------------------------------------------------------------------------

; [ character icon task ]

CharIconTask:
@7b42:  tax
        jmp     (near CharIconTaskTbl,x)

CharIconTaskTbl:
@7b46:  .addr   CharIconTask_00
        .addr   CharIconTask_01
        .addr   CharIconTask_02
        .addr   CharIconTask_03
        .addr   CharIconTask_04
        .addr   CharIconTask_05

; ------------------------------------------------------------------------------

; [ init group 1 sprite task ]

CharIconTask_00:
@7b52:  lda     #$01                    ; enable group 1 sprite tasks
        tsb     z47
        ldx     zTaskOffset
        lda     #$03
        sta     near wTaskProp::State,x
        jsr     InitAnimTask
        clr_a
        jsr     CreateForcedCharTask
        bra     _7b7e

; ------------------------------------------------------------------------------

; [ init group 2 sprite task ]

CharIconTask_01:
@7b66:  ldx     zTaskOffset
        lda     #$04
        sta     near wTaskProp::State,x
        jsr     InitAnimTask
        bra     _7b8d

; ------------------------------------------------------------------------------

; [ init group 3 sprite task ]

CharIconTask_02:
@7b72:  ldx     zTaskOffset
        lda     #$05
        sta     near wTaskProp::State,x
        jsr     InitAnimTask
        bra     _7ba1

; ------------------------------------------------------------------------------

; [ update group 1 sprite task ]

CharIconTask_03:
_7b7e:  lda     z47
        and     #$01
        beq     @7b8b
        ldx     zTaskOffset
        jsr     UpdateAnimTask
        sec
        rts
@7b8b:  clc                             ; terminate task
        rts

; ------------------------------------------------------------------------------

; [ update group 2 sprite task ]

CharIconTask_04:
_7b8d:  lda     z47
        and     #$02
        beq     _7b9a                   ; task terminates after 1 frame if set
        ldx     zTaskOffset
        jsr     UpdateAnimTask
        clc                             ; terminate task
        rts
_7b9a:  ldx     zTaskOffset
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ update group 3 sprite task ]

CharIconTask_05:
_7ba1:  lda     z47
        and     #$04
        beq     _7b9a                   ; task terminates after 1 frame if set
        ldx     zTaskOffset
        jsr     UpdateAnimTask
        clc                             ; terminate task
        rts

; ------------------------------------------------------------------------------

; [ create arrow sprite task for forced party members ]

CreateForcedCharTask:
@7bae:  sta     ze6
        lda     r0200
        cmp     #MENU_TYPE::PARTY
        bne     @7c0e                   ; return if not party menu
        ldx     zTaskOffset
        clr_a
        lda     near wTaskProp::w7e35c9,x
        bmi     @7c0e
        asl
        longa
        tax
        lda     f:ForcedCharMaskTbl,x
        sta     ze7
        lda     r0202
        and     ze7
        shorta
        beq     @7c0e
        lda     #$00
        pha
        plb
        lda     ze6
        bne     @7bdf
        ldy     #near CharIconTask
        bra     @7be2
@7bdf:  ldy     #near PartySpriteTask
@7be2:  lda     #3
        jsr     CreateTask
        lda     #$7e
        pha
        plb
        lda     #$ff
        sta     near wTaskProp::w7e35c9,x
        ldy     near wTaskProp::w7e374a,x
        longa
        lda     near wTaskProp::PosX_H,y
        sta     near wTaskProp::PosX_H,x
        lda     near wTaskProp::PosY_H,y
        sta     near wTaskProp::PosY_H,x
        lda     #near PartyArrowAnim
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^PartyArrowAnim
        sta     near wTaskProp::AnimBank,x
@7c0e:  rts

; ------------------------------------------------------------------------------

; note: this is exactly the same as CharEquipMaskTbl
ForcedCharMaskTbl:
@7c0f:  .word   $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        .word   $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

; ------------------------------------------------------------------------------

; [ draw character portrait in party menu ]

LoadPartyPortraitGfx:
@7c2f:  ldy     #$2600
        sty     zDMA2Dest
        ldy     #$0320
        sty     zDMA2Size
        clr_a
        lda     z4b
        clc
        adc     z4a
        adc     z5a
        tax
        lda     $7e9d89,x
        bmi     @7ca4
        bra     @7c6e
        ldy     #$2600
        sty     zDMA2Dest
        bra     @7c5f
        ldy     #$2800
        sty     zDMA2Dest
        bra     @7c5f
        ldy     #$2800
        sty     zDMA2Dest
        bra     @7ca4
@7c5f:  ldy     #$0320
        sty     zDMA2Size
        clr_a
        lda     z4b
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
        and     #STATUS1::IMP
        beq     @7c85
        lda     #PORTRAIT::IMP
        bra     @7c8f
@7c85:  lda     0,y
        cmp     #CHAR_PROP::LOCKE
        beq     @7c8f
        lda     $0001,y
@7c8f:  longa
        asl
        tax
        lda     f:PortraitGfxPtrs,x
        clc
        adc     #near PortraitGfx
        sta     zDMA2Src
        shorta
        lda     #^PortraitGfx
        sta     zDMA2Src_B
        rts
@7ca4:  ldy     #$9f51
        sty     zDMA2Src
        lda     #$7e
        sta     zDMA2Src_B
        rts

; ------------------------------------------------------------------------------

; [ load portrait palette in party menu ]

LoadPartyPortraitPal:
@7cae:  ldy     zZero
        phy
        clr_a
        lda     z4b
        clc
        adc     z4a
        adc     z5a
        tax
        lda     $7e9d89,x
        bpl     @7cd6
        clr_a
        bra     @7cd6
        ldy     zZero
        bra     @7cca
        ldy     #$0020
@7cca:  phy
        clr_a
        lda     z4b
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
        sta     ze3
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
        sta     wPalBuf::SpritePal0,x
        shorta
        plx
        inx2
        iny2
        dec     ze3
        bne     @7d02
        shorta
        rts

; ------------------------------------------------------------------------------

; unused menu states
        array_label MENU_STATE, MENU_STATE::MENU_STATE_44
        array_label MENU_STATE, MENU_STATE::MENU_STATE_45
        array_label MENU_STATE, MENU_STATE::MENU_STATE_46

; ------------------------------------------------------------------------------

