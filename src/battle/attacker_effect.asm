
.enum ATTACKER_EFFECT
        COUNT = ATTACK_SPECIAL_EFFECT::COUNT
.endenum

; ------------------------------------------------------------------------------

; [ execute attacker special effect ]

DoAttackerEffect:
_magicfunc3:
@3e7d:  phx
        php
        shortai
        txy
        ldx     $11a9
        jsr     (near AttackerEffectTbl,x)
        plp
        plx

AttackerEffectNone:
@3e8a:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $01: thiefknife ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::THIEFKNIFE
@3e8b:  jsr     RandCarry
        bcs     @3e9f
        lda     #$a4        ; special effect $52 (steal)
        sta     $11a9
        lda     zb5
        cmp     #BATTLE_CMD::FIGHT
        bne     @3e9f
        lda     #BATTLE_CMD::CAPTURE
        sta     zb5
@3e9f:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $1e: step mine ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::STEP_MINE
@3ea0:  stz     near w7e3414       ; disable damage modification
        longa
        clr_a
        dec
        sta     $11b0
        lda     $1867
        ldx     $11a6
        jsr     Div
        shorta
        xba
        bne     @3ec9
        txa
        xba
        sta     $11b1
        lda     $1866
        ldx     $11a6
        jsr     Div
        sta     $11b0
