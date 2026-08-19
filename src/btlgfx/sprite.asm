; ------------------------------------------------------------------------------

; [ update character/monster animation sprite data (back layer) ]

UpdateBackAnimSprites:
@25e1:  lda     near w7e62d1
        beq     DrawBackAnimSprites
        clr_ay
@25e8:  lda     z7b
        cmp     near w7e6142,y
        bne     @2601
        phy
        tya
        asl
        tax
        longa
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        jsr     DrawBackAnimSprites
        ply
@2601:  iny
        cpy     #$000a
        bne     @25e8
        rts

DrawBackAnimSprites:
@2608:  lda     near w7e60aa
        beq     @2617
        lda     z0e
        and     #%1
        beq     @2617
        lda     #$02
        bra     @261a
@2617:  lda     near w7e7b0d
@261a:  bmi     @2641
        and     #$0f
        sta     near wSpriteThreadCounter
@2621:  lda     near wAnimThread::SpriteIsActive,x  ; skip is sprite is not active
        beq     @2631
        lda     near wAnimThread::IsBackSprite,x  ; skip if not a back sprite
        beq     @2631
        jsr     DrawAnimSprites
        ldx     near wSpriteThreadPtr
@2631:  longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        dec     near wSpriteThreadCounter
        bne     @2621
@2641:  rts

; ------------------------------------------------------------------------------

; [ update character/monster animation sprite data (front layer) ]

UpdateFrontAnimSprites:
@2642:  lda     near w7e62d1
        beq     DrawFrontAnimSprites
        clr_ay
@2649:  lda     z7b
        cmp     near w7e6142,y
        bne     @2662
        phy
        tya
        asl
        tax
        longa
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        jsr     DrawFrontAnimSprites
        ply
@2662:  iny
        cpy     #$000a
        bne     @2649
        rts

; ------------------------------------------------------------------------------

; [ update animation sprite data (front layer) ]

;    +X: pointer to thread data (+$6a2e)
; $7b0d: number of threads to update

DrawFrontAnimSprites:
@2669:  lda     near w7e60aa
        beq     @2678
        lda     z0e
        and     #%1
        beq     @2678
        lda     #$02
        bra     @267b
@2678:  lda     near w7e7b0d
@267b:  bmi     @26a9
        and     #$0f
        sta     near wSpriteThreadCounter
@2682:  lda     near wAnimThread::SpriteIsActive,x     ; skip if sprite is not active
        beq     @2699
        lda     near wAnimThread::LayerPriority,x     ; skip if not a sprite thread
        and     #$03
        bne     @2699
        lda     near wAnimThread::IsBackSprite,x     ; skip if not a front sprite
        bne     @2699
        jsr     DrawAnimSprites
        ldx     near wSpriteThreadPtr
@2699:  longa        ; next thread
        txa
        clc
        adc     #$0010
        tax
        shorta0
        dec     near wSpriteThreadCounter
        bne     @2682
@26a9:  rts

; ------------------------------------------------------------------------------

; [ update animation thread sprite data ]

DrawAnimSprites:
@26aa:  stx     near wSpriteThreadPtr
        lda     near wAnimThread::SpriteTileOffset,x     ; $3c = tile offset
        sta     $3c
        longa
        lda     near wAnimThread::SpritePosX,x     ; +$36 = x offset
        sta     $36
        lda     near wAnimThread::SpritePosY,x     ; +$38 = y offset
        sta     $38
        lda     near wAnimThread::SpriteFlags,x     ; +$3a = sprite data
        sta     $3a
        lda     near wAnimThread::SpriteFrame,x     ; frame number
        and     #$00ff
        asl
        tax
        lda     $3a
        and     #$0040
        beq     @26d8
        lda     f:_c2c424,x   ; pointer to frame data
        bra     @26dc
@26d8:  lda     f:_c2c3e4,x
@26dc:  tax
        lda     z71         ; next available sprite
        and     #$00ff
        asl2
        tay
        shorta0
@26e8:  lda     a:0,x     ; frame data
        cmp     #$ff
        beq     @276b       ; skip if 0
        bpl     @26fd       ; branch if msb clear
        clc
        adc     $36
        sta     $0300,y
        lda     $37
        adc     #$01
        bra     @2707
@26fd:  clc
        adc     $36         ; add to x offset
        sta     $0300,y
        lda     $37
        adc     #$00
@2707:  and     #$01
        beq     @271c
        stx     $3e
        lda     near w7ea17f,y
        tax
        lda     $0500,x     ; set high sprite data
        ora     near w7ea77f,y
        sta     $0500,x
        ldx     $3e         ; add to y offset
@271c:  clc
        lda     a:1,x
        bpl     @272d
        adc     $38
        sta     $3e
        lda     $39
        adc     #$01
        jmp     @2735
@272d:  adc     $38
        sta     $3e
        lda     $39
        adc     #$00
@2735:  and     #$01
        beq     @2742
        lda     $3e
        cmp     #$e0
        bcs     @274a       ; branch if sprite is off-screen
        jmp     @2748
@2742:  lda     $3e
        cmp     #$97
        bcc     @274a
@2748:  lda     #$e0
@274a:  sta     $0301,y
        lda     a:2,x     ; tile number
        clc
        adc     $3c             ; add tile offset
        sta     $0302,y
        lda     a:3,x
        ora     $3b
        sta     $0303,y
        inx4                ; next sprite
        iny4
        inc     z71         ; increment next available sprite
        jmp     @26e8
@276b:  rts

; ------------------------------------------------------------------------------

; [ update sprites ]

; called directly from nmi

UpdateSprites:
@276c:  lda     near w7e201e       ; monsters shown
        and     near w7e61ab       ;
        and     near w7e60ab
        sta     near w7e88d1       ; monsters with visible sprites
        clr_ax
@277a:  lda     near w7e631a,x     ; damage numeral
        and     #$7f
        beq     @27aa       ; branch if disabled
        lda     near w7e631e,x     ; damage numeral target
        cmp     #$04
        bcc     @279a       ; branch if a character
        sec
        sbc     #$04
        phx
        jsr     GetBitMask
        plx
        and     near w7e88d1
        bne     @27aa       ; branch if monster sprite is visible
        stz     near w7e631a,x     ; disable damage numeral
        bra     @27aa
@279a:  phx
        jsr     GetBitMask
        plx
        and     near w7e201d       ; branch if character is visible
        and     near w7e61ac
        bne     @27aa
        stz     near w7e631a,x     ; disable damage numeral
@27aa:  inx
        cpx     #4
        bne     @277a
        lda     near wHideBG1MonsterSprites
        asl
        tax
        jmp     (near DrawSpritesTbl,x)

.enum DRAW_SPRITES
        ALL_SPRITES
        NO_BG1_MONSTERS
        COUNT = 2
.endenum

DrawSpritesTbl:
        ptr_tbl DRAW_SPRITES

; ------------------------------------------------------------------------------

        array_label DRAW_SPRITES, DRAW_SPRITES::ALL_SPRITES
        jmp     DrawSprites

        array_label DRAW_SPRITES, DRAW_SPRITES::NO_BG1_MONSTERS
        jmp     DrawSpritesNoBG1

; ------------------------------------------------------------------------------

; [ update monster sprite data ]

; this subroutine draws sprites for a single monster

UpdateMonsterSprites:
@27c2:  lda     near w7e88d2
        pha
        sta     z7b
        asl
        tax
        longa
        lda     f:_c2ce93,x   ; pointer to monster animation thread data (+$7e64de)
        tax
        shorta0
        phx
        jsr     UpdateFrontAnimSprites
        lda     near w7e88d2
        jsr     DrawDmgNumSprites
        lda     z71
        sta     a:z60
        lda     near w7e88d2
        jsr     GetBitMask
        and     near w7e88d1
        and     near w7e201e
        and     near w7e61ab
        and     near w7ee9e6
        and     near w7e6191                 ; skip if monster is newly entering
        beq     @285e
        jsr     DrawMonsterSprite
        lda     near w7e88d2
        and     #$07
        jsr     GetBitMask
        and     near w7e619d
        beq     @285e
        lda     near w7e88d2
        and     #$07
        asl
        tax
        lda     near w7e812f+1,x
        longa
        asl3
        sta     $36
        lda     near w7e80cf,x
        pha
        clc
        adc     $36
        sta     near w7e80cf,x
        shorta0
        lda     near w7e80db+1,x
        pha
        lda     near w7e80f3,x
        eor     near w7e617e,x
        pha
        phx
        lda     near w7e80f3,x
        eor     near w7e617e,x
        ora     #$02
        sta     near w7e80f3,x
        lda     near w7e80db+1,x
        and     #$cf
        ora     #$20
        sta     near w7e80db+1,x
        jsr     DrawMonsterSprite
        plx
        pla
        sta     near w7e80f3,x
        pla
        sta     near w7e80db+1,x
        longa
        pla
        sta     near w7e80cf,x
        shorta0
@285e:  lda     a:z60
        sta     z71
        plx
        jsr     UpdateBackAnimSprites
        pla
        rts

; ------------------------------------------------------------------------------

; [ update sprite data (except bg1 monsters) ]

DrawSpritesNoBG1:
@2869:  jsr     CheckBG1Monsters2
        not_a
        and     near w7e201e       ; monsters shown
        and     near w7e61ab       ; monsters shown
        sta     near w7e88d1
        jmp     DrawSprites

; ------------------------------------------------------------------------------

; [ check bg1 monsters ]

; this subroutine is identical to CheckBG1Monsters except the result
; is in w7e88d1 instead of $24

CheckBG1Monsters2:
@287a:  clr_ax
        stz     near w7e88d1
@287f:  lda     near w7e80f3+1,x     ; bg1 monster (from battle data)
        lsr
        ora     near w7e88d1
        ror
        sta     near w7e88d1
        inx2                ; next monster
        cpx     #$000c
        bne     @287f
        lsr2
        sta     near w7e88d1
        rts

; ------------------------------------------------------------------------------

; [ update sprite data ]

DrawSprites:
@2897:  lda     near wDrawOrderInvalid       ; branch if character/monster order priority data is valid
        beq     @28ca

; copy character/monster order priority data from buffer
        stz     near wDrawOrderInvalid       ; validate character/monster draw order
        clr_ax
        longa
        shorti
@28a5:  lda     near wTargetDrawOrderBuf::_0::BottomY,x
        sta     near wTargetDrawOrder::_0::BottomY,x
        lda     near wTargetDrawOrderBuf::_0::TargetIndex,x
        sta     near wTargetDrawOrder::_0::TargetIndex,x
        lda     near wTargetDrawOrderBuf::_5::BottomY,x
        sta     near wTargetDrawOrder::_5::BottomY,x
        lda     near wTargetDrawOrderBuf::_5::TargetIndex,x
        sta     near wTargetDrawOrder::_5::TargetIndex,x
        inx4
        cpx     #near wTargetDrawOrderBuf::SIZE / 2
        bne     @28a5
        shorta0
        longi
