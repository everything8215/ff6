.include "src/text/attack_name.inc"
.include "src/text/attack_msg.inc"

; ------------------------------------------------------------------------------

; [ execute attacks (self-target) ]

ExecSelfAttack:
@3167:  .i8
        lda     #$80        ; don't ignore vanish
        trb     zb3
        lda     #$0c        ; retarget if target invalid, no friendly targets
        tsb     zba
        stz     near w7e341b       ; set flag for self-target
        longa
        lda     near wTargetMask,x
        sta     zb8
        shorta
; fall through

; ------------------------------------------------------------------------------

; [ execute attacks ]

ExecAttack:
@317b:  phx
        lda     zbd         ; damage multiplier
        sta     zbc
        lda     #$ff
        sta     near w7e3a82
        sta     near w7e3a83
        lda     near w7e3400
        inc
        bne     @31b3
        lda     near w7e3413
        bmi     @31b3
        sta     zb5
        jsr     InitTarget
        lda     near w7e3a70
        inc
        lsr
        jsr     _c2299f
        lda     $11a6
        jeq     @3275       ; jump if no damage
        lda     zb5
        cmp     #BATTLE_CMD::CAPTURE
        bne     @31b3       ; branch if command is not capture
        lda     #$a4        ; special effect $52 (steal)
        sta     $11a9
@31b3:  jsr     _c237eb
        lda     #$20
        trb     zb2
        beq     @31c1
        bit     $11a3
        bne     @31c5
@31c1:  lda     #$04
        tsb     zba
@31c5:  lda     zb8_L
        ora     zb8_H
        bne     @31d3
        lda     #$04
        bit     zb3
        beq     @31d3
        trb     zba
@31d3:  lda     near w7e3415
        bmi     @31dc
        lda     #$40
        tsb     zba
@31dc:  lda     zb3
        lsr
        bcs     @31e9
        lda     #$04
        tsb     zba
        stz     zb8_L
        stz     zb8_H
@31e9:  jsr     ShowAttackName
        lda     near w7e3417
        bmi     @31f2
        tax
@31f2:  lda     near w7e3a7c
        cmp     #ACTION_BATTLE_CMD::ROULETTE
        bne     @3201
        stz     zb8_L                     ; clear targets
        stz     zb8_H
        lda     #$04                    ; don't retarget
        sta     zba

; check if casting a spell (nonzero mp cost)
@3201:  lda     $11a5
        beq     @3225
        lda     near wTargetProp3::w7e3ee5,x
        bit     #STATUS2::SILENCE
        bne     @321b                   ; do nothing if silenced
        lda     near wTargetProp3::w7e3ee4,x
        bit     #STATUS1::IMP
        beq     @3225
        lda     near w7e3410                   ; last spell cast
        cmp     #ATTACK::IMP
        beq     @3225                   ; do nothing if imp (unless casting imp)
@321b:  txa
        lsr
        xba
        lda     #GFX_CMD::RESET_CHAR_ACTION
        jsr     _c262bf       ; add battle script command to queue
        bra     @3275
@3225:  jsr     RunicEffect
        jsr     AirAnchorEffect
        jsr     CalcDmg
        jsr     RelicDmgEffect
        longa
        jsr     CalcAttackEffect
        lda     $11a2
        lsr
        bcs     @3243       ; branch if physical damage
        lda     za6
        beq     @3243       ; branch if no targets were refleced off of
        jsr     CalcReflectDmg
@3243:  lda     near w7e3a30
        sta     zb8         ;
        shorta
        jsr     UpdateStatus
        jsr     CheckWeaponSpellCast
        lda     near w7e3401
        cmp     #$ff
        beq     @3262       ; branch if there is no battle message
        xba
        lda     #GFX_CMD::ATTACK_MSG
        jsr     _c262bf       ; add battle script command to queue
        lda     #$ff
        sta     near w7e3401       ; disable battle message
@3262:  lda     $11a7
        bit     #$02
        beq     @3275       ; branch if battle message based on attack index is disabled
        cpx     #$08
        bcc     @3275       ; branch if attacker is a character
        lda     zb6         ; attack index
        xba
        lda     #GFX_CMD::ATTACK_MSG
        jsr     _c262bf       ; add battle script command to queue
