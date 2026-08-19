; ------------------------------------------------------------------------------

; [ calculate damage for target ]

CalcTargetDmg:
@0b83:  php
        shorta
        lda     $11a6
        jeq     @0c2b       ; return if power = 0
        lda     $11a4
        bmi     @0b98       ; branch if damage is a fraction of max hp/mp
        jsr     CalcDmgMod
        bra     @0b9b
@0b98:  jsr     CalcDmgRatio
@0b9b:  stz     $f2
        lda     near wTargetProp3::w7e3ee4,y
        asl
        bmi     @0bfa
        lda     $11a4
        sta     $f2
        lda     $11a2
        bit     #$08
        beq     @0bd3
        lda     near wTargetProp2::MonsterFlags,y  ; MONSTER_FLAG::UNDEAD
        bpl     @0bbf
        lda     $11aa
        bitflg  STATUS1, {DEAD, ZOMBIE}
        bne     @0c2b
        stz     $f2
        bra     @0bc6
@0bbf:  lda     near wTargetProp3::w7e3ee4,y
        bit     #STATUS1::ZOMBIE
        beq     @0bd3
@0bc6:  lda     $11a4
        bit     #$02
        beq     @0bd3       ; branch if not a drain attack
        lda     $f2
        eor     #$01
        sta     $f2
@0bd3:  lda     $11a1
        beq     @0c1e
        lda     near w7e3eb0 + 24
        not_a
        and     $11a1
        beq     @0bfa
        lda     near wTargetProp2::ElemAbsorb,y
        bit     $11a1
        beq     @0bf2
        lda     $f2
        eor     #$01
        sta     $f2
        bra     @0c1e
@0bf2:  lda     near wTargetProp2::ElemNull,y
        bit     $11a1
        beq     @0c00
@0bfa:  stz     $f0
        stz     $f1
        bra     @0c1e
@0c00:  lda     near wTargetProp2::ElemHalf,y
        bit     $11a1
        beq     @0c0e
        lsr     $f1
        ror     $f0
        bra     @0c1e
@0c0e:  lda     near wTargetProp2::ElemWeak,y
        bit     $11a1
        beq     @0c1e
        lda     $f1
        bmi     @0c1e
        asl     $f0
        rol     $f1
@0c1e:  lda     $11a9       ; item special effect
        cmp     #$04
        bne     @0c28       ; branch if not atma weapon
        jsr     UltimaEffect
@0c28:  jsr     CalcMaxDmg
@0c2b:  plp
        rts

; ------------------------------------------------------------------------------

; [ calculate maximum damage ]

; +x: attacker
; +y: target

CalcMaxDmg:
@0c2d:  lda     $11a2
        lsr
        bcc     @0c5d       ; branch if attack is not physical damage
        lda     near w7e3a82
        and     near w7e3a83
        bpl     @0c5d       ; branch if blocked by golem or interceptor
        lda     near wTargetProp3::w7e3ee4,x
        bit     #STATUS1::ZOMBIE
        beq     @0c45       ; branch if attacker is not a zombie
        jsr     ZombieEffect
@0c45:  lda     $11ab
        eorflg  STATUS2, {SLEEP, CONFUSE}
        andflg  STATUS2, {SLEEP, CONFUSE}
        and     near wTargetProp3::w7e3ee5,y     ; remove sleep and muddled status from target
        ora     near wTargetProp2::w7e3dfd,y
        sta     near wTargetProp2::w7e3dfd,y
        lda     near wTargetProp1::ControlAttacker,y     ; invalidate target's controller
        ora     #$80
        sta     near wTargetProp1::ControlAttacker,y
@0c5d:  lda     $11a4
        bit     #$02
        beq     @0c75       ; branch if not a drain attack
        jsr     FixDrainDmg
        phx
        phy
        phy
        txy                 ; swap attacker and target
        plx
        jsr     _c2362f       ; save previous attacker
        sec
        jsr     @0c76       ; set damage taken/healed
        ply                 ; restore attacker and target
        plx
@0c75:  clc
; fall through

; set damage taken/healed
@0c76:  phy
        php
        rol
        eor     $f2
        lsr
        bcc     @0c82       ; branch if damage taken
        tya
        adc     #$13        ; change to damage healed ($13 because the carry is set, but it really adds $14)
        tay