@28ca:  jsr     UpdateCharXPos
        lda     near w7e62b0       ; branch if esper thread 1 sprites are shown below monsters/characters
        bne     @28dd
        lda     #1        ; update 1 thread
        sta     near w7e7b0d
        ldx     #GENJU_THREAD_1_OFFSET
        jsr     DrawFrontAnimSprites
@28dd:  lda     #1        ; update 1 thread
        sta     near w7e7b0d
        ldx     #GENJU_THREAD_2_OFFSET
        jsr     DrawFrontAnimSprites
        lda     #1        ; update 1 thread
        sta     near w7e7b0d
        ldx     #GENJU_THREAD_3_OFFSET
        jsr     DrawFrontAnimSprites
        clr_ax
@28f5:  phx
        lda     near w7e7b0e       ; number of threads to update (monsters)
        sta     near w7e7b0d
        lda     near wTargetDrawOrder::TargetIndex,x     ; character/monster number
        cmp     #4
        bcc     @2928       ; branch if a character
        cmp     #10
        bcs     @295b       ; skip if not a monster

; monster
        sec
        sbc     #$04
        tax
        sta     near w7e88d2       ; current monster
        lda     f:BitOrTbl,x   ; bit mask
        and     near w7e62af
        bne     @2923
        lda     f:BitOrTbl,x   ; bit mask
        and     near w7e201e
        and     near w7e61ab
        beq     @295b       ; skip if ???
@2923:  jsr     UpdateMonsterSprites
        bra     @295b

; character
@2928:  ora     #$80        ;
        sta     z7b
        and     #$03
        asl
        tax
        longa
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        lda     near w7e7b0f       ; number of threads to update (characters)
        sta     near w7e7b0d
        phx
        lda     z7b
        pha
        jsr     UpdateFrontAnimSprites
        pla
        jsr     UpdateCharSprites
        and     #$7f
        cmp     near w7e7b68
        bne     @2955
        jsr     _c12d92
@2955:  plx
        pha
        jsr     UpdateBackAnimSprites
        pla

; next character/monster
@295b:  plx
        inx4
        cpx     #$0028
        bne     @28f5
        lda     near w7e62b0       ; branch if esper thread 1 sprites are shown above monsters/characters
        beq     @2975
        lda     #1
        sta     near w7e7b0d
        ldx     #GENJU_THREAD_1_OFFSET
        jsr     DrawFrontAnimSprites
@2975:  lda     near w7e7b68       ;
        inc
        and     #$03
        sta     near w7e7b68
        rts

; ------------------------------------------------------------------------------

; [ update character sprite data ]

; A: character number

UpdateCharSprites:
@297f:  pha
        and     #$03
        tax
        phx
        lda     f:BitOrTbl,x   ; bit mask
        sta     $2c         ; $2c = character bit mask
        plx
        lda     near w7e201d       ; characters shown
        and     near w7e61ac       ; characters shown
        and     $2c
        bne     @2998       ; return if character is not shown
@2995:  jmp     @2a25
@2998:  lda     f:CharGfxDataBufPtrs,x
        tax
        lda     near wCharGfxDataBuf::GfxID,x
        cmp     #$ff
        beq     @2995       ; return if invalid
        lda     near wCharGfxDataBuf::ActiveStatus4,x
        andflg  STATUS4, HIDE
        bne     @2a25       ; branch if hide status
        pla
        jsr     DrawDmgNumSprites
        sta     $36
        lda     near w7e62bd       ; return if characters are hidden for esper attack
        bne     @2a24
        lda     $36
        pha
        lda     near wMagitekModeEnabled
        bne     @2a18
        pla
        jsr     DrawStatusSprites
        jsr     DrawCharSprite
        pha
        and     #$03
        sta     $36
        jsr     GetBitMask
        and     near w7e619c
        beq     @2a0e       ; branch if vertical mirror image is enabled
        lda     $36
        and     #$03
        tax
        lda     f:CharGfxDataBufPtrs,x
        tax
        longa
        lda     near wCharGfxData::PosY,x     ; add $18 to y position
        pha
        clc
        adc     #$0018
        sta     near wCharGfxData::PosY,x
        lda     near wCharGfxData::LayerPriority,x
        pha
        phx
        shorta0
        lda     near wCharGfxData::LayerPriority,x     ; sprite priority
        and     #$cf
        ora     #$a0        ; set vertical flip, priority = 2
        sta     near wCharGfxData::LayerPriority,x
        lda     $36
        jsr     DrawCharSprite
        longa
        plx
        pla
        sta     near wCharGfxData::LayerPriority,x
        pla
        sta     near wCharGfxData::PosY,x
        shorta0
@2a0e:  pla
        jsr     _c12a27
        jsr     DrawEchoSprites
        jmp     DrawCharShadow
@2a18:  pla
        pha
        jsr     DrawCharSprite
        jsr     _c12a27
        jsr     DrawBlockSprites
        pla
@2a24:  rts
@2a25:  pla
        rts

; ------------------------------------------------------------------------------

; [  ]

_c12a27:
set_deth_poi:
@2a27:  pha
        and     #$03
        asl
        tay
        tax
        lda     near w7ee9da
        lsr
        and     #$08
        sta     $36
        txa
        clc
        adc     $36
        tax
        lda     f:CondemnNumGfxPtrs,x
        sta     near w7ee9d2,y
        lda     f:CondemnNumGfxPtrs+1,x
        sta     near w7ee9d2+1,y
        pla
        rts

; ------------------------------------------------------------------------------

; [ update echo sprites ]

; A: current character

DrawEchoSprites:
@2a4a:  pha
        and     #$03
        cmp     near w7e62d3       ; return if this is not the character with echo effect
        bne     @2a57
        lda     near w7e62d4       ; return if echo effect is disabled
        bne     @2a59
@2a57:  pla
        rts
@2a59:  lda     z0e         ; frame counter
        and     near w7e62d5       ; frame delay
        bne     @2aa7
        ldx     #$0038
        longa
@2a65:  .repeat 4, i
        lda     near w7e62d6 + i * 2 - 8,x     ; shift all sprites back 1
        sta     near w7e62d6 + i * 2,x
        .endrep
        txa
        sec
        sbc     #$0008
        tax
        bne     @2a65
        lda     z71         ; next available sprite
        and     #$00ff
        dec2                ; previous sprite
        asl2
        tax
        .repeat 4, i
        lda     $0300 + i * 2,x     ; copy previous sprite data to echo sprite data (top and bottom)
        sta     near w7e62d6 + i * 2
        .endrep
@2aa7:  longa
        lda     z71         ; next available sprite
        and     #$00ff
        asl2
        tax
        lda     z0e         ; frame counter
        and     #%1
        beq     @2abd
        ldy     #$0008
        bra     @2abe
@2abd:  tay
@2abe:
        .repeat 4, i
        lda     near w7e62d6 + i * 2,y
        sta     $0300 + i * 2,x
        .endrep
        .repeat 4, i
        lda     near w7e62d6 + i * 2 + 16,y
        sta     $0308 + i * 2,x
        .endrep
        .repeat 4, i
        lda     near w7e62d6 + i * 2 + 32,y
        sta     $0310 + i * 2,x
        .endrep
        .repeat 4, i
        lda     near w7e62d6 + i * 2 + 48,y
        sta     $0318 + i * 2,x
        .endrep
        shorta0
        lda     z71         ; increment next available sprite (8 sprites)
        clc
        adc     #$08
        sta     z71
        pla
        rts

; ------------------------------------------------------------------------------

; [ update damage numeral sprites ]

DrawDmgNumSprites:
@2b2a:  jsr     _c12c67       ; update damage numeral for target
        pha
        sta     $3a
        lda     near w7e7b3e       ; branch if mass damage numerals are disabled
        beq     @2b54
        jsr     _c12bfc       ;
        bcs     @2b4b
        lda     $3a
        tax
        lda     near w7e7b3f,x     ; branch if damage numeral is disabled
        and     #$7f
        beq     @2b4b
        lda     near w7e7b49,x     ; damage numeral frame counter
        cmp     #$40
        bne     @2b57       ; branch after 64 frames (a little over 1 second)
@2b4b:  lda     $3a
        tax
        stz     near w7e7b3f,x     ; disable damage numeral
        stz     near w7e7b49,x
@2b54:  jmp     @2bfa
@2b57:  phx
        tax
        lda     f:DmgNumBounceTbl,x   ; $3c = y offset for bouncing damage numerals
        sta     $3c
        plx
        inc     near w7e7b49,x     ; increment frame counter
        stz     $41
        lda     near w7e7b53,x     ; +$40 = x offset
        sta     $40
        bpl     @2b6e
        dec     $41
@2b6e:  longa
        lda     $36         ; +$36 = x position
        sec
        sbc     $40
        sta     $36
        shorta0
        lda     $38         ; $38 = y position
        sec
        sbc     $3c
        sta     $38
        lda     z71         ; next available sprite
        longa
        asl2
        tay
        shorta0
        lda     $3a
        tax
        lda     near w7e7b3f,x
        and     #$80
        bne     @2b99
        lda     #$38
        bra     @2b9b
@2b99:  lda     #$3a
@2b9b:  sta     $0303,y
        sta     $0307,y
        lda     $36
        sta     $0300,y
        lda     $37
        and     #$01
        beq     @2bbb
        phx
        lda     near w7ea17f,y
        tax
        lda     $0500,x
        ora     near w7ea77f,y
        sta     $0500,x
        plx
@2bbb:  longa
        lda     $36
        clc
        adc     #$0010
        sta     $36
        shorta0
        lda     $36
        sta     $0304,y
        lda     $37
        and     #$01
        beq     @2be2
        phx
        lda     near w7ea17f + 4,y
        tax
        lda     $0500,x
        ora     near w7ea77f + 4,y
        sta     $0500,x
        plx
@2be2:  lda     $38
        sta     $0301,y
        sta     $0305,y
        lda     f:_c2e398,x
        sta     $0302,y
        inc2
        sta     $0306,y
        inc     z71         ; increment next available sprite (2 sprites)
        inc     z71
@2bfa:  pla
        rts

; ------------------------------------------------------------------------------

; [  ]

_c12bfc:
get_damage_poi:
@2bfc:  lda     $3a
        bpl     @2c2a
        and     #$03
        sta     $3a
        jsr     GetBitMask
        and     near w7e201d
        and     near w7e61ac
        bne     @2c11
        sec
        rts