@3275:  lda     #$ff
        sta     near w7e3414       ; enable damage modification
        sta     near w7e3415
        sta     near w7e341c
        lda     near w7e3a83
        bmi     @3288
        sta     near w7e3416
@3288:  plx                 ; next attack
        dec     near w7e3a70
        bmi     @3291
        pea     ExecAttack-1
@3291:  rts

; ------------------------------------------------------------------------------

; [ calculate attack effect ]

; yama_magic_magic:
CalcAttackEffect:
@3292:  .a16
        .i8
        stz     near w7e3a5a
        stz     near w7e3a54
        jsr     ClearGfxParams
        jsr     ChooseTarget
        phx
        lda     zb8         ; targets
        jsr     CountBits
        stx     near w7e3eb0 + 25       ; set number of targets
        plx
        jsr     CoverEffect
        jsr     InitGfxParams
        jsr     _c23865
        lda     near w7e3a4c
        beq     @32ec
        sec
        lda     near wTargetProp2::CurrMP,x
        sbc     near w7e3a4c
        stz     near w7e3a4c
        bcs     @32e0
        cpx     #$08
        bcc     @32ca
        ldy     #BATTLE_CMD::MIMIC
        sty     zb5
@32ca:  jsr     _c235ad
        stz     za2
        stz     za4
        lda     #$0002                  ; disable attack message
        trb     $11a7
        lda     #make_word GFX_CMD::ATTACK_MSG, ATTACK_MSG::NOT_ENOUGH_MP
        jsr     _c2629b       ; add battle script command to queue
        jmp     CopyGfxParamsToBuf
@32e0:  sta     near wTargetProp2::CurrMP,x
        lda     #$0080
        ora     near wTargetProp1::w7e3204,x
        sta     near wTargetProp1::w7e3204,x
@32ec:  shorta
        lda     near w7e3412
        cmp     #$06
        bne     @334f                   ; branch if not a monster special attack
        phx
        lda     #$02
        tsb     zb2
        lsr
        tsb     za0
        lda     near wTargetProp2::MonsterSpecialAnim,x
        sta     zb7
        lda     near wTargetProp1::MonsterSpecialProp,x
        pha
        asl
        bpl     @3311       ; branch if attack deals damage
        stz     $11a6       ; clear attack power
        lda     #$01
        tsb     $11a7       ; automatically miss if target is immune to status
@3311:  bcc     @3318       ; branch if attack can miss
        lda     #$20
        tsb     $11a4       ; can't dodge
@3318:  pla
        and     #$3f
        cmp     #$30
        bcc     @3339       ; branch if special attack < $30 (status or damage)
        cmp     #$32
        bcs     @3332       ; branch if >= $32 (remove rflect status)

; $30/$31: drain hp/mp
        lsr
        lda     #$02
        tsb     $11a4       ; drain effect
        bcc     @334e       ; branch if draining hp
        lda     #$80
        tsb     $11a3       ; affect mp
        bra     @334e

; $32+: remove rflect status
@3332:  lda     #$04
        tsb     $11a4
        lda     #$17
@3339:  cmp     #$20
        bcc     @3345       ; branch if special attack < $20 (status)
        sbc     #$20
        adc     zbc         ; add to damage multiplier
        sta     zbc
        bra     @334e

; $00-$1f: status
@3345:  jsr     GetBitPtr
        ora     $11aa,x
        sta     $11aa,x
@334e:  plx

; check for runic
@334f:  lda     #$40
        tsb     zb2
        bne     @3364
        lda     #GFX_BATTLE_CMD::RUNIC_ABSORB
        xba
        lda     #GFX_CMD::ATTACK_ANIM
        jsr     _c262bf                 ; add battle script command to queue
        jsr     CopyGfxParamsToBuf
        lda     #$10
        trb     za0

; double damage if attacker morphed
@3364:  lda     #STATUS4::MORPH
        bit     near wTargetProp3::w7e3ef9,x
        beq     @336f
        inc     zbc
        inc     zbc

; +50% damage if attacker is berserk (physical attacks only)
@336f:  lda     $11a2
        lsr
        bcc     @337e
        lda     #STATUS2::BERSERK
        bit     near wTargetProp3::w7e3ee5,x
        beq     @337e
        inc     zbc

