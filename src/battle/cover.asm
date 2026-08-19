; ------------------------------------------------------------------------------

; [ check true knight/love token (cover effect) ]

CoverEffect:
        .a16
@123b:  phx
        php
        lda     zb2
        bit     #$0002
        bne     @12a5       ; return if not critical
        lda     zb8
        beq     @12a5       ; return if there are no targets
        ldy     #$ff
        sty     $f4         ; $f4 = covering target
        jsr     BitToTargetID
        sty     $f8         ; $f8 = original target
        stz     $f2         ; +$f2 = hp of covering target with highest hp remaining
        phx
        ldx     near wTargetProp1::LoveTokenTarget,y
        bmi     @125f       ; branch if love token target is invalid
        jsr     CheckCoverTarget
        jsr     SetCoverTarget
@125f:  plx
        lda     near wTargetProp3::w7e3ee4,y
        bit     #STATUS12::NEAR_FATAL
        beq     @12a5
        bit     #STATUS12::VANISH
        bne     @12a5
        lda     near wTargetProp1::SeizeTarget,y
        bpl     @12a5       ; return if seize target is valid
        lda     #$000f      ; +$f0 = character bit masks
        cpy     #$08
        bcc     @127c       ; branch if a character
        lda     #$3f00
@127c:  sta     $f0         ; +$f0 = monster bit masks
        lda     near wTargetMask,y
        ora     near wTargetMask,x
        trb     $f0
        ldx     #$12
@1288:  lda     near wTargetProp2::RelicEffect4,x
        bit     #RELIC_EFFECT4::COVER
        beq     @129a       ; branch if no true knight
        lda     near wTargetMask,x
        bit     $f0
        beq     @129a
        jsr     CheckCoverTarget
@129a:  dex2
        bpl     @1288
        lda     $f2
        beq     @12a5
        jsr     SetCoverTarget
@12a5:  plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ set true knight/love token target ]

SetCoverTarget:
@12a8:  ldx     $f4
        bmi     @12bf       ; return if target is invalid
        cpy     $f8
        bne     @12bf
        stx     $f8
        sty     za8
        lsr     za8
        php
        longa
        lda     near wTargetMask,x
        sta     zb8
        plp
        .a8
@12bf:  rts

; ------------------------------------------------------------------------------

; [ check true knight/love token target ]

CheckCoverTarget:
@12c0:  php
        longa
        lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @12f3       ; branch if $3aa0.0 is clear (target is not present)
        lda     near wTargetProp1::ControlTarget,x
        bpl     @12f3       ; branch if controlling something
        lda     near wTargetProp1::SeizeTarget,x
        bpl     @12f3
        lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS12, {ZOMBIE, DEAD, PETRIFY, VANISH, SLEEP, CONFUSE}
        bne     @12f3
        lda     near wTargetProp3::w7e3ef8,x
        bitflg  STATUS34, {STOP, CONTROL, HIDE, FROZEN}
        bne     @12f3
        lda     near wTargetMask,x
        tsb     za6
        lda     near wTargetProp2::CurrHP,x     ; current hp
        cmp     $f2
        bcc     @12f3
        sta     $f2
        stx     $f4
@12f3:  plp
        .a8
        rts

; ------------------------------------------------------------------------------
