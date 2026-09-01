; ------------------------------------------------------------------------------

; [ battle animation command $80/$7c: swap target and attacker ]

; used by engulf (zone eater ability)

AnimCmd_00_7c_far:
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        pha
        lda     near wAnimThread::TargetIndex,x     ; target
        sta     near wAnimThread::AttackerIndex,x     ; swap target and attacker
        pla
        sta     near wAnimThread::TargetIndex,x
        longa
        lda     near wAnimThread::AttackerPosX,x
        pha
        lda     near wAnimThread::AttackerPosY,x
        pha
        lda     near wAnimThread::TargetPosX,x
        sta     near wAnimThread::AttackerPosX,x
        lda     near wAnimThread::TargetPosY,x
        sta     near wAnimThread::AttackerPosY,x
        pla
        sta     near wAnimThread::TargetPosY,x
        pla
        sta     near wAnimThread::TargetPosX,x
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7b: flip all characters ]

; used after running to opposite side of screen

AnimCmd_00_7b_far:
        clr_axy
@b2b7:  stz     near wCharGfxData::AnimAction,x
        lda     near wCharGfxData::Flip,x     ; flip character horizontal
        eor     #$40
        sta     near wCharGfxData::Flip,x
        lda     near w7e7b10,y     ; switch hands
        eor     #$01
        sta     near w7e7b10,y
        iny                 ; next character
        txa
        clc
        adc     #$20
        tax
        cmp     #$80
        bne     @b2b7
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$79: characters run to left side of screen ]

; takes 56 loops to reach other side of screen

AnimCmd_00_79_far:
        clr_ax
        longa
@b2d9:  lda     near wCharGfxData::w7e61c9,x     ; subtract 4 from character xy angle
        sec
        sbc     #4
        sta     near wCharGfxData::w7e61c9,x
        shorta0
        lda     near wCharGfxDataBuf::ActiveStatus1,x     ; branch if wound or petrify status
        andflg  STATUS1, {DEAD, PETRIFY}
        bne     @b2f2
        lda     #CHAR_ACTION::WALKING_FORWARD
        sta     near wCharGfxData::AnimAction,x     ; set secondary graphical action to 4 (running forward)
@b2f2:  longa
        txa                 ; next character
        clc
        adc     #$0020
        tax
        cpx     #$0080
        bne     @b2d9
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7a: characters run to right side of screen ]

AnimCmd_00_7a_far:
        clr_ax
        longa
@b307:  lda     near wCharGfxData::w7e61c9,x
        clc
        adc     #4
        sta     near wCharGfxData::w7e61c9,x
        shorta0
        lda     near wCharGfxDataBuf::ActiveStatus1,x
        andflg  STATUS1, {DEAD, PETRIFY}
        bne     @b320
        lda     #CHAR_ACTION::WALKING_BACK
        sta     near wCharGfxData::AnimAction,x
@b320:  longa
        txa
        clc
        adc     #$0020
        tax
        cpx     #$0080
        bne     @b307
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$77: save seized character position ]

AnimCmd_00_77_far:
        jsr     GetTargetThreadPtr
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        asl
        tax
        longa
        lda     near wCharGfxData::PosX,y
        sta     near w7e6256,x
        lda     near wCharGfxData::PosY,y
        sta     near w7e6256+8,x

; move seized character to attacker's position
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x
        sta     near wCharGfxData::PosX,y
        lda     near wAnimThread::AttackerPosY,x
        sec
        sbc     #$0030
        sta     near wCharGfxData::PosY,y
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$78: restore seized character position (discard) ]

AnimCmd_00_78_far:
        jsr     GetTargetThreadPtr
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        asl
        tax
        longa
        lda     near w7e6256,x
        sta     near wCharGfxData::PosX,y
        clr_a
        sta     near wCharGfxData::OffsetX,y
        sta     near wCharGfxData::AnimOffsetX,y
        lda     near w7e6256+8,x
        sta     near wCharGfxData::PosY,y
        clr_a
        sta     near wCharGfxData::OffsetY,y
        sta     near wCharGfxData::JumpOffset,y
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$76: update seize scroll hdma data ]

