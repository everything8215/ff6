; ------------------------------------------------------------------------------

; [ check if attack hits ]

CheckHit:
@220d:  pha
        phx
        clc
        php
        shorta
        stz     $fe
        lda     zb3
        bpl     @2235
        lda     near wTargetProp3::w7e3ee4,y
        bit     #STATUS1::VANISH
        beq     @2235
        lda     $11a4
        asl
        bmi     @222d
        lda     $11a2
        lsr
        jmp     @22b3

; remove vanish status
@222d:  lda     near wTargetProp2::w7e3dfc,y
        ora     #STATUS1::VANISH
        sta     near wTargetProp2::w7e3dfc,y
@2235:  lda     $11a3
        bit     #$02
        bne     @224b
        lda     near wTargetProp3::w7e3ef8,y
        bpl     @224b
        longa
        lda     near wTargetMask,y
        tsb     za6
        jmp     @22e5

@224b:  .a8
        lda     $11a2
        bit     #$02
        beq     @2259
        lda     near wTargetProp2::w7e3aa1,y
        bit     #$04
        bne     @22b5       ; branch if $3aa1.2 is set (instant death protection)
@2259:  lda     $11a2
        bit     #$04
        beq     @2268
        lda     near wTargetProp3::w7e3ee4,y
        eor     near wTargetProp2::MonsterFlags,y
        bpl     @22b5                   ; MONSTER_FLAG::UNDEAD
@2268:  lda     zb5
        cmp     #BATTLE_CMD::FIGHT
        beq     @2272
        cmp     #BATTLE_CMD::CAPTURE
        bne     @22a1
@2272:  lda     $11a9
        bne     @22a1
        lda     near w7e3eb0 + 25
        cmp     #$01
        bne     @22a1       ; branch if there is not one target

; single target
        cpy     #$08
        bcs     @22a1
        lda     near wTargetProp3::w7e3ef9,y         ; check interceptor status
        asl
        bpl     @2293
        jsr     RandCarry
        bcc     @2293
        lda     #$40
        sta     $fe
        bra     @22b5
@2293:  lda     near wGolemHP_L
        ora     near wGolemHP_H
        beq     @22a1
        lda     #$20
        sta     $fe
        bra     @22b5

; multiple targets
@22a1:  lda     $11a4
        bit     #$20
        bne     @22e8
        bit     #$40
        bne     @22ec
        bit     #$10
        beq     @22fb
        jsr     _c2239c
@22b3:  bcc     @22e8
@22b5:  lda     near wTargetProp3::w7e3ee4,y
        bitflg  STATUS1, {VANISH, ZOMBIE, MAGITEK}
        bne     @22d1
        cpy     #$08
        bcs     @22d1
        jsr     _c223bf
        cmp     #$06
        bcc     @22d1
        ldx     #$03
@22c9:  stz     $11aa,x
        dex
        bpl     @22c9
        bra     @22e8
@22d1:  lda     #$02
        tsb     zb2
        stz     near wWeaponSpellCast
        lda     near w7e341c
        beq     @22e5
        longa
        lda     near wTargetMask,y
        tsb     near w7e3a5a
@22e5:  plp
        sec
        php
@22e8:  plp
        plx
        pla
        rts
@22ec:  ldx     $11a8
        clr_a
        lda     near wTargetProp2::Level,y
        jsr     Div
        txa
        bne     @22d1
        bra     @22e8
@22fb:  peaflg  STATUS12, {PETRIFY, SLEEP}
        peaflg  STATUS34, {STOP, FROZEN}
        jsr     CheckStatus
        bcc     @22e8
        longa
        lda     near wTargetMask,y
        bit     near w7e3a54
        shorta
        bne     @22e8
        lda     $11a8
        cmp     #$ff
        beq     @22e8
        sta     $ee
        lda     $11a2
        lsr
        bcc     @233f                   ; branch if a magic attack
        lda     near wTargetProp2::RetalFlags,y  ; RETAL_FLAGS::RETORT
        lsr
        bcs     @22e8                   ; branch if $3e4c.0 is set (retort)
        lda     near wTargetProp3::w7e3ee5,y
        bit     #STATUS2::IMAGE
.if BUGFIX_EVADE
        beq     @2346
.else
        beq     @233f
.endif
        jsr     Rand
        cmp     #$40
        bcs     @22d1
        lda     near wTargetProp2::w7e3dfd,y
        ora     #STATUS2::IMAGE
        sta     near wTargetProp2::w7e3dfd,y
        bra     @22d1
@233f:
.if BUGFIX_EVADE
        lda     near wTargetProp2::MagicEvade,y
        pha
        bra     @2388
@2346:  lda     near wTargetProp2::Evade,y
        pha
        nop
.else
        lda     near wTargetProp2::Evade,y
        bcs     @2347
        lda     near wTargetProp2::MagicEvade,y
@2347:  pha
        bcc     @2388
.endif
        lda     near wTargetProp3::w7e3ee4,x                 ; check blind
        lsr
        bcc     @2352
        lsr     $ee
@2352:  lda     near wTargetProp2::RelicEffect4,y
        bit     #RELIC_EFFECT4::RAND_EVADE      ; beads effect
        beq     @235b
        lsr     $ee
@235b:  peaflg  STATUS12, {BLIND, ZOMBIE, CONFUSE}
        peaflg  STATUS34, {SLOW, RERAISE}
        jsr     CheckStatus
        bcs     @2372
        lda     $ee
        lsr2
        adc     $ee
        bcc     @2370
        lda     #$ff
@2370:  sta     $ee
@2372:  peaflg  STATUS12, {POISON, SAP, NEAR_FATAL}
        pea     STATUS34::HASTE
        jsr     CheckStatus
        bcs     @2388
        lda     $ee
        lsr     $ee
        lsr     $ee
        sec
        sbc     $ee
        sta     $ee
@2388:  pla
        xba
        lda     $ee
        jsr     MultAB
        xba
        sta     $ee
        lda     #$64
        jsr     RandA
        cmp     $ee
        jmp     @22b3

; ------------------------------------------------------------------------------

; [  ]

_c2239c:
; death:
@239c:  lda     near wTargetProp2::MagicEvade,y
        xba
        lda     $11a8
        jsr     MultAB
        xba
        sta     $ee
        lda     #$64
        jsr     RandA
        cmp     $ee
        bcs     _23be
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_c223b2:
@23b2:  jsr     Rand
        and     #$7f        ; random number (0..127)
        sta     $ee
        lda     near wTargetProp2::Stamina,y
        cmp     $ee
_23be:  rts

; ------------------------------------------------------------------------------

; [  ]

_c223bf:
_setevasionanima:
@23bf:  phy
        lda     $11a2
        lsr
        bcs     @23c7
        iny                             ; use magical block graphic
@23c7:  clr_a
        lda     near wTargetProp2::BlockGfx,y
        ora     $fe
        beq     @23eb
        jsr     RandBit
        bit     #$40
        beq     @23d9
        sty     near w7e3a83
@23d9:  bit     #$20
        beq     @23e0
        sty     near w7e3a82
@23e0:  jsr     GetBitNum
        tya
        lsr
        tay
        txa
        inc
        sta     zaa,y
@23eb:  ply
        rts

; ------------------------------------------------------------------------------
