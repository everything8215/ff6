.include "src/text/attack_msg.inc"

; ------------------------------------------------------------------------------

.import DanceBG, BattleBGDance

.enum UMARO_ATTACK
        THROW
        STORM
        TACKLE
        FIGHT

        COUNT
.endenum

; ------------------------------------------------------------------------------

; [ execute command ]

ExecCmd:
; _dispatcher:
@13d3:  phx
        php
        jsr     InitGfxScript
        lda     #$10
        tsb     zb0         ; disable pre-magic swirly animation
        lda     #GFX_CMD::ATTACK_ANIM
        sta     zb4         ; battle script command $06 (show battle animation)
        stz     zbd         ; clear extra damage multiplier
        stz     near wWeaponSpellCast       ; disable random weapon spellcast
        stz     near w7e3eb0 + 25       ; clear number of targets
        stz     near w7e3a8e       ; disable dragon horn effect
        txy
        lda     #$ff        ; set lots of flags
        sta     zb2
        sta     zb3
        ldx     #$0f
@13f4:  sta     near w7e3410,x     ; clear some variables
        dex
        bpl     @13f4
        lda     zb5         ; command
        asl
        tax
        jsr     (near BattleCmdTbl,x)
        lda     #$ff
        sta     near w7e3417       ; clear character using sketch
        jsr     _c2629b       ; add battle script command to queue
        jsr     AfterAction1
        jsr     CheckRetal
        jsr     CheckDeadMonsters
        lda     #BTL_GFX::GFX_SCRIPT
        jsr     ExecBtlGfx
        jsr     UpdateDead
        jsr     _c2147a       ; update targets that are present
        jsr     AfterAction2
        jsr     _c2144f       ; update targets that are not present
        jsr     _c262c7       ; add obtained items to inventory
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ check dead monsters ]

CheckDeadMonsters:
@1429:  ldx     #$0a
@142b:  lda     near wTargetMask::_4 + 1,x     ; monster mask
        bit     near w7e3a3a
        beq     @144a       ; skip if monster is still alive
        xba
        lda     near wTargetProp3::_4::w7e3ef9,x     ; status 4
        bit     #STATUS4::HIDE
        bne     @1446       ; mark monster as dead if it has hide status
        lda     near wTargetProp2::_4::RetalFlags,x
        bmi     @1446       ; skip if piranha status $3e4c.7 RETAL_FLAGS::PIRANHA
        lda     near wTargetProp1::_4::w7e32cd,x     ; pointer to next pending counterattack
        inc
        bne     @144a       ; branch if there is a counterattack pending
@1446:  xba
        trb     near w7e2f2f       ; mark monster as dead
@144a:  dex2
        bpl     @142b
        rts

; ------------------------------------------------------------------------------

; [ update targets that are not present ]

_c2144f:
_timeenable2:
@144f:  php
        longa
        ldx     #$12
@1454:  lda     near wTargetMask,x     ; character/monster mask
        trb     near w7e2f4c       ; clear "can't be targetted" flag
        beq     @1474       ; skip if it wasn't set
        shorta
        xba
        trb     near w7e2f2f       ; clear "monster not dead" flag
        lda     #$fe
        jsr     ClearFlag0       ; clear $3aa0.0 (make target not present)
        lda     near wTargetProp3::w7e3ef9,x     ; set hide status
        ora     #STATUS4::HIDE
        sta     near wTargetProp3::w7e3ef9,x
        jsr     _c207c8
        longa
@1474:  dex2                ; next target
        bpl     @1454
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ update targets that are present ]

_c2147a:
_timeenable:
@147a:  php
        longa
        ldx     #$12