@2c11:  lda     near w7e7b10,x
        sta     $2c
        txa
        asl
        tax
        lda     near w7e8043,x
        sta     $38
        lda     near w7e8033+1,x
        sta     $37
        lda     near w7e8033,x
        sta     $36
        bra     @2c5c
@2c2a:  lda     $3a
        jsr     GetBitMask
        and     near w7e201e
        and     near w7e61ab
        beq     @2c5e
        txa
        asl
        tax
        lda     near w7e8027,x
        sta     $38
        lda     near w7e800f,x
        sta     $36
        lda     near w7e800f+1,x
        sta     $37
        lda     near w7e80f3,x
        eor     near w7e617e,x
        and     #$01
        eor     #$01
        sta     $2c
        lda     $3a
        clc
        adc     #$04
        sta     $3a
@2c5c:  clc
        rts
@2c5e:  lda     $3a
        clc
        adc     #$04
        sta     $3a
        sec
        rts

; ------------------------------------------------------------------------------

; [ update damage numeral for target ]

; A: target

_c12c67:
one_damage_oam_set2:
@2c67:  sta     near w7e6141       ; current character/monster
        sta     $3a
        jsr     _c12bfc       ;
        bcc     @2c91
        clr_ax
@2c73:  lda     near w7e631a,x     ; damage numeral
        and     #$7f
        beq     @2c87       ; branch if numeral is disabled
        lda     near w7e631e,x     ; numeral target
        cmp     $3a
        bne     @2c87       ; branch if it doesn't match the current target
        stz     near w7e631a,x     ; disable damage numeral
        stz     near w7e6322,x
@2c87:  inx
        cpx     #4
        bne     @2c73
        lda     near w7e6141
        rts
@2c91:  clr_ax
@2c93:  lda     near w7e631a,x     ; damage numeral
        and     #$7f
        beq     @2cb8       ; branch if numeral is disabled
        lda     near w7e631e,x     ; numeral target
        cmp     $3a
        bne     @2cb8       ; branch if it doesn't match the current target
        lda     $3a
        pha
        phx
        stx     $3c
        lda     near w7e6141       ; current character/monster
        sta     $3a
        jsr     _c12bfc       ;
        ldx     $3c
        jsr     _c12cc2       ; update damage numeral sprite
        plx
        pla
        sta     $3a
@2cb8:  inx                 ; next numeral
        cpx     #4
        bne     @2c93
        lda     near w7e6141
        rts

; ------------------------------------------------------------------------------

; [ update damage numeral sprite ]

_c12cc2:
@2cc2:  pha
        lda     near w7e6322,x     ; damage numeral frame counter
        cmp     #$40        ; branch after 64 frames (a little over 1 second)
        bne     @2cd2
        stz     near w7e631a,x     ; disable damage numeral
        stz     near w7e6322,x
        pla
        rts
@2cd2:  phx
        tax
        lda     f:DmgNumBounceTbl,x   ; $3c = y offset for bouncing damage numerals
        sta     $3c
        plx
        inc     near w7e6322,x     ; increment frame counter
        stz     $41
        lda     near w7e6326,x     ; +$40 = x offset to center sprite
        sta     $40
        bpl     @2ce9
        dec     $41
@2ce9:  longa
        lda     $36         ; +$36 = x position
        sec
        sbc     $40
        sta     $36
        shorta0
        lda     $38         ; +$38 = y position
        sec
        sbc     $3c
        sta     $38
        lda     $3a         ; target
        cmp     #$04
        bcc     @2d0e       ; branch if a character
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80e7+1,y
        sta     $3a         ; $3a = $80e8,y (monster)
        bra     @2d12
@2d0e:  lda     #$ff
        sta     $3a         ; $3a = #$ff (character)
@2d12:  lda     z71         ; next available sprite
        longa
        asl2
        tay
        shorta0
        lda     near w7e631a,x     ; branch if numeral is green
        and     #$80
        bne     @2d27
        lda     #$38        ; use palette 4 (white numerals)
        bra     @2d29
@2d27:  lda     #$3a        ; use palette 5 (green numerals)
@2d29:  and     $3a
        sta     $0303,y     ; vhoopppm
        sta     $0307,y
        lda     $36
        sta     $0300,y     ; x position
        lda     $37
        and     #$01
        beq     @2d4b       ; branch if x position < $0100
        phx
        lda     near w7ea17f,y
        tax
        lda     $0500,x     ; set sprite high data
        ora     near w7ea77f,y
        sta     $0500,x
        plx
@2d4b:  longa
        lda     $36         ; next tile, x += 16
        clc
        adc     #$0010
        sta     $36
        shorta0
        lda     $36
        sta     $0304,y     ; x position
        lda     $37
        and     #$01
        beq     @2d72       ; branch if x position < $0100
        phx
        lda     near w7ea17f + 4,y
        tax
        lda     $0500,x     ; set sprite high data
        ora     near w7ea77f + 4,y
        sta     $0500,x
        plx
@2d72:  lda     $38         ; y position
        cmp     #$97
        bcc     @2d7a       ; hide sprite if y position < $97
        lda     #$e0
@2d7a:  sta     $0301,y
        sta     $0305,y
        lda     f:_c2e394,x   ; tile pointer for damage numeral sprite
        sta     $0302,y
        inc2
        sta     $0306,y
        inc     z71         ; increment next available sprite
        inc     z71
        pla
        rts

; ------------------------------------------------------------------------------

; [  ]

_c12d92:
bunsin_obj_set:
@2d92:  pha
        lda     near w7e7b68
        tax
        phx
        lda     f:BitOrTbl,x
        sta     $2c
        plx
        lda     near w7e201d
        and     near w7e61ac
        and     $2c
        beq     @2dd1
        lda     f:CharGfxDataBufPtrs,x
        tax
        lda     near wCharGfxDataBuf::GfxID,x
        cmp     #$ff
        beq     @2dd1
        lda     near wCharGfxDataBuf::ActiveStatus4,x
        andflg  STATUS4, HIDE
        bne     @2dd1
        lda     near wCharGfxDataBuf::ShownStatus2,x
        andflg  STATUS2, IMAGE
        beq     @2dd1
        lda     #$01
        sta     near w7e7b69
        lda     near w7e7b68
        jsr     DrawCharSprite
        stz     near w7e7b69
@2dd1:  pla
        rts

; ------------------------------------------------------------------------------

; [ update character color palettes ]

.enum STATUS_SKIN_COLOR
        POISON
        ZOMBIE
        BERSERK
.endenum

.enum STATUS_OUTLINE_COLOR
        REFLECT
        SAFE
        SHELL
        HASTE
        SLOW
        VANISH
        UNUSED
        STOP
.endenum

UpdateCharPal:
@2dd3:  lda     a:z98       ; frame counter
        inc
        and     #%11
        asl5
        tay                 ; +y = pointer to current character palette
        phy
        ldx     #$0018
@2de3:  lda     near w7e81ad,y     ; copy unaltered character palette
        sta     near w7e7e00::_12,y
        iny
        dex
        bne     @2de3
        ply
        lda     near wCharGfxData::VanishAnimCounter,y     ; branch if not vanishing
        beq     @2e05
        dec2                ; decrement vanish counter
        sta     near wCharGfxData::VanishAnimCounter,y
        bne     @2dfd
        stz     near w7e7b6a       ; vanish animation complete
@2dfd:  lda     #STATUS_OUTLINE_COLOR::VANISH
        jsr     UpdateVanishOutlineColor
        jmp     @2eb4
@2e05:  longa
        lda     near wCharGfxDataBuf::ShownStatus12,y     ; +$36 = current status 1 & 2
        sta     $36
        lda     near wCharGfxDataBuf::ShownStatus34,y     ; +$38 = current status 3 & 4
        sta     $38
        shorta0
        lda     $36         ; branch if character doesn't have petrify status
        andflg  STATUS1, PETRIFY
        beq     @2e2d
        clr_ax
@2e1c:  lda     f:PetrifyPal,x
        sta     near w7e7e00::_12::Color1,y
        iny
        inx
        cpx     #$0016
        bne     @2e1c
        jmp     @2eb4
@2e2d:  lda     $39         ; branch if character doesn't have frozen status
        andflg  STATUS4, FROZEN
        beq     @2e45
        clr_ax
        phy
@2e36:  lda     f:FrozenPal,x
        sta     near w7e7e00::_12::Color1,y
        iny
        inx
        cpx     #$0016
        bne     @2e36
        ply

; poison
@2e45:  lda     $36
        andflg  STATUS1, POISON
        beq     @2e51
        clr_a   ; lda #STATUS_SKIN_COLOR::POISON
        jsr     UpdateStatusSkinColor
        bra     @2eb4

; zombie
@2e51:  lda     $36
        andflg  STATUS1, ZOMBIE
        beq     @2e5e
        lda     #STATUS_SKIN_COLOR::ZOMBIE
        jsr     UpdateStatusSkinColor
        bra     @2eb4

; berserk
@2e5e:  lda     $37
        andflg  STATUS2, BERSERK
        beq     @2e6b
        lda     #STATUS_SKIN_COLOR::BERSERK
        jsr     UpdateStatusSkinColor
        bra     @2eb4

; reflect
@2e6b:  lda     $38
        bpl     @2e75
        clr_a   ; lda #STATUS_OUTLINE_COLOR::REFLECT
        jsr     UpdateStatusOutlineColor
        bra     @2eb4

; protect
@2e75:  andflg  STATUS3, SAFE
        beq     @2e80
        lda     #STATUS_OUTLINE_COLOR::SAFE
        jsr     UpdateStatusOutlineColor
        bra     @2eb4

; shell
@2e80:  lda     $38
        andflg  STATUS3, SHELL
        beq     @2e8d
        lda     #STATUS_OUTLINE_COLOR::SHELL
        jsr     UpdateStatusOutlineColor
        bra     @2eb4

; stop
@2e8d:  lda     $38
        andflg  STATUS3, STOP
        beq     @2e9a
        lda     #STATUS_OUTLINE_COLOR::STOP
        jsr     UpdateStatusOutlineColor
        bra     @2eb4

; haste
@2e9a:  lda     $38
        andflg  STATUS3, HASTE
        beq     @2ea7
        lda     #STATUS_OUTLINE_COLOR::HASTE
        jsr     UpdateStatusOutlineColor
        bra     @2eb4

; slow
@2ea7:  lda     $38
        andflg  STATUS3, SLOW
        beq     @2eb4
        lda     #STATUS_OUTLINE_COLOR::SLOW
        jsr     UpdateStatusOutlineColor
        bra     @2eb4