; halve damage if 2 or more targets
@337e:  lda     $11a2
        bit     #$40
        bne     @3392
        lda     near w7e3eb0 + 25
        cmp     #2
        bcc     @3392                   ; branch if there are less than 2 targets
        lsr     $11b1
        ror     $11b0

; halve damage if attacker is in back row
@3392:  lda     #$20
        bit     zb3
        bne     @33a3
        bit     near wTargetProp2::w7e3aa1,x
        beq     @33a3       ; branch if $3aa1.5 is clear (character row)
        lsr     $11b1
        ror     $11b0

@33a3:  jsr     UpdateFacingDirection
        jsr     DoAttackerEffect
        longa
        ldy     near w7e3405
        bmi     @33b1
        rts
@33b1:  ldy     #$12
@33b3:  lda     near wTargetMask,y
        bit     za4
        beq     @33c1
        jsr     CheckHit
        bcc     @33c1
        trb     za4
@33c1:  dey2
        bpl     @33b3
        shorta
        lda     near w7e341c
        bmi     @33d6
        lda     za4_L
        ora     za4_H
        bne     @33d6
        lda     #BATTLE_CMD::MIMIC
        sta     zb5
@33d6:  lda     near w7e341d
        bmi     @33e5
        lda     za2_L
        ora     za2_H
        bne     @33e5
        lda     #BATTLE_CMD::MIMIC
        sta     zb5
@33e5:  lda     #MONSTER_FLAG::IMP_DMG_BONUS
        bit     near wTargetProp2::MonsterFlags,x
        beq     @33f2
        lsr
        bit     near wTargetProp3::w7e3ee4,x                 ; check for imp status
        bne     @340c
@33f2:  lda     #$02
        bit     zb3
        beq     @340c                   ; auto-crit
        bit     zb2
        bne     @3414
        bit     zba
        beq     @3414
        jsr     Rand
        cmp     #$08
        bcs     @3414       ; 31/32 chance to branch
        lda     near w7e3eb0 + 25
        beq     @3414       ; branch if there are no targets
@340c:  inc     zbc         ; damage x2
        inc     zbc
        lda     #$20        ; flash screen (critical)
        tsb     za0
@3414:  jsr     _c235ad
        longa
        lda     $11b0
        jsr     ApplyDmgMult
        sta     $11b0
        shorta
        lda     $11a3
        asl
        bpl     @342e
        txy
        jsr     _c23852
@342e:  ldy     near wTargetProp1::ControlAttacker,x
        bmi     @343c
        phx
        tyx
        ldy     near wTargetProp1::ControlTarget,x
        jsr     SetControlCmd
        plx
@343c:  longa
        ldy     #$12
@3440:  lda     near wTargetMask,y
        trb     za4
        beq     @346c
        bit     near w7e3a54
        beq     @344e
        inc     zbc
@344e:  jsr     _c235e3
        cpy     near wZingerAttacker
        beq     @346c
        stz     near w7e3a48
        jsr     MagicStatusEffect
        jsr     DoTargetEffect
        lda     near w7e3a48
        bne     @346c
        lda     near wTargetMask,y
        tsb     za4
        jsr     CalcTargetDmg
@346c:  dey2
        bpl     @3440
        jsr     ExecDmg
        jsr     LearnLore
        lda     za4
        bne     @3480
        lda     #$0002                  ; disable attack message
        trb     $11a7
@3480:  jmp     CopyGfxParamsToBuf

; ------------------------------------------------------------------------------

; [ calculate damage (reflected attack) ]

CalcReflectDmg:
@3483:  phx
        pha
        jsr     ClearGfxParams
        stz     near w7e3a5a
        shorta
        lda     #$22
        tsb     $11a3
        lda     #TARGET::ENEMY
        sta     zbb
        lda     #$50
        tsb     zba
        lda     zb6
        sta     near w7e3a2a
        ldx     near w7e3405
        bmi     @34ac
        lda     #$10
        trb     zba
        lda     #GFX_CMD::SUPER_BALL
        bra     @34ae
@34ac:  lda     #GFX_CMD::REFLECT_ANIM
@34ae:  jsr     _c2629b                 ; add battle script command to queue
        lda     #$ff
        ldy     #$09
