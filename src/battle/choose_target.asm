; ------------------------------------------------------------------------------

; [ choose target ]

; unless the attack target has been specifically chosen by the player, this
; subroutine determines what the target(s) will be.

ChooseTarget:
@587e:  phx
        phy
        php
        shortai
        lda     zbb
        cmp     #TARGET::SELF
        bne     @5895

; self-target
        lda     near wTargetMask,x
        sta     zb8_L
        lda     near wTargetMask + 1,x
        sta     zb8_H
        bra     @58f6

; not self-target
@5895:  jsr     _c258fa
        lda     zba
        bit     #$40
        bne     @58b9
        bit     #$08
        bne     @58a5
        jsr     CheckTargetsPresent

; check if a valid target has already been chosen
@58a5:  lda     zb8_L
        ora     zb8_H
        beq     @58b3
        lda     zbb
        bitflg  TARGET, {MULTI_TARGET, INIT_HALF}
        beq     @58ed                   ; choose a single target at random
        bra     @58f6                   ; use the selected target

; no valid targets set, choose one at random
@58b3:  lda     zba
        bit     #$04
        bne     @58c8                   ; branch if no retarget

; choose a new target
@58b9:  jsr     Retarget
        jsr     _c258fa
        lda     zba
        bit     #$08
        bne     @58c8                   ; don't remove dead targets for life spells
        jsr     CheckTargetsPresent
@58c8:  jsr     CheckTargetsBattleType
        lda     zba
        bit     #$20
        beq     @58de
        longa
        lda     zb8
        bne     @58dc
        lda     near w7e3a4e                   ; use backup targets
        sta     zb8
@58dc:  shorta

; choose single or multiple targets
@58de:  lda     zbb
        bit     #TARGET::INIT_HALF
        bne     @58f6
        bit     #TARGET::MULTI_TARGET
        beq     @58ed
        jsr     RandCarry               ; 50% chance to target all
        bcs     @58f6

; choose a single target at random
@58ed:  longa
        lda     zb8
        jsr     RandBit
        sta     zb8
@58f6:  plp
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

_c258fa:
_masktarget:
@58fa:  .a8
        php
        lda     #$02
        trb     near w7e3a46
        bne     @5915       ; return if $3a46.1 is set (seize, joker doom)
        jsr     _c25917
        lda     zba
        bpl     @590b
        stz     zb8_L
@590b:  lsr
        bcc     @5915
        longa
        lda     near wTargetMask,x
        trb     zb8
@5915:  plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_c25917:
_masktarget2:
@5917:  php
        lda     near w7e2f46       ; characters that are targettable
        xba
        lda     near w7e3403       ; seized targets
        longa
        and     near w7e3a78
        and     near w7e3408       ; targets that were revived/summoned
        and     zb8
        sta     zb8
        lda     near w7e341b - 1
        bpl     @5935       ; branch if self-target
        lda     near w7e3f2c       ; remove jump/seize targets
        trb     zb8
@5935:  plp
        rts

; ------------------------------------------------------------------------------

; [  ]

Retarget:
@5937:  .a8
        stz     zb8_H
        clr_a
        cpx     #$08
        ror
        sta     zb8_L
        lda     zba
        bit     #$10
        bne     @5986                   ; random target if reflected
        lda     near wTargetProp1::CharmAttacker,x
        bmi     @5950
        lda     #$80
        eor     zb8_L
        sta     zb8_L
@5950:  lda     near wTargetMask,x
        bit     near w7e3a40
        beq     @595e
        lda     #$80
        eor     zb8_L
        sta     zb8_L
@595e:  lda     zbb
        and     #TARGET::INIT_MASK
        cmp     #TARGET::INIT_ALL
        bne     @596a
        lda     #$40
        tsb     zb8_L
@596a:  lda     zbb
        and     #TARGET::ENEMY
        asl
        eor     zb8_L
        sta     zb8_L
        lda     near wTargetProp3::w7e3ee4,x                 ; check for zombie status
        lsr2
        bcc     @597e
        lda     #$40
        tsb     zb8_L
