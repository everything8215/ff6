
.import MonsterSketch, MetamorphProp

; ------------------------------------------------------------------------------

; [ execute target special effect ]

DoTargetEffect:
@387e:  phx
        phy
        php
        shortai
        ldx     $11a9
        jsr     (near TargetEffectTbl,x)
        plp
        ply
        plx

TargetEffectNone:
@388c:  rts

; ------------------------------------------------------------------------------

; [ target special effect $0d: scimitar/zantetsuken (instant kill) ]

TargetEffect_0d:
@388d:  sec
        lda     #$ee

ScimitarEffect:
@3890:  xba
        lda     near wTargetProp2::w7e3aa1,y
        bit     #$04
        bne     TargetEffectNone     ; branch if $3aa1.2 is set (instant death protection)
        bcs     @389f
        lda     near wTargetProp2::MonsterFlags,y  ; MONSTER_FLAG::UNDEAD
        bmi     @38ab
@389f:  jsr     Rand
        cmp     #$40
        bcs     TargetEffectNone     ; 3/4 chance to return
        jsr     _c223b2
        bcs     TargetEffectNone
@38ab:
.if LANG_EN
        lda     near w7e3a70
        beq     @38b6
        lda     zb5
        cmp     #BATTLE_CMD::JUMP
        beq     TargetEffectNone
.endif
@38b6:  lda     near wTargetMask,y
        tsb     za4_L
        trb     near w7e3a4e
        lda     near wTargetMask + 1,y
        tsb     za4_H
        trb     near w7e3a4e_H
        lda     #$10
        tsb     za0
        lda     #STATUS1::DEAD
        jsr     SetStatus1
        stz     near w7e341d
        stz     $11a6
        lda     #BATTLE_CMD::MAGIC
        sta     zb5
        xba
        sta     zb6
        cmp     #$ee
        bne     @38ec
        cpy     #$08
        bcc     @38ec
        lda     near wTargetProp2::w7e3de9,y
        ora     #STATUS4::HIDE
        sta     near wTargetProp2::w7e3de9,y
@38ec:  jsr     _c235ad
        jmp     CopyGfxParamsToBuf

; ------------------------------------------------------------------------------

; [ target special effect $04: man eater ]

TargetEffect_04:
@38f2:  lda     near wTargetProp2::MonsterFlags,y
        bit     #MONSTER_FLAG::HUMAN
        beq     _38fd       ; return if not human
        inc     zbc         ; 2x damage multiplier
        inc     zbc
_38fd:  rts

; ------------------------------------------------------------------------------

; [ target special effect $08: sniper/hawkeye ]

; 1/2 chance to deal +50% damage or +150% damage vs. flying target (changes command to throw)

TargetEffect_08:
@38fe:  jsr     RandCarry
        bcc     _38fd       ; 1/2 chance to return
        inc     zbc         ; +50% damage
        lda     near wTargetProp3::w7e3ef9,y     ; return if target does not have float status
        bpl     _38fd
        lda     zb5         ; return if command is not fight
        cmp     #BATTLE_CMD::FIGHT
        bne     _38fd
        inc     zbc         ; +150% damage
        inc     zbc
        inc     zbc
        lda     #BATTLE_CMD::THROW
        sta     zb5
        lda     zb7         ;
        dec
        sta     zb6
        jmp     _c235bb

; ------------------------------------------------------------------------------

; [ target special effect $22: stone ]

TargetEffect_22:
@3922:  lda     5,s
        tax
        lda     near wTargetProp2::Level,x
        cmp     near wTargetProp2::Level,y
        bne     @3933
        lda     #$0d
        adc     zbc
        sta     zbc
@3933:  rts

; ------------------------------------------------------------------------------

; [ target special effect $13: palidor ]

TargetEffect_13:
@3934:  lda     #$01        ; flag for character that just jumped - remove all actions from action queue
        jsr     SetCharFlag
        lda     near wTargetProp1::w7e32cc,y     ; old command list pointer
        pha
        jsr     AddToQueue
        sta     near wTargetProp1::w7e32cc,y     ; set new command list pointer
        tay
        asl
        tax
        pla
        cmp     #$ff
        beq     @394e       ; branch if character/monster had no pending actions in the command list
        sta     near w7e3184,y     ; clear the old command list slot