@34b5:  sta     za0,y
        dey
        bpl     @34b5
        longa
        lsr     $11b0
        ldy     #$12
@34c2:  lda     near wTargetMask,y
        and     1,s
        beq     @350f
        tyx
        jsr     ChooseTarget
        lda     zb8
        beq     @350f
        phy
        jsr     BitToTargetID
        phx
        shorta
        txa
        lsr
        tax
        lda     near w7e3405
        bmi     @34e4
        dec     near w7e3405
        tax
@34e4:  tya
        lsr
        sta     za0,x
        longa
        plx
        jsr     CheckHit
        bcs     @3509
        stz     near w7e3a48
        jsr     _c235e3
        jsr     MagicStatusEffect
        jsr     DoTargetEffect
        lda     near w7e3a48
        bne     @3509
        lda     near wTargetMask,x
        tsb     zae
        jsr     CalcTargetDmg
@3509:  ply
        ldx     near w7e3405
        bpl     @34c2
@350f:  dey2
        bpl     @34c2
        pla
        plx
        lda     #$0010
        bit     zba
        bne     @3525
        lda     near wTargetMask,x
        sta     zae
        stz     zaa
        stz     zaa + 2
@3525:  jsr     ExecDmg
        jmp     CopyGfxParamsToBuf
        .a8

; ------------------------------------------------------------------------------

; [ runic effect ]

RunicEffect:
@352b:  .i8

; return if attack can't be absorbed by runic
        lda     $11a3
        bit     #$08
        beq     @35ac

; find runic targets
        stz     $ee
        stz     $ef
        ldy     #$12
@3538:  lda     near wTargetProp2::w7e3aa0,y
        lsr
        bcc     @355e                   ; branch if $3aa0.0 is clear (target is not present)
        lda     near wTargetProp2::RetalFlags,y
        bitflg  RETAL_FLAGS, {RUNIC, MONSTER_RUNIC}
        beq     @355e                   ; branch if $3e4c.1 and $3e4c.2 are clear (runic and enemy runic)
        and     #<~RETAL_FLAGS::RUNIC
        sta     near wTargetProp2::RetalFlags,y                 ; clear $3e4c.2 (character runic)
        peaflg  STATUS12, {DEAD, PETRIFY, SLEEP}
        peaflg  STATUS34, {STOP, FROZEN, HIDE}
        jsr     CheckStatus
        bcc     @355e
        longa
        lda     near wTargetMask,y
        tsb     $ee
        shorta
@355e:  dey2
        bpl     @3538

; return if no targets have runic
        lda     $ee
        ora     $ef
        beq     @35ac
        phx
        jsr     _c23865
        stz     near w7e3415
        longa
        lda     $ee
        sta     zb8
        jsr     CountBits
        stz     $11aa
        stz     $11ac
        lda     #$2182                  ; affect mp, ignore reflect, can't dodge, restore mp
        sta     $11a3
        shorta
        lda     #$60
        sta     $11a2
        clr_a
        lda     $11a5
        jsr     Div
        sta     $11a6
        jsr     _c2385e                 ; clear level/hit rate
        stz     near w7e3414                   ; disable damage modification
        lda     #$40
        trb     zb2                     ; enable runic sword animation
        lda     #$04
        sta     zba                     ; no retarget if target invalid
        lda     #$03
        trb     $11a7                   ; don't display battle message, don't automatically miss if target immune to status
        stz     $11a9                   ; no special effect
        plx
@35ac:  rts

; ------------------------------------------------------------------------------

; [  ]

_c235ad:
_setattackmes:
@35ad:  phx
        ldx     near w7e3a72
        stx     near w7e3a71
        plx
        jsr     _c235d4
        jmp     _c2629e       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [  ]

_c235bb:
_writeattackmes:
@35bb:  jsr     _c235d4       ; copy battle script command to buffer

_c235be:
_writekernelmes:
@35be:  phx
        php
        ldx     near w7e3a72       ; save battle script command queue pointer
        phx
        ldx     near w7e3a71       ;
        stx     near w7e3a72
        jsr     _c2629e       ; add battle script command to queue
        plx
        stx     near w7e3a72       ; restore battle script command queue pointer
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ copy battle script command to buffer ]