@147f:  lda     near wTargetMask,x     ; character/monster mask
        trb     near w7e2f4e       ; clear "can be targetted" flag
        beq     @14a7       ; skip if it wasn't set
        shorta
        xba
        tsb     near w7e2f2f       ; set "monster not dead" flag
        lda     #$01
        jsr     SetFlag0     ; set $3aa0.0 (make target present)
        lda     near wTargetProp3::w7e3ee4,x     ; status 1
        clrflg  STATUS1, {DEAD, PETRIFY, IMP, ZOMBIE}
        sta     near wTargetProp3::w7e3ee4,x
        lda     near wTargetProp3::w7e3ef9,x     ; status 4
        and     #<~STATUS4::HIDE
        sta     near wTargetProp3::w7e3ef9,x
        jsr     CheckFirstStrike
        longa
@14a7:  dex2                ; next character/monster
        bpl     @147f
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ update targets getting hit in the back ]

UpdateFacingDirection:
@14ad:  lda     $11a2
        lsr
        bcc     @1511       ; return if attack doesn't deal physical damage
        cpx     #$08
        bcs     @14e5       ; branch if attacker is a monster

; character attacker
        lda     near w7e201f
        cmp     #BATTLE_TYPE::SIDE
        bne     @1511       ; return if a side attack
        lda     near wTargetMask,x
        and     near w7e2f50
        sta     $ee
        ldy     #$0a
@14c8:  lda     $ee
        xba
        lda     near wTargetMask::_4 + 1,y
        bit     near w7e2f50 + 1
        beq     @14d8
        xba
        eor     near wTargetMask,x
        xba
@14d8:  xba
        bne     @14df
        xba
        tsb     near w7e3a54_H       ; monster getting hit in the back
@14df:  dey2
        bpl     @14c8
        bra     @1511

; monster attacker
@14e5:  lda     near w7e201f
        cmp     #BATTLE_TYPE::PINCER
        bne     @1511       ; return if a pincer attack
        lda     near wTargetMask + 1,x
        and     near w7e2f50 + 1
        sta     $ee
        ldy     #$06
@14f6:  lda     $ee
        xba
        lda     near wTargetMask,y
        bit     near w7e2f50
        beq     @1506
        xba
        eor     near wTargetMask + 1,x
        xba
@1506:  xba
        bne     @150d
        xba
        tsb     near w7e3a54_L       ; character getting hit in the back
@150d:  dey2
        bpl     @14f6
@1511:  rts

; ------------------------------------------------------------------------------

; [ double damage for spears (when using jump) ]

; A: item index

SpearEffect:
@1512:  cmp     #ITEM::MITHRIL_PIKE
        bcc     BattleCmdNoEffect
        cmp     #ITEM::IMPERIAL        ; imperial (after imp halberd)
        bcs     BattleCmdNoEffect
        lda     #$02
        sta     zbd         ; other damage multiplier
; fallthrough

; ------------------------------------------------------------------------------

; [ command with no effect ]

BattleCmdNoEffect:
        array_label ACTION_BATTLE_CMD, BATTLE_CMD::MIMIC
        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::RANDOM
        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::ACTION_BATTLE_CMD_40
        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::ACTION_BATTLE_CMD_49
        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::ACTION_BATTLE_CMD_50
        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::ACTION_BATTLE_CMD_51
@151e:  rts

; ------------------------------------------------------------------------------