@2eb4:  rts

; ------------------------------------------------------------------------------

; [ update glowing border (vanish) ]

UpdateVanishOutlineColor:
@2eb5:  pha
        lda     near wCharGfxData::VanishAnimCounter,y
        asl2
        clc
        adc     #$40
        sta     $2c
        pla
        bra     _2ec9

; ------------------------------------------------------------------------------

; [ update glowing border ]

; A: border color
;      0: blue/reflect
;      1: yellow/safe
;      2: green/shell
;      3: red/haste
;      4: white/slow
;      5: white/vanish
;      6: red/unused
;      7: pink/stop

UpdateStatusOutlineColor:
@2ec3:  pha
        lda     z0e
        sta     $2c
        pla

one_pal1_main:
_2ec9:  pha
        lda     $2c
        and     #%11
        tax
        lda     f:StatusOutlineDelayTbl,x
        clc
        adc     $2c
        sta     $36
        and     #$40
        beq     @2eee
        lda     $36
        and     #$3c
        lsr
        sta     $2c
        lda     #%11111
        sec
        sbc     $2c
        sta     $2c
        stz     $2d
        bra     @2ef7
@2eee:  lda     $36
        and     #$3c
        lsr
        sta     $2c
        stz     $2d
@2ef7:  pla
        asl
        tax
        longa
        jsr     _c141e4
        lda     f:StatusOutlineColorTbl,x
        jsr     _c14202
        sta     near w7e7e00::_12::Color1,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update skin color ]

; A: skin color
;      0: poison
;      1: zombie
;      2: berserk

UpdateStatusSkinColor:
@2f0d:  asl2
        tax
        longa
        lda     f:StatusSkinColorTbl,x
        sta     near w7e7e00::_12::Color6,y
        lda     f:StatusSkinColorTbl+2,x
        sta     near w7e7e00::_12::Color7,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ determine which status sprite to use for this character ]

.enum STATUS_SPRITE
        NONE
        POISON
        CONFUSE
        BLIND
        BERSERK
        RAGE = BERSERK
        SILENCE
        SLEEP
.endenum

UpdateStatusSpriteIndex:
@2f24:  phx

; sleep
        lda     near wCharGfxDataBuf::ActiveStatus2,x
        sta     $10
        bpl     @2f30
        lda     #STATUS_SPRITE::SLEEP
        bra     @2f70

; confuse
@2f30:  lda     $10
        andflg  STATUS2, CONFUSE
        beq     @2f3a
        lda     #STATUS_SPRITE::CONFUSE
        bra     @2f70

; berserk
@2f3a:  lda     $10
        andflg  STATUS2, BERSERK
        beq     @2f44
        lda     #STATUS_SPRITE::BERSERK
        bra     @2f70

; rage
@2f44:  lda     near wCharGfxDataBuf::ActiveStatus4,x
        andflg  STATUS4, RAGE
        beq     @2f4f
        lda     #STATUS_SPRITE::RAGE
        bra     @2f70

; poison
@2f4f:  lda     near wCharGfxDataBuf::ActiveStatus1,x
        andflg  STATUS1, POISON
        beq     @2f5a
        lda     #STATUS_SPRITE::POISON
        bra     @2f70

; blind
@2f5a:  lda     near wCharGfxDataBuf::ActiveStatus1,x
        andflg  STATUS1, BLIND
        beq     @2f65
        lda     #STATUS_SPRITE::BLIND
        bra     @2f70

; silence
@2f65:  lda     $10
        andflg  STATUS2, SILENCE
        beq     @2f6f
        lda     #STATUS_SPRITE::SILENCE
        bra     @2f70

; none
@2f6f:  clr_a   ; lda #STATUS_SPRITE::NONE
@2f70:  sta     near wCharGfxData::StatusSpriteIndex,x
        plx
        rts

; ------------------------------------------------------------------------------

; [ update character status change animations (long access) ]

UpdateStatusChangeAnim_far:
@2f75:  jsr     UpdateStatusChangeAnim       ; update character status change animations
        rtl

; ------------------------------------------------------------------------------

; [ update character status change animations ]

; imp, morph, vanish

UpdateStatusChangeAnim:
@2f79:  lda     near w7e7b78       ; character index for status change animations
        and     #$03
        tay
        asl5
        tax
        lda     near wCharGfxData::VanishAnimCounter,x     ; counter for vanish palette
        jne     @304c
        lda     #1
        sta     near wCharGfxData::w7e61ce,x
        lda     near w7e2f4b       ; branch if running is disabled (event battles)
        and     #$01
        bne     @2fd1
        lda     near wCharGfxDataBuf::ActiveStatus4,x
        andflg  STATUS4, MORPH
        beq     @2fb5                   ; branch if not morph status
        lda     near w7e7b6c,y     ; character graphics index
        cmp     #CHAR_GFX::ESPER_TERRA
        beq     @2fe6       ; branch if esper terra
        lda     #CHAR_GFX::ESPER_TERRA
        sta     near w7e7b6c,y     ; change graphics to esper terra
        jsr     _c13157       ; update character graphics for status changes
        clr_a
        sta     near w7e7b70,y
        bra     @2fe6
@2fb5:  lda     near wCharGfxDataBuf::ActiveStatus1,x
        andflg  STATUS1, IMP
        beq     @2fd1
        lda     near w7e7b6c,y     ; character graphics index
        cmp     #CHAR_GFX::IMP
        beq     @2fe6       ; branch if imp
        lda     #CHAR_GFX::IMP
        sta     near w7e7b6c,y     ; change graphics to imp
        jsr     _c13157       ; update character graphics for status changes
        clr_a
        sta     near w7e7b70,y
        bra     @2fe6
@2fd1:  lda     near w7e7b6c,y     ; character graphics index
        cmp     near wCharGfxDataBuf::GfxID,x
        beq     @2fe6       ; branch if the same as buffer value
        lda     near wCharGfxDataBuf::GfxID,x
        sta     near w7e7b6c,y     ; change graphics to buffer value
        jsr     _c13157       ; update character graphics for status changes
        clr_a
        sta     near w7e7b70,y
@2fe6:  lda     near w7e2f4b       ; branch if running is disabled (event battles)
        and     #$01
        bne     @3013
        lda     near wCharGfxDataBuf::ActiveStatus1,x
        andflg  STATUS1, VANISH
        beq     @3013                   ; branch if not vanish status
        lda     near w7e7b70,y
        bne     @3032
        lda     near w7e7b6a
        bne     @3032
        inc     near w7e7b6a
        jsr     _c13050
        jsr     IsolateCharOutlineGfx
        lda     #$01
        sta     near w7e7b70,y
        lda     #$1e
        sta     near wCharGfxData::VanishAnimCounter,x
        bra     @3032
@3013:  lda     near w7e7b70,y
        beq     @3032
        lda     near w7e7b6a
        bne     @3032
        inc     near w7e7b6a
        jsr     _c13050
        lda     near w7e7b6c,y
        jsr     _c13157       ; update character graphics for status changes
        clr_a
        sta     near w7e7b70,y
        lda     #$1e
        sta     near wCharGfxData::VanishAnimCounter,x
@3032:  stz     near wCharGfxData::w7e61ce,x     ;
        jsr     _c13071
        jsr     UpdateStatusSpriteIndex
        longa
        lda     near wCharGfxDataBuf::ActiveStatus12,x     ; copy status to second graphics buffer
        sta     near wCharGfxDataBuf::ShownStatus12,x
        lda     near wCharGfxDataBuf::ActiveStatus34,x
        sta     near wCharGfxDataBuf::ShownStatus34,x
        shorta0
@304c:  inc     near w7e7b78       ; increment character number
        rts

; ------------------------------------------------------------------------------

; [ copy character graphics to buffer ]

_c13050:
tfr_chr_tmp:
@3050:  phy
        phx
        lda     near w7e7b78
        and     #$03
        asl
        tax
        phb
        longa
        lda     f:_c2e422,x
        tax
        ldy     #$8000
        lda     #$1fff
        mvn     #$7f,#$7f
        shorta0
        plb
        plx
        ply
        rts

; ------------------------------------------------------------------------------

; [ set character gfx action based on status ]

_c13071:
one_status_chr_set:
@3071:  phx
        longa
        lda     near wCharGfxDataBuf::ActiveStatus12,x
        sta     $10
        lda     near wCharGfxDataBuf::ActiveStatus34,x
        sta     $12
        shorta0
        lda     $10
        bpl     @3089                   ; dead
        lda     #$01
        bra     @30be
@3089:  lda     $11
        bpl     @3091                   ; sleep
        lda     #$0a
        bra     @30be
@3091:  andflg  STATUS2, CONFUSE
        beq     @3099
        lda     #$25
        bra     @30be
@3099:  lda     $13
        andflg  STATUS4, CONTROL
        beq     @30a3
        lda     #$09
        bra     @30be
@30a3:  lda     $10
        andflg  STATUS1, POISON
        beq     @30ad
        lda     #$0a
        bra     @30be
@30ad:  lda     $11
        andflg  STATUS2, NEAR_FATAL
        beq     @30b7
        lda     #$0a
        bra     @30be
@30b7:  lda     near wCharGfxData::w7e61bb,x
        bne     @30be
        lda     #$06
@30be:  sta     near wCharGfxData::w7e61bf,x
        plx
        rts

; ------------------------------------------------------------------------------

; [ isolate outline for character graphics buffer (for vanish) ]

; unused ???

@30c3:  phy
        phx
        phb
        lda     #$7f
        pha
        plb
        ldx     #$8000                  ; character graphics buffer
        ldy     #$0100
@30d0:  lda     #$08
        sta     $16
@30d4:  lda     a:$0001,x
        ora     a:$0010,x
        ora     a:$0011,x
        not_a
        and     a:$0000,x
        sta     a:$0000,x
        stz     a:$0001,x
        stz     a:$0010,x
        stz     a:$0011,x
        inx2
        dec     $16
        bne     @30d4
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        dey
        bne     @30d0
        plb
        plx
        ply
        rts

; ------------------------------------------------------------------------------

; [ isolate outline for character graphics (for vanish) ]

IsolateCharOutlineGfx:
@3106:  phy
        phx
        lda     near w7e7b78
        and     #$03
        asl
        tax
        longa
        lda     f:_c2e422,x             ; character graphics
        tax
        shorta0
        phb
        lda     #$7f
        pha
        plb
        ldy     #$0100
@3121:  lda     #$08
        sta     $16
@3125:  lda     a:$0001,x
        ora     a:$0010,x
        ora     a:$0011,x
        not_a
        and     a:$0000,x
        sta     a:$0000,x
        stz     a:$0001,x
        stz     a:$0010,x
        stz     a:$0011,x
        inx2
        dec     $16
        bne     @3125
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        dey
        bne     @3121
        plb
        plx
        ply
        rts