@394e:  clr_a
        sta     near w7e3620,x     ; clear old command mp cost
        longa
        sta     near w7e3520,x     ; clear old command targets
        lda     #$0016      ; command $16 (jump)
        sta     near w7e3420,x     ; set old command/action
        rts

; ------------------------------------------------------------------------------

; [ target special effect $39: engulf ]

TargetEffect_39:
@395e:  .a8
        lda     near wTargetMask,y
        tsb     near w7e3a8a       ; set target as engulfed
        bra     _396c

; ------------------------------------------------------------------------------

; [ target special effect $33: bababreath ]

TargetEffect_33:
@3966:  lda     near wTargetMask,y
        tsb     near w7e3a88
; fall through

; ------------------------------------------------------------------------------

; [ target special effect $27/$38/$4b: escape/sneeze/smoke bomb ]

TargetEffect_27:
TargetEffect_38:
TargetEffect_4b:
_396c:  longa
        lda     near wTargetMask,y
        tsb     near w7e2f4c
        tsb     near w7e3a39
        rts

; ------------------------------------------------------------------------------

; [ target special effect $1f: dischord ]

TargetEffect_1f:
@3978:  tyx
        inc     near wTargetProp2::Level,x
        lsr     near wTargetProp2::Level,x
        rts

; ------------------------------------------------------------------------------

; [ target special effect $2b: r. polarity ]

TargetEffect_2b:
@3980:  .a8
        lda     near wTargetProp2::w7e3aa1,y     ; $3aa1.5 toggle target's row
        eor     #$20
        sta     near wTargetProp2::w7e3aa1,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $26: wallchange ]

TargetEffect_26:
        .a8
@3989:  clr_a
        lda     #$ff
        jsr     RandBit
        sta     near wTargetProp2::ElemWeak,y
        not_a
        sta     near wTargetProp2::ElemNull,y
        jsr     RandBit
        sta     near wTargetProp2::ElemAbsorb,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $52: steal ]

TargetEffect_52:
@399e:  lda     5,s
        tax
        lda     #ATTACK_MSG::STEAL_MSG
        sta     near w7e3401
        cpx     #$08
        bcs     @3a09
        longa
        lda     near wTargetProp1::w7e3308,y
        inc
        shorta_sec
        beq     @3a01
        inc     near w7e3401
        lda     near wTargetProp2::Level,x
        adc     #$32
        bcs     @39d8
        sbc     near wTargetProp2::Level,y
        bcc     @3a01
        bmi     @39d8
        sta     $ee
        lda     near wTargetProp2::RelicEffect3,x  ; RELIC_EFFECT3::INC_STEAL_RATE
        lsr
        bcc     @39cf
        asl     $ee
@39cf:  lda     #100
        jsr     RandA
        cmp     $ee
        bcs     @3a01
@39d8:  phy
        jsr     Rand
        cmp     #$20
        bcc     @39e1
        iny
@39e1:  lda     near wTargetProp1::w7e3308,y
        ply
        cmp     #$ff
        beq     @3a01
        sta     near w7e2f35
        sta     near wTargetProp1::w7e32f4,x
        lda     near wTargetMask,x
        tsb     near w7e3a8c
        lda     #$ff
        sta     near wTargetProp1::w7e3308,y
        sta     near wTargetProp1::w7e3309,y
        inc     near w7e3401
        rts
@3a01:  shorta
        lda     #$00
        sta     near wTargetProp2::w7e3d48,y
        rts
@3a09:  stz     near w7e2f38_B
        inc     near w7e3401
        jsr     Rand
        cmp     #$c0
        bcs     @3a01
        dec     near w7e3401
        lda     near wTargetProp2::Level,x
        xba
        lda     #$14
        longa
        jsr     TakeGil
        beq     @3a01
        sta     near w7e2f38
        clc
        adc     near wTargetProp2::MonsterGil,x
        bcc     @3a31
        clr_a
        dec
@3a31:  sta     near wTargetProp2::MonsterGil,x
        shorta
        lda     #ATTACK_MSG::STEAL_GIL
        sta     near w7e3401
        rts

; ------------------------------------------------------------------------------