; [ command $0d: sketch ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::SKETCH
@151f:  tyx
        jsr     _c2298a
        lda     #$ff
        sta     zb7
        lda     #$aa        ; special effect $55 (sketch)
        sta     $11a9
        jsr     ExecAttack
        ldy     near w7e3417       ; return if no character used sketch
        bmi     BattleCmdNoEffect
        stx     near w7e3417
        lda     near wTargetProp2::MonsterSpecialAnim,y
        sta     near wTargetProp2::MonsterSpecialAnim,x
        lda     near wTargetProp1::MonsterSpecialProp,y
        sta     near wTargetProp1::MonsterSpecialProp,x
        stz     near w7e3415
        lda     near w7e3400
        sta     zb6
        lda     #$ff
        sta     near w7e3400
        lda     #$01
        tsb     zb2

_c21554:
@1554:  lda     zb6
        jsr     GetCmdForAI
        sta     zb5         ; command
        asl
        tax
        jmp     (near BattleCmdTbl,x)

; ------------------------------------------------------------------------------

; [ command $10: rage ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::RAGE
@1560:  lda     near wTargetProp1::w7e33a8_L,y
        inc
        bne     @1579
        ldx     near w7e3a93
        cpx     #$14
        bcc     @156f
        ldx     #$00
@156f:  lda     near wTargetProp1::w7e33a8_L,x
        sta     near wTargetProp1::w7e33a8_L,y
        clr_a
        sta     near wTargetProp1::w7e33a8_H,y
@1579:  sty     near w7e3a93
        lda     near wTargetProp3::w7e3ef9,y
        ora     #STATUS4::RAGE
        sta     near wTargetProp3::w7e3ef9,y
        jsr     SetRage
        tyx
        jsr     FixImmuneStatus
        jsr     _c21554
        jmp     UpdateImmuneStatus

; ------------------------------------------------------------------------------

; [ command $05: steal ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::STEAL
@1591:  tyx
        jsr     _c2298a
        lda     #$a4        ; special effect $52 (steal)
        sta     $11a9
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $0a: blitz ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::BLITZ
@159d:  lda     zb6
        bpl     @15b0
        lda     #$01
        trb     zb3
        lda     #ATTACK_MSG::BLITZ_FAIL
        sta     near w7e3401
        lda     #ATTACK::FIRST_BLITZ
        sta     zb6
        bra     @15b5
@15b0:  lda     #$08                    ; attack name type = 2 (blitz)
        sta     near w7e3412
@15b5:  lda     zb6
        pha
        sec
        sbc     #ATTACK::FIRST_BLITZ
        sta     zb6
        pla
        tyx
        jsr     InitCmdTarget
        jsr     InitAttacker
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $00: fight ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::FIGHT
@15c8:  cpy     #$08
        bcs     _1610
        lda     near w7e3a3e_H
        cmp     #$03
        bcc     _1610
        lda     near wTargetProp3::w7e3ee5,y
        bit     #STATUS2::NEAR_FATAL
        beq     _1610
        bitflg  STATUS2, {CONFUSE, IMAGE}
        bne     _1610
        lda     near wTargetProp3::w7e3ee4,y
        bitflg  STATUS1, {VANISH, ZOMBIE}
        bne     _1610
        lda     zb8_H
        beq     _1610
        jsr     Rand
        and     #$0f
        bne     _1610
        lda     near wTargetMask,y
        tsb     near w7e3f2f
        bne     _1610
        lda     near w7e3ed8,y                 ; calculate desperation attack id
        cmp     #CHAR_PROP::GOGO
        beq     @1604
        cmp     #CHAR_PROP::GAU
        bcs     _1610
        inc
@1604:  dec
        ora     #ATTACK::FIRST_DESPERATION
        sta     zb6
        lda     #$10
        trb     zb0
        jmp     DesperationAttack

; ------------------------------------------------------------------------------

; [ command $06: capture ]

; normal fight attack enters here
        array_label ACTION_BATTLE_CMD, BATTLE_CMD::CAPTURE
_1610:  cpy     #$08
        bcs     FightAttack
        lda     near w7e3ed8,y
        cmp     #CHAR_PROP::UMARO
        beq     _163b                   ; branch if Umaro

        array_label UMARO_ATTACK, UMARO_ATTACK::FIGHT
FightAttack:
_161b:  tyx
        lda     near wTargetProp2::RelicEffect4,x  ; RELIC_EFFECT4::X_FIGHT
        lsr
        lda     #1                      ; 1 attack
        bcc     @1626
        lda     #7                      ; 7 attacks
@1626:  sta     near w7e3a70
        jsr     CheckTargetsPresent
        jsr     _c23865
        lda     #$02
        trb     zb2
        lda     zb5
        sta     near w7e3413
        jmp     ExecAttack

; choose umaro's attack
_163b:  stz     $fe
        lda     #ITEM::RAGE_RING
        cmp     near wTargetProp2::Relics_L,y
        beq     @1649
        cmp     near wTargetProp2::Relics_H,y
        bne     @1656
@1649:  clr_a
        lda     near wTargetMask,y
        eor     near w7e3a74_L
        beq     @1656
        lda     #$04
        tsb     $fe
@1656:  lda     #ITEM::BLIZZARD_ORB
        cmp     near wTargetProp2::Relics_L,y
        beq     @1662
        cmp     near wTargetProp2::Relics_H,y
        bne     @1666
@1662:  lda     #$08
        tsb     $fe
@1666:  lda     $fe
        tax
        ora     #$30
        asl2
        jsr     RandBitWithRate
        txa
        asl
        tax
        jmp     (near UmaroAttackTbl,x)

; ------------------------------------------------------------------------------

UmaroAttackTbl:
        ptr_tbl UMARO_ATTACK

; ------------------------------------------------------------------------------

; [ umaro's charge/tackle attack ]

        array_label UMARO_ATTACK, UMARO_ATTACK::TACKLE
@167e:  tyx
        jsr     InitUmaroAttack
        lda     #$20
        tsb     $11a2
        lda     #$02
        trb     zb2
        lda     #GFX_BATTLE_CMD::UMARO_TACKLE
        sta     zb5
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ umaro's throw attack ]

        array_label UMARO_ATTACK, UMARO_ATTACK::THROW
@1692:  tyx
        jsr     InitUmaroAttack
        lda     near wTargetMask,x
        eor     near w7e3a74_L
        ldx     #$06
@169e:  bit     near wTargetMask,x
        beq     @16bf
        xba
        lda     near wTargetProp3::w7e3ef9,x
        bit     #STATUS4::HIDE
        beq     @16b2
        xba
        eor     near wTargetMask,x
        xba
        bra     @16be
@16b2:  lda     near wTargetProp3::w7e3ee5,x
        bitflg  STATUS2, {SLEEP, CONFUSE}
        beq     @16be
        xba
        lda     near wTargetMask,x
        xba
@16be:  xba
@16bf:  dex2
        bpl     @169e
        pha
        clr_a
        pla
        beq     array_item UMARO_ATTACK, UMARO_ATTACK::TACKLE
        jsr     RandBit
        jsr     BitToTargetID
        tyx
        lda     near w7e3ed8,x
        cmp     #CHAR_PROP::MOG
        bne     @16da
        lda     #$02                    ; auto-crit if throwing mog
        trb     zb3
@16da:  lda     near wTargetProp2::RHandAttackPower,x
        adc     near wTargetProp2::LHandAttackPower,x
        bcc     @16e4
        lda     #$fe
@16e4:  adc     $11a6
        bcc     @16eb
        lda     #$ff
@16eb:  sta     $11a6
        lda     #GFX_BATTLE_CMD::UMARO_THROW
        sta     zb5
        lda     #$20
        tsb     $11a2
        lda     #$02
        trb     zb2
        lda     #$01
        tsb     zba
        lda     near wTargetProp3::w7e3ee5,x
        andflg  STATUS2, {SLEEP, CONFUSE}
        ora     near wTargetProp2::w7e3dfd,x
        sta     near wTargetProp2::w7e3dfd,x
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ umaro's storm attack ]

        array_label UMARO_ATTACK, UMARO_ATTACK::STORM
@170d:  stz     near w7e3415
        lda     #ATTACK::STORM
        sta     zb6
; fallthrough

; ------------------------------------------------------------------------------

; [ character desperation attack ]

DesperationAttack:
@1714:  lda     #BATTLE_CMD::MAGIC
        sta     zb5
        bra     _175f

; ------------------------------------------------------------------------------

; [ command $1b: shock ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::SHOCK
@171a:  lda     #ATTACK::SHOCK
        bra     _1720

; ------------------------------------------------------------------------------

; [ command $1a: health ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::HEALTH
@171e:  lda     #ATTACK::CURA
_1720:  sta     zb6
        lda     #$05        ; attack name type = 5 (command)
        bra     _1765

; ------------------------------------------------------------------------------

; [ command $0f: slot ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::SLOT
@1726:  lda     #$10
        trb     zb0
        lda     zb6
        cmp     #ATTACK::L5_DOOM
        bne     @1734
        lda     #$07        ; attack name type = 7 (joker doom [slot])
        bra     _1765
@1734:  cmp     #ATTACK::FIRST_NINJA
        bcc     array_item ACTION_BATTLE_CMD, BATTLE_CMD::SUMMON
        cmp     #ATTACK::LAGOMORPH
        bne     array_item ACTION_BATTLE_CMD, BATTLE_CMD::MAGIC
        lda     #ATTACK_MSG::SLOT_FAIL
        sta     near w7e3401

; ------------------------------------------------------------------------------

; [ command $02/$17: magic/x-magic ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::MAGIC
        array_label ACTION_BATTLE_CMD, BATTLE_CMD::X_MAGIC
@1741:  cpy     #$08
        bcs     _175f
        lda     near w7e3ed8,y
        cmp     #CHAR_PROP::TERRA
        bne     _175f
        lda     #$02
        trb     near w7e3eb0 + 12
        beq     _175f
        ldx     #BATTLE_EVENT_SCRIPT::TERRA_MAGIC
        lda     #ACTION_BATTLE_CMD::BATTLE_EVENT
        jsr     CreateImmediateAction
        lda     #$20
        tsb     $11a4

; ------------------------------------------------------------------------------

; [ command $0c/$1d: lore/magitek ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::LORE
        array_label ACTION_BATTLE_CMD, BATTLE_CMD::MAGITEK
; _actbluemagic0:
_175f:  lda     #$00        ; attack name type = 0 (normal)
        bra     _1765

; ------------------------------------------------------------------------------

; [ command $19: summon ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::SUMMON
@1763:  lda     #$02        ; attack name type = 2 (esper)

magic_atmk:
_1765:  sta     near w7e3412
        tyx
        lda     zb6
        jsr     InitCmdTarget
        jsr     InitAttacker
        lda     zb5
        cmp     #BATTLE_CMD::SLOT
        bne     @177a       ; branch if not slot (magicite)
        stz     $11a5       ; for slot espers, set mp cost to zero
@177a:  jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $13: dance ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::DANCE
@177d:  lda     near wTargetProp3::w7e3ef8,y     ; set dance status
        ora     #STATUS3::DANCE
        sta     near wTargetProp3::w7e3ef8,y
        lda     #$ff        ; no background change
        sta     zb7
        lda     near wTargetProp1::w7e32e1,y
        bpl     @1794       ; branch if valid
        lda     near w7e3a6f       ; default dance battle background
        sta     near wTargetProp1::w7e32e1,y
@1794:  ldx     $11e2       ; current battle background
        cmp     f:BattleBGDance,x   ; dance for current background
        beq     array_item ACTION_BATTLE_CMD, BATTLE_CMD::MAGIC      ; branch if dance matches
        jsr     RandCarry
        bcc     @17af       ; 50% chance to branch
        tax
        lda     f:DanceBG,x   ; change battle background
        sta     zb7
        sta     $11e2
        jmp     array_item ACTION_BATTLE_CMD, BATTLE_CMD::MAGIC
@17af:  lda     near wTargetProp3::w7e3ef8,y     ; clear dance status
        and     #<~STATUS3::DANCE
        sta     near wTargetProp3::w7e3ef8,y
        tyx
        lda     #ATTACK_MSG::DANCE_FAIL
        sta     near w7e3401
        lda     #GFX_BATTLE_CMD::CHANGE_BATTLE
        sta     zb5
        jsr     _c2298d
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ init umaro's attack power ]

InitUmaroAttack:
@17c7:  jsr     _c2298a
        clc
        lda     near wTargetProp2::RHandAttackPower,x
        adc     near wTargetProp2::LHandAttackPower,x
        bcc     @17d5
        lda     #$ff
@17d5:  sta     $11a6
        lda     near wTargetProp2::Level,x     ; level
        sta     $11af
        lda     near wTargetProp2::Strength,x     ; vigor * 2
        sta     $11ae       ; hit rate
        rts

; ------------------------------------------------------------------------------

; [ command $1c: possess ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::POSSESS
@17e5:  tyx
        jsr     InitCmdTarget
        lda     #$20
        tsb     $11a4
        lda     #$a0        ; special effect $50 (possess)
        sta     $11a9
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $16: jump ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::JUMP
@17f6:  tyx
        jsr     InitCmdTarget
        lda     near wTargetProp2::LHandAttackPower,x
        beq     @1808
        sec
        lda     near wTargetProp2::RHandAttackPower,x
        beq     @1808
        jsr     RandCarry
@1808:  jsr     _c2299f
        lda     #$20
        sta     $11a4
        tsb     zb3
        inc     zbd
        lda     near wTargetProp2::RHandItem,x
        jsr     SpearEffect
        lda     near wTargetProp2::LHandItem,x
        jsr     SpearEffect
        lda     near wTargetProp2::RelicEffect1,x  ; RELIC_EFFECT1::DRAGON_HORN
        bpl     @183c       ; branch if no dragon horn
        dec     near w7e3a8e       ; enable dragon horn effect
        jsr     Rand
        inc     near w7e3a70
        cmp     #$40
        bcs     @183c
        inc     near w7e3a70
        cmp     #$10
        bcs     @183c
        inc     near w7e3a70
@183c:  lda     near wTargetProp3::w7e3ef9,x
        and     #<~STATUS4::HIDE
        sta     near wTargetProp3::w7e3ef9,x
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $07: swdtech ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::BUSHIDO
@1847:  tyx
        lda     zb6
        pha
        sec
        sbc     #ATTACK::FIRST_BUSHIDO
        sta     zb6
        pla
        jsr     InitCmdTarget
        jsr     InitAttacker
        lda     zb6
        cmp     #$01
        bne     @187d       ; branch if not retort
        lda     near wTargetProp2::RetalFlags,x     ; toggle $3e4c.0 (retort)
        eor     #RETAL_FLAGS::RETORT
        sta     near wTargetProp2::RetalFlags,x
        lsr
        bcc     @1879
        ror     zb6
        stz     $11a6
        lda     #$20
        tsb     $11a4
        lda     #$01
        trb     $11a2
        bra     @1882
@1879:  lda     #$10
        trb     zb0
@187d:  lda     #$04                    ; attack name type = 4 (bushido)
        sta     near w7e3412
@1882:  jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $09: tools ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::TOOLS
@1885:  lda     zb6
        sbc     #ITEM::FIRST_TOOL - 1
        sta     zb6
        bra     _189e

; ------------------------------------------------------------------------------

; [ command $08: throw ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::THROW
@188d:  lda     #$02
        sta     zbd
        lda     #$10
        trb     zb3
        bra     _189e

; ------------------------------------------------------------------------------

; [ command $01: item ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::ITEM
@1897:  stz     near w7e3414       ; disable damage modification
        lda     #$80
        trb     zb3
_189e:  tyx
        lda     #$01                    ; attack name type = 1 (item)
        sta     near w7e3412
        lda     near w7e3a7d
        jsr     InitCmdTarget
        lda     #$10
        trb     zb1
        bne     @18b5
        lda     #$ff
        sta     near wTargetProp1::w7e32f4,x
@18b5:  lda     near wTargetMask,x
        tsb     near w7e3a8c
        lda     zb5
        bcc     @18e3       ; carry was set or cleared in $26d3 subroutine

; items that do not use a spell
        cmp     #$02
        lda     near w7e3411
        jsr     CalcItemEffect
        lda     $11aa
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @18e0
        longa
        lda     near w7e3a74
        ora     near w7e3a42         ; enemy characters that are alive
        and     zb8
        sta     zb8
        shorta
        lda     #$04
        trb     zb3
@18e0:  jmp     ExecAttack

; items that use a spell (bio blaster/flash, rods, shields, water/fire/bolt edge)
@18e3:  cmp     #BATTLE_CMD::ITEM
        bne     @18ee
        inc     zb5
        lda     near w7e3410
        sta     zb6
@18ee:  stz     zbd
        jsr     InitAttacker
        lda     #$02
        tsb     $11a3
        lda     #$20
        tsb     $11a4
        lda     #$08
        trb     zba
        stz     $11a5
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $18: gp rain ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::GP_RAIN
@1907:  tyx
        jsr     _c2298a
        inc     $11a6
        lda     #$60
        tsb     $11a2
        stz     near w7e3414                 ; disable damage modification
        cpx     #$08
        bcc     @191f
        lda     #$05                    ; attack name type = 5 (command)
        sta     near w7e3412
@191f:  lda     #$a2                    ; special effect $51 (gp rain)
        sta     $11a9
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $04: revert ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::REVERT
@1927:  lda     near wTargetProp3::w7e3ef9,y
        bit     #STATUS4::MORPH
        bne     _1937

_c2192e:
@192e:  tya
        lsr
        xba
        lda     #GFX_CMD::RESET_CHAR_ACTION
        jmp     _c262bf                 ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $03: morph ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::MORPH
@1936:  sec
_1937:  php
        tyx
        jsr     _c2298a
        plp
        lda     #STATUS4::MORPH
        sta     $11ad
        bcc     @1945
        clr_a
@1945:  lsr
        tsb     $11a4
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $14: row ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::ROW
@194c:  tyx
        lda     near wTargetProp2::w7e3aa1,x     ; toggle battle row
        eor     #$20
        sta     near wTargetProp2::w7e3aa1,x
        jsr     _c2298a
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $0b: runic ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::RUNIC
@195b:  tyx
        lda     near wTargetProp2::RetalFlags,x     ; set $3e4c.2 (runic)
        ora     #RETAL_FLAGS::RUNIC
        sta     near wTargetProp2::RetalFlags,x
        jsr     _c2298a
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $15: def. ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::DEF
@196a:  tyx
        lda     #$02
        jsr     SetFlag1       ; set $3aa1.1
        jsr     _c2298a
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $0e: control ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::CONTROL
@1976:  lda     near wTargetProp3::w7e3ef9,y
        bit     #STATUS4::CONTROL
        beq     @1987
        jsr     _c2192e
        lda     near wTargetProp1::ControlTarget,y
        tay
        jmp     _c21554
@1987:  tyx
        jsr     _c2298a
        lda     #$a6
        sta     $11a9       ; special effect $53 (control)
        lda     #$01
        trb     $11a2
        lda     #$20
        tsb     $11a4
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $11: leap ]

        array_label ACTION_BATTLE_CMD, BATTLE_CMD::LEAP
@199d:  tyx
        jsr     _c2298a
        lda     #$a8        ; special effect $54 (leap)
        sta     $11a9
        lda     #$01
        trb     $11a2
        lda     #TARGET::ENEMY
        sta     zbb
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $1e: roulette ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::ROULETTE
@19b2:  lda     #BATTLE_CMD::LORE
        sta     zb5
        jsr     _175f
        lda     #GFX_BATTLE_CMD::ROULETTE
        xba
        lda     #GFX_CMD::ATTACK_ANIM
        jmp     _c262bf                 ; add battle script command to queue

; ------------------------------------------------------------------------------

; [  ]

InitCmdTarget:
@19c1:  xba
        lda     zb5
        jmp     InitTarget

; ------------------------------------------------------------------------------

; command jump table
BattleCmdTbl:
        ptr_tbl ACTION_BATTLE_CMD

; ------------------------------------------------------------------------------