_c235d4:
attackmessub:
@35d4:  php
        longa
        lda     zb4
        sta     near w7e3a28
        lda     zb6
        sta     near w7e3a2a
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ ]

_c235e3:
_setblacklist:
@35e3:  php
        shortai
        jsr     _c2361b
        txa

; set last command used
        sta     near wTargetProp1::RetalCmdTarget,y
        lda     near w7e3a7c
        sta     near wTargetProp2::w7e3d48,y

; set last attack
        lda     near w7e3410
        cmp     #$ff
        beq     @3601
        sta     near wTargetProp2::w7e3d49,y
        txa
        sta     near wTargetProp1::RetalAttackTarget,y

; set previous item used
@3601:  lda     near w7e3411
        cmp     #$ff
        beq     @360f
        sta     near wTargetProp2::w7e3d5c,y
        txa
        sta     near wTargetProp1::RetalItemTarget,y

; set previous element used
@360f:  lda     $11a1
        sta     near wTargetProp2::w7e3d5d,y
        txa
        sta     near wTargetProp1::RetalElemTarget,y
        plp
        .i16
        rts

; ------------------------------------------------------------------------------

; [ set retaliation target (50% chance) ]

_c2361b:
_setblacklist2:
@361b:  php
        shorta_sec
        lda     near wTargetProp1::w7e32e0,y
        bpl     @3628                   ; branch if waiting to retaliate
        jsr     RandCarry               ; 50% chance to retaliate
        bcc     @362d
@3628:  txa
        ror
        sta     near wTargetProp1::w7e32e0,y
@362d:  plp
        rts

; ------------------------------------------------------------------------------

; [ set retaliation target ]

; +x: attacker
; +y: target
; will only retaliate if carry is set when called

_c2362f:
_setblacklist3:
@362f:  pha
        php
        lda     near wTargetProp1::w7e32e0,y                 ; last target that attacked you
        bmi     @363b                   ; return if waiting to retaliate
        txa
        ror                             ; set flag for waiting to retaliate
        sta     near wTargetProp1::w7e32e0,y                 ; set last target that attacked you
@363b:  plp
        pla
        rts

; ------------------------------------------------------------------------------

; [ random weapon spellcast ]

; 25% chance to cast the weapon's spell after the attack

CheckWeaponSpellCast:
@363e:  lda     zb5
        cmp     #BATTLE_CMD::JUMP
        bne     @3649       ; branch if command was not jump
        lda     near w7e3a70
        bne     _3665       ; return if there is more than one attack (dragon horn)
@3649:  lda     near wWeaponSpellCast
        bit     #WEAPON_SPELL_FLAGS::RAND_CAST
        beq     _3665       ; return if random weapon spellcast is disabled
        xba
        jsr     Rand
        cmp     #$40
        bcs     _3665       ; 3/4 chance to return
        xba
        and     #$3f
        sta     near w7e3400       ; set spell index
        lda     #$10
        trb     zb2         ; follow-up spell hits same target
        inc     near w7e3a70       ; increment number of attacks

ShowAttackName_03:
_3665:  rts

; ------------------------------------------------------------------------------

; [ display attack name ]

ShowAttackName:
@3666:  lda     #$01
        trb     zb2
        beq     _3665       ; return if attack name has already been displayed (quadra slam, etc.)
        lda     near w7e3412       ; attack name type
        bmi     _3665       ; return if disabled
        phx
        txy
        sta     near w7e3a29       ; param 2 = attack name type
        asl
        tax
        lda     #GFX_CMD::ATTACK_NAME
        sta     near w7e3a28
        jsr     (near ShowAttackNameTbl,x)
        sta     near w7e3a2a       ; param 3 = return value
        plx
        jmp     _c2629e       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ attack name type $00: normal / bushido ]

ShowAttackName_00:
ShowAttackName_04:
@3687:  lda     zb6         ; spell/attack index
        rts

; ------------------------------------------------------------------------------

; [ attack name type $01: item ]

ShowAttackName_01:
@368a:  lda     near w7e3a7d       ; item index
        rts

; ------------------------------------------------------------------------------

; [ attack name type $02: esper ]