; ------------------------------------------------------------------------------

; [ update character graphics for status changes ]

_c13157:
one_poi_chr_set:
@3157:  phy
        phx
        pha
        tya
        sta     $10
        lda     near w7e7b78       ; character index
        and     #$03
        asl
        tax
        longa
        lda     f:_c2e422,x   ; pointer to character graphics buffer (+$7f0000)
        tax
        shorta0
        pla
        jsr     LoadCharGfx
        plx
        ply
        rts

; ------------------------------------------------------------------------------

; [ update character shadow sprites ]

DrawCharShadow:
@3175:  pha
        and     #$03
        tax
        lda     f:CharGfxDataBufPtrs,x
        tax
        stz     $42
        lda     near wCharGfxData::LayerPriority,x
        sta     $43
        lda     z71
        longa
        asl2
        tay
        lda     near wCharGfxData::PosX,x
        clc
        adc     near wCharGfxData::OffsetX,x
        clc
        adc     near wCharGfxData::AnimOffsetX,x
        sta     $36
        lda     near wCharGfxData::PosY,x
        clc
        adc     #$0010
        adc     near wCharGfxData::OffsetY,x
        sta     $38
        lda     $42
        ora     #$0c2c
        sta     $42
        shorta0
        lda     $36
        sta     $0300,y
        lda     $37
        and     #$01
        beq     @31c7
        lda     near w7ea17f,y
        tax
        lda     $0500,x
        ora     near w7ea77f,y
        sta     $0500,x
@31c7:  lda     $39
        and     #$01
        beq     @31d6
        lda     $38
        cmp     #$e0
        bcs     @31de
        jmp     @31dc
@31d6:  lda     $38
        cmp     #$97
        bcc     @31de
@31dc:  lda     #$97
@31de:  sta     $0301,y
        longa
        lda     $42
        sta     $0302,y
        shorta0
        inc     z71
        pla
        rts

; ------------------------------------------------------------------------------

; [  ]

; A:

_c131ef:
armer_pat_set:
@31ef:  and     #$03
        sta     $36
        lda     z0e         ; frame counter
        and     #%11
        cmp     $36
        bne     @326a
        tax
        tay
        lda     near w7ee9ef
        beq     @3209       ; branch if battle time is running
        lda     z0e
        lsr3
        bra     @320d
@3209:  lda     z0e
        lsr2
@320d:  and     #$03
        sta     $36
        lda     near wMagitekAnimType,x
        asl2
        clc
        adc     $36
        tax
        lda     f:_c2cf73,x
        asl2
        tax
        longa
        lda     f:MagitekGfxPtrs,x
        sta     near wMagitekGfxSrcPtr
        clc
        adc     #$0080
        sta     near wMagitekGfxSrcPtr + 4
        clc
        adc     #$0180
        sta     near wMagitekGfxSrcPtr + 2
        clc
        adc     #$0080
        sta     near wMagitekGfxSrcPtr + 6
        lda     z0e
        and     #%11
        asl3
        tax
        .repeat 4, i
        lda     f:MagitekGfxVRAMTbl + i * 2,x
        sta     near wMagitekGfxVRAMPtr + i * 2
        .endrep
        shorta0
        inc     near wForceMagitekGfxTfr
@326a:  rts

; ------------------------------------------------------------------------------

; [  ]

_c1326b:
set_armer_offset:
@326b:  phx
        lda     z0e
        and     #%11
        cmp     $32
        bne     @329d
        tax
        tay
        lda     z0e
        lsr2
        sta     $36
        lda     near w7ee9ef       ; branch if battle time is running
        beq     @3283
        lsr     $36
@3283:  lda     $36
        and     #$03
        sta     $36
        lda     near wMagitekAnimType,x
        asl2
        clc
        adc     $36
        tax
        lda     f:_c2cf73,x
        beq     @329a
        lda     #1
@329a:  sta     near w7e64d0,y
@329d:  plx
        rts

; ------------------------------------------------------------------------------

; [ draw shield block sprites ]

DrawBlockSprites:
@329f:  pha
        and     #$03
        sta     $32
        tax
        jsr     _c1326b
        lda     near w7e64d0,x
        sta     $3c
        lda     f:CharGfxDataBufPtrs,x
        tax
        stz     $3a
        lda     near wCharGfxData::w7e61c3,x     ; current graphic action
        cmp     #$30
        bcc     @32bf       ; branch if not mirrored
        lda     #$40
        sta     $3a
@32bf:  lda     near wCharGfxData::Flip,x
        and     #$c0
        eor     $3a
        ora     near wCharGfxData::LayerPriority,x
        and     #$f1
        ora     near wMagitekPalOffset
        sta     $43
        stz     $42
        lda     z71
        dec2
        longa
        asl2
        tay
        shorta0
        lda     $0301,y
        clc
        adc     $3c
        sta     $0301,y
        lda     $0305,y
        clc
        adc     $3c
        sta     $0305,y
        lda     z71
        longa
        asl2
        tay
        lda     near wCharGfxData::PosX,x
        clc
        adc     near wCharGfxData::OffsetX,x
        clc
        adc     near wCharGfxData::AnimOffsetX,x
        sta     $36
        lda     near wCharGfxData::PosY,x
        clc
        adc     near wCharGfxData::OffsetY,x
        clc
        adc     near wCharGfxData::JumpOffset,x
        sta     $38
        shorta0
        lda     $32
        asl2
        tax
        clc
        lda     f:_c2cf83,x
        bpl     @332c
        adc     $36
        sta     $0300,y
        lda     $37
        adc     #$01
        jmp     @3335
@332c:  adc     $36
        sta     $0300,y
        lda     $37
        adc     #$00
@3335:  and     #$01
        beq     @334c
        stx     $3c
        lda     near w7ea17f,y
        tax
        lda     $0500,x
        ora     near w7ea57f,y
        sta     $0500,x
        ldx     $3c
        bra     @335d
@334c:  stx     $3c
        lda     near w7ea17f,y
        tax
        lda     $0500,x
        ora     near w7ea37f,y
        sta     $0500,x
        ldx     $3c
@335d:  clc
        lda     f:_c2cf83+1,x
        bpl     @336e
        adc     $38
        sta     $3e
        lda     $39
        adc     #$01
        bra     @3376
@336e:  adc     $38
        sta     $3e
        lda     $39
        adc     #$00
@3376:  and     #$01
        beq     @3383
        lda     $3e
        cmp     #$e0
        bcs     @338b
        jmp     @3389
@3383:  lda     $3e
        cmp     #$97
        bcc     @338b
@3389:  lda     #$97
@338b:  sta     $0301,y
        longa
        lda     f:_c2cf83+2,x
        ora     $42
        sta     $0302,y
        shorta0
        inc     z71
        pla
        jsr     _c131ef
        rts

; ------------------------------------------------------------------------------

; [ update character status sprites ]

DrawStatusSprites:
@33a3:  pha
        and     #$03
        tax
        stz     $42
        lda     f:CharGfxDataBufPtrs,x
        tax
        lda     near wCharGfxData::StatusSpriteIndex,x
        bne     @33b5                   ; return if no status sprite
        pla
        rts
@33b5:  stz     $3a
        lda     near wCharGfxData::w7e61c3,x
        cmp     #$30
        bcc     @33c2
        lda     #$40
        sta     $3a
@33c2:  lda     near wCharGfxData::w7e61c3,x     ; current graphic action
        cmp     #$14
        beq     @33d2       ; branch if kneeling
        cmp     #$44
        beq     @33d2       ; branch if kneeling
        stz     $3c
        jmp     @33d6
@33d2:  lda     #$1c        ; y-offset for kneeling character status sprite
        sta     $3c
@33d6:  stz     $32
        lda     near wCharGfxData::Flip,x
        and     #$c0
        eor     $3a
        ora     near wCharGfxData::LayerPriority,x
        sta     $43
        and     #$40
        beq     @33ed
        lda     near wCharGfxData::StatusSpriteIndex,x
        sta     $32
@33ed:  jsr     _c134a5
        lda     z71
        longa
        asl2
        tay
        lda     near wCharGfxData::PosX,x
        clc
        adc     near wCharGfxData::OffsetX,x
        clc
        adc     near wCharGfxData::AnimOffsetX,x
        sta     $36
        lda     near wCharGfxData::PosY,x
        clc
        adc     near wCharGfxData::OffsetY,x
        adc     near wCharGfxData::JumpOffset,x
        adc     $38
        sta     $38
        phx
        lda     $32             ; status sprite index
        and     #$00ff
        asl
        tax
        lda     f:StatusSpriteOffsetTbl,x   ; x offsets for character status sprites
        clc
        adc     $36
        sta     $36
        plx
        shorta0
        lda     near wCharGfxData::StatusSpriteIndex,x       ; could be lda $32
        dec
        asl2
        clc
        adc     $3c
        tax
        clc
        lda     f:StatusSpriteData,x   ; x position for character status sprites
        bpl     @3444
        adc     $36
        sta     $0300,y
        lda     $37
        adc     #$01
        jmp     @344d
@3444:  adc     $36
        sta     $0300,y
        lda     $37
        adc     #$00
@344d:  and     #$01
        beq     @3462
        stx     $3c
        lda     near w7ea17f,y
        tax
        lda     $0500,x
        ora     near w7ea77f,y
        sta     $0500,x
        ldx     $3c
@3462:  clc
        lda     f:StatusSpriteData+1,x   ; y position for character status sprites
        bpl     @3473
        adc     $38
        sta     $3e
        lda     $39
        adc     #$01
        bra     @347b
@3473:  adc     $38
        sta     $3e
        lda     $39
        adc     #$00
@347b:  and     #$01
        beq     @3488
        lda     $3e
        cmp     #$e0
        bcs     @3490
        jmp     @348e
@3488:  lda     $3e
        cmp     #$97
        bcc     @3490
@348e:  lda     #$97
@3490:  sta     $0301,y
        longa
        lda     f:StatusSpriteData+2,x
        ora     $42
        sta     $0302,y
        shorta0
        inc     z71
        pla
        rts

; ------------------------------------------------------------------------------

; [ update y-offset for float/magitek status ]

_c134a5:
get_yoffset:
@34a5:  stz     $38
        stz     $39
        lda     near wMagitekModeEnabled
        beq     @34b6
        phx
        ldx     #$fff4
        stx     $38
        plx
        rts
