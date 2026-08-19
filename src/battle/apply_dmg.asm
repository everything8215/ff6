; ------------------------------------------------------------------------------

; [ update hp/mp after damage ]

; c: set = target died, clear = target didn't die

ApplyDmg:
        .a8
@12f5:  phx
        php
        ldx     #2
        lda     $11a2
        bmi     @1300       ; branch if mp damage
        ldx     #0
@1300:  jsr     (near ApplyDmgTbl,x)   ; hp/mp damage
        shorta
        bcc     @131c       ; return if target didn't die
        lda     2,s       ; attacker
        tax
        stx     $ee
        jsr     _c2362f       ; save previous attacker
        cpy     $ee
        beq     @131c       ; branch if attacker was target
        sta     near wTargetProp1::RetalTarget,y     ; set target that just attacked you
        lda     near wTargetMask,y
        trb     near w7e3419       ; disable black belt effect
@131c:  plp
        plx
        rts

; hp/mp damage jump table
ApplyDmgTbl:
@131f:  .addr   ApplyDmgHP
        .addr   ApplyDmgMP

; ------------------------------------------------------------------------------

; 0: hp damage
ApplyDmgHP:
        .a16
@1323:  jsr     _c213a7
        beq     _133b
        bcc     _133d
        clc
        adc     near wTargetProp2::CurrHP,y
        bcs     @1335
        cmp     near wTargetProp2::MaxHP,y
        bcc     @1338
@1335:  lda     near wTargetProp2::MaxHP,y
@1338:  sta     near wTargetProp2::CurrHP,y
_133b:  clc
_133c:  rts
_133d:  not_a
        sta     $ee
        lda     near wTargetProp2::CurrHP,y
        sbc     $ee
        sta     near wTargetProp2::CurrHP,y
        beq     _c21390     ; target reached 0 hp
        bcs     _133c       ; return if target is still alive
        bra     _c21390     ; target reached 0 hp

; ------------------------------------------------------------------------------

; 1: mp damage
ApplyDmgMP:
@1350:  jsr     _c213a7       ; calculate net damage
        beq     _133b       ; return if no damage was taken or healed
        bcc     @136b       ; branch if damage was taken
        clc
        adc     near wTargetProp2::CurrMP,y     ; add to current mp
        bcs     @1362
        cmp     near wTargetProp2::MaxMP,y
        bcc     @1365
@1362:  lda     near wTargetProp2::MaxMP,y
@1365:  sta     near wTargetProp2::CurrMP,y
        clc
        bra     @138a
@136b:  not_a
        sta     $ee
        lda     near wTargetProp2::CurrMP,y     ; subtract from current mp
        sbc     $ee
        sta     near wTargetProp2::CurrMP,y
        beq     @137c
        bcs     @138a
@137c:  clr_a
        sta     near wTargetProp2::CurrMP,y
        lda     near wTargetProp2::MonsterFlags,y
        lsr
        bcc     @1389       ; MONSTER_FLAG::DIE_AT_0_MP
        jsr     _c21390     ; target reached 0 hp
@1389:  sec
@138a:  lda     #$0080      ; update enabled spells/espers
        jmp     SetCharFlag

; ------------------------------------------------------------------------------

; [ target reached 0 hp ]

; or 0 mp if they die at 0 mp

dead_sub:
_c21390:
@1390:  sec
        clr_ax
        stx     near wWeaponSpellCast       ; disable random weapon spellcast
        sta     near wTargetProp2::CurrHP,y     ; set current hp to zero
        lda     near wTargetProp3::w7e3ee4,y
        bit     #STATUS1::ZOMBIE
        bne     _133c       ; branch if target is a zombie
        lda     #STATUS1::DEAD
        jmp     SetStatus1

; ------------------------------------------------------------------------------

; [ calculate net damage ]

; a: (damage healed) - (damage taken) (out)
; c: set = damage was taken, clear = damage was healed (out)

_c213a7:
deal_sub:
        .a16
@13a7:  lda     near wTargetProp1::DmgTaken,y     ; damage taken
        inc
        beq     @13bc       ; branch if invalid
        lda     near wTargetMask,y
        bit     near w7e3a3c
        beq     @13b9       ; branch if target is not invincible
        clr_a
        sta     near wTargetProp1::DmgTaken,y
@13b9:  lda     near wTargetProp1::DmgTaken,y     ; damage taken
@13bc:  sta     $ee
        lda     near w7e3a82 - 1       ; golem block targets
        and     near w7e3a83 - 1       ; dog block targets
        bmi     @13c8       ; branch if both are invalid
        stz     $ee         ; 0 damage taken
@13c8:  lda     near wTargetProp1::DmgHealed,y     ; damage healed
        inc
        beq     @13cf
        dec
@13cf:  sec
        sbc     $ee
        rts
        .a8

; ------------------------------------------------------------------------------