ShowAttackName_02:
@368e:  sec
        lda     zb6         ; spell/attack index - 54
        sbc     #ATTACK::FIRST_GENJU
        rts

; ------------------------------------------------------------------------------

; [ attack name type $05: command ]

ShowAttackName_05:
@3694:  lda     zb5         ; command index
        rts

; ------------------------------------------------------------------------------

; [ attack name type $06: monster special attack ]

ShowAttackName_06:
@3697:  lda     #GFX_CMD::MONSTER_SPECIAL
        sta     near w7e3a28       ; b1 = battle script command $11 (display monster special attack name)
        lda     near wTargetProp1::w7e33a8_L,y
        sta     near w7e3a29       ; +b2 = monster index
        lda     near wTargetProp1::w7e33a8_H,y
        rts

; ------------------------------------------------------------------------------

; [ attack name type $07: joker doom ]

ShowAttackName_07:
@36a6:  lda     #$02
        tsb     near w7e3a46       ; set $3a46.1
        trb     $11a2       ;
        lda     #$20
        tsb     $11a4       ; can't dodge
        lda     #$00        ; attack name type = 0 (normal)
        sta     near w7e3a29
        lda     #ATTACK::FIRST_BUSHIDO     ; same index as first bushido attack
        rts

; ------------------------------------------------------------------------------

; [ attack name type $08: blitz ]

ShowAttackName_08:
@36bb:  lda     #$00        ; attack name type = 0 (normal)
        sta     near w7e3a29
        lda     near w7e3a7d       ; blitz index
        rts

; ------------------------------------------------------------------------------

; attack name type jump table
ShowAttackNameTbl:
@36c4:  .addr   ShowAttackName_00
        .addr   ShowAttackName_01
        .addr   ShowAttackName_02
        .addr   ShowAttackName_03
        .addr   ShowAttackName_04
        .addr   ShowAttackName_05
        .addr   ShowAttackName_06
        .addr   ShowAttackName_07
        .addr   ShowAttackName_08

; ------------------------------------------------------------------------------

; [ learn lore ]

LearnLore:
@36d6:  .i8
        phx
        php
        shorta
        lda     $11a3
        bit     #$04
        beq     @3708
        ldy     .loword(array_item w7e3000, CHAR::STRAGO)
        bmi     @3708
        peaflg  STATUS12, {DEAD, PETRIFY, BLIND, ZOMBIE, SLEEP, CONFUSE, BERSERK}
        peaflg  STATUS34, {STOP, FROZEN, RAGE, HIDE}
        jsr     CheckStatus
        bcc     @3708
        lda     zb6
        sbc     #$8b
        clc
        jsr     GetBitPtr
        cpx     #$03
        bcs     @3708
        bit     $1d29,x
        bne     @3708
        ora     near w7e3a84,x
        sta     near w7e3a84,x
@3708:  plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ apply damage multiplier ]

; +A *= (1 + ($bc / 2))

ApplyDmgMult:
@370b:  phy
        ldy     zbc
        beq     @372d
        pha
        lda     zb2                     ; ignore damage multiplier flag (in $b3)
        asl
        and     $11a1                   ;
        asl3
        pla
        bcs     @372d
        sta     $ee
        lsr     $ee
@3721:  clc
        adc     $ee
        bcc     @3728
        clr_a                           ; max damage 65535
        dec
@3728:  dey
        bne     @3721
        sty     zbc
@372d:  ply
        rts

; ------------------------------------------------------------------------------

; [ set command for control ]

SetControlCmd:
@372f:  phx
        phy
        php
        longai_clc
        lda     f:CmdPropPtrs,x
        adc     #wControlCmdList - wCmdList
        sta     f:hWMADDL
        tyx
        lda     near wTargetProp2::CurrMP,x
        inc
        sta     $ee
        lda     near w7e2001 - 8,x
        asl2
        tax
        shorta
        clr_a
        sta     f:hWMADDH
        ldy     #4
@3756:  clr_a
        pha
        lda     f:MonsterControl,x
        sta     f:hWMDATA
        cmp     #$ff
        beq     @3780
        xba
        lda     #$0e
        jsr     MultAB
        phx
        tax
        lda     f:MagicProp+5,x
        xba
        lda     f:MagicProp,x   ; spell data
        plx
        sta     1,s
        clc
        lda     $ef
        bne     @3780
        xba
        cmp     $ee