; [ target special effect $12: metamorph ]

TargetEffect_12:
@3a3c:  cpy     #$08
        bcc     _3a8a
        lda     near wTargetProp2::MetamorphProp,y
        pha
        and     #$1f
        jsr     RandCarry
        rol
        jsr     RandCarry
        rol
        tax
        lda     f:MetamorphProp,x
        sta     near w7e2f35
        lda     #GFX_CMD::ATTACK_MSG
        sta     near w7e3a28
        lda     #ATTACK_MSG::METAMORPH_ITEM
        sta     near w7e3a29
        jsr     _c235be
        jsr     _c235ad
        pla
        lsr5
        tax
        jsr     Rand
        cmp     f:MetamorphRateTbl,x
        bcs     _3a8a
        lda     5,s                   ; attacker index
        tax
        lda     near w7e2f35
        sta     near wTargetProp1::w7e32f4,x                 ; obtained item
        lda     near wTargetMask,x                 ; character mask
        tsb     near w7e3a8c
        lda     #STATUS1::DEAD          ; kill target
        jmp     SetStatus1

; metamorph miss
_3a8a:  jmp     _c23b1b                 ; miss

; ------------------------------------------------------------------------------

; [ target special effect $56: debilitator ]

TargetEffect_56:
@3a8d:  clr_a
        lda     near wTargetProp2::ElemWeak,y
        ora     near w7e3eb0 + 24
        not_a
.if LANG_EN
        beq     _3a8a
.else
        beq     _c23b1b                 ; miss
.endif
        jsr     RandBit
        pha
        jsr     GetBitNum
        txa
        clc
        adc     #ATTACK_MSG::DEBILITATOR_ELEMENT
        sta     near w7e3401
        lda     1,s
        ora     near wTargetProp2::ElemWeak,y
        sta     near wTargetProp2::ElemWeak,y
        pla
        not_a
        pha
        and     near wTargetProp2::ElemHalf,y
        sta     near wTargetProp2::ElemHalf,y
        lda     1,s
        xba
        pla
        longa
        and     near wTargetProp2::ElemAbsorb,y
        sta     near wTargetProp2::ElemAbsorb,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $53: control ]

TargetEffect_53:
@3ac5:  .a8
        .i8
        cpy     #$08
        bcc     @3b16       ; miss if target is a character
        lda     near wTargetProp2::MonsterStatus,y  ; MONSTER_STATUS::CANT_CONTROL
        bmi     @3b16       ; miss if monster can't be controlled
        peaflg  STATUS12, {DEAD, PETRIFY, VANISH, ZOMBIE, SLEEP, CONFUSE, BERSERK}
        peaflg  STATUS34, {RAGE, HIDE, MORPH}
        jsr     CheckStatus
        bcc     @3b16       ; miss if set
        lda     near wTargetProp1::ControlAttacker,y
        bpl     @3b16       ; miss if already controlled
        lda     5,s
        tax
        lda     near wTargetProp2::RelicEffect3,x  ; RELIC_EFFECT3::INC_CONTROL_RATE
        lsr4
        jsr     CheckSketchHit
        bcs     _c23b1b                 ; miss if attack failed
        tya
        sta     near wTargetProp1::ControlTarget,x     ; target you control (attacker)
        txa
        sta     near wTargetProp1::ControlAttacker,y     ; target controlling you (target)
        lda     near wTargetMask + 1,y
        tsb     near w7e2f53 + 1       ; h-flip for targets being controlled (target)
.if LANG_EN
        lda     near wTargetProp2::ExtraStatus,x     ; use control battle menu for attacker $3e4d.0
        ora     #$01
        sta     near wTargetProp2::ExtraStatus,x
.endif
        lda     near wTargetProp3::w7e3ef9,x     ; set control status (attacker)
        ora     #STATUS4::CONTROL
        sta     near wTargetProp3::w7e3ef9,x
        lda     near wTargetProp2::w7e3aa1,y     ; set $3aa1.6 pending control action (target)
        ora     #$40
        sta     near wTargetProp2::w7e3aa1,y
        jmp     SetControlCmd

@3b16:  lda     #ATTACK_MSG::CONTROL_FAIL
        sta     near w7e3401