@34b6:  lda     near wCharGfxDataBuf::ShownStatus4,x
        bpl     @34da
        lda     near wCharGfxData::DisableFloatOffset,x
        bne     @34da
        lda     near wCharGfxData::w7e61c1,x
        bne     @34da
        phx
        lda     near wCharGfxData::w7e61c2,x
        and     #$38
        lsr3
        tax
        lda     #$ff
        sta     $39
        lda     f:FloatStatusOffsetTbl,x
        sta     $38
        plx
@34da:  rts

; ------------------------------------------------------------------------------

; [ update character sprites ]

DrawCharSprite:
@34db:  pha
        and     #$03
        tay
        tax
        lda     f:BitOrTbl,x
        sta     $36
        lda     f:_c2cf57,x
        sta     $40
        lda     f:CharGfxDataBufPtrs,x
        tax
        lda     near w7e7b69
        beq     @34f9
        dec     near wCharGfxData::w7e61c2,x
@34f9:  stz     $44
        stz     $45
        lda     near wCharGfxData::Pal,x
        ora     near wCharGfxData::LayerPriority,x
        sta     $42
        lda     near w7e629a
        bne     @3549
        lda     near w7eecb8
        cmp     #$21
        beq     @3516
        lda     near w7e2f45
        beq     @3549
@3516:  lda     near w7e62a5,y
        bne     @3549
        lda     near w7e62a0,y
        bne     @3549
        lda     near w7e2f47
        and     $36
        bne     @3549
        lda     near wCharGfxDataBuf::ShownStatus1,x
        andflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @3549
        lda     near wCharGfxDataBuf::ShownStatus2,x
        andflg  STATUS2, SLEEP
        bne     @3549
        lda     near wCharGfxDataBuf::ShownStatus3,x
        andflg  STATUS3, STOP
        bne     @3549
        lda     near wCharGfxDataBuf::ShownStatus4,x
        andflg  STATUS4, MORPH
        bne     @3549
        lda     #$0c
        sta     $36
        bra     @355f
@3549:  lda     near wCharGfxData::w7e61c1,x
        bne     @3595
        lda     near wCharGfxData::w7e61c0,x
        bne     @3556
        lda     near wCharGfxData::w7e61bf,x
@3556:  asl2
        sta     $36
        lda     near wCharGfxData::w7e61d0,x
        beq     @3564
@355f:  lda     near wCharGfxData::w7e61c2,x
        bra     @3568
@3564:  lda     near wCharGfxData::w7e61c2,x
        lsr
@3568:  lsr2
        sta     $38
        lda     near wMagitekModeEnabled
        beq     @3578
        lda     near w7ee9ef       ; branch if battle time is running
        beq     @3578
        lsr     $38
@3578:  lda     $38
        and     #$03
        clc
        adc     $36
        txy
        tax
        lda     f:_c2c6a9,x   ; frames for animated graphic actions
        sta     $36
        and     #$1f
        cmp     #$07
        bne     @3592
        ldx     $44
        dex
        stx     $44
@3592:  tyx
        lda     $36
@3595:  sta     near wCharGfxData::w7e61c3,x     ; set current graphic action
        sta     $36
        stz     $38
        cmp     #$30
        bcc     @35a9
        sec
        sbc     #$30
        sta     $36
        lda     #$40
        sta     $38
@35a9:  stz     $3a
        lda     $36
        bne     @35b3
        lda     #$08
        sta     $3a
@35b3:  lda     near wCharGfxData::Flip,x
        and     #$c0
        eor     $38
        ora     $42
        sta     $42
        and     #$c0
        lsr2
        ora     $3a
        sta     $3a
        sta     near w7ee9da
        stz     $36
        stz     $37
        lda     near w7e7b69
        beq     @35e2
        lda     $42
        and     #$40
        beq     @35dd
        ldy     #$fff8
        bra     @35e0
@35dd:  ldy     #$0008
@35e0:  sty     $36
@35e2:  jsr     _c134a5
        inc     near wCharGfxData::w7e61c2,x
        lda     z71
        longa
        asl2
        tay
        lda     near wCharGfxData::PosX,x
        clc
        adc     near wCharGfxData::AnimOffsetX,x
        clc
        adc     near wCharGfxData::OffsetX,x
        clc
        adc     $36
        sta     $36
        lda     near wCharGfxData::PosY,x
        clc
        adc     near wCharGfxData::OffsetY,x
        adc     near wCharGfxData::JumpOffset,x
        adc     $38
        adc     $44
        sta     $38
        shorta0
        lda     $3a
        tax
        lda     #$02
        sta     $41
@3619:  clc
        lda     f:CharSpriteData,x
        bpl     @362c
        adc     $36
        sta     $0300,y
        lda     $37
        adc     #$01
        jmp     @3635
@362c:  adc     $36
        sta     $0300,y
        lda     $37
        adc     #$00
@3635:  and     #$01
        beq     @364a
        stx     $3c
        lda     near w7ea17f,y
        tax
        lda     $0500,x
        ora     near w7ea77f,y
        sta     $0500,x
        ldx     $3c
@364a:  iny
        inx
        clc
        lda     f:CharSpriteData,x
        bpl     @365e
        adc     $38
        sta     $3e
        lda     $39
        adc     #$01
        jmp     @3666
@365e:  adc     $38
        sta     $3e
        lda     $39
        adc     #$00
@3666:  and     #$01
        beq     @3673
        lda     $3e
        cmp     #$e0
        bcs     @367b
        jmp     @3679
@3673:  lda     $3e
        cmp     #$97
        bcc     @367b
@3679:  lda     #$97
@367b:  sta     $0300,y
        iny
        inx
        lda     f:CharSpriteData,x
        clc
        adc     $40
        sta     $0300,y
        iny
        inx
        lda     f:CharSpriteData,x
        ora     $42
        sta     $0300,y
        iny
        inx
        inc     z71
        dec     $41
        jne     @3619
        pla
        rts

; ------------------------------------------------------------------------------

; [ update character graphics ]

UpdateCharGfx:
@36a2:  clr_a
        stz     $2c
@36a5:  tax
        pha
        lda     near wCharGfxData::w7e61ce,x
        bne     @36d7
        lda     near wCharGfxData::w7e61c2,x
        dec
        and     #$07
        beq     @36bc
        lda     near wCharGfxData::w7e61c3,x
        cmp     near wCharGfxData::w7e61c4,x
        beq     @36d7       ; branch if character graphic action has not changed
@36bc:  lda     near wCharGfxData::w7e61c3,x
        sta     near wCharGfxData::w7e61c4,x
        cmp     #$30
        bcc     @36c9
        sec
        sbc     #$30
@36c9:  sta     $37
        lda     near wCharGfxData::VanishAnimCounter,x
        sta     $3a
        stz     $3b
        lda     $2c
        jsr     _c136e2
@36d7:  inc     $2c
        pla
        clc
        adc     #$20
        cmp     #$80
        bne     @36a5
        rts

; ------------------------------------------------------------------------------

; [  ]

;   A: character slot
; $37: graphic action
; $3a: counter for vanish palette

_c136e2:
player_pat_chr_set:
@36e2:  pha
        sta     $3c
        lda     $3a
        bne     @36ee       ; branch if vanish palette counter is active
        jsr     UpdateCharGfxBuf
        bra     @36f8
@36ee:  lsr3
        and     #%11
        asl
        tax
        jsr     (near _c1373f,x)
@36f8:  pla
        and     #%11
        tax
        lda     near wCondemnNumBuf,x        ; condemned number
        beq     @373e                   ; return if not visible
        txa
        asl
        tax
        phb
        lda     #$7f
        pha
        plb
        longa
        lda     w7ee9d2,x   ; pointer to condemned numeral graphics
        tay
        lda     f:_c2e41a,x   ; pointer to character graphics buffer
        tax
        lda     #8
        sta     $3a
@371a:  lda     a:$0000,y
        sta     a:$0000,x
        lda     a:$0010,y
        sta     a:$0010,x
        lda     a:$0020,y
        sta     a:$0020,x
        lda     a:$0030,y
        sta     a:$0030,x
        iny2
        inx2
        dec     $3a
        bne     @371a
        shorta0
        plb
@373e:  rts

; ------------------------------------------------------------------------------

; jump table for vanishing character ??? (one per character)
super_jmp:
_c1373f:
@373f:  .addr   _c1379a,_c137e7,_c13834,_c13881

; ------------------------------------------------------------------------------

; [  ]

UpdateCharGfxBuf:
@3747:  lda     $3c         ; character slot
        asl
        tax
        phb
        stz     $36
        longa
        lda     f:_c2e41a,x   ; pointer to character graphics buffer
        sta     $38
        tay
        lda     f:_c2e422,x   ; pointer to character sprite sheet buffer
        clc
        adc     $36
        tax
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0200
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0040
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     wMagitekModeEnabled
        and     #$00ff
        bne     @3795
        lda     $38
        clc
        adc     #$0240
        tay
        lda     #$003f
        mvn     #$7f,#$7f
@3795:  shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1379a:
@379a:  lda     $3c
        asl
        tax
        phb
        stz     $36
        longa
        lda     f:_c2e412,x
        sta     $3c
        lda     f:_c2e41a,x   ; pointer to character graphics buffer
        sta     $38
        tay
        lda     f:_c2e422,x   ; pointer to character sprite sheet buffer
        clc
        adc     $36
        tax
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0200
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0040
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0240
        tay
        jsr     _c138d2
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c137e7:
@37e7:  lda     $3c
        asl
        tax
        phb
        stz     $36
        longa
        lda     f:_c2e412,x
        sta     $3c
        lda     f:_c2e41a,x   ; pointer to character graphics buffer
        sta     $38
        tay
        lda     f:_c2e422,x   ; pointer to character sprite sheet buffer
        clc
        adc     $36
        tax
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0200
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0040
        tay
        jsr     _c138d2
        lda     $38
        clc
        adc     #$0240
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c13834:
@3834:  lda     $3c
        asl
        tax
        phb
        stz     $36
        longa
        lda     f:_c2e412,x
        sta     $3c
        lda     f:_c2e41a,x   ; pointer to character graphics buffer
        sta     $38
        tay
        lda     f:_c2e422,x
        clc
        adc     $36
        tax
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0200
        tay
        jsr     _c138d2
        lda     $38
        clc
        adc     #$0040
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0240
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c13881:
@3881:  lda     $3c
        asl
        tax
        phb
        lda     #$7f
        pha
        plb
        stz     $36
        longa
        lda     f:_c2e412,x
        sta     $3c
        lda     f:_c2e41a,x   ; pointer to character graphics buffer
        sta     $38
        tay
        lda     f:_c2e422,x   ; pointer to character sprite sheet buffer
        clc
        adc     $36
        tax
        jsr     _c138d2
        lda     $38
        clc
        adc     #$0200
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0040
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        lda     $38
        clc
        adc     #$0240
        tay
        lda     #$003f
        mvn     #$7f,#$7f
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c138d2:
super_level_tfr:
        .a16