; this makes the tentacles stretch out towards the character its seizing

AnimCmd_00_76_far:
        ldx     near wAnimThreadPtr
        ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $10
        bmi     @b39c
        stz     $11
        bra     @b3a0
@b39c:  lda     #$ff
        sta     $11
@b3a0:  longa
        inc     zAnimScriptPtr
        lda     near wAnimThread::w7e74d9,x
        clc
        adc     $10
        sta     near wAnimThread::w7e74d9,x
        sta     $10
        stz     $12
        stz     $16
        lda     #$0040
        sta     $18
        lda     near wAnimThread::w7e6f87,x
        and     #$00ff
        beq     @b3ef
        lda     near wAnimThread::AttackerPosY,x
        and     #$00ff
        asl2
        tax
@b3c9:  lda     $12
        clc
        adc     $10
        sta     $12
        lda     $13
        and     #$00ff
        sta     $13
        lda     $16
        sec
        sbc     $13
        sta     $16
        stz     $13
        sta     near wBG1ScrollData::Horz,x
        dex4
        dec     $18
        bne     @b3c9
        shorta0
        rtl

        .a16
@b3ef:  lda     near wAnimThread::AttackerPosY,x
        and     #$00ff
        asl2
        tax
@b3f8:  lda     $12
        clc
        adc     $10
        sta     $12
        lda     $13
        and     #$00ff
        clc
        adc     $16
        sta     $16
        stz     $13
        sta     near wBG1ScrollData::Horz,x
        dex4
        dec     $18
        bne     @b3f8
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ update character/monster facing directions ]

UpdateFacingDir:
@b41a:  clr_ax
        stx     near w7e2f50       ; character/monster facing directions
        ldx     #$0003
@b422:  lda     near w7e7b10,x     ; character facing direction (0 = left, 1 = right)
        lsr
        rol     near w7e2f50
        dex
        bpl     @b422
        clr_ax
        ldx     #$000a
@b431:  lda     near w7e80f3,x     ; monster horizontal flip (for graphics)
        eor     near w7e617e,x     ; monster horizontal flip (control)
        eor     #$01        ; invert
        lsr
        rol     near w7e2f50 + 1
        dex2
        bpl     @b431
        rtl

; ------------------------------------------------------------------------------

; [ filter colors (yellow, for flashbacks) ]

; +$18: palette range start (+$7e7e00)
; +$1a: palette range end (+$7e7e00)

FilterColors:
        ldx     $18
        longa
@b446:  lda     near w7e7e00,x     ; original color
        sta     $10
        lsr5
        sta     $12
        lsr5
        and     #$001f
        sta     $14
        lda     $10
        and     #$001f
        clc
        adc     $14
        sta     $14
        lda     $12
        and     #$001f
        clc
        adc     $14
        sta     f:hWRDIVL     ; sum of rgb color values
        shorta
        lda     #3
        sta     f:hWRDIVB     ; divide by 3 to get average
        clr_a
        longa
        nop6
        lda     f:hRDDIVL     ; average
        sta     $10
        asl5
        ora     $10
        sta     near w7e7e00,x     ; set red and green components
        inx2                ; next color
        cpx     $1a
        bne     @b446
        shorta0
        rtl

; ------------------------------------------------------------------------------

; unused ???

@b49d:  .byte   1,2,3,4,5,6

; ------------------------------------------------------------------------------

; [ get slot attack based on slot reel positions ]

; A: resulting attack (see SlotAttackTbl in battle module)
;      0: 7,7,bar joker death (kills allies)
;      1: 7,7,7 joker death (kills enemies)
;      2: dragon (mega flare)
;      3: bar (summon)
;      4: airship (H-bomb)
;      5: chocobo (chocobop)
;      6: diamond (7-flush)
;      7: mysidian rabbit