; fallthrough

; attack misses (common)
_c23b1b:
@3b1b:  longa                           ; make attack miss this target
        lda     near wTargetMask,y
        sta     near w7e3a48                   ; missed target due to status
        tsb     near w7e3a5a                   ; add missed target
        trb     za4                     ; remove from targets hit
        rts

; ------------------------------------------------------------------------------

; [ target special effect $55: sketch ]

TargetEffect_55:
@3b29:  .a8
        cpy     #$08
        bcc     _c23b1b                 ; miss
        lda     near wTargetProp2::MonsterStatus,y
        bit     #MONSTER_STATUS::CANT_SKETCH
        bne     @3b64                   ; branch if target can't be sketched
        lda     5,s
        tax
        lda     near wTargetProp2::RelicEffect3,x  ; RELIC_EFFECT3::INC_SKETCH_RATE
        lsr3
        jsr     CheckSketchHit
        bcs     _c23b1b                 ; miss
        sty     near w7e3417
        tya
        sbc     #$07
        lsr
        sta     zb7
        jsr     _c235bb
        jsr     Rand
        cmp     #$40
        longai
        lda     near w7e2001 - 8,y
        rol
        tax
        lda     f:MonsterSketch,x
        shortai
        sta     near w7e3400
        rts
@3b64:  lda     #ATTACK_MSG::SKETCH_FAIL
        sta     near w7e3401
        bra     _c23b1b                 ; miss

; ------------------------------------------------------------------------------

; [ target special effect $25: misses floating targets ]

TargetEffect_25:
@3b6b:  lda     near wTargetProp3::w7e3ef9,y
        bmi     _c23b1b                 ; miss if target has float status
        rts

; ------------------------------------------------------------------------------

; [ target special effect $54: leap ]

TargetEffect_54:
@3b71:  lda     near w7e2f49
        bit     #$08
        bne     @3b90       ; branch if leap is disabled
        lda     near w7e3a76
        cmp     #2
        bcc     @3b90
        lda     5,s
        tax
        lda     near wTargetProp2::w7e3de9,x
        ora     #STATUS4::HIDE
        sta     near wTargetProp2::w7e3de9,x
        lda     #$04        ; end of battle special event 2 (gau leaped)
        sta     near w7e3a6e
        rts
@3b90:  lda     #ATTACK_MSG::LEAP_FAIL
        sta     near w7e3401
        jmp     _c23b1b                 ; miss

; ------------------------------------------------------------------------------

; [ target special effect $50: possess ]

TargetEffect_50:
@3b98:  lda     5,s
        tax
        lda     near wTargetMask,x
        tsb     near w7e2f4c
        tsb     near w7e3a88
        jsr     _c2384a
        phx
        tyx
        jsr     _c2384a
        ply
        jmp     _c2361b

; ------------------------------------------------------------------------------

; [ target special effect $28: mind blast ]

TargetEffect_28:
@3bb0:  longa
        jsr     ResetStatusMod
        lda     near wTargetMask,y
        ldx     #$06
@3bba:  bit     near w7e3a5c,x
        beq     @3bc6
        pha
        phx
        jsr     _c23bd0
        plx
        pla
@3bc6:  dex2
        bpl     @3bba
        rts

; ------------------------------------------------------------------------------

; [ target special effect $3b: evil toot ]

TargetEffect_3b:
@3bcb:  longa
        jsr     ResetStatusMod

_c23bd0:
siren_atmk:
@3bd0:  lda     $11aa
        jsr     CountBits
        stx     $ee
        lda     $11ac
        jsr     CountBits
        shorta
        txa
        clc
        adc     $ee
        jsr     RandA
        cmp     $ee
        longa
        php
        lda     $11aa
        bcc     @3bf4
        lda     $11ac
@3bf4:  jsr     RandBit
        plp
        jcc     SetStatus1
        ora     near wTargetProp2::w7e3de8,y
        sta     near wTargetProp2::w7e3de8,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $21: rippler ]

