; ------------------------------------------------------------------------------

; [ execute counterattack ]

ExecRetal:
@4b7b:  sec
        ror     near w7e3407       ; set $3407 msb
        lda     #$01        ; set counterattack flag
        tsb     zb1
        pea     BattleLoop-1       ; push return address (start of main code loop)
@4b86:  lda     near wTargetProp1::w7e32cd,x
        bmi     @4bf3       ; return if counterattack command list pointer is invalid
        asl
        tay
        jsr     InitPlayerAction

; check for random attack
        cmp     #ACTION_BATTLE_CMD::RANDOM
        bne     @4b9c       ; branch if not command $1f (random attack)
        jsr     RemoveRetal
        jsr     ExecAIRetal
        bra     @4b86

@4b9c:  lda     near wTargetProp1::w7e32cd,x     ; command list pointer
        tay
        lda     near w7e3184,y     ; command list
        cmp     near wTargetProp1::w7e32cd,x
        bne     @4baa       ; branch if character/monster has more than one action pending
        lda     #$ff
@4baa:  sta     near wTargetProp1::w7e32cd,x     ; set new command list pointer
        lda     #$ff
        sta     near w7e3184,y     ; clear old command list slot
        lda     zb5
        cmp     #$1e
        bcs     @4bd5       ; branch if command >= $1e
        cpx     #$08
        bcs     @4bd5       ; branch if a monster
        lda     near wTargetMask,x
        bit     near w7e3a39
        bne     @4be3       ; branch if character has been sneezed away
        bit     near w7e3a40
        bne     @4bd5       ; branch if character is an enemy
        lda     near w7e3a77
        beq     @4be3       ; branch if no enemies are still alive
        lda     near wTargetProp2::w7e3aa0,x
        bit     #$50
        bne     @4be3       ; branch if $3aa0.4 or $3aa0.6 are set (atb gauge needs to be updated ???)
@4bd5:  lda     near wTargetProp1::w7e3204,x
        ora     #$04
        sta     near wTargetProp1::w7e3204,x
        jsr     ExecCmd
        jsr     SaveMimicAction
@4be3:  lda     near wTargetProp1::w7e32cd,x
        inc
        bne     @4bf0       ; branch if command list pointer is still valid (more pending counterattacks)
        lda     zb0
        bmi     @4bf3       ;
        jmp     EndAction

; attacker still has more pending retaliations to be executed
@4bf0:  stx     near w7e3407       ; set currently counterattacking character/monster
@4bf3:  rts

; ------------------------------------------------------------------------------

; [ ai counterattack ]

ExecAIRetal:
@4bf4:  php
        longa
        stz     near w7e3a98                   ; clear "unresponsive" indicator
        lda     near wTargetMask,x
        trb     near w7e33fc
        beq     @4c52           ; return if already had a chance to retaliate
        trb     near w7e3a56
        bne     @4c28           ; deathrattle attack skips status checks
        lda     near w7e3403
        bmi     @4c11       ; branch if quick target is invalid
        cpx     near w7e3404
        bne     @4c30           ; branch if this target is quick

; check if unresponsive
@4c11:  lda     near wTargetProp2::RetalStatus12,x
        bitflg  STATUS12, {SLEEP, CONFUSE, BERSERK}
        bne     @4c30
        lda     near wTargetProp2::RetalStatus34,x
        bitflg  STATUS34, {FROZEN, STOP}
        bne     @4c30
        lda     near wTargetProp1::CharmTarget,x
        bpl     @4c30                   ; branch if charmed
        bra     @4c33                   ; allow any conditionals

; this target died, check if it was self-targeted
@4c28:  lda     near wTargetMask,x
        tsb     near w7e33fe
        beq     @4c11                   ; branch if not self-target

; set unresponsive conditional indicator if asleep, confused, berserk, frozen,
; stopped, charmed, quick, or died and targeted itself (only allow retaliations
; if the conditional block includes if_self_dead, if_monsters_dead of if_always)
@4c30:  dec     near w7e3a98