@0c82:  longa
        lda     near wTargetProp1::DmgTaken,y     ; damage taken/healed
        inc
        beq     @0c8b       ; branch if it's $ffff (no damage)
        dec
@0c8b:  clc
        adc     $f0         ; add damage
        bcs     @0c95       ; branch on overflow
        cmp     #MAX_HP + 1
        bcc     @0c98       ; branch if less than 10,000
@0c95:  lda     #MAX_HP     ; cap at 9999
@0c98:  sta     near wTargetProp1::DmgTaken,y     ; set damage taken/healed
        plp
        .a8
        ply
        rts

; ------------------------------------------------------------------------------

; [ calculate damage modification ]

; random variance, defense stat, shell/safe, defending, row, morph, friendly fire

CalcDmgMod:
@0c9e:  php
        longa
        lda     $11b0       ; damage
        sta     $f0
        shorta
        lda     near w7e3414
        jeq     @0d3b
        jsr     Rand
        ora     #$e0        ; random variance (240..255)
        sta     $e8
        jsr     MultDmg
        clc
        lda     $11a3
        bmi     @0cc4
        lda     $11a2
        lsr
@0cc4:  lda     $11a2
        bit     #$20
        bne     @0d22
        php
        lda     near wTargetProp2::MagicDefense,y
        bcc     @0cd4
        lda     near wTargetProp2::Defense,y
@0cd4:  inc
        beq     @0ce7
        xba
        lda     near w7e3a82
        and     near w7e3a83
        bmi     @0ce3
        lda     #$c1
        xba
@0ce3:  xba
        dec
        not_a
@0ce7:  sta     $e8
        jsr     MultDmg
        lda     1,s
        lsr
        lda     near wTargetProp3::w7e3ef8,y
        bcs     @0cf5
        asl
@0cf5:  asl
        bpl     @0cff
        lda     #$aa
        sta     $e8
        jsr     MultDmg
@0cff:  plp
        bcc     @0d17
        lda     near wTargetProp2::w7e3aa1,y
        bit     #$02
        beq     @0d0d       ; branch if $3aa1.1 is clear
        lsr     $f1
        ror     $f0
@0d0d:  bit     #$20
        beq     @0d22
        lsr     $f1
        ror     $f0
        bra     @0d22
@0d17:  lda     near wTargetProp3::w7e3ef9,y
        bit     #STATUS4::MORPH
        beq     @0d22
        lsr     $f1
        ror     $f0
@0d22:  longa
        lda     $11a4
        lsr
        bcs     @0d34
        cpy     #$08
        bcs     @0d34
        cpx     #$08
        bcs     @0d34
        lsr     $f0
@0d34:  lda     $f0
        jsr     ApplyDmgMult
        sta     $f0
@0d3b:  plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ multiply damage by fraction ($e8 / 255) ]

MultDmg:
@0d3d:  php
        longa
        lda     $f0
        jsr     Mult24
        inc
        sta     $f0
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ atlas armlet/earring effect ]

RelicDmgEffect:
@0d4a:  php
        lda     $11a4                   ; restore hp/mp flag
        lsr
        bcs     @0d85
        lda     $11a3                   ; affect MP flag
        bmi     @0d5a
        lda     $11a2                   ; physical damage flag
        lsr
@0d5a:  longa
        lda     $11b0
        sta     $ee
        lda     near wTargetProp2::RelicEffect1,x  ; relic effects 1/3
        shorta
        bcs     @0d6e                   ; branch if physical damage
        bit     #RELIC_EFFECT1::EARRING ; check double earrings effect
        bne     @0d75
        xba                             ; check single earring effect
        lsr
@0d6e:  lsr
        bcc     @0d85                   ; check atlas armlet effect

; +50% damage
        lsr     $ef
        ror     $ee

; +100% damage
@0d75:  longa
        lda     $ee
        lsr
        clc
        adc     $11b0
        bcc     @0d82
        clr_a
        dec
@0d82:  sta     $11b0
@0d85:  plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ calculate damage (fraction of max hp/mp) ]

CalcDmgRatio:
@0d87:  phx
        phy
        php
        longa
        lda     near wTargetProp1::DmgTaken,y
        inc
        beq     @0d93
        dec