@3ec9:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0e: organyx (ogre nix) ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::OGRE_NIX
@3eca:  lda     zb1         ; counterattack flag
        lsr
        bcs     array_item ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MP_CRIT       ; branch if a counterattack
        lda     near wTargetProp2::w7e3aa0,y
        bit     #$04
        bne     array_item ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MP_CRIT       ; branch if $3aa0.2 is set (ogre nix can't be broken)
        lda     near wTargetProp2::CurrHP_H,y
        xba
        lda     near wTargetProp2::CurrHP_L,y
        ldx     #10
        jsr     Div
        inx
        txa
        jsr     RandA
        dec
        bpl     array_item ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MP_CRIT
        tya
        lsr
        tax
        inc     near w7e2f30,x
        xba
        lda     #wItemList::ITEM_SIZE
        jsr     MultAB
        sta     $ee
        tyx
        lda     near w7e3a70
        lsr
        bcs     @3f06
        inx
        lda     $ee
        adc     #(wLHandItemList) - (wRHandItemList)
        sta     $ee
@3f06:  stz     near wTargetProp2::RHandAttackPower,x
        ldx     $ee
        lda     near wRHandItemList::ItemID,x
        cmp     #ITEM::OGRE_NIX
        bne     array_item ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MP_CRIT
        lda     #ITEM::UNARMED
        sta     near wRHandItemList::ItemID,x
        sta     near wRHandItemList::UsageFlags,x
        stz     near wRHandItemList::Qty,x
        lda     #ATTACK_MSG::OGRE_NIX_BROKEN
        sta     near w7e3401
; fall through

; ------------------------------------------------------------------------------

; [ attacker special effect $07: use mp for critical ]

; rune edge, illumina, ragnarok, punisher

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MP_CRIT
@3f22:  lda     #12                     ; use 12 mp
_3f24:  sta     $ee
        lda     zb2
        bit     #$02
        bne     @3f4f
        lda     near w7e3eb0 + 25
        beq     @3f4f                   ; return if there are no targets
        clr_a
        jsr     Rand
        and     #$07
        clc
        adc     $ee
        longa
        sta     $ee
        lda     near wTargetProp2::CurrMP,y
        cmp     $ee
        bcc     @3f4f
        sbc     $ee
        sta     near wTargetProp2::CurrMP,y
        lda     #$0200
        trb     zb2
@3f4f:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0f: use more mp for critical (unused) ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MORE_MP_CRIT
@3f50:  .a8
        lda     #28                     ; use 28 mp
        bra     _3f24

; ------------------------------------------------------------------------------

; [ attacker special effect $1b: pearl wind ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::WHITE_WIND
@3f54:  lda     #$60
        tsb     $11a2
        stz     near w7e3414       ; disable damage modification
        longa
        lda     near wTargetProp2::CurrHP,y
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $11: golem ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::GOLEM
@3f65:  longa
        lda     near wTargetProp2::CurrHP,y
        sta     near wGolemHP
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $06: soul sabre ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::SOUL_SABRE
@3f6e:  .a8
        lda     #$80
        tsb     $11a3
; fall through

; ------------------------------------------------------------------------------

; [ attacker special effect $05: drainer ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::DRAINER
@3f73:  lda     #$08
        tsb     $11a2
        lda     #$02
        tsb     $11a4       ; drain effect
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0c: heal rod ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::HEAL_ROD
@3f7e:  lda     #$20
        tsb     $11a2
        lda     #$01
        tsb     $11a4
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0a: valiantknife ]

; increase damage by (max hp - current hp)

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::VALIANTKNIFE
@3f89:  lda     #$20
        tsb     $11a2
        longa
        sec
        lda     near wTargetProp2::MaxHP,y
        sbc     near wTargetProp2::CurrHP,y
        clc
        adc     $11b0
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0b: tempest ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::TEMPEST
@3f9f:  .a8
        jsr     Rand
        cmp     #$80
        bcs     _3fb6       ; 50% chance to return
        stz     $11a6       ; clear attack power
        lda     #ATTACK::WIND_SLASH
        bra     _3fb0

; ------------------------------------------------------------------------------

; [ attacker special effect $49: magicite ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MAGICITE
@3fad:  jsr     RandGenju
_3fb0:  sta     near w7e3400       ; current spell
        inc     near w7e3a70       ; increment number of attacks
_3fb6:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $51: gp rain ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::GIL_TOSS
@3fb7:  lda     near wTargetProp2::Level,y
        xba
        lda     #$1e
        jsr     MultAB
        longa
        cpy     #$08
        bcs     @3fd3
        jsr     TakeGil
        bne     @3fe9
@3fcb:  stz     za4
        ldx     #ATTACK_MSG::GIL_TOSS_FAIL
        stx     near w7e3401
        rts
@3fd3:  sta     $ee
        lda     near wTargetProp2::MonsterGil,y
        beq     @3fcb
        sbc     $ee
        bcs     @3fe4
        lda     near wTargetProp2::MonsterGil,y
        sta     $ee
        clr_a
@3fe4:  sta     near wTargetProp2::MonsterGil,y
        lda     $ee
@3fe9:  ldx     #$02
        stx     $e8
        jsr     Mult24
        lda     $e8
        ldx     near w7e3eb0 + 25       ; number of targets
        jsr     Div
        sta     $11b0       ; damage
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $19: exploder ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::EXPLODER
@3ffc:  .a8
        tyx
        stz     zbc
        lda     #$10                    ; disable pre-attack animation
        tsb     zb0
        stz     near w7e3414                   ; disable damage modification
        longa
        lda     za4
        pha
        lda     near wTargetMask,x
        sta     zb8
        jsr     InitGfxParams
        jsr     CopyGfxParamsToBuf
        lda     1,s
        sta     zb8
        jsr     InitGfxParams
        pla
        ora     near wTargetMask,x
        sta     za4
        lda     near wTargetProp2::CurrHP,x
        sta     $11b0
        jmp     _c235ad

; ------------------------------------------------------------------------------

; [ attacker special effect $4a: super ball ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::SUPER_BALL
@402c:  .a8
        lda     #$7d
        sta     zb6
        jsr     Rand
        and     #$03
        bra     _4039

; ------------------------------------------------------------------------------

; [ attacker special effect $2c: launcher ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::LAUNCHER
@4037:  lda     #$07
_4039:  sta     near w7e3405
        longa
        lda     near wTargetMask,y
        sta     za6
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $02: atma weapon ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::ATMA_WEAPON
@4044:  .a8
        lda     #$20
        tsb     $11a2       ; ignore target's defense
        lda     #$02
        tsb     zb2         ; no critical
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $18/$4d: warp/warp stone ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::WARP
        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::WARP_STONE
@404e:  lda     zb1
        bit     #$04
        bne     @405a       ; branch if can't run away
        lda     #$02        ; end of battle special event 1 (ran out of time before emperor's banquet)
        sta     near w7e3a6e
        rts
@405a:  lda     #ATTACK_MSG::WARP_FAIL
        sta     near w7e3401
        bra     AttackerEffectMiss

; ------------------------------------------------------------------------------

; [ attacker special effect $33: bababreath ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::BABABREATH
@4061:  stz     $ee
        ldx     #$06
@4065:  lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @407c       ; branch if $3aa0.0 is clear
        lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        beq     @407c
        lda     near wTargetMask,x
        bit     near w7e3f2c
        bne     @407c
        sta     $ee
@407c:  dex2
        bpl     @4065
        lda     $ee
        bne     @408d
        lda     near w7e3a76
        cmp     #2
        bcs     _40ba
        bra     AttackerEffectMiss
@408d:  sta     zb8_L
        stz     zb8_H
        tyx
        jmp     InitGfxParams

; ------------------------------------------------------------------------------

; [ attacker special effect $50: possess ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::POSSESS
@4095:  jsr     Rand
        cmp     #150
        bcc     _40ba       ; ~60% chance to return (40% chance to miss)

miss_atmk:
AttackerEffectMiss:
@409c:  stz     za4_L         ; clear targets hit
        stz     za4_H
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $1d: l? pearl ]

; hits targets with level divisble by last digit of gp

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::PEARL_LORE
@40a1:  lda     $1862       ; gp
        xba
        lda     $1861
        ldx     #10
        jsr     Div
        txa
        xba
        lda     $1860
        ldx     #10
        jsr     Div
        stx     $11a8       ; success rate
_40ba:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $27: escape ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::ESCAPE
@40bb:  cpy     #$08
        bcs     _40ba       ; return if attacker is a monster
        lda     #GFX_BATTLE_CMD::RUN_AWAY
        sta     zb5         ; command $22 (characters run away)
        lda     #$10
        tsb     za0         ; disable pre-attack swirly animation
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $4b: smoke bomb ]

; characters run away

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::SMOKE_BOMB
@40c8:  lda     #$04
        bit     zb1
        beq     _40ba       ; return if party can run away
        jsr     AttackerEffectMiss
        stz     $11a9       ; disable attack special effect

; *** bug *** this should probably be ATTACK_MSG::WARP_FAIL
        lda     #ATTACK_MSG::RUN_FAIL
_40d6:  sta     near w7e3401
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $31: forcefield ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::FORCEFIELD
@40da:  clr_a
        lda     #$ff
        eor     near w7e3eb0 + 24       ; elements nullified by forcefield
        beq     AttackerEffectMiss
        jsr     RandBit
        tsb     near w7e3eb0 + 24
        jsr     GetBitNum
        txa
        clc
        adc     #ATTACK_MSG::ELEMENT_IMMUNE
        bra     _40d6

; ------------------------------------------------------------------------------

; [ attacker special effect $32: quadra slam/slice ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::QUADRA_SLAM
@40f1:  lda     #3
        sta     near w7e3a70       ; 3 extra attacks
        lda     #$40
        tsb     zba         ; random target
        stz     $11a9       ; disable special effect
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $1a: blow fish ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::BLOW_FISH
@40fe:  lda     #$60        ;
        tsb     $11a2
        stz     near w7e3414       ; disable damage modification
        longa
        lda     #1000       ; set damage to 1000
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $2a: flare star ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::FLARE_STAR
@410f:  stz     near w7e3414       ; disable damage modification
        longa
        lda     za2
        jsr     RandBit
        jsr     BitToTargetID
        lda     za2
        jsr     CountBits
        shorta
        lda     near wTargetProp2::Level,y
        xba
        lda     $11a6
        jsr     MultAB
        jsr     Div
        longa
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $4c: elixir/megalixir ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::ELIXIR
@4136:  .a8
        lda     #$80
        trb     $11a3
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $28: mind blast ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MIND_BLAST
@413c:  longa
        ldy     #$06
@4140:  lda     za4         ; character targets hit
        jsr     RandBit
        sta     near w7e3a5c,y     ; set mind blast status
        dey2
        bpl     @4140
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $29: n. cross ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::N_CROSS
@414d:  .a8
        jsr     Rand
        trb     za4_L         ; random character targets
        jsr     Rand
        trb     za4_H     ; random monster targets
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $09: dice/fixed dice ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::DICE
@4158:  stz     near w7e3414       ; disable damage modification
        lda     #$20
        tsb     $11a4       ; can't dodge
        lda     #$0f
        sta     zb6         ; disable 3rd die roll
        clr_a
        jsr     Rand
        pha
        and     #$0f
        ldx     #6
        jsr     Div
        stx     zb7
        inx
        stx     $ee         ; +$ee = die 1
        pla
        ldx     #$60
        jsr     Div
        txa
        and     #$f0
        ora     zb7
        sta     zb7         ; dice rolls (low/high nybble)
        lsr4
        inc
        xba
        lda     $ee
        jsr     MultAB
        sta     $ee         ; +$ee = die 1 * die 2
        lda     $11a8
        cmp     #$03
        bcc     @41ab       ; branch if only 2 dice
        clr_a
        lda     $021e       ; game time (frames)
        ldx     #6
        jsr     Div
        txa
        sta     zb6         ; set 3rd die roll (low nybble)
        inc
        xba
        lda     $ee
        jsr     MultAB
        sta     $ee         ; +$ee = die 1 * die 2 * die 3
@41ab:  ldx     #$00        ; bonus multiplier = 0
        lda     zb6
        asl4
        ora     zb6
        cmp     zb7
        bne     @41bb       ; branch unless all dice match (only if there are 3 dice)
        ldx     zb6         ; bonus multiplier = matching dice value
@41bb:  lda     $ee
        xba
        lda     $11af       ; level
        asl
        jsr     MultAB
        longa
        sta     $ee
@41c9:  clc
        sta     $11b0
        lda     $ee
        adc     $11b0
        bcc     @41d6
        clr_a
        dec
@41d6:  dex
        bpl     @41c9
        shorta
        lda     zb5
        cmp     #BATTLE_CMD::FIGHT
        bne     @41e3
        lda     #GFX_BATTLE_CMD::DICE_ROLL
@41e3:  sta     zb5
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $3d: revenge ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::REVENGE
@41e6:  stz     near w7e3414       ; disable damage modification
        longa
        sec
        lda     near wTargetProp2::MaxHP,y     ; damage = max hp - current hp
        sbc     near wTargetProp2::CurrHP,y
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $13: sonic dive ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::PALIDOR
@41f6:  .a8
        lda     #$10
        tsb     near w7e3a46       ; set $3a46.4
        longa
        ldx     #$12
@41ff:  lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS12, {PETRIFY, SLEEP}
        bne     @420f
        lda     near wTargetProp3::w7e3ef8,x
        bitflg  STATUS34, {STOP, HIDE, FROZEN}
        beq     @4216
@420f:  lda     near wTargetMask,x
        trb     za2
        trb     za4
@4216:  dex2
        bpl     @41ff
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $36: empowerer ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::EMPOWERER
@421b:  .a8
        lda     $11a3       ; toggle "affect mp" flag
        eor     #$80
        sta     $11a3
        bpl     @422a
        lda     #BATTLE_CMD::MIMIC
        sta     zb5
        rts
@422a:  inc     near w7e3a70       ; increment number of attacks
        lsr     $11a6       ; divide attack power by 4
        lsr     $11a6
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $16: spiraler ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::SPIRALER
@4234:  tyx
        lda     near wTargetMask,x
        trb     za2_L
        trb     za4_L
        tsb     near w7e2f4c
        jsr     _c2384a
        longa
        stz     near wTargetProp2::CurrHP,x     ; set hp and mp to zero
        stz     near wTargetProp2::CurrMP,x
_424a:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $44: discard ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::DISCARD
@424b:  .a8
        jsr     AttackerEffectMiss
        lda     #$20
        tsb     $11a4       ; can't dodge
        ldx     near wTargetProp1::SeizeTarget,y
        bmi     _424a       ; return if seize target is not valid
        lda     near wTargetMask,x
        sta     zb8_L         ; set target
        stz     zb8_H
        tyx
        jmp     InitGfxParams

; ------------------------------------------------------------------------------

; [ attacker special effect $15: mantra ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::MANTRA
@4263:  .a8
        lda     #$60
        tsb     $11a2
        stz     near w7e3414       ; disable damage modification
        longa
        lda     near wTargetMask,y
        trb     za4
        ldx     near w7e3eb0 + 25       ; number of targets - 1
        dex
        lda     near wTargetProp2::CurrHP,y     ; current hp
        jsr     Div
        sta     $11b0       ; damage
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $42: quarter damage ]

; unused

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::QUARTER_DMG
@4280:  longa
        lsr     $11b0       ; divide damage by 4
; fall through

; ------------------------------------------------------------------------------

; [ attacker special effect $41: halve damage ]

; unused

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::HALF_DMG
@4285:  longa
        lsr     $11b0       ; divide damage by 2
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $30: suplex ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::SUPLEX
@428b:  .a8
        lda     #$10
        tsb     zb0
        longa
        lda     za2
        sta     $ee
        ldx     #$0a
@4297:  lda     near wTargetProp2::_4::MonsterStatus,x
        bit     #MONSTER_STATUS::CANT_SUPLEX
        beq     @42a4       ; skip if target can be suplex'ed
        lda     near wTargetMask::_4,x
        trb     $ee         ; remove target
@42a4:  dex2
        bpl     @4297
        lda     $ee
        bne     @42ae
        lda     za2
@42ae:  jsr     RandBit
        sta     zb8
        tyx
        jmp     InitGfxParams

; ------------------------------------------------------------------------------

; [ attacker special effect $1c: reflect??? ]

; misses targets that do not have reflect status

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::REFLECT_LORE
@42b7:  longa
        ldx     #$12
@42bb:  lda     near wTargetProp3::w7e3ef8 - 1,x     ; check each character/monster's status 3
        bmi     @42c5       ; branch if it has reflect status
        lda     near wTargetMask,x
        trb     za4         ; clear target
@42c5:  dex2
        bpl     @42bb
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $43: quick ]

        array_label ATTACKER_EFFECT, ATTACK_SPECIAL_EFFECT::QUICK
        .a8
@42ca:  lda     near w7e3402                   ; quick counter
        bpl     @42d8                   ; branch if another target is already quick
        sty     near w7e3404                   ; set quick target
        lda     #2                      ; set quick counter to 2
        sta     near w7e3402
        rts

; make attack miss if another target is already quick
@42d8:  longa
        lda     near wTargetMask,y
        tsb     near w7e3a5a
        rts

; ------------------------------------------------------------------------------

; define labels for unused target effects
.repeat ATTACK_SPECIAL_EFFECT::COUNT, i
        .ifndef array_item ATTACKER_EFFECT, i
                array_item ATTACKER_EFFECT, {i} := AttackerEffectNone
        .endif
.endrep

; attacker special effect jump table
AttackerEffectTbl:
        ptr_tbl ATTACKER_EFFECT

; ------------------------------------------------------------------------------