TargetEffect_21:
@3c04:  lda     5,s
        tax
        longa
        lda     near wTargetProp3::w7e3ee4,x
        and     near wTargetProp3::w7e3ee4,y
        not_a
        sta     $ee
        lda     near wTargetProp3::w7e3ee4,x
        and     $ee
        sta     near wTargetProp2::w7e3dd4,y
        sta     near wTargetProp2::w7e3dfc,x
        lda     near wTargetProp3::w7e3ee4,y
        and     $ee
        sta     near wTargetProp2::w7e3dd4,x
        sta     near wTargetProp2::w7e3dfc,y
        lda     near wTargetProp3::w7e3ef8,x
        and     near wTargetProp3::w7e3ef8,y
        not_a
        sta     $ee
        lda     near wTargetProp3::w7e3ef8,x
        and     $ee
        sta     near wTargetProp2::w7e3de8,y
        sta     near wTargetProp2::w7e3e10,x
        lda     near wTargetProp3::w7e3ef8,y
        and     $ee
        sta     near wTargetProp2::w7e3de8,x
        sta     near wTargetProp2::w7e3e10,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $19: exploder ]

TargetEffect_19:
@3c4c:  .a8
        lda     5,s
        tax
        stx     $ee
        cpy     $ee
        bne     _3c5a
        lda     near wTargetMask,x
        trb     za4_L
_3c5a:  rts

; ------------------------------------------------------------------------------

; [ target special effect $10: scan ]

TargetEffect_10:
@3c5b:  lda     near wTargetProp2::MonsterStatus,y
        bit     #MONSTER_STATUS::CANT_SCAN
        bne     @3c68                   ; branch if target can't be scanned
        tyx
        lda     #ACTION_BATTLE_CMD::SCAN_INFO
        jmp     CreateImmediateAction
@3c68:  lda     #ATTACK_MSG::SCAN_FAIL
        sta     near w7e3401
        rts

; ------------------------------------------------------------------------------

; [ target special effect $30: suplex ]

TargetEffect_30:
@3c6e:  lda     near wTargetProp2::MonsterStatus,y
        bit     #MONSTER_STATUS::CANT_SUPLEX
        beq     _3c5a                   ; branch if not immune to suplex
_3c75:  jmp     _c23b1b                 ; miss

; ------------------------------------------------------------------------------

; [ target special effect $57: air anchor ]

TargetEffect_57:
@3c78:  lda     near wTargetProp2::w7e3aa1,y
        bit     #$04
        bne     _3c75       ; branch if $3aa1.2 set (instant death protection)
        lda     #ATTACK_MSG::AIR_ANCHOR
        sta     near w7e3401
        lda     near wTargetProp1::w7e3205,y     ; clear air anchor effect ($3205.2)
        and     #$fb
        sta     near wTargetProp1::w7e3205,y
; fall through

; ------------------------------------------------------------------------------

; [ target special effect $23: disable counterattack ]

TargetEffect_23:
@3c8c:  stz     near w7e341a       ; disable counterattack
        rts

; ------------------------------------------------------------------------------

; [ target special effect $1c: reflect??? ]

TargetEffect_1c:
@3c90:  rts

; ------------------------------------------------------------------------------

; [ target special effect $34: charm ]

TargetEffect_34:
@3c91:  lda     5,s       ; attacker
        tax
        lda     near wTargetProp1::CharmTarget,x     ; charm target
        bpl     _3c75       ; return if attacker already has a charm target
        tya
        sta     near wTargetProp1::CharmTarget,x     ; set attacker's charm target
        txa
        sta     near wTargetProp1::CharmAttacker,y     ; set target's charm attacker
        rts

; ------------------------------------------------------------------------------

; [ target special effect $17: tapir ]

TargetEffect_17:
@3ca2:  lda     near wTargetProp3::w7e3ee5,y
        bpl     _3c75                   ; sleep
        longa
        lda     near wTargetProp2::MaxHP,y
        sta     near wTargetProp2::CurrHP,y
_3caf:  longa
        lda     near wTargetProp2::MaxMP,y
        sta     near wTargetProp2::CurrMP,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $20: pep up ]

TargetEffect_20:
@3cb8:  lda     5,s
        tax
        jsr     _c2384a
        longa
        lda     near wTargetMask,x
        tsb     near w7e2f4c
        stz     near wTargetProp2::CurrHP,x
        stz     near wTargetProp2::CurrMP,x
        bra     _3caf                   ; restore MP to max