@38d2:  phx
        lda     $3a
        and     #$0007
        sta     $3a
        lda     #$0008
        sec
        sbc     $3a
        sta     $3e
@38e2:  lda     a:$0000,x
        sta     a:$0000,y
        lda     a:$0010,x
        sta     a:$0010,y
        lda     a:$0020,x
        sta     a:$0020,y
        lda     a:$0030,x
        sta     a:$0030,y
        inx2
        iny2
        dec     $3e
        bne     @38e2
        lda     $3a
        beq     @392b
        txa
        clc
        adc     $3c
        tax
@390b:  lda     a:$0000,x
        sta     a:$0000,y
        lda     a:$0010,x
        sta     a:$0010,y
        lda     a:$0020,x
        sta     a:$0020,y
        lda     a:$0030,x
        sta     a:$0030,y
        inx2
        iny2
        dec     $3a
        bne     @390b
@392b:  pla
        clc
        adc     $3c
        clc
        adc     #$0040
        tax
        rts
        .a8

; ------------------------------------------------------------------------------

; [ draw monster (sprite) ]

DrawMonsterSprite:
        lda     near w7e88d2
        tay
        asl
        tax
        stx     $2e
        lda     near w7e88b9,y
        sta     $2c
        lda     near w7e80db,x
        ora     near w7e80db+1,x
        and     near w7e80e7+1,x
        sta     $3d
        stz     $3c
        lda     #^MonsterSpriteDataPtrs
        sta     $38
        lda     near w7e80f3,x
        eor     near w7e617e,x
        and     #$03
        asl2
        tax
        longa
        lda     $3c
        eor     f:_c2c464,x
        sta     $3c
        lda     f:_c2c464+2,x
        sta     $36
        ldy     $2e
        tyx
        lda     [$36],y
        tay
        lda     near w7e80c3,x
        sta     $38
        lda     near w7e80cf,x
        sta     $3a
        lda     z60
        and     #$00ff
        asl2
        tax
        shorta0
@3989:  clc
        lda     $0000,y
        bpl     @399f
        adc     $38
        sta     $0300,x
        lda     $39
        adc     #$01
        and     #$01
        bne     @39c0
        jmp     @39ac
@399f:  adc     $38
        sta     $0300,x
        lda     $39
        adc     #$00
        and     #$01
        bne     @39c0
@39ac:  sty     $44
        lda     near w7ea17f,x
        tay
        lda     $0500,y
        ora     near w7ea37f,x
        sta     $0500,y
        ldy     $44
        jmp     @39d1
@39c0:  sty     $44
        lda     near w7ea17f,x
        tay
        lda     $0500,y
        ora     near w7ea57f,x
        sta     $0500,y
        ldy     $44
@39d1:  iny
        inx
        lda     $0000,y
        bpl     @39e8
        clc
        adc     $3a
        sta     $3e
        lda     $3b
        adc     #$01
        and     #$01
        beq     @39fe
        jmp     @39f5
@39e8:  clc
        adc     $3a
        sta     $3e
        lda     $3b
        adc     #$00
        and     #$01
        beq     @39fe
@39f5:  lda     $3e
        cmp     #$e0
        bcs     @3a06
        jmp     @3a04
@39fe:  lda     $3e
        cmp     #$97
        bcc     @3a06
@3a04:  lda     #$97
@3a06:  sta     $0300,x
        iny
        inx
        longa
        lda     $0000,y
        ora     $3c
        sta     $0300,x
        shorta0
        iny2
        inx2
        inc     z60
        dec     $2c
        jne     @3989
        rts

; ------------------------------------------------------------------------------

; [ update character x positions ]

UpdateCharXPos:
        .repeat 4, i
        ldx     .loword(array_member wCharGfxData, i, w7e61c9)       ; character 1 target xy angle
        cpx     .loword(array_member wCharGfxData, i, w7e61cb)
        beq     :+       ; branch if equal to current xy angle
        stx     .loword(array_member wCharGfxData, i, w7e61cb)       ; +$36 = xy angle
        stx     $36
        lda     .loword(array_member wCharGfxData, i, PosY)       ; $2c = y position
        sta     $2c
        jsr     CalcCharXPos
        stx     .loword(array_member wCharGfxData, i, PosX)       ; x position
:       .endrep
        rts

; ------------------------------------------------------------------------------

; [ calculate character x position ]

; +$36: xy angle ($0100 = vertical, $0180 = 45 degrees to the right)
;  $2c: y position
;   +X: absolute x position (out)

CalcCharXPos:
@3a87:  stz     $2d
        lda     $2c
        clc
        adc     #$68        ; top of "character triangle" is $68 above top of screen
        sta     $2c
        longa
        lda     $36
        and     #$01ff
        sec
        sbc     #$0100      ; +$2e = xy angle battlefield center (-255..255)
        sta     $2e
        lda     $2e
        bpl     @3ab0       ; branch if to the right of center
        not_a
        sta     $2e
        jsr     Mult816NoHW
        lda     $31
        not_a
        bra     @3ab5
@3ab0:  jsr     Mult816NoHW
        lda     $31
@3ab5:  clc
        adc     #$0078      ; add $78 center to center x position on screen
        tax
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init character graphics data ]

InitCharGfxMain:
.if LANG_EN
@3abe:  lda     near w7eecb8       ; battle bg
        cmp     #BATTLE_BG::MAGITEK_TRAIN
        bne     @3ac9       ; branch if not $2c (magitek train car)
        lda     #$04
        bra     @3acc
@3ac9:  lda     near w7e201f       ; battle type
@3acc:  asl2
        tax
        .repeat 4, i
        lda     f:CharYOffsetTbl + i,x   ; character y-offset
        tay
        sty     .loword(array_member wCharGfxData, i, PosY)
        .endrep
        .repeat 4, i
        lda     f:CharFlipTbl+i,x   ; character h-flip
        sta     .loword(array_member wCharGfxData, i, Flip)
        .endrep
.endif
        jsl     _c2afa3
        stz     $10
        lda     near wCharGfxDataBuf::_0::GfxID
        sta     near w7e7b6c
        ldx     #$0000
        jsr     LoadCharGfx
        lda     #$01
        sta     $10
        lda     near wCharGfxDataBuf::_1::GfxID
        sta     near w7e7b6c+1
        ldx     #$2000
        jsr     LoadCharGfx
        lda     #$02
        sta     $10
        lda     near wCharGfxDataBuf::_2::GfxID
        sta     near w7e7b6c + 2
        ldx     #$4000
        jsr     LoadCharGfx
        lda     #$03
        sta     $10
        lda     near wCharGfxDataBuf::_3::GfxID
        sta     near w7e7b6c + 3
        ldx     #$6000
        jsr     LoadCharGfx
        lda     #$d0        ;
        sta     $1e
        lda     near w7e201f       ; battle type
        asl2
        tax
        .repeat 4, i
        lda     f:CharDirTbl + i,x   ; character hand swap
        sta     near w7e7b10 + i
        .endrep
        lda     near w7e201f       ; battle type
        asl3
        tax
        longa
        .repeat 4, i
        lda     f:CharXAngleTbl+2*i,x   ; character xy angle
        sta     .loword(array_member wCharGfxData, i, w7e61c9)
        inc
        sta     .loword(array_member wCharGfxData, i, w7e61cb)
        lda     .loword(array_member wCharGfxDataBuf, i, Row)
        and     #$00ff
        beq     :+       ; branch if front row
        shorta
        lda     #1
        sta     .loword(array_member wCharGfxDataBuf, i, Row)
        longa
        lda     .loword(array_member wCharGfxData, i, w7e61c9)
        clc
        adc     f:CharRowOffsetTbl + i * 2,x   ; add back row xy angle
        sta     .loword(array_member wCharGfxData, i, w7e61c9)
:       .endrep
        .repeat 4, i
        stz     .loword(array_member wCharGfxData, i, JumpOffset) + 1
        .endrep
        shorta0
.if !LANG_EN
        lda     near w7eecb8
        cmp     #BATTLE_BG::MAGITEK_TRAIN
        bne     @3bbd
        lda     #$04
        bra     @3bc0
@3bbd:  lda     near w7e201f
@3bc0:  asl2
        tax
        .repeat 4, i
        lda     f:CharYOffsetTbl + i,x   ; character y-offset
        tay
        sty     .loword(array_member wCharGfxData, i, PosY)
        .endrep
        .repeat 4, i
        lda     f:CharFlipTbl + i,x   ; character h-flip
        sta     .loword(array_member wCharGfxData, i, Flip)
        .endrep
.endif
        ldx     $11e0       ; battle index
        cpx     #$023e
        beq     @3c34       ; branch if shadow at colosseum
        cpx     #$023f
        bne     @3c3a       ; branch if not colosseum
@3c34:  ldy     #$0068
        sty     near wCharGfxData::PosY       ; character 1 y position
@3c3a:  clr_axy
        longa
@3c3f:  lda     near w7e6246,x
        cmp     #$ffff
        beq     @3c54
        clc
        adc     #$0080
        sta     near wCharGfxData::w7e61c9,y
        lda     near w7e6248,x
        sta     near wCharGfxData::PosY,y
@3c54:  inx4                ; next character
        tya
        clc
        adc     #$0020
        tay
        cpy     #$0080
        bne     @3c3f
        shorta0
        lda     #$08
        sta     near wCharGfxData::_0::Pal       ; character 1 palette
        lda     #$0a
        sta     near wCharGfxData::_1::Pal       ; character 2 palette
        lda     #$0c
        sta     near wCharGfxData::_2::Pal       ; character 3 palette
        lda     #$0e
        sta     near wCharGfxData::_3::Pal       ; character 4 palette
        lda     #$30
        sta     near wCharGfxData::_0::LayerPriority       ; sprite priority = 3
        sta     near wCharGfxData::_1::LayerPriority
        sta     near wCharGfxData::_2::LayerPriority
        sta     near wCharGfxData::_3::LayerPriority
        lda     #$06        ; tertiary graphics index = 6
        sta     near wCharGfxData::_0::w7e61bf
        sta     near wCharGfxData::_1::w7e61bf
        sta     near wCharGfxData::_2::w7e61bf
        sta     near wCharGfxData::_3::w7e61bf
        ldx     zZero         ; primary & secondary graphics index = 0
        stx     near wCharGfxData::_0::w7e61c0
        stx     near wCharGfxData::_1::w7e61c0
        stx     near wCharGfxData::_2::w7e61c0
        stx     near wCharGfxData::_3::w7e61c0
        clr_a
        sta     a:z98       ; clear frame counter
        sta     near wCharGfxData::_0::w7e61c2       ; character 1 graphic action counter = 0
        inc2
        sta     near wCharGfxData::_1::w7e61c2       ; character 2 graphic action counter = 2
        inc2
        sta     near wCharGfxData::_2::w7e61c2       ; character 3 graphic action counter = 4
        inc2
        sta     near wCharGfxData::_3::w7e61c2       ; character 4 graphic action counter = 6
        clr_axy