@597e:  lda     near wTargetProp3::w7e3ee5,x                 ; check for confuse status
        asl3
        bcc     @598c

; set target bit 6 if confused or reflected attack
@5986:  lda     #$80
        eor     zb8_L
        sta     zb8_L
@598c:  lda     zb8_L
        asl
        stz     zb8_L
        bmi     @5995                   ; branch if attacker is a zombie
        bcc     @59a0                   ; branch if not confused or reflected

; choose random enemy target
@5995:  php
        lda     #$3f                    ; target all monsters
        tsb     zb8_H
        lda     near w7e3a40                   ; target enemy characters
        tsb     zb8_L
        plp
@59a0:  bmi     @59a4                   ; branch if attacker is a zombie
        bcs     @59ab                   ; return if confused or reflected
@59a4:  lda     #$0f
        eor     near w7e3a40
        tsb     zb8_L                   ; can target non-enemy characters
@59ab:  rts

; ------------------------------------------------------------------------------

; [ target check based on battle type ]

CheckTargetsBattleType:
@59ac:  lda     zba
        bit     #$10
        beq     @59da                   ; branch if not reflected
        bit     #$02
        beq     @59d9
        lda     near wTargetProp3::w7e3ee5,x
        bit     #$20
        bne     @59d9
        jsr     RandCarry
        bcs     @59d9
        phx
        ldx     near w7e3a32
        lda     near w7e2c6e + 1 - 16,x      ; attacker from previous action
        asl
        tax
        longa
        lda     near wTargetMask,x
        bit     zb8
        beq     @59d6
        sta     zb8
@59d6:  shorta
        plx
@59d9:  rts
@59da:  lda     zbb
        and     #TARGET::INIT_MASK
        pha
        bit     #TARGET::INIT_ALL
        bne     @5a35
        lda     near w7e201f
        cmp     #BATTLE_TYPE::PINCER
        bne     @5a0d
        lda     near w7e2ead
        xba
        lda     near w7e2eac
        cpx     #$08
        bcc     @59fc
        bit     near wTargetMask + 1,x
        beq     @5a0b
        bra     @5a0a
@59fc:  bit     zb8_H
        beq     @5a0d
        xba
        bit     zb8_H
        beq     @5a0d
        jsr     RandCarry
        bcc     @5a0b
@5a0a:  xba
@5a0b:  trb     zb8_H
@5a0d:  lda     near w7e201f
        cmp     #BATTLE_TYPE::SIDE
        bne     @5a35
        lda     #$0c
        xba
        lda     #$03
        cpx     #$08
        bcs     @5a24
        bit     near wTargetMask,x
        beq     @5a33
        bra     @5a32
@5a24:  bit     zb8_L
        beq     @5a35
        xba
        bit     zb8_L
        beq     @5a35
        jsr     RandCarry
        bcc     @5a33
@5a32:  xba
@5a33:  trb     zb8_L
@5a35:  pla
        cmp     #TARGET::INIT_ALL
        beq     @5a4c
        lda     zb8_L
        beq     @5a4c
        lda     zb8_H
        beq     @5a4c
        jsr     Rand
        phx
        and     #$01
        tax
        stz     zb8,x
        plx
@5a4c:  rts

; ------------------------------------------------------------------------------

; [ remove invalid targets ]

CheckTargetsPresent:
@5a4d:  phx
        php
        longa
        ldx     #$12
@5a53:  lda     near wTargetMask,x     ; target mask
        bit     zb8
        beq     @5a7c       ; skip if not in targets
        lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @5a77       ; branch if $3aa0.0 is clear (target is present)
        ldaflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        cpx     #$08
        bcs     @5a6a       ; branch if a monster
        lda     #STATUS1::DEAD
@5a6a:  bit     near wTargetProp3::w7e3ee4,x
        bne     @5a77       ; branch if dead
        lda     near wTargetProp3::w7e3ef8,x
        bit     #STATUS34::HIDE
        beq     @5a7c
@5a77:  lda     near wTargetMask,x
        trb     zb8         ; remove invalid target
@5a7c:  dex2                ; next target
        bpl     @5a53
        plp
        plx
        rts

; ------------------------------------------------------------------------------