; ------------------------------------------------------------------------------

; [ target special effect $2e: seize ]

TargetEffect_2e:
@3cce:  .a8
        lda     5,s       ; attacker
        tax
        lda     near wTargetProp1::SeizeTarget,x     ; seize target
        bpl     _3c75       ; return if attacker already has a seize target
        cpy     #$08
        bcs     _3c75       ; return if target is a monster
        tya
        sta     near wTargetProp1::SeizeTarget,x     ; set attacker's seize target
        txa
        sta     near wTargetProp1::SeizeAttacker,y     ; set target's seize attacker
        lda     near wTargetProp2::MonsterVar,x     ; set msb of attacker's character/monster variable
        ora     #$80
        sta     near wTargetProp2::MonsterVar,x
        lda     near wTargetMask,y     ; target's character/monster mask
        trb     near w7e3403       ; set target that is seized
        lda     near wTargetProp2::w7e3aa0,y     ; clear $3aa0.7 (target's battle menu can't open)
        and     #$7f
        sta     near wTargetProp2::w7e3aa0,y
        lda     #$40        ; remove all advance wait actions (set $3204.6)
        jmp     SetCharFlag

; ------------------------------------------------------------------------------

; [ target special effect $44: discard ]

TargetEffect_44:
@3cfd:  lda     5,s       ; attacker
        tax
        lda     near wTargetProp2::MonsterVar,x     ; clear msb of attacker's character/monster variable
        and     #$7f
        sta     near wTargetProp2::MonsterVar,x
        lda     #$ff
        sta     near wTargetProp1::SeizeTarget,x     ; invalidate attacker's seize target
        sta     near wTargetProp1::SeizeAttacker,y     ; invalidate target's seize attacker
        lda     near wTargetMask,y
        tsb     near w7e3403       ; clear target that is seized
        rts

; ------------------------------------------------------------------------------

; [ target special effect $4c: elixir/megalixir ]

TargetEffect_4c:
@3d17:  lda     #$80        ; update enabled spells/espers
        jsr     SetCharFlag
        bra     _3caf                   ; restore MP to max

; ------------------------------------------------------------------------------

; [ target special effect $37: overcast ]

TargetEffect_37:
@3d1e:  lda     near wTargetProp2::ExtraStatus,y     ; set overcast status ($3e4d.1)
        ora     #STATUS1::ZOMBIE
        sta     near wTargetProp2::ExtraStatus,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $3a: zinger ]

TargetEffect_3a:
@3d27:  lda     5,s       ; attacker
        tax
        stx     near wZingerAttacker
        sty     near wZingerTarget
        lda     near wTargetMask + 1,x
        tsb     near w7e2f4c + 1       ; attacker can't be targetted
        rts

; ------------------------------------------------------------------------------

; [ target special effect $2d: love token ]

TargetEffect_2d:
@3d37:  lda     5,s       ; attacker
        tax
        tya
        sta     near wTargetProp1::LoveTokenTarget,x     ; love token target
        txa
        sta     near wTargetProp1::LoveTokenAttacker,y     ; love token attacker
        rts

; ------------------------------------------------------------------------------

; [ target special effect $03: instant kill (with "x") ]

; striker, wing edge, trump

TargetEffect_03:
@3d43:  clc
        lda     #$7e
        jsr     ScimitarEffect
; fall through

; ------------------------------------------------------------------------------

; [ target special effect $35: doom ]

TargetEffect_35:
@3d49:  lda     near wTargetProp2::MonsterFlags,y  ; MONSTER_FLAG::UNDEAD
        bpl     @3d62
        cpy     #$08
        bcs     @3d63
        lda     near wTargetProp2::w7e3dd4,y
        and     #<~STATUS1::DEAD
        sta     near wTargetProp2::w7e3dd4,y
        longa
        lda     near wTargetProp2::MaxHP,y
        sta     near wTargetProp2::CurrHP,y
@3d62:  rts