@3cbd:  lda     near wCharGfxDataBuf::GfxID,x     ; character graphics index
        cmp     #$ff
        beq     @3cd1       ; branch if no character
        iny
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @3cbd
        clr_ay
@3cd1:  tyx                 ; y = first empty character slot (0 if no slots are empty)
        lda     f:MagitekPalOffsetTbl,x
        sta     near wMagitekPalOffset       ; magitek color palette
        txa
        asl5
        tay
        lda     near wMagitekModeEnabled       ; branch if not magitek mode
        beq     @3cfb
        lda     #$18        ; 12 colors
        sta     $10
        clr_ax
@3ceb:  lda     f:MagitekPal,x
        sta     near w7e81ad,y
        sta     near w7e7e00::_12,y
        inx
        iny
        dec     $10
        bne     @3ceb
@3cfb:  lda     near w7e2f47       ; characters acting as enemies
        sta     $10
        clr_axy
@3d03:  lsr     $10
        bcc     @3d17       ; branch if character is not acting as an enemy
        lda     near w7e7b10,x     ; swap character hands
        eor     #$01
        sta     near w7e7b10,x
        lda     near wCharGfxData::Flip,y     ; h-flip character
        eor     #$40
        sta     near wCharGfxData::Flip,y
@3d17:  tya                 ; next character
        clc
        adc     #$20
        tay
        inx
        cpx     #4
        bne     @3d03
        rts

; ------------------------------------------------------------------------------

; [ init char sprite data (next part of final battle) ]

InitCharGfxFinalBattle:
@3d23:  jsr     InitCharGfxMain
        rts

; ------------------------------------------------------------------------------

; [ init char sprite data ]

InitCharGfx:
@3d27:  jsr     InitCharGfxMain
        jsr     UpdateCharXPos
        lda     #4
        dec     a:z98
@3d32:  pha
        jsr     UpdateCharPal
        jsr     UpdateStatusChangeAnim       ; update character status change animations
        inc     a:z98
        inc     z0e
        pla
        dec
        bne     @3d32
        rts

; ------------------------------------------------------------------------------

; [ load character graphics/palette ]

;  A: character graphics index
; +X: pointer to graphics buffer(+$7f0000)

LoadCharGfx:
@3d43:  cmp     #$ff
        bne     @3d48       ; return if not a valid character
        rts
@3d48:  sta     $14
        stx     $1c
        tax
        lda     $10
        pha
        pha
        phx
        ldx     $1c
        stx     $1a
        lda     $14
        asl
        clc
        adc     $14
        tax
        lda     #^_c2c745
        sta     $16
        phb
        lda     #$7f
        pha
        plb
        lda     f:CharGfxPtrs+2,x
        sta     $12
        longa
        lda     f:CharGfxPtrs,x
        sta     $10
        lda     #near _c2c745   ; pointers to tile graphics in buffer (+$7f0000)
        sta     $14
        ldx     $1a
        lda     #$0100      ; copy 256 tiles
        sta     $1a
@3d80:  lda     #$0010      ; copy 16 words (one 8x8 tile)
        sta     $18
        lda     [$14]       ; destination
        cmp     #$ffff
        bne     @3d98       ; branch if there is a tile
        clr_a
@3d8d:  sta     a:$0000,x     ; clear graphics
        inx2
        dec     $18
        bne     @3d8d
        bra     @3da6
@3d98:  tay
@3d99:  lda     [$10],y
        sta     a:$0000,x     ; copy graphics to buffer (one 8x8 tile)
        inx2
        iny2
        dec     $18
        bne     @3d99
@3da6:  inc     $14         ; next tile
        inc     $14
        dec     $1a
        bne     @3d80
        shorta0
        ldx     $1c
        lda     #$40        ; 64 tiles
        sta     $12
@3db7:  lda     $03c0,x     ; horizontally flip legs tiles
        .repeat 8
        asl
        ror     $10
        .endrep
        lda     $10
        sta     $03c0,x
        lda     $10c0,x
        .repeat 8
        asl
        ror     $10
        .endrep
        lda     $10
        sta     $10c0,x
        inx
        dec     $12
        bne     @3db7
        plb
        plx
        pla
        asl5
        phx
        tax
        lda     near wCharGfxDataBuf::GfxID,x
        cmp     #CHAR_GFX::SOLDIER
        bne     @3e1f       ; branch if not brown soldier
        lda     near wCharGfxDataBuf::CharID,x
        cmp     #CHAR::LOCKE
        bne     @3e1f       ; branch if not locke
        lda     $1ea0
        and     #$08
        beq     @3e1f       ; event bit for when locke is a green soldier
        plx
        clr_a                 ; force palette 0 to get green soldier
        bra     @3e24
@3e1f:  plx
        lda     f:CharPalTbl,x
@3e24:  longa
        asl5
        tax
        shorta0
        pla
        asl5
        tay
        phy
        lda     #$18
        sta     $10
@3e3b:  lda     f:BattleCharPal,x
        sta     near w7e81ad,y
        inx
        iny
        dec     $10
        bne     @3e3b
        plx
        inc     near wCharGfxData::w7e61c4,x     ; invalidate previous graphic action (forces buffer update)
        rts

; ------------------------------------------------------------------------------

; [ load status/cursor palettes ]

LoadStatusPal:
@3e4d:  clr_ax
@3e4f:  lda     f:_c2c689,x
        sta     near w7e7e00::_12::Color12,x
        lda     f:_c2c689+8,x
        sta     near w7e7e00::_13::Color12,x
        lda     f:_c2c689+16,x
        sta     near w7e7e00::_14::Color12,x
        lda     f:_c2c689+24,x
        sta     near w7e7e00::_15::Color12,x
        inx
        cpx     #8
        bne     @3e4f
        rts

; ------------------------------------------------------------------------------

; [ init monster sprite data ]

_c13e72:
v_mode_init:
@3e72:  lda     #$ff
        clr_ax
@3e76:  sta     near w7e8259,x     ; clear monster sprite data
        sta     near w7e83f1,x
        sta     near w7e8589,x
        sta     near w7e8721,x
        inx
        cpx     #$0198
        bne     @3e76
        lda     near w7e2000       ; vram map index * 12
        sta     $22
        lda     #12
        sta     $24
        jsr     Mult8
        lda     $26
        tax
        lda     f:MonsterSpriteMapPtrs,x
        sta     $10
        lda     f:MonsterSpriteMapPtrs+1,x
        sta     $11
        lda     #^MonsterSpriteMapPtrs
        sta     $12
        ldx     #near w7e8259      ; +$14 = pointer to monster sprite data
        stx     $14
        lda     #$06        ; $16 = monster counter
        sta     $16
@3eb0:  longa
        lda     [$10]       ; monster's x and y position in graphics buffer
        sta     $18
        inc     $10
        inc     $10
        shorta0
        ldy     zZero
@3ebf:  lda     [$10]       ; sprite number
        bmi     @3eef       ; branch if at end of data
        asl2
        tax
        lda     f:_c2b9e7,x   ; sprite's x offset
        sec
        sbc     $18
        sta     ($14),y
        iny
        lda     f:_c2b9e7+1,x   ; sprite's y offset
        sec
        sbc     $19
        sta     ($14),y
        iny
        lda     f:_c2b9e7+2,x   ; sprite's tile pointer
        sta     ($14),y
        iny
        lda     f:_c2b9e7+3,x
        sta     ($14),y
        iny                 ; next sprite
        ldx     $10
        inx
        stx     $10
        bra     @3ebf
@3eef:  sta     ($14),y     ; store end byte
        longa
        inc     $10         ; next monster
        lda     $14
        clc
        adc     #$0044
        sta     $14
        shorta0
        dec     $16
        bne     @3eb0
        ldx     zZero
@3f06:  lda     near w7e8259,x     ; copy first set of sprite data to other three sets
        sta     near w7e83f1,x
        sta     near w7e8589,x
        sta     near w7e8721,x
        inx
        cpx     #$0198
        bne     @3f06
        stz     $14         ;
        lda     #$01
        sta     $12
        ldx     zZero
@3f20:  dec     $12
        bne     @3f36
        lda     #$11
        sta     $12
        lda     $14
        asl
        tay
        lda     near w7e812f,y     ; monster width
        asl3                ; convert to pixels
        sta     $10
        inc     $14
@3f36:  lda     near w7e8259,x     ; sprite x position
        cmp     #$ff
        beq     @3f46       ; branch if no sprite
        neg_a
        sec
        sbc     #$20        ; subtract 32
        clc
        adc     $10         ; add width
@3f46:  sta     near w7e83f1,x     ; set 1st and 3rd copy x position
        sta     near w7e8721,x
        inx4                ; next sprite
        cpx     #$0198
        bne     @3f20
        stz     $14
        lda     #$01
        sta     $12
        ldx     zZero
@3f5d:  dec     $12
        bne     @3f73
        lda     #$11
        sta     $12
        lda     $14
        asl
        tay
        lda     near w7e812f+1,y
        asl3
        sta     $10
        inc     $14
@3f73:  lda     near w7e8259+1,x     ; sprite y position
        cmp     #$ff
        beq     @3f83       ; branch if no sprite
        neg_a
        sec
        sbc     #$20        ; subtract 32
        clc
        adc     $10         ; add width
@3f83:  sta     near w7e8589+1,x     ; set 2nd and 3rd copy y position
        sta     near w7e8721+1,x
        inx4                ; next sprite
        cpx     #$0198
        bne     @3f5d
        clr_ay
@3f94:  tya
        asl
        tax
        lda     f:MonsterSpriteDataPtrs,x
        sta     $10
        lda     f:MonsterSpriteDataPtrs+1,x
        sta     $11
        lda     #$11
        sta     $12
        clr_a
        sta     near w7e88b9,y
@3fab:  lda     ($10)
        cmp     #$ff
        beq     @3fc4
        lda     near w7e88b9,y
        inc
        sta     near w7e88b9,y
        ldx     $10
        inx4
        stx     $10
        dec     $12
        bne     @3fab
@3fc4:  iny
        cpy     #$0006
        bne     @3f94
        rts

; ------------------------------------------------------------------------------