@4c33:  lda     near wTargetProp1::w7e3268,x     ; start of counterattack ai script
        sta     $f0
        lda     near wTargetProp2::w7e3d20,x     ; ai script loop address (counterattack)
        sta     $f2
        lda     near wTargetProp1::w7e3241,x     ; ai loop counter
        sta     $f4
        clc
        jsr     ExecAI
        lda     $f2
        sta     near wTargetProp2::w7e3d20,x     ; update ai script loop address (counterattack)
        shorta
        lda     $f5
        sta     near wTargetProp1::w7e3241,x     ; update ai loop counter
@4c52:  plp
        rts

; ------------------------------------------------------------------------------

; [ remove next pending counterattack from command list ]

RemoveRetal:
@4c54:  phx
        inx                 ; x points to $32cd instead of $32cc
        jsr     RemoveAction
        plx
        rts

; ------------------------------------------------------------------------------

; [ check for counterattacks ]

CheckRetal:
@4c5b:  ldx     #$12                    ; loop through all targets
@4c5d:  lda     near wTargetProp2::w7e3aa0,x                 ; $3aa0.0 skip if target is not present
        lsr
        bcc     @4cbe
        lda     near w7e341a                   ; skip if counterattacks are disabled
        beq     @4cbe
        stz     zb8_L                     ; clear targets
        stz     zb8_H
        lda     near wTargetProp1::w7e32e0,x                 ; last character/monster that targetted this target
        bpl     @4c86                   ; branch if not waiting to retaliate
        asl
        sta     $ee
        cpx     $ee
        beq     @4c86                   ; branch if targeting self
        tay
        longa
        lda     near wTargetMask,y
        sta     zb8                     ; set retaliation target
        lda     near wTargetMask,x
        trb     near w7e33fe                   ; set retaliation attacker