@3780:  ror
        sta     f:hWMDATA
        pla
        sta     f:hWMDATA
        inx
        dey
        bne     @3756
        plp
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ check sketch/control success ]

; c: set = beret/coronet, clear = no beret/coronet
; c: set = failed, clear = successful (out)

CheckSketchHit:
@3792:  phx
        lda     near wTargetProp2::Level,y     ; target's level
        bcc     @379f
        xba
        lda     #$aa        ; multiply by (170/255) if coronet is equipped
        jsr     MultAB
        xba
@379f:  pha
        clr_a
        lda     near wTargetProp2::Level,x     ; attacker's level
        xba
        plx
        jsr     Div
        pha
        clc
        xba
        bne     @37b3
        jsr     Rand
        cmp     1,s
@37b3:  pla
        plx
        rts

; ------------------------------------------------------------------------------

; [ take gil from the party ]

; for gp rain or if a monsters uses steal

TakeGil:
@37b6:  pha
        sec
        lda     $1860
        sta     $ee
        sbc     1,s
        sta     $1860
        shorta
        lda     $1862
        sbc     #$00
        sta     $1862
        longa
        bcs     @37da
        lda     $ee
        sta     1,s
        stz     $1860
        stz     $1861
@37da:  pla
        rts

; ------------------------------------------------------------------------------

; [ choose a random esper ]

RandGenju:
@37dc:  .a8
        lda     #$19
        jsr     RandA
        cmp     #$0b
        bcc     @37e7
        inc2                ; can't pick odin or raiden
@37e7:  clc
        adc     #$36
        rts

; ------------------------------------------------------------------------------

; [  ]

_c237eb:
_loadmagic3:
@37eb:  lda     near w7e3400
        cmp     #$ff
        beq     @3837
        sta     zb6
        jsr     GetCmdForAI
        sta     zb5
        jsr     InitTarget
        jsr     InitAttacker
        stz     $11a5
        lda     #$ff
        sta     near w7e3400
        lda     #$02
        tsb     zb2
        lda     #$10
        bit     zb2
        beq     @3814
        stz     near w7e3415
@3814:  bne     @382d
        lda     #$0c
        trb     $11a3
        tsb     zba
        lda     #TARGET::ENEMY
        sta     zbb
        lda     #$10
        bit     $11a4
        beq     @382d
        stz     near w7e341c
        bra     @3832
@382d:  lda     #$20
        tsb     $11a4
@3832:  lda     #$02
        tsb     $11a3
@3837:  rts

; ------------------------------------------------------------------------------

; [ air anchor effect ]

AirAnchorEffect:
@3838:  lda     near wTargetProp1::w7e3205,x
        bit     #$04
        bne     @3849       ; return if $3205.2 is set (air anchor effect)
        ora     #$04
        sta     near wTargetProp1::w7e3205,x     ; set $3205.2 (disable air anchor effect)
        lda     #$40
        tsb     $11a3       ; attacker dies after attack
@3849:  rts

; ------------------------------------------------------------------------------

; [  ]

_c2384a:
_deatherase:
@384a:  lda     near wTargetProp2::w7e3de9,x
        ora     #STATUS4::HIDE
        sta     near wTargetProp2::w7e3de9,x
; fallthrough

; ------------------------------------------------------------------------------

_c23852:
_setdeath:
@3852:  jsr     _c2362f
        lda     #STATUS1::DEAD
        ora     near wTargetProp2::w7e3dd4,x
        sta     near wTargetProp2::w7e3dd4,x
        rts

; ------------------------------------------------------------------------------

; [ clear level/hit rate (runic) ]

_c2385e:
_itemdamage:
@385e:  stz     $11af
        stz     $11ae
        rts

; ------------------------------------------------------------------------------

; [  ]

_c23865:
_setupoldtarget:
@3865:  php
        longa
        lda     near w7e3414       ; damage modification
        bmi     @3874
        lda     near w7e3a30
        sta     zb8
        bra     @387c
@3874:  lda     zb8
        sta     near w7e3a30
        tsb     near w7e3a4e
@387c:  plp
        rts

; ------------------------------------------------------------------------------