; monster target
@3d63:  .a8
        clr_a
        lda     near wTargetProp2::w7e3de9,y
        ora     #STATUS4::HIDE
        sta     near wTargetProp2::w7e3de9,y
        lda     near wTargetMask + 1,y
        xba
        longa
        sta     zb8
        ldx     #MONSTER_ENTRY_EXIT_ANIM::MATERIALIZE
        lda     #ACTION_BATTLE_CMD::MONSTER_ENTRY_EXIT
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; [ target special effect $3e: phantasm ]

TargetEffect_3e:
@3d7c:  .a8
        lda     near wTargetProp2::ExtraStatus,y
        ora     #STATUS2::SAP
        sta     near wTargetProp2::ExtraStatus,y     ; set phantasm status ($3e4d.6)
        rts

; ------------------------------------------------------------------------------

; [ target special effect $3f: stunner ]

TargetEffect_3f:
@3d85:  jsr     Rand
        cmp     $11a8
        bcc     @3da7
        longa
        lda     $11aa
        not_a
        and     near wTargetProp2::w7e3dd4,y
        sta     near wTargetProp2::w7e3dd4,y
        lda     $11ac
        not_a
        and     near wTargetProp2::w7e3de8,y
        sta     near wTargetProp2::w7e3de8,y
@3da7:  rts

; ------------------------------------------------------------------------------

; [ target special effect $2f: targetting ]

TargetEffect_2f:
@3da8:  .a8
        lda     5,s
        tax
        tya
        sta     near wTargetProp1::w7e32f5,x     ; set "targetting" target
        rts

; ------------------------------------------------------------------------------

; [ target special effect $40: fallen one ]

TargetEffect_40:
@3db0:  longa
        clr_a
        inc
        sta     near wTargetProp2::CurrHP,y     ; set hp to 1
        rts

; ------------------------------------------------------------------------------

; [ target special effect $4a: super ball ]

TargetEffect_4a:
@3db8:  .a8
        jsr     Rand
        and     #$07        ; (1..8)
        inc
        sta     $11b1       ; item damage * 256
        stz     $11b0
        rts

; ------------------------------------------------------------------------------

; metamorph probabilities
;   0: 255/256
;   1: 3/4
;   2: 1/2
;   3: 1/4
;   4: 1/8
;   5: 1/16
;   6: 1/32
;   7: 0

MetamorphRateTbl:
@3dc5:  .byte   $ff,$c0,$80,$40,$20,$10,$08,$00

; ------------------------------------------------------------------------------

; target special effect jump table
TargetEffectTbl:
@3dcd:  .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_03
        .addr   TargetEffect_04
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone

        .addr   TargetEffect_08
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_0d
        .addr   TargetEffectNone
        .addr   TargetEffectNone

        .addr   TargetEffect_10
        .addr   TargetEffectNone
        .addr   TargetEffect_12
        .addr   TargetEffect_13
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_17

        .addr   TargetEffectNone
        .addr   TargetEffect_19
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_1c
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_1f

        .addr   TargetEffect_20
        .addr   TargetEffect_21
        .addr   TargetEffect_22
        .addr   TargetEffect_23
        .addr   TargetEffectNone
        .addr   TargetEffect_25
        .addr   TargetEffect_26
        .addr   TargetEffect_27

        .addr   TargetEffect_28
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_2b
        .addr   TargetEffectNone
        .addr   TargetEffect_2d
        .addr   TargetEffect_2e
        .addr   TargetEffect_2f

        .addr   TargetEffect_30
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_33
        .addr   TargetEffect_34
        .addr   TargetEffect_35
        .addr   TargetEffectNone
        .addr   TargetEffect_37

        .addr   TargetEffect_38
        .addr   TargetEffect_39
        .addr   TargetEffect_3a
        .addr   TargetEffect_3b
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_3e
        .addr   TargetEffect_3f

        .addr   TargetEffect_40
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_44
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone

        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffect_4a
        .addr   TargetEffect_4b
        .addr   TargetEffect_4c
        .addr   TargetEffectNone
        .addr   TargetEffectNone
        .addr   TargetEffectNone

        .addr   TargetEffect_50
        .addr   TargetEffectNone
        .addr   TargetEffect_52
        .addr   TargetEffect_53
        .addr   TargetEffect_54
        .addr   TargetEffect_55
        .addr   TargetEffect_56
        .addr   TargetEffect_57

; ------------------------------------------------------------------------------