@4c86:  longa
        lda     near wTargetMask,x
        bit     near w7e3a56
        shorta
        bne     @4c9d                   ; branch if died
        lda     zb1                     ; counterattack flag
        lsr
        bcs     @4cbe                   ; skip if a counterattack (can't counter a counter)
        lda     zb8_L
        ora     zb8_H
        beq     @4cbe                   ; branch if there are no retaliation targets
@4c9d:  lda     near wTargetProp1::w7e3268_H,x                 ; pointer to ai counterattack script
        bmi     @4cb1
        lda     near wTargetProp1::w7e32cd,x                 ; counter queue pointer
        bpl     @4cb1                   ; branch if waiting to execute a counter already
        lda     #ACTION_BATTLE_CMD::RANDOM
        sta     near w7e3a7a
        jsr     CreateRetalAction
        bra     @4cbe
@4cb1:  cpx     #$08
        bcs     @4cbe                   ; skip if a monster
        lda     $11a2                   ;
        lsr
        bcc     @4cbe
        jsr     @4cc3
@4cbe:  dex2                            ; next character/monster
        bpl     @4c5d
@4cc2:  rts

; check retort and black belt
@4cc3:  lda     near wTargetProp2::RetalFlags,x  ; RETAL_FLAGS::RETORT
        lsr
        bcc     @4cd6
        lda     #BATTLE_CMD::BUSHIDO
        sta     near w7e3a7a
        lda     #ATTACK::RETORT
        sta     near w7e3a7b
        jmp     CreateRetalAction
@4cd6:  lda     zb8_H                     ; return if attacker was a character
        beq     @4cc2
        cpx     near w7e3416                   ; branch if target is not protected by interceptor
        bne     @4cf4
        jsr     Rand
        lsr
        bcc     @4cf4
        lsr
        clr_a
        adc     #ATTACK::FIRST_INTERCEPTOR
        sta     near w7e3a7b
        lda     #BATTLE_CMD::MAGIC
        sta     near w7e3a7a
        jmp     CreateRetalAction
@4cf4:  lda     near wTargetMask,x                 ; return if not a black belt target
        bit     near w7e3419
        bne     @4cc2
        lda     near wTargetProp2::RelicEffect4,x                 ; return if black belt not equipped
        bit     #RELIC_EFFECT4::RAND_RETAL
        beq     @4cc2
        jsr     Rand
        cmp     #$c0
        bcs     @4cc2                   ; 3/4 chance to return
        txy
        peaflg  STATUS12, {DEAD, PETRIFY, MAGITEK, ZOMBIE, SLEEP, CONFUSE}
        peaflg  STATUS34, {DANCE, STOP, FROZEN, CONTROL, HIDE}
        jsr     CheckStatus
        bcc     @4cc2                   ; return if any are set
        stz     near w7e3a7a                   ; clear command and attack
        stz     near w7e3a7b
        jmp     CreateRetalAction

; ------------------------------------------------------------------------------

; [ create pending user actions ]

.proc GetPlayerActions

        ldy     near w7e3a6a                   ; pointer to pending user action queue
        lda     near wPlayerActionBuf::CharSlot,y
        bmi     Done                    ; return if no action pending
        asl
        tax
        jsr     _c24e66                 ; add action to advance wait queue
        lda     #$7b                    ; should this be #$7d to skip advance wait ???
        jsr     ClearFlag0              ; clear $3aa0.2 and $3aa0.7 (ogre nix can break, battle menu can't open)
        lda     #$ff
        sta     near wPlayerActionBuf::CharSlot,y
        tya
        adc     #$08                    ; loop through 4 characters
        and     #$18
        sta     near w7e3a6a
        jsr     GetPlayerActionTargets
        lda     near wPlayerActionBuf::Attack,y
        xba
        lda     near wPlayerActionBuf::BattleCmd,y
        jsr     FixPlayerAttack
        jsr     FixPlayerCmd
        jsr     CreateNormalAction
        lda     near wPlayerActionBuf::BattleCmd,y
        cmp     #BATTLE_CMD::X_MAGIC
        bne     GetPlayerActions        ; go to next queue slot if not x-magic

; second attack for x-magic
        iny3                            ; get secondary attack
        jsr     GetPlayerActionTargets
        lda     near wPlayerActionBuf::Attack,y
        xba
        lda     #BATTLE_CMD::X_MAGIC
        jsr     FixPlayerCmd
        jsr     CreateNormalAction
        bra     GetPlayerActions        ; go to next queue slot

Done:   rts

.endproc  ; GetPlayerActions

; ------------------------------------------------------------------------------

; [ get targets for player action ]

GetPlayerActionTargets:
@4d6d:  php
        longa
        lda     near wPlayerActionBuf::Targets,y
        sta     zb8
        plp
        rts

; ------------------------------------------------------------------------------

; [ fix command ]

FixPlayerCmd:
@4d77:  php
        longa
        sta     near w7e3a7a       ; set command index
        lda     near wTargetProp3::w7e3ee4,x     ; status 1 and 2
        bitflg  STATUS12, {CONFUSE, ZOMBIE}
        beq     @4d87
        stz     zb8         ; clear targets
@4d87:  plp
        rts

; ------------------------------------------------------------------------------

; [ fix attack index ]

FixPlayerAttack:
@4d89:  .a8
        phx
        phy
        txy
        cmp     #BATTLE_CMD::X_MAGIC
        bne     @4d92       ; branch if not x-magic
        lda     #BATTLE_CMD::MAGIC
@4d92:  cmp     #BATTLE_CMD::SUMMON
        bne     @4da7       ; branch if not summon
        pha
        xba
        cmp     #$ff
        bne     @4d9f
        lda     near wTargetProp1::w7e3344,y ; equipped esper
@4d9f:  xba
        lda     near wTargetMask,y
        tsb     near w7e3f2e
        pla
@4da7:  cmp     #BATTLE_CMD::ITEM
        beq     @4daf       ; branch if item
        cmp     #BATTLE_CMD::THROW
        bne     @4db4       ; branch if not throw
@4daf:  xba
        sta     near wTargetProp1::w7e32f4,y
        xba
@4db4:  cmp     #BATTLE_CMD::SLOT
        bne     @4ddb       ; branch if not slot
        pha
        xba
        tax
        lda     f:SlotAttackTbl,x   ; slot spell numbers
        cpx     #$02
        bcs     @4dd2       ; branch if not joker doom
        pha
        lda     f:JokerTargetTbl,x
        sta     zb8,x
        lda     zb8_L
        eor     near w7e3a40
        sta     zb8_L
        pla
@4dd2:  cmp     #$ff
        bne     @4dd9       ; branch if not esper
        jsr     RandGenju
@4dd9:  xba
        pla
@4ddb:  cmp     #BATTLE_CMD::DANCE
        bne     @4dec       ; branch if not dance
        pha
        xba
        sta     near wTargetProp1::w7e32e1,y
        sta     near w7e3a6f
        jsr     RandDance
        xba
        pla
@4dec:  cmp     #BATTLE_CMD::RAGE
        bne     @4dfa       ; branch if not rage
        pha
        xba
        sta     near wTargetProp1::w7e33a8_L,y
        jsr     RandRage
        xba
        pla
@4dfa:  cmp     #BATTLE_CMD::BLITZ
        bne     @4e13       ; branch if not blitz
        pha
        xba
        pha
        bmi     @4e10
        tax
        jsr     _c21e57
        bit     $1d28
        bne     @4e10
        lda     #$ff
        sta     1,s
@4e10:  pla
        xba
        pla
@4e13:  ldx     #sizeof_CmdWithAttackTbl - 1
@4e15:  cmp     f:CmdWithAttackTbl,x
        bne     @4e26
        xba
        clc
        adc     f:CmdAttackOffsetTbl,x  ; add attack offset
        bcc     @4e25
        lda     #ATTACK::BATTLE
@4e25:  xba
@4e26:  dex                 ; check next command
        bpl     @4e15
        pha
        clc
        jsr     GetBitPtr
        and     f:RetargetCmdTbl,x   ; commands that need to retarget
        beq     @4e38       ; branch if no retarget
        stz     zb8_L         ; clear targets
        stz     zb8_H
@4e38:  pla
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; commands with attack numbers (summon, lore, magitek, blitz, swdtech)
CmdWithAttackTbl:
        .byte   BATTLE_CMD::SUMMON
        .byte   BATTLE_CMD::LORE
        .byte   BATTLE_CMD::MAGITEK
        .byte   BATTLE_CMD::BLITZ
        .byte   BATTLE_CMD::BUSHIDO
        calc_size CmdWithAttackTbl

; attack offset for above commands
CmdAttackOffsetTbl:
        .byte   ATTACK::FIRST_GENJU
        .byte   ATTACK::FIRST_LORE
        .byte   ATTACK::FIRST_MAGITEK
        .byte   ATTACK::FIRST_BLITZ
        .byte   ATTACK::FIRST_BUSHIDO

; bitmask of commands that need to retarget (swdtech, blitz, rage, leap, dance)
RetargetCmdTbl:
        bitlist 30
        bitlist_set BATTLE_CMD::BUSHIDO
        bitlist_set BATTLE_CMD::BLITZ
        bitlist_set BATTLE_CMD::RAGE
        bitlist_set BATTLE_CMD::LEAP
        bitlist_set BATTLE_CMD::DANCE
        end_bitlist

; slot spell numbers ($ff is esper)
SlotAttackTbl:
        .byte   ATTACK::L5_DOOM
        .byte   ATTACK::L5_DOOM
        .byte   ATTACK::BAHAMUT
        .byte   ATTACK::NONE
        .byte   ATTACK::H_BOMB
        .byte   ATTACK::CHOCOBOP
        .byte   ATTACK::SEVEN_FLUSH
        .byte   ATTACK::LAGOMORPH

; joker doom targetting (all characters or all monsters)
JokerTargetTbl:
@4e52:  .byte   $0f,$3f

; ------------------------------------------------------------------------------

; [ add to action queue ]

; A: pointer to command list (out)

AddToQueue:
@4e54:  phx
        ldx     #$7f
@4e57:  lda     near w7e3184,x     ; command list
        bmi     @4e60
        dex
        bpl     @4e57       ; look for the first empty slot
        inx
@4e60:  txa
        sta     near w7e3184,x     ; set pointer to command list
        plx
        rts

; ------------------------------------------------------------------------------

; [ add action to advance wait queue ]

_c24e66:
_circleinputwrite:
@4e66:  txa
        phx
        ldx     near w7e3a65       ; advance wait queue end
        sta     near w7e3720,x     ; add action
        plx
        inc     near w7e3a65       ; increment advance wait queue end
        lda     #$fe
        jmp     ClearFlag1       ; clear $3aa1.0

; ------------------------------------------------------------------------------

; [ add action to action queue ]

_c24e77:
_circleactionwrite:
@4e77:  txa
        phx
        ldx     near w7e3a67
        sta     near w7e3820,x
        plx
        inc     near w7e3a67
        rts

; ------------------------------------------------------------------------------

; [ add action to counterattack queue ]

; X: character/monster number

_c24e84:
_circlereactionwrite:
@4e84:  txa
        phx
        ldx     near w7e3a69       ; counterattack queue end
        sta     near w7e3920,x     ; add counterattack action
        plx
        inc     near w7e3a69       ; increment counterattack queue end
        rts

; ------------------------------------------------------------------------------

; [ create immediate action ]

;   A: command index
;   X: attack index
; $b8: spell index

CreateImmediateAction:
@4e91:  phy
        php
        shorta
        sta     near w7e3a7a       ; command
        stx     near w7e3a7b       ; attack
        jsr     AddToQueue
        pha
        lda     near w7e340a       ; branch if there's already an immediate action
        cmp     #$ff
        bne     CreateAction
        lda     1,s       ; set immediate action
        sta     near w7e340a
        bra     CreateAction

; ------------------------------------------------------------------------------

; [ create action (normal or retaliation based on flag) ]

CreateDefaultAction:
@4ead:  lda     zb1         ; counterattack flag
        lsr
        bcc     CreateNormalAction
; fall through

; ------------------------------------------------------------------------------

; [ create counterattack action ]

CreateRetalAction:
@4eb2:  phy
        php
        shorta
        jsr     AddToQueue
        pha
        lda     near wTargetProp1::w7e32cd,x     ; get character/monster's current command list pointer (counterattack)
        cmp     #$ff
        bne     CreateAction       ; branch if there was already a counterattack pending
        jsr     _c24e84       ; add pending action to counterattack queue
        lda     1,s
        sta     near wTargetProp1::w7e32cd,x     ; set the character/monster's command list pointer (counterattack)
        bra     CreateAction

; ------------------------------------------------------------------------------

; [ create normal action ]

CreateNormalAction:
@4ecb:  phy
        php
        shorta
        jsr     AddToQueue
        pha                 ; push new command list pointer
        lda     near wTargetProp1::w7e32cc,x     ; get character/monster's current command list pointer
        cmp     #$ff
        bne     CreateAction       ; branch if there was already an action pending
        lda     1,s
        sta     near wTargetProp1::w7e32cc,x     ; set the character/monster's command list pointer to the new pointer
; fallthrough

; ------------------------------------------------------------------------------

; [ common code for creating actions ]

CreateAction:
@4edf:  tay
        cmp     near w7e3184,y     ; pending action pointer (or new pointer if none pending)
        beq     @4eec       ; branch if none pending
        lda     near w7e3184,y     ; look for the last pending action
        bmi     @4eec
        bra     @4edf
@4eec:  pla
        sta     near w7e3184,y     ; set the next-to-last pending action to reference the new last action
        asl
        tay
        jsr     GetMPCost
        sta     near w7e3620,y     ; add to mp cost queue
        longa
        lda     near w7e3a7a       ; command/attack
        sta     near w7e3420,y     ; add to command/attack queue
        lda     zb8         ; targets
        sta     near w7e3520,y     ; add to targets queue
        plp
        ply
        rts

; ------------------------------------------------------------------------------

; [ calculate mp cost ]

GetMPCost:
        .a8
@4f08:  phx
        php
        clr_a
        lda     #$40
        trb     zb1
        bne     @4f53
        lda     near w7e3a7a       ; command
        cmp     #BATTLE_CMD::SUMMON
        beq     @4f24       ; branch if command is summon
        cmp     #BATTLE_CMD::LORE
        beq     @4f24       ; branch if command is lore
        cmp     #BATTLE_CMD::MAGIC
        beq     @4f24       ; branch if command is magic
        cmp     #BATTLE_CMD::X_MAGIC
        bne     @4f53       ; return if command is not x-magic
@4f24:  longi
        lda     near w7e3a7b       ; branch if attacker is a monster
        cpx     #$0008
        bcs     @4f47
        phx
        tax
        lda     near w7e3084,x     ; pointer to master spell list
        plx
        cmp     #$ff
        beq     @4f53       ; return if spell is not in list
        longa
        asl2
        adc     near w7e302c,x     ; calculate pointer to character spell list (at $208e)
        tax
        shorta
        lda     a:.loword(array_member_offset wSpellList, 0, MPCost),x     ; modified mp cost (byte 3)
        bra     @4f54
@4f47:  xba
        lda     #$0e        ; calculate pointer to spell data
        jsr     MultAB
        tax
        lda     f:MagicProp+5,x   ; mp cost from spell data
        xba
@4f53:  xba
@4f54:  plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ command $23: execute battle event ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::BATTLE_EVENT
; _itou:
@4f57:  lda     zb6         ;
        xba
        lda     #GFX_CMD::BATTLE_EVENT
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $26: cast spell with no caster ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::IMMEDIATE_ACTION
; _selfmagic:
@4f5f:  lda     zb8_L
        ldx     zb6
        sta     zb6
        cmp     #ATTACK::DOOM
        bne     @4f78       ; branch if spell is not $0d (doom)
        lda     near wTargetProp1::w7e3204,x     ; stop condemned counter
        ora     #$10
        sta     near wTargetProp1::w7e3204,x
        lda     near w7e3a77
        beq     _4fdf       ; return if there are no enemies alive
        lda     #ATTACK::DOOM
@4f78:  xba
        lda     #BATTLE_CMD::MAGIC
        sta     zb5
        jsr     InitTarget
        jsr     InitAttacker
        lda     #$10
        trb     zb0         ;
        lda     #$02
        sta     $11a3       ;
        lda     #$20
        tsb     $11a4       ;
        stz     $11a5       ; zero mp cost
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $24: show/hide monsters ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::MONSTER_ENTRY_EXIT
@4f97:  .i8
        stz     near w7e3a2a
        stz     near w7e3a2b
        lda     near w7e3a73
        not_a
        trb     zb8_H
        lda     zb8_L
        asl
        tax
        ldy     #$12
@4faa:  lda     near wTargetMask + 1,y
        bit     zb8_H
        beq     @4fb4
        jsr     (near MonsterEntryExitTbl,x)
@4fb4:  dey2
        cpy     #$08
        bcs     @4faa
        lda     zb6
        xba
        lda     #GFX_CMD::MONSTER_ENTRY_EXIT
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; $04: hide monsters but don't allow battle to end
        array_label MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::KILL_MONSTERS_WAIT
@4fc2:  pha
        lda     #$ff
        sta     near w7e3a95       ; don't allow battle to end
        pla
        array_op bra, MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::HIDE_MONSTERS
        ; bra     array_item MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::HIDE_MONSTERS

; ------------------------------------------------------------------------------

; $01: hide monsters
        array_label MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::KILL_MONSTERS
@4fcb:  tsb     near w7e2f4c + 1       ;
; fall through

; ------------------------------------------------------------------------------

; $03: hide monsters (can still be targetted)
        array_label MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::HIDE_MONSTERS
; death_local:
@4fce:  trb     near w7e3408_H
        trb     near w7e2f2f
        tsb     near w7e3a2a
        lda     near wTargetProp3::w7e3ef9,y     ; set hide status
        ora     #STATUS4::HIDE
        sta     near wTargetProp3::w7e3ef9,y
_4fdf:  rts

; ------------------------------------------------------------------------------

; $00: revive and restore hp
        array_label MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::RESTORE_MONSTERS
@4fe0:  pha
        longa
        lda     near wTargetProp2::MaxHP,y     ; max hp
        sta     near wTargetProp2::CurrHP,y     ; set current hp to max
        shorta
        pla
; fall through

; ------------------------------------------------------------------------------

; $02: revive monsters at current hp
        array_label MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::SHOW_MONSTERS
@4fec:  trb     near w7e3a3a       ; clear "monsters that have died/escaped" flag
        tsb     near w7e2f2f       ; set "monsters that are not dead" flag
        tsb     near w7e3a2b       ; battle script command byte 4
        tsb     near w7e2f4e + 1       ; monster can be targetted
        tsb     near w7e3408_H       ; monster was revived/summoned
        stz     near w7e3a95       ; allow battle to end
        rts

; ------------------------------------------------------------------------------

; $05: hide monsters and set wound status
        array_label MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::KILL_MONSTERS_DEBUG
@4fff:  jsr     array_item MONSTER_ENTRY_EXIT, MONSTER_ENTRY_EXIT::HIDE_MONSTERS
        lda     near wTargetProp3::w7e3ee4,y     ; set wound status
        ora     #STATUS1::DEAD
        sta     near wTargetProp3::w7e3ee4,y
        rts

; ------------------------------------------------------------------------------

; [ command $22: poison/regen/sap damage ]

; $b6: -s---pr-
;        s: sap/phantasm damage
;        p: poison damage
;        r: regen heal

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::POISON_REGEN
; rigene:
@500b:  lda     near w7e3a77
        beq     _4fdf       ; return if no enemies are alive
        lda     near wTargetProp2::w7e3aa1,y     ; clear $3aa1.4 (target no longer has a pending dot action)
        and     #$ef
        sta     near wTargetProp2::w7e3aa1,y
        lda     near wTargetProp2::w7e3aa0,y
        bit     #$10
        bne     _4fdf       ; branch if $3aa0.4 is set
        jsr     _c2298a
        lda     #$90
        trb     zb3
        lda     #BATTLE_CMD::MIMIC
        sta     zb5
        lda     #$68
        sta     $11a2
        lsr     $11a4
        lda     zb6
        lsr2
        rol     $11a4                   ; roll in a 1 for regen, 0 for sap/poison
        lsr
        bcc     @5051                   ; branch if not poison

; apply poison damage multiplier
        lda     near wTargetProp2::PoisonDmgMult,y
        sta     zbd
        inc2
        cmp     #15
        bcc     @5049
        lda     #14
@5049:  sta     near wTargetProp2::PoisonDmgMult,y
        lda     #ELEMENT::POISON
        sta     $11a1

; calculate damage
@5051:  lda     near wTargetProp2::Stamina,y
        sta     $e8
        longa
        lda     near wTargetProp2::MaxHP,y
        jsr     Mult24
        lsr2
        cmp     #254
        shorta
        bcc     @5069
        lda     #252
@5069:  adc     #2
        sta     $11a6
        tyx
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $20: battle change ]

; +$b8: battle index (restore monsters to full hp/mp if msb set)

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::CHANGE_BATTLE
; _scenechange:
@5072:  lda     zb8_L
        sta     $11e0       ; battle index
        asl     near w7e3a47
        lda     zb8_H
        eor     #$80        ; invert msb
        asl
        ror     near w7e3a47       ; set $3a47.7 if msb clear
        lsr
        sta     $11e1
        jsr     LoadBattleProp
        longa
        ldx     #$0a
@508d:  stz     near wTargetProp2::_4::w7e3aa0,x     ; clear monster status flags
        stz     near wTargetProp2::_4::RetalFlags,x
        clr_a
        dec
        sta     near w7e2001,x     ; clear monster indexes
        lda     #$ffbc
        sta     near wTargetProp1::_4::w7e3204,x     ; clear monster update flags
        dex2
        bpl     @508d
        shorta
        jsr     InitMonsters
        jsr     UpdateStatus
        jsr     AfterAction1
        jsr     AfterAction2
        jsr     UpdateDead
        jsr     InitStatus
        jsr     ChooseBattleType
        lda     near w7e3a74_H
        sta     near w7e3a2b                   ; monsters to show
        lda     near w7e201e
        sta     near w7e3a2a                   ; monsters to hide
        lda     zb6
        xba
        lda     #GFX_CMD::CHANGE_BATTLE
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $25: display attack message ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::ATTACK_MSG
; _message2:
@50cd:  lda     #GFX_CMD::ATTACK_MSG
        bra     _50d3

; ------------------------------------------------------------------------------

; [ command $21: display monster dialog ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::MONSTER_DLG
; _message:
@50d1:  lda     #GFX_CMD::MONSTER_DLG

message_atmk:
_50d3:  xba
        lda     zb6         ; monster dialog index
        xba
        stz     near w7e3a2a       ; clear battle script command byte 3
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $27: display scan info ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::SCAN_INFO
; _ribra:
@50dd:  ldx     zb6
        lda     #GFX_CMD::TERMINATE
        sta     near w7e2d6e::_1
        lda     #GFX_CMD::ATTACK_MSG
        sta     near w7e2d6e::_0
        stz     near w7e2f35_H
        stz     near w7e2f35_B
        stz     near w7e2f38_B
        lda     near wTargetProp2::Level,x     ; level
        sta     near w7e2f35_L
        lda     #ATTACK_MSG::SCAN_LEVEL
        sta     near w7e2d6e + 1
        lda     #BTL_GFX::GFX_SCRIPT
        jsr     ExecBtlGfx
        longa
        lda     near wTargetProp2::CurrHP,x     ; current hp
        sta     near w7e2f35
        lda     near wTargetProp2::MaxHP,x     ; max hp
        sta     near w7e2f38
        shorta
        lda     #ATTACK_MSG::SCAN_HP
        sta     near w7e2d6e + 1
        lda     #BTL_GFX::GFX_SCRIPT
        jsr     ExecBtlGfx
        longa
        lda     near wTargetProp2::CurrMP,x     ; current mp
        sta     near w7e2f35
        lda     near wTargetProp2::MaxMP,x     ; max mp
        sta     near w7e2f38
        shorta
        beq     @5138       ; branch if max mp = 0
        lda     #ATTACK_MSG::SCAN_MP
        sta     near w7e2d6e + 1
        lda     #BTL_GFX::GFX_SCRIPT
        jsr     ExecBtlGfx
@5138:  lda     #ATTACK_MSG::ELEMENT_WEAK
        sta     near w7e2d6e + 1
        lda     near wTargetProp2::ElemWeak,x     ; set weak elements
        sta     $ee
        lda     near wTargetProp2::ElemHalf,x     ; clear halved elements
        ora     near wTargetProp2::ElemAbsorb,x     ; clear absorbed elements
        ora     near wTargetProp2::ElemNull,x     ; clear immune elements
        trb     $ee
        lda     #$01
@514f:  bit     $ee
        beq     @515a
        pha
        lda     #BTL_GFX::GFX_SCRIPT
        jsr     ExecBtlGfx
        pla
@515a:  inc     near w7e2d6e + 1       ; next element
        asl
        bcc     @514f
        rts

; ------------------------------------------------------------------------------

; [ command $29: stop, reflect, freeze, or psyche counter just word off ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::STATUS_TIMER_EXPIRED
; _timer:
@5161:  ldx     near w7e3a7d
        jsr     _c2298a
        lda     #BATTLE_CMD::MIMIC
        sta     zb5
        lda     #$10
        trb     zb0
        lsr     zb8_L
        bcc     @5178
        lda     #STATUS3::STOP
        tsb     $11ac
@5178:  lsr     zb8_L
        bcc     @5181
        lda     #STATUS3::REFLECT
        tsb     $11ac
@5181:  lsr     zb8_L
        bcc     @518a
        lda     #STATUS4::FROZEN
        tsb     $11ad
@518a:  lsr     zb8_L
        bcc     @51a0
        lda     #STATUS2::SLEEP
        and     near wTargetProp3::w7e3ee5,x
        beq     @51a0
        tsb     $11ab
        lda     #BATTLE_CMD::MAGIC
        sta     zb5
        lda     #$78
        sta     zb6
@51a0:  lda     #$04
        tsb     $11a4
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $2c: reset character graphical action ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::REVERT_CHAR_POSE
; _cancelinputanima:
@51a8:  lda     near w7e3a7d
        lsr
        xba
        lda     #GFX_CMD::RESET_CHAR_ACTION
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $2d: seize status hp drain ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::SEIZE_DMG
; _capture:
@51b2:  lda     near wTargetProp2::w7e3aa1,y     ; clear $3aa1.4 (target no longer has a pending dot action)
        and     #$ef
        sta     near wTargetProp2::w7e3aa1,y
        tyx
        jsr     _c2298a
        stz     $11ae
        lda     #$10
        sta     $11af       ; level 16
        sta     $11a6
        lda     #$28
        sta     $11a2
        lda     #$02
        sta     $11a3       ; ignore reflect
        tsb     $11a4       ; drain effect
        tsb     near w7e3a46       ; set $3a46.1
        lda     #$80        ; cap drain damage when attacker's hp is full (seize)
        trb     zb2
        lda     #BATTLE_CMD::MIMIC
        sta     zb5
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; monster death jump table
MonsterEntryExitTbl:
        ptr_tbl MONSTER_ENTRY_EXIT

; ------------------------------------------------------------------------------