GetSlotAttack:
@b4a3:  lda     $36                     ; reel 1
        cmp     $37                     ; reel 2
        bne     @b4af
        cmp     $38                     ; reel 3
        bne     @b4af

; 3 matching reels, attack is reel icon + 1
        inc
        rtl

; check for 7,7,bar
@b4af:  ora     $37
        bne     @b4bb
        lda     $38
        cmp     #$02
        bne     @b4bb
        clr_a
        rtl

; use mysidian rabbit
@b4bb:  lda     #$07
        rtl

; ------------------------------------------------------------------------------

; pointers to attack animation properties for attack commands (+$d07fb2)

CmdAnimPropPtrs:
        .word   283 * 14        ; MORPH
        .word   288 * 14        ; REVERT
        .word   289 * 14        ; STEAL
        .word   290 * 14        ; BUSHIDO
        .word   291 * 14        ; BLITZ
        .word   292 * 14        ; RUNIC
        .word   293 * 14        ; RAGE
        .word   130 * 14        ; SHOCK
        .word   296 * 14        ; BATTLE_CMD_ANIM_8
        .word   297 * 14        ; JUMP_MONSTER
        .word   298 * 14        ; JUMP_CHAR_MISS
        .word   299 * 14        ; JUMP_MONSTER_MISS
        .word   380 * 14        ; THREE_DICE
        .word   381 * 14        ; TWO_DICE
        .word   386 * 14        ; CAPTURE_TO
        .word   387 * 14        ; CAPTURE_FROM
        .word   388 * 14        ; CHARS_RUN_LEFT
        .word   127 * 14        ; CHOCOBOP
        .word   129 * 14        ; SEVEN_FLUSH
        .word   254 * 14        ; LAGOMORPH
        .word   312 * 14        ; THROW_THICK_KNIFE
        .word   313 * 14        ; THROW_THIN_KNIFE
        .word   314 * 14        ; THROW_SWORD
        .word   315 * 14        ; THROW_KATANA
        .word   316 * 14        ; THROW_ROD
        .word   317 * 14        ; THROW_SPEAR
        .word   318 * 14        ; THROW_HAWK_EYE
        .word   319 * 14        ; ARISE
        .word   320 * 14        ; FIRE_SKEAN
        .word   321 * 14        ; WATER_EDGE
        .word   322 * 14        ; BOLT_EDGE
        .word   323 * 14        ; INVIZ_EDGE
        .word   324 * 14        ; SHADOW_EDGE
        .word   325 * 14        ; THROW_FULL_MOON
        .word   326 * 14        ; THROW_BOOMERANG
        .word   327 * 14        ; THROW_UNUSED
        .word   296 * 14        ; GP_RAIN
        .word   300 * 14        ; SKETCH
        .word   301 * 14        ; LEAP
        .word   302 * 14        ; HEALTH
        .word   287 * 14        ; LORE
        .word   303 * 14        ; RUN_AWAY
        .word   256 * 14        ; MAGITEK
        .word   279 * 14        ; JUMP_UNARMED
        .word   304 * 14        ; JUMP_THICK_KNIFE
        .word   305 * 14        ; JUMP_THIN_KNIFE
        .word   306 * 14        ; JUMP_SWORD
        .word   307 * 14        ; JUMP_KATANA
        .word   308 * 14        ; JUMP_ROD
        .word   309 * 14        ; JUMP_SPEAR
        .word   310 * 14        ; JUMP_HAWK_EYE
        .word   311 * 14        ; JUMP_UNUSED
        .word   278 * 14        ; POSSESS
        .word   277 * 14        ; UMARO_TACKLE
        .word   276 * 14        ; UMARO_THROW
        .word   275 * 14        ; RUNIC_ABSORB
        .word   379 * 14        ; CHANGE_BATTLE
        .word   404 * 14        ; CONTROL

; ------------------------------------------------------------------------------