@0d93:  sta     $ee
        shorta
        jsr     FixMPDmg
        lda     $11a6
        sta     $e8
        lda     zb5
        cmp     #BATTLE_CMD::ITEM
        beq     @0dab
        lda     $11a2
        lsr3
@0dab:  longa
        bcs     @0dba
        sec
        lda     near wTargetProp2::CurrHP,y
        sbc     $ee
        bcs     @0dbd
        clr_a
        bra     @0dbd
@0dba:  lda     near wTargetProp2::MaxHP,y
@0dbd:  jsr     CalcRatio
        pha
        pla
        bne     @0dc5
        inc
@0dc5:  sta     $f0
        plp
        .a8
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ +A = $e8 * (+a / 16) ]

CalcRatio:
@0dcb:  .a16
        jsr     Mult24
        lda     #3

; lsr A times
LsrA:
@0dd1:  phx
        tax
        lda     $e8
@0dd5:  lsr     $ea
        ror
        dex
        bpl     @0dd5
        plx
        rts
        .a8

; ------------------------------------------------------------------------------

; [ adjust pointers to affect hp or mp ]

FixMPDmg:
@0ddd:  lda     $11a3
        bpl     @0dec
        tya
        clc
        adc     #$14
        tay
        txa
        clc
        adc     #$14
        tax
@0dec:  rts

; ------------------------------------------------------------------------------

; [ calculate maximum damage for drain attacks ]

FixDrainDmg:
@0ded:  phx
        phy
        php
        jsr     FixMPDmg
        lda     near w7e3414
        bpl     @0e1d       ; branch if damage modification is disabled
        longa
        lda     $f2
        lsr
        bcc     @0e02
        phx
        tyx
        ply
@0e02:  lda     near wTargetProp2::CurrHP,y
        cmp     $f0
        bcs     @0e0b
        sta     $f0
@0e0b:  lda     zb1
        bpl     @0e1d
        txy
        sec
        lda     near wTargetProp2::MaxHP,y
        sbc     near wTargetProp2::CurrHP,y
        cmp     $f0
        bcs     @0e1d
        sta     $f0
@0e1d:  plp
        .a8
        ply
        plx
_0e20:  rts

; ------------------------------------------------------------------------------

; [ zombie attack effect ]

ZombieEffect:
@0e21:  jsr     Rand

; 1/16 chance to cause poison status
        cmp     #$10
        bcs     @0e2c
        lda     #STATUS1::POISON
        bra     SetStatus1

; 1/16 chance to cause blind status
@0e2c:  cmp     #$20
        bcs     _0e20
        lda     #STATUS1::BLIND
; fallthrough

; ------------------------------------------------------------------------------

; [ set bit in status 1 ]

SetStatus1:
@0e32:  ora     near wTargetProp2::w7e3dd4,y
        sta     near wTargetProp2::w7e3dd4,y
        rts

; ------------------------------------------------------------------------------

; [ calculate atma weapon damage ]

UltimaEffect:
@0e39:  php
        phx
        phy
        txy
        lda     near wTargetProp2::CurrHP_H,y     ; b = current hp (hi byte) + 1
        inc
        xba
        lda     near wTargetProp2::Level,y     ; a = level
        jsr     MultAB       ; a = (current hp + 1) * level
        ldx     near wTargetProp2::MaxHP_H,y     ; x = max hp (hi byte) + 1
        inx
        jsr     Div       ; $e8 = [(current hp + 1) * level] / [max hp (hi byte) + 1]
        sta     $e8
        longa
        lda     $f0         ; original damage
        jsr     Mult24       ; a = original damage * [(current hp + 1) * level] / [max hp (hi byte) + 1] / 256
        lda     #5
        jsr     LsrA
        inc
        sta     $f0         ; set calculated damage
        cmp     #501
        bcc     @0e73       ; branch if less than 501
        ldx     #$5b
        cmp     #1001
        bcc     @0e6e       ; branch if less than 1001
        inx
@0e6e:  stx     zb7         ; set atma weapon length ($5b or $5c -> $626a)
        jsr     _c235bb
@0e73:  ply
        plx
        plp
        .a8
        rts

; ------------------------------------------------------------------------------
