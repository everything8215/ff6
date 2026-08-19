.import DanceProp, BattleCmdProp, MonsterRage, MonsterControl, MonsterSpecialAnim

; ------------------------------------------------------------------------------

; [ create advance wait action for jump ]

_00e4:  tsb     near w7e3f2c
        shorta
        lda     near wTargetProp2::w7e3aa0,x
        ora     #$08        ; set $3aa0.3
        and     #$df        ; clear $3aa0.5
        sta     near wTargetProp2::w7e3aa0,x
        stz     near wTargetProp2::w7e3ab4_H,x     ; clear advance wait counter
        jmp     _c24e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ execute action ]

; called when an action reaches the top of the queue
; x = pointer to character/monster data

ExecAction:
@00f9:  sec
        ror     near w7e3406       ; set $3406 msb
        pea     BattleLoop-1
@0100:  lda     #BATTLE_CMD::MIMIC
        sta     zb5
        sta     near w7e3a7c
        lda     near wTargetProp1::w7e32cc,x     ; command list pointer
        bmi     @0183       ; branch if not valid
        asl
        tay
        lda     near w7e3420,y     ; command index
        cmp     #BATTLE_CMD::MIMIC
        bne     @0118       ; branch if not mimic
        jsr     LoadMimicAction
@0118:  sec
        jsr     InitPlayerAction

; check for random attack
        cmp     #ACTION_BATTLE_CMD::RANDOM
        bne     @013e       ; branch if command is not $1f (random attack)
        jsr     RemoveAction
        lda     near w7e3a97
        bne     @0134       ; branch if a colosseum battle
        lda     near wTargetProp1::CharmAttacker,x
        bpl     @0134
        lda     near wTargetProp3::w7e3ee5,x
        bitflg  STATUS2, {BERSERK, CONFUSE}
        beq     @0139
@0134:  jsr     RandMonsterAction
        bra     @0100
@0139:  jsr     ExecMonsterAction
        bra     @0100

; check for jump
@013e:  cmp     #BATTLE_CMD::JUMP        ; branch if command is not jump
        bne     @014e
        longa
        lda     near wTargetMask,x         ; check flag for jumping target (this gets set again below)
        trb     near w7e3f2c
        beq     _00e4       ; branch if character was not already jumping
        shorta
@014e:  lda     near wTargetProp1::w7e32cc,x     ; command list pointer
        tay
        lda     near w7e3184,y     ; command list
        cmp     near wTargetProp1::w7e32cc,x
        bne     @016d       ; branch if more than one action pending
        lda     #$80        ; disable battle menus opening
        trb     zb1

; check quick
        lda     #$ff
        cpx     near w7e3404
        bne     @016d       ; branch if there is no quick target
        dec     near w7e3402       ; decrement quick counter
        bne     @016d       ; branch if this wasn't the last quick action
        sta     near w7e3404       ; clear quick target
@016d:  xba                 ; b = next pending action in command list ($ff if no actions pending)
        lda     near wTargetProp2::w7e3aa0,x
        bit     #$50
        beq     @017a       ; branch if $3aa0.4 and $3aa0.6 are clear
        lda     #$80        ; set $3aa1.7 and return
        jmp     SetFlag1
@017a:  lda     #$ff        ; clear entry in command list
        sta     near w7e3184,y
        xba
        sta     near wTargetProp1::w7e32cc,x     ; set new command list pointer ($ff if no actions pending)
@0183:  lda     near wTargetProp2::w7e3aa0,x     ;
        and     #$d7        ; clear $3aa0.3 and $3aa0.5
        ora     #$40        ; set $3aa0.6
        sta     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @01a6       ; branch if target is not present
        lda     near wTargetProp1::w7e3204,x
        ora     #$04
        sta     near wTargetProp1::w7e3204,x
        lda     near wTargetProp1::w7e3205,x     ; set $3205.7
        ora     #$80
        sta     near wTargetProp1::w7e3205,x
        jsr     ExecCmd
        jsr     SaveMimicAction
@01a6:  lda     #$a0        ;
        tsb     zb0
        lda     #$10
        trb     near w7e3a46
        bne     @01b7       ; branch if $3a46.4 is set (sonic dive)
        lda     near wTargetProp1::w7e32cc,x     ; branch if target still has pending actions
        inc
        bne     @01d5
@01b7:  lda     near wTargetProp2::w7e3aa0,x     ; $3aa0.3 branch if atb gauge is stopped
        bit     #$08
        bne     @01c6
        inc     near wTargetProp1::w7e3218_H,x     ; reset atb gauge
        bne     @01c6
        dec     near wTargetProp1::w7e3218_H,x
@01c6:  lda     #$ff
        sta     near wTargetProp1::AdvanceWaitDur,x     ; disable advance wait
        stz     near wTargetProp2::w7e3ab4_H,x     ; clear advance wait counter
        lda     #$80        ;
        trb     zb0
        jmp     EndAction

; attacker still has more pending actions to be executed
@01d5:  stx     near w7e3406       ; currently acting character/monster
_01d8:  rts

; ------------------------------------------------------------------------------

; [ replace mimic command with the previous command that is getting mimicked ]

LoadMimicAction:
@01d9:  lda     near w7e3f28
        cmp     #BATTLE_CMD::JUMP
        bne     @01f1

; mimicking a jump
        longa
        lda     near w7e3f28
        sta     near w7e3420,y
        lda     near w7e3f2a
        sta     near w7e3520,y
        shorta
        rts

; not mimicking a jump
@01f1:  longa
        lda     near w7e3f20
        sta     near w7e3420,y
        lda     near w7e3f22
        sta     near w7e3520,y

; check if mimicking x-magic
        shorta
        lda     near w7e3f24
        cmp     #BATTLE_CMD::MIMIC
        beq     _01d8                   ; return if no 2nd x-magic command

; queue 2nd x-magic command
        longa
        lda     near w7e3f24                   ; copy 2nd x-magic command and attack
        sta     near w7e3a7a
        lda     near w7e3f26                   ; copy 2nd x-magic targets
        sta     zb8
        shorta
        lda     #$40
        tsb     zb1
        jmp     CreateNormalAction

; ------------------------------------------------------------------------------

; [ update mimic data ]

SaveMimicAction:
@021e:  phx
        php
        cpx     #$08
        bcs     @0264       ; return if attacker was a monster
        lda     near w7e3a7c
        cmp     #$1e
        bcs     @0264       ; return for command >= $1e
        asl
        tax
        lda     f:BattleCmdProp,x   ; return if command can't be mimicked
        bit     #BATTLE_CMD_FLAG::MIMIC
        beq     @0264
        lda     #BATTLE_CMD::MIMIC
        sta     near w7e3f28
        lda     near w7e3a7c
        cmp     #BATTLE_CMD::X_MAGIC
        beq     @0256
        lda     #BATTLE_CMD::MIMIC
        sta     near w7e3f24       ;
        longa
        lda     near w7e3a7c       ; save last command/attack
        sta     near w7e3f20
        lda     near w7e3a30       ; save last targets
        sta     near w7e3f22
        bra     @0264

; save 2nd x-magic command for mimic
@0256:  longa
        lda     near w7e3a7c       ; save last command/attack (x-magic)
        sta     near w7e3f24
        lda     near w7e3a30       ; save last targets (x-magic)
        sta     near w7e3f26
@0264:  plp
        .a8
        plx
        rts

; ------------------------------------------------------------------------------

; [ move character back after attacking ]

EndAction:
@0267:  lda     #GFX_CMD::STEP_BACK
        sta     near w7e2d6e::_0
        lda     #GFX_CMD::TERMINATE
        sta     near w7e2d6e::_1
        lda     #BTL_GFX::GFX_SCRIPT
        jmp     ExecBtlGfx

; ------------------------------------------------------------------------------

; [ init queued action ]

; carry set: retarget at random if attacker became a zombie or confused
; A: command (out)

InitPlayerAction:
@0276:  php
        longa
        lda     near w7e3520,y     ; targets
        sta     zb8
        lda     near w7e3420,y     ; command/attack
        sta     near w7e3a7c
        sta     zb5
        plp
        .a8
        pha
        bcc     @029a       ; branch if ??? (carry set or cleared when subroutine called)
        cmp     #BATTLE_CMD::MAGITEK
        bcs     @029a       ; branch if command >= $1d (magitek)
        lda     near wTargetMask,x     ; character mask
        trb     near w7e3a4a       ; remove attacker from characters/monsters with changed status
        beq     @029a       ; branch if there were no changed statuses
        stz     zb8_L         ; clear targets (target will be chosen at random)
        stz     zb8_H
@029a:  lda     near w7e3620,y     ; mp cost
        sta     near w7e3a4c

; use fight if the attacker is an imp and the command is not allowed for imps
        lda     near wTargetProp3::w7e3ee4,x     ; current status 1
        bit     #STATUS1::IMP
        beq     @02da       ; return if not imp
        lda     zb5
        cmp     #$1e        ; return if command >= $1e
        bcs     @02da
        phx
        asl
        tax
        lda     f:BattleCmdProp,x   ; battle command data
        plx
        bit     #BATTLE_CMD_FLAG::IMP
        bne     @02da       ; return if command can't be used by imp
        stz     near w7e3a4c       ; clear mp cost
        phx
        clr_a
        cpx     #$08        ; check if attacker is a character or monster
        rol
        tax
        lda     zb8,x       ; get target byte ($b8 or $b9)
        and     near w7e3a40,x     ; remove ally targets
        sta     zb8,x
        longa
        stz     near w7e3a7c       ; change command to fight
        stz     zb5
        lda     zb8
        jsr     RandBit
        sta     zb8         ; random target
        shorta
        plx
@02da:  pla
        rts

; ------------------------------------------------------------------------------

; [ execute ai ]

ExecMonsterAction:
@02dc:  longa
        stz     near w7e3a98                   ; clear "unresponsive" indicator
        lda     near wTargetProp1::w7e3254,x
        sta     $f0
        lda     near wTargetProp2::w7e3d0c,x
        sta     $f2
        lda     near wTargetProp1::w7e3240,x
        sta     $f4
        clc
        jsr     ExecAI
        lda     $f2
        sta     near wTargetProp2::w7e3d0c,x
        shorta
        lda     $f5
        sta     near wTargetProp1::w7e3240,x
        rts

; ------------------------------------------------------------------------------

; [ remove next pending action from command list ]

RemoveAction:
@0301:  lda     near wTargetProp1::w7e32cc,x     ; command list pointer
        bmi     @031b       ; return if no pending actions
        phy
        tay
        lda     near w7e3184,y     ; command list
        cmp     near wTargetProp1::w7e32cc,x
        bne     @0312       ; branch if multiple commands are pending
        lda     #$ff
@0312:  sta     near wTargetProp1::w7e32cc,x     ; set new command list pointer ($ff if no commands pending)
        lda     #$ff
        sta     near w7e3184,y     ; clear old command list slot
        ply
@031b:  rts

; ------------------------------------------------------------------------------

; [ create advance wait action ]

QueueAction:
@031c:  stz     zb8_L         ; clear targets
        stz     zb8_H
        inc     near wTargetProp1::AdvanceWaitDur,x     ; set the advance wait duration to zero, but only if is disabled
        beq     @0328
        dec     near wTargetProp1::AdvanceWaitDur,x
@0328:  jsr     ClearDef
        lda     near wTargetProp2::RetalFlags,x     ; clear runic and retort ($3e4c.0 and $3e4c.2)
        clrflg  RETAL_FLAGS, {RUNIC, RETORT}
        sta     near wTargetProp2::RetalFlags,x
        cpx     #$08
        bcc     @0344       ; branch if a character

; random monster action
        lda     near wTargetProp1::w7e32cc,x
        bpl     @0357       ; branch if command list pointer is valid
        lda     #ACTION_BATTLE_CMD::RANDOM
        sta     near w7e3a7a
        jmp     CreateNormalAction

; random character action
@0344:  lda     near wTargetMask,x     ; character mask
        trb     near w7e3a4a       ; clear in targets with changed status
        lda     near wTargetProp1::w7e3254_H,x
        jpl     ExecMonsterAction

; no ai script
        lda     near wTargetProp1::w7e32cc,x     ; command list pointer
        bmi     @037b       ; branch if no pending actions
@0357:  pha
        asl
        tay
        longa
        lda     near w7e3520,y
        sta     zb8
        lda     near w7e3420,y
        jsr     CalcCmdDelay
        lda     zb8
        sta     near w7e3520,y
        shorta
        pla
        tay
        cmp     near w7e3184,y     ; command list
        beq     @037a       ; return if this is the last pending action for this character/monster
        lda     near w7e3184,y     ; check the next pending action
        bra     @0357
@037a:  rts

; no pending actions
@037b:  lda     near wTargetProp3::w7e3ef8,x     ; status 3
        lsr
        bcs     RandDanceAction
        lda     near wTargetProp3::w7e3ef9,x     ; status 4
        lsr
        bcs     RandRageAction
        lda     near wTargetProp3::w7e3ee4,x     ; status 1
        bit     #STATUS1::MAGITEK
        bne     RandMagitekAction
        jsr     RandCharAction
        cmp     #BATTLE_CMD::X_MAGIC
        bne     @03b0       ; branch if not x-magic
        pha
        xba
        pha
        pha
        txy
        jsr     RandMagic
        sta     1,s
        pla
        xba
        lda     #$02
        jsr     CalcCmdDelay
        jsr     CreateNormalAction
        stz     zb8_L
        stz     zb8_H
        pla
        xba
        pla
@03b0:  jsr     FixRoulette
        jsr     CalcCmdDelay
        jmp     CreateNormalAction

; ------------------------------------------------------------------------------

; [ correct roulette command index ]

FixRoulette:
@03b9:  php
        longa
        cmp     #make_word BATTLE_CMD::LORE, ATTACK::ROULETTE
        bne     @03c4
        lda     #make_word ACTION_BATTLE_CMD::ROULETTE, ATTACK::ROULETTE
@03c4:  plp
        .a8
        rts

; ------------------------------------------------------------------------------

; random magitek action
RandMagitekAction:
@03c6:  jsr     RandMagitek
        xba
        lda     #BATTLE_CMD::MAGITEK
        bra     _03de

; random rage
RandRageAction:
@03ce:  txy
        jsr     RandRage
        xba
        lda     #BATTLE_CMD::RAGE
        bra     _03de

; random dance
RandDanceAction:
@03d7:  txy
        jsr     RandDance
        xba
        lda     #BATTLE_CMD::DANCE
_03de:  jsr     CalcCmdDelay
        jmp     CreateNormalAction

; ------------------------------------------------------------------------------

; [ set advance wait timer ]

CalcCmdDelay:
@03e4:  php
        shortai
        sta     near w7e3a7a       ; command
        xba
        sta     near w7e3a7b       ; attack
        xba
        cmp     #$1e        ; return if command >= $1e
        bcs     @041e
        pha
        phx
        tax
        lda     f:CmdDelayTbl,x   ; advance wait duration for command
        plx
        clc
        adc     near wTargetProp1::AdvanceWaitDur,x     ; add to advance wait duration (max $fe)
        bcs     @0404
        inc
        bne     @0406
@0404:  lda     #$ff
@0406:  dec
        sta     near wTargetProp1::AdvanceWaitDur,x
        pla
        jsr     InitTarget
        lda     #$04
        trb     zba         ; clear "no retarget if target becomes invalid" flag
        longa
        lda     zb8         ;
        bne     @041e
        stz     near w7e3a4e
        jsr     ChooseTarget
@041e:  plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ select berserk/zombie/muddled/charmed/colosseum action ]

; A: command (out)
; B: attack (out)

RandCharAction:
@0420:  txa
        xba
        lda     #6
        jsr     MultAB
        tay
        stz     $fe
        stz     $ff
        lda     near wCmdList::CmdID,y                 ; $f6 = command 1
        sta     $f6
        lda     near wCmdList::CmdID+3,y                 ; $f8 = command 2
        sta     $f8
        lda     near wCmdList::CmdID+6,y                 ; $fa = command 3
        sta     $fa
        lda     near wCmdList::CmdID+9,y                 ; $fc = command 4
        sta     $fc
        lda     #$05
        sta     $f5
        lda     near wTargetProp3::w7e3ee5,x                 ; status 2
        asl2
        sta     $f4
        asl
        bpl     @0452                   ; branch if berserk
        stz     $f4
        bra     @045e
@0452:  lda     near wTargetProp1::CharmAttacker,x                 ; charm attacker
        eor     #$80
        tsb     $f4
        lda     near w7e3a97                   ; colosseum characters
        tsb     $f4
@045e:  txy
        phx
        ldx     #$06                    ; loop through each attack
@0462:  phx
        lda     $f6,x                   ; command
        pha
        bmi     @0482                   ; skip if command slot is empty
        clc
        jsr     GetBitPtr
        and     f:ConfusedCmdTbl,x
        beq     @0482
        lda     $f4
        bmi     @0488                   ; branch if not berserk
        lda     1,s                   ; command
        clc
        jsr     GetBitPtr
        and     f:BerserkCmdTbl,x
        bne     @0488
@0482:  lda     #$ff                    ; clear command
        sta     1,s
        dec     $f5                     ; decrement number of available commands
@0488:  clr_a
        lda     1,s                   ; command
        ldx     #$08
@048d:  cmp     f:RandCmdIDTbl,x
        bne     @0499
        jsr     (near RandCmdTbl,x)
        xba
        bra     @04a9
@0499:  cmp     f:RandCmdIDTbl+1,x
        bne     @04a5
        jsr     (near RandCmdTbl+10,x)
        xba
        bra     @04a9
@04a5:  dex2                            ; next command
        bpl     @048d
@04a9:  pla
        plx
        sta     $f6,x                   ; command
        xba
        sta     $f7,x                   ; attack
        dex2
        bpl     @0462
        lda     $f5
        jsr     RandA
        tay
        ldx     #$08
@04bc:  lda     $f6,x                   ; command
        bmi     @04c3                   ; skip if not valid
        dey
        bmi     @04ca                   ; branch if this is the randomly selected command
@04c3:  dex2
        bpl     @04bc
        clr_a
        bra     @04ce
@04ca:  xba
        lda     $f7,x                   ; a = command, b = attack
        xba
@04ce:  plx
        rts

; ------------------------------------------------------------------------------

; bitmask of muddled/charmed/colosseum commands
ConfusedCmdTbl:
        bitlist 30
        bitlist_set BATTLE_CMD::FIGHT
        bitlist_set BATTLE_CMD::MAGIC
        bitlist_set BATTLE_CMD::MORPH
        bitlist_set BATTLE_CMD::STEAL
        bitlist_set BATTLE_CMD::CAPTURE
        bitlist_set BATTLE_CMD::BUSHIDO
        bitlist_set BATTLE_CMD::TOOLS
        bitlist_set BATTLE_CMD::BLITZ
        bitlist_set BATTLE_CMD::RUNIC
        bitlist_set BATTLE_CMD::LORE
        bitlist_set BATTLE_CMD::SKETCH
        bitlist_set BATTLE_CMD::RAGE
        bitlist_set BATTLE_CMD::MIMIC
        bitlist_set BATTLE_CMD::DANCE
        bitlist_set BATTLE_CMD::ROW
        bitlist_set BATTLE_CMD::JUMP
        bitlist_set BATTLE_CMD::X_MAGIC
        bitlist_set BATTLE_CMD::GP_RAIN
        bitlist_set BATTLE_CMD::HEALTH
        bitlist_set BATTLE_CMD::SHOCK
        bitlist_set BATTLE_CMD::MAGITEK
        end_bitlist

; bitmask of berserk/zombie commands
BerserkCmdTbl:
        bitlist 30
        bitlist_set BATTLE_CMD::FIGHT
        bitlist_set BATTLE_CMD::CAPTURE
        bitlist_set BATTLE_CMD::RAGE
        bitlist_set BATTLE_CMD::JUMP
        bitlist_set BATTLE_CMD::MAGITEK
        end_bitlist

; commands with special code when used randomly
; these are interlaced compared to the table below, so the first
; column corresponds to the first 5 addresses and the second column
; corresponds to the second 5 addresses
RandCmdIDTbl:
        .byte   BATTLE_CMD::MAGIC,      BATTLE_CMD::X_MAGIC
        .byte   BATTLE_CMD::BUSHIDO,    BATTLE_CMD::BLITZ
        .byte   BATTLE_CMD::RAGE,       BATTLE_CMD::DANCE
        .byte   BATTLE_CMD::LORE,       BATTLE_CMD::MORPH
        .byte   BATTLE_CMD::MAGITEK,    BATTLE_CMD::TOOLS

; command special code jump pointers
RandCmdTbl:
@04e2:  .addr   RandMagic
        .addr   RandBushido
        .addr   RandRage
        .addr   RandLore
        .addr   RandMagitek

        .addr   RandMagic
        .addr   RandBlitz
        .addr   RandDance
        .addr   RandMorph
        .addr   RandTools

; ------------------------------------------------------------------------------

; [ lore command (random) ]

RandLore:
@04f6:  lda     near wTargetProp3::w7e3ee5,y
        bit     #STATUS2::SILENCE
        bne     RandCmdInvalid
        lda     near wNumKnownLores
        beq     RandCmdInvalid
        pha
        longa_clc
        lda     near w7e302c,y
        adc     #$00d8
        sta     $ee
        shorta
        pla
        xba
        lda     #$60
        jsr     _0534
        clc
        adc     #$8b        ; condemned (first lore)
        rts

; ------------------------------------------------------------------------------

; [ magic/x-magic command (random) ]

RandMagic:
@051a:  lda     near wTargetProp3::w7e3ee5,y
        bit     #STATUS2::SILENCE
        bne     RandCmdInvalid
        lda     near wTargetProp2::NumKnownSpells,y
        beq     RandCmdInvalid
        pha
        longa
        lda     near w7e302c,y
        sta     $ee
        shorta
        pla
        xba
        lda     #$d8
_0534:  phx
        phy
        tay
        xba
        jsr     RandA
        tax
@053c:  lda     ($ee),y
        cmp     #$ff
        beq     @0545
        dex
        bmi     @054c
@0545:  dey4
        bne     @053c
        clr_a
@054c:  ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ command invalid ]

RandCmdInvalid:
_054f:  dec     $f5
        lda     #$ff
        sta     3,s
        clr_a
        rts

; ------------------------------------------------------------------------------

; [ morph command (random) ]

RandMorph:
@0557:  lda     #$0f
        cmp     $1cf6       ; morph counter
        clr_a
        bcs     RandCmdInvalid
        rts

; ------------------------------------------------------------------------------

; [ swdtech command (random) ]

RandBushido:
@0560:  lda     near wTargetProp2::RHandWeaponFlags,y
        ora     near wTargetProp2::LHandWeaponFlags,y
        bit     #WEAPON_FLAG::BUSHIDO
        beq     RandCmdInvalid
        lda     near w7e2020
        inc
        jsr     RandA
        clc
        adc     #ATTACK::FIRST_BUSHIDO
        rts

; ------------------------------------------------------------------------------

; [ blitz command (random) ]

RandBlitz:
@0575:  clr_a
        lda     $1d28       ; known blitzes
        jsr     RandBit
        jsr     GetBitNum
        txa
        clc
        adc     #ATTACK::FIRST_BLITZ
        rts

; ------------------------------------------------------------------------------

; [ magitek command (random) ]

RandMagitek:
@0584:  lda     #$03
        jsr     RandA
        clc
        adc     #ATTACK::FIRST_MAGITEK
        rts

; ------------------------------------------------------------------------------

; [ tools command (random) ]

RandTools:
@058d:  clr_a
        lda     near wOwnedTools
        jsr     RandBit
        jsr     GetBitNum
        txa
        clc
        adc     #ITEM::NOISEBLASTER
        rts

; ------------------------------------------------------------------------------

; [ dance command (random) ]

RandDance:
@059c:  phx
        lda     near wTargetProp1::w7e32e1,y
        cmp     #$ff
        bne     @05b2
        clr_a
        lda     $1d4c       ; known dances
        jsr     RandBit
        jsr     GetBitNum
        txa
        sta     near wTargetProp1::w7e32e1,y
@05b2:  asl2
        sta     $ee
        jsr     Rand
        ldx     #$02
@05bb:  cmp     f:DanceRateTbl,x
        bcs     @05c3
        inc     $ee
@05c3:  dex
        bpl     @05bb
        ldx     $ee
        lda     f:DanceProp,x   ; dance data
        plx
        rts

; dance attack probabilities (7/16, 3/8, 1/8, 1/16)
DanceRateTbl:
@05ce:  .byte   $10,$30,$90

; ------------------------------------------------------------------------------

; [ rage command (random) ]

RandRage:
@05d1:  phx
        php
        clr_a
        sta     near wTargetProp1::w7e33a8_H,y
        lda     near wTargetProp1::w7e33a8_L,y
        cmp     #$ff
        bne     @0600
        inc
        sta     near wTargetProp1::w7e33a8_L,y
        lda     near wNumKnownRages
        jsr     RandA
        inc
        sta     $ee
        ldx     #0
@05ed:  lda     near wRageList,x     ; known rages
        cmp     #$ff
        beq     @0600
        dec     $ee
        beq     @05fd
        inx
        bne     @05ed
        bra     @0600
@05fd:  sta     near wTargetProp1::w7e33a8_L,y
@0600:  jsr     RandCarry
        longai
        rol                 ; 1/2 chance first or second attack will be chosen
        tax
        shorta
        lda     f:MonsterRage,x   ; monster rage attacks
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ set the monster for rage ]

SetRage:
@0610:  php
        lda     near wTargetProp1::w7e33a8_L,y
        tax
        xba
        lda     f:MonsterSpecialAnim,x
        sta     near wTargetProp2::MonsterSpecialAnim,y
        lda     #$20
        jsr     MultAB
        longi
        tax
        lda     f:MonsterProp+26,x
        sta     near wTargetProp2::RHandItem,y
        sta     near wTargetProp2::LHandItem,y
        jsr     LoadRageProp
        plp
        rts

; ------------------------------------------------------------------------------

; [ choose monster confused attack ]

RandMonsterAction:
@0634:  phx
        longai
        lda     near w7e2001 - 8,x     ; monster id (actually $2001)
        asl2
        tax
        lda     f:MonsterControl,x   ; monster control/muddled attacks
        sta     $f0
        lda     f:MonsterControl+2,x
        sta     $f2
        shortai
        stz     $ee
        jsr     Rand
        and     #$03
        tax
@0653:  lda     $f0,x
        cmp     #$ff
        bne     @0664
        dex
        bpl     @0653
        inc     $ee
        beq     @0664
        ldx     #$03
        bra     @0653
@0664:  plx
        pha
        lda     near wTargetProp3::w7e3ee5,x
        bit     #STATUS2::BERSERK
        beq     @0671
        lda     #ATTACK::BATTLE
        sta     1,s
@0671:  pla
        jsr     GetCmdForAI
        jsr     CalcCmdDelay
        jmp     CreateNormalAction

; ------------------------------------------------------------------------------

; advance wait durations for each command
CmdDelayTbl:
@067b:  .byte   16
        .byte   16
        .byte   32
        .byte   0
        .byte   0
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   32
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   16
        .byte   224
        .byte   32
        .byte   16
        .byte   16
        .byte   32
        .byte   32
        .byte   16
        .byte   16
        .byte   0
        .byte   0

; ------------------------------------------------------------------------------

; [ update special status (seize, control, love token, etc.) ]

AfterAction1:
@069b:  ldx     #$12
@069d:  lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @0700       ; $3aa0.0 branch if target is not present
        longa
        lda     near wTargetMask,x
        bit     near w7e2f4e
        shorta
        bne     @0700       ; branch if target can't be targetted
        jsr     ValidateControl
        lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS1, {DEAD, ZOMBIE}
        beq     @06bf       ; branch if target doesn't have wound or zombie status
        stz     near wTargetProp2::CurrHP_L,x     ; set current hp to 0
        stz     near wTargetProp2::CurrHP_H,x
@06bf:  lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        beq     @06cf       ; branch if target doesn't have wound, petrify, or zombie status
        lda     near wTargetMask + 1,x
        tsb     near w7e3a3a       ; target has died/escaped
        jsr     _c207c8
@06cf:  lda     near wTargetProp3::w7e3ee4,x
        bpl     @0700       ; branch if target does not have wound status
        cpx     #$08
        bcs     @06e4       ; branch if a monster
        lda     near w7e3ed8,x     ; actor index
        cmp     #CHAR_PROP::BANON
        bne     @06e4       ; branch if not $0e (banon)
        lda     #$06        ; end of battle special event 3 (banon died)
        sta     near w7e3a6e
@06e4:  jsr     CheckJump
        lda     near wTargetProp3::w7e3ee4,x
        bit     #STATUS1::ZOMBIE
        beq     @06f1       ; branch if target has zombie status
        jsr     FixDeadStatus
@06f1:  lda     near wTargetProp3::w7e3ee4,x
        bpl     @0700       ; branch if target does not have wound status
        lda     near wTargetProp3::w7e3ef9,x
        bit     #STATUS4::RERAISE
        beq     @0700       ; branch if target doesn't have life 3 status
        jsr     ReraiseEffect
@0700:  dex2                ; next target
        bpl     @069d
        ldx     #$12
@0706:  jsr     RemoveControlTarget
        dex2
        bpl     @0706
        jmp     UpdateCharGfxBuf

; ------------------------------------------------------------------------------

; [ make jumping character die when they land ]

CheckJump:
@0710:  longa
        lda     near wTargetMask,x
        bit     near w7e3f2c       ; jumping targets
        shorta
        beq     @0727       ; return if not jump/seize
        jsr     FixDeadStatus
        lda     near wTargetProp1::w7e3205,x     ; set air anchor effect ($3205.2)
        and     #$fb
        sta     near wTargetProp1::w7e3205,x
@0727:  rts

; ------------------------------------------------------------------------------

; [ remove wound status (jumping/seized/zombie target) ]

FixDeadStatus:
@0728:  lda     near wTargetProp3::w7e3ee4,x     ; remove wound status
        and     #<~STATUS1::DEAD
        sta     near wTargetProp3::w7e3ee4,x
        lda     near wTargetProp1::w7e3204,x     ; don't remove all advance wait actions
        and     #$bf
        sta     near wTargetProp1::w7e3204,x
        rts

; ------------------------------------------------------------------------------

; [ remove control status (target) ]

RemoveControlTarget:
@0739:  lda     near wTargetProp1::ControlAttacker,x     ; target controlling you
        cmp     #$ff
        beq     @0748       ; branch if not valid
        bpl     @0748       ; branch if msb set ???
        and     #$7f
        tay
        jsr     RemoveControlAttacker
@0748:  lda     near wTargetProp1::ControlTarget,x     ; target you control
        cmp     #$ff
        beq     @075a       ; branch if not valid
        bpl     @075a       ; branch if msb set ???
        and     #$7f
        phx
        txy
        tax
        jsr     RemoveControlAttacker
        plx
@075a:  rts

; ------------------------------------------------------------------------------

; [ remove control status (attacker) ]

RemoveControlAttacker:
.if LANG_EN
@075b:  lda     near wTargetProp2::ExtraStatus,y     ; don't use control battle menu ($3e4d.0)
        and     #$fe
        sta     near wTargetProp2::ExtraStatus,y
.endif
        lda     near wTargetProp3::w7e3ef9,y     ; clear control status
        and     #<~STATUS4::CONTROL
        sta     near wTargetProp3::w7e3ef9,y
        lda     #$ff
        sta     near wTargetProp1::ControlAttacker,x     ; clear target controlling you (target)
        sta     near wTargetProp1::ControlTarget,y     ; clear target you control (attacker)
        lda     near wTargetMask + 1,x
        trb     near w7e2f53 + 1       ; clear horizontal flip for targets being controlled
        phx
        jsr     UpdateSeize
        tyx
        jsr     UpdateSeize
        plx
        rts

; ------------------------------------------------------------------------------

; [ update seize status ]

UpdateSeize:
@0783:  lda     #$40
        jsr     SetFlag1       ; set $3aa1.6 pending seize action
        lda     near wTargetProp1::w7e3204,x
        ora     #$40
        sta     near wTargetProp1::w7e3204,x     ; remove all advance wait actions
        lda     #$7f

ClearFlag0:
@0792:  and     near wTargetProp2::w7e3aa0,x     ; clear $3aa0.7 (don't allow battle menu to open)
        sta     near wTargetProp2::w7e3aa0,x
        rts

; ------------------------------------------------------------------------------

; [ life 3 effect (monster) ]

ReraiseEffect:
@0799:  and     #<~STATUS4::RERAISE
        sta     near wTargetProp3::w7e3ef9,x     ; clear life 3 status
        lda     near wTargetMask + 1,x     ; monster mask
        trb     near w7e2f2f       ; make monster alive
        lda     #ATTACK::RAISE
        sta     zb8_L
        lda     #ACTION_BATTLE_CMD::IMMEDIATE_ACTION
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; [ update control status ]

ValidateControl:
@07ad:  peaflg  STATUS12, {DEAD, PETRIFY, ZOMBIE, BERSERK, CONFUSE, SLEEP}
        peaflg  STATUS34, {DANCE, STOP, RAGE, FROZEN}
        txy
        jsr     CheckStatus
        bcs     @07c7
        asl     near wTargetProp1::ControlTarget,x     ; set msb of "target you control"
        sec
        ror     near wTargetProp1::ControlTarget,x
        asl     near wTargetProp1::ControlAttacker,x     ; set msb of "target controlled by you"
        sec
        ror     near wTargetProp1::ControlAttacker,x
@07c7:  rts

; ------------------------------------------------------------------------------

; [ update zinger, love token, charm status ]

_c207c8:
_dead:
@07c8:  cpx     near wZingerTarget
        bne     @07f5       ; branch if not zinger target
        phx
        ldx     near wZingerAttacker
        lda     near wTargetMask + 1,x     ; entrance effects b2 is mask of affected monster
        sta     zb8_H
        lda     #$04        ; entrance effects b1 $04 (hide monsters but don't allow battle to end)
        sta     zb8_L
        ldx     #MONSTER_ENTRY_EXIT_ANIM::INSTANT
        lda     #ACTION_BATTLE_CMD::MONSTER_ENTRY_EXIT
        jsr     CreateImmediateAction
        lda     #$02        ; entrance effects b1 $02 (revive monsters at current hp)
        sta     zb8_L
        ldx     #MONSTER_ENTRY_EXIT_ANIM::FADE_DOWN
        lda     #ACTION_BATTLE_CMD::MONSTER_ENTRY_EXIT
        jsr     CreateImmediateAction
        lda     #$ff
        sta     near wZingerAttacker
        sta     near wZingerTarget
        plx
@07f5:  lda     near wTargetProp1::LoveTokenTarget,x     ; love token target
        bmi     @07fe       ; branch if a monster
        tay
        jsr     RemoveLoveToken
@07fe:  lda     near wTargetProp1::LoveTokenAttacker,x     ; love token attacker
        bmi     @080a       ;
        phx
        txy
        tax
        jsr     RemoveLoveToken
        plx
@080a:  lda     near wTargetProp1::CharmTarget,x
        bmi     @0813
        tay
        jsr     RemoveCharm
@0813:  lda     near wTargetProp1::CharmAttacker,x
        bmi     @081f
        phx
        txy
        tax
        jsr     RemoveCharm
        plx

; disable quick if target is quick
@081f:  cpx     near w7e3404
        bne     @082c
        lda     #$ff
        sta     near w7e3404
        sta     near w7e3402
@082c:  rts

; ------------------------------------------------------------------------------

; [ clear love token status ]

RemoveLoveToken:
@082d:  lda     #$ff
        sta     near wTargetProp1::LoveTokenTarget,x     ; clear love token target/attacker
        sta     near wTargetProp1::LoveTokenAttacker,y
        rts

; ------------------------------------------------------------------------------

; [ clear charm status ]

RemoveCharm:
@0836:  lda     #$ff
        sta     near wTargetProp1::CharmTarget,x     ; clear charm target/attacker
        sta     near wTargetProp1::CharmAttacker,y
        rts

; ------------------------------------------------------------------------------

; [ update targets after each command ]

AfterAction2:
@083f:  ldx     #$12        ; loop through all characters/monsters
@0841:  lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @08be       ; skip if $3aa0.0 is clear (target is not present)
        asl     near wTargetProp1::w7e32e0,x     ; clear MSB of previous attacker byte
        lsr     near wTargetProp1::w7e32e0,x
        lda     near wTargetProp3::w7e3ee4,x
        bmi     @0859       ; branch if target has wound status
        lda     near wTargetProp2::w7e3aa1,x
        bit     #$40
        beq     @085c       ; $3aa1.6 branch if no pending run/control/psyche/seize action
@0859:  jsr     DisableATB
@085c:  lda     near wTargetProp1::w7e3204,x
        beq     @08ab
        lsr
        bcc     @0867
        jsr     QuetzEffect
@0867:  asl     near wTargetProp1::w7e3204,x
        bcc     @086f
        jsr     UpdateEnabledMagic
@086f:  asl     near wTargetProp1::w7e3204,x
        bcc     @087c
        jsr     RemoveAllActions
        lda     #$80
        jsr     SetFlag1       ; set $3aa1.7
@087c:  asl     near wTargetProp1::w7e3204,x
        bcc     @0884
        jsr     StartCondemn
@0884:  asl     near wTargetProp1::w7e3204,x
        bcc     @088c
        jsr     StopCondemn
@088c:  asl     near wTargetProp1::w7e3204,x
        bcc     @0898
        cpx     #$08        ; skip if a monster
        bcs     @0898
        jsr     UpdateCmdList
@0898:  asl     near wTargetProp1::w7e3204,x
        bcc     @08a0
        jsr     CalcSpeed
@08a0:  asl     near wTargetProp1::w7e3204,x
        bcc     @08a8
        jsr     UpdateMorph
@08a8:  asl     near wTargetProp1::w7e3204,x
@08ab:  jsr     CheckPlayerAction
        jsr     _c208c6
        lda     near wTargetProp2::w7e3aa0,x
        bit     #$50
        beq     @08bb       ; branch if $3aa0.4 and $3aa0.6 are clear
        jsr     ClearDef
@08bb:  jsr     NearFatalEffect
@08be:  dex2                ; next character/monster
        jpl     @0841
_08c5:  rts

; ------------------------------------------------------------------------------

; [ add pending action to queue ]

_c208c6:
_countercheck:
@08c6:  lda     #$50
        jsr     SetFlag0     ; set $3aa0.4 and $3aa0.6
        lda     near w7e3404
        bmi     @08d5       ; branch if there is no quick target
        cpx     near w7e3404
        bne     _08c5       ; return if this target is not quick
@08d5:  lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS1, {DEAD, PETRIFY}
        bne     _08c5       ; return if target has wound or petrify status
        lda     near wTargetProp3::w7e3ef8,x
        bit     #STATUS3::STOP
        bne     _08c5       ; return if target has stop status
        lda     #$ef
        jsr     ClearFlag0       ; clear $3aa0.4
        lda     near wTargetProp1::ControlAttacker,x
        bpl     _08c5       ; return if target controlling you msb clear
        lda     near wTargetProp3::w7e3ee5,x
        bmi     _08c5       ; return if target has sleep status
        lda     near wTargetProp3::w7e3ef9,x
        bit     #STATUS4::FROZEN
        bne     _08c5       ; return if target has frozen status
        lda     near wTargetProp1::SeizeAttacker,x
        bpl     _08c5       ; return if seize attacker is valid
        lda     #$bf
        jsr     ClearFlag0       ; clear $3aa0.6
        lda     near wTargetProp2::w7e3aa1,x
        bpl     _08c5       ; return if $3aa1.7 clear
        and     #$7f
        sta     near wTargetProp2::w7e3aa1,x     ; clear $3aa1.7
        lda     near wTargetProp1::w7e32cc,x     ; command list pointer
        inc
        beq     _08c5       ; return if there are no pending actions in the command list
        lda     near wTargetProp2::w7e3aa1,x
        lsr
        jcs     _c24e77       ; add action to queue
        jmp     _c24e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ add pending advance wait action to queue ]

CheckPlayerAction:
_inputcheck:
@091f:  cpx     #$08
        bcs     _08c5                   ; return if a monster
        lda     near w7e3ed8,x
        cmp     #CHAR_PROP::UMARO
        beq     _08c5                   ; return if umaro
        lda     near wTargetProp1::w7e3254_H,x
        bpl     _08c5                   ; return if character has a valid ai script
        lda     near w7e3a97
        bne     _08c5                   ; return if characters are in colosseum
        lda     #$02                    ; set $3aa0.1
        sta     $ee
        cpx     near w7e3404                   ; branch if target is not quick
        bne     @0941
        lda     #$88                    ; set $3aa0.3 and $3aa0.7 (atb gauge is full, allow battle menu to open)
        tsb     $ee
@0941:  lda     $ee
        jsr     SetFlag0                 ; set bits in $3aa0
        lda     near wTargetMask,x
        bit     near w7e2f4c
        bne     CancelAction            ; try to add action to advance wait queue if character can't be targetted (zinger etc.)
        lda     near wTargetProp1::SeizeAttacker,x
        and     near wTargetProp1::CharmAttacker,x
        bpl     CancelAction            ; try to add action to advance wait queue if seize or charm attacker is valid
        peaflg  STATUS12, {DEAD, PETRIFY, ZOMBIE, SLEEP, CONFUSE, BERSERK}
        peaflg  STATUS34, {DANCE, HIDE, RAGE}
        txy
        jsr     CheckStatus
        bcc     CancelAction            ; try to add action to advance wait queue if status set
        lda     near wTargetProp2::w7e3aa0,x
        bpl     _09cd                   ; return if $3aa0.7 is clear (battle menu will not open)
        lda     near wTargetProp1::w7e32cc,x                 ; command list pointer
        bpl     _09cd                   ; return if character/monster has an action pending
        lda     near wTargetProp2::w7e3aa0,x
        ora     #$08
        sta     near wTargetProp2::w7e3aa0,x                 ; set $3aa0.3 (stop atb gauge)
        jmp     _c211ef                 ; open battle menu

; ------------------------------------------------------------------------------

; [ add pending run/control/psyche/seize action to advance wait queue ]

DisableATB:
_gaugedisable:
@0977:  longa
        lda     #$bfd3
        jsr     ClearFlag0       ; clear $3aa0.2, $3aa0.3, $3aa0.5, $3aa1.6
        shorta
        lda     #$01
        sta     near wTargetProp1::w7e3218_H,x     ; empty atb gauge
; fall through

; ------------------------------------------------------------------------------

; [  ]

CancelAction:
_cancelcommand:
@0986:  lda     #$f9        ; -> $3aa0 (clear $3aa0.1, $3aa0.2)
        xba
        lda     near wTargetProp3::w7e3ef9,x
        bit     #STATUS4::HIDE
        bne     @09a3       ; branch if hide status is set
        lda     near wTargetMask,x
        bit     near w7e2f4c
        bne     @09a3       ; branch if can't be targetted
        lda     near wTargetProp2::w7e3aa0,x
        bpl     @09a3
        lda     #$79        ; clear $3aa0.1, $3aa0.2, $3aa0.7 (don't skip advance wait, ogre nix can break, allow battle menu to open)
        xba
        jsr     _c24e66       ; add action to advance wait queue
@09a3:  xba
        jsr     ClearFlag0       ; clear flags in $3aa0
        cpx     #$08
        bcs     _09cd       ; return if a monster
        txa
        lsr
        sta     $10         ; character index
        lda     #BTL_GFX::CLOSE_MENU
        jmp     ExecBtlGfx

; ------------------------------------------------------------------------------

; [ start condemned counter ]

StartCondemn:
@09b4:  lda     $11af       ; attacker level
        jsr     RandA
        clc
        adc     $11af       ; a = level + (0..level-1)
        sta     $ee
        sec
        lda     #60         ; subtract from 60 (min 0)
        sbc     $ee
        bcs     @09c8
        clr_a
@09c8:  adc     #20
        sta     near wTargetProp2::w7e3b05,x     ; set condemned number
_09cd:  rts

; ------------------------------------------------------------------------------

; [ stop condemned counter ]

StopCondemn:
@09ce:  stz     near wTargetProp2::w7e3b05,x     ; clear condemned number
        rts

; ------------------------------------------------------------------------------

; [ update atb gauge constant ]

CalcSpeed:
@09d2:  php
        ldy     #$20
        lda     near wTargetProp3::w7e3ef8,x
        bit     #STATUS3::SLOW
        bne     @09e4
        ldy     #$40        ; y = haste/normal/slow constant (32/64/82)
        bit     #STATUS3::HASTE
        beq     @09e4
        ldy     #$54
@09e4:  tya
        sta     near wTargetProp2::w7e3add,x     ; set haste/normal/slow constant (for status counters)
        tya
        pha
        clc
        lsr
        adc     1,s       ; haste/normal/slow constant * 1.5
        sta     1,s
        lda     near wTargetProp2::Speed,x     ; speed + 20
        adc     #$14
        xba
        cpx     #$08
        bcc     @0a00       ; branch if a character
        lda     near w7e3a90       ; 255 - (battle_speed * 24)
        jsr     MultAB       ; b = (speed + 20) * (255 - (battle_speed * 24)) / 255 for monsters
@0a00:  pla                 ; b = (speed + 20) for characters
        jsr     MultAB       ; multiply b * (haste/normal/slow constant * 1.5)
        longa
        lsr4
        sta     near wTargetProp2::w7e3ac8,x     ; set atb gauge constant
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ clear all pending actions ]

; doesn't clear counterattacks

RemoveAllActions:
@0a0f:  jsr     RemoveAction
        lda     near wTargetProp1::w7e32cc,x     ; branch if character/monster still has actions pending
        bpl     @0a0f
        ldy     near w7e3a64       ; advance wait queue start
@0a1a:  txa
        cmp     near w7e3720,y     ; look for character in advance wait queue
        bne     @0a25
        lda     #$ff
        sta     near w7e3720,y     ; remove character
@0a25:  iny
        cpy     near w7e3a65
        bcc     @0a1a
        lda     near wTargetProp1::w7e3218_H,x     ; atb gauge
        bne     @0a38
        dec     near wTargetProp1::w7e3218_H,x
        lda     #$d3
        jsr     ClearFlag0       ; clear $3aa0.2, $3aa0.3, $3aa0.5
@0a38:  cpx     #$08        ; return if not a character
        bcs     _0a49
        lda     #ACTION_BATTLE_CMD::REVERT_CHAR_POSE
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; [ clear def. status ]

ClearDef:
@0a41:  lda     #$fd
; fallthrough

ClearFlag1:
@0a43:  and     near wTargetProp2::w7e3aa1,x     ; clear $3aa1.1
        sta     near wTargetProp2::w7e3aa1,x
_0a49:  rts

; ------------------------------------------------------------------------------

; [ update near-fatal relic effects ]

NearFatalEffect:
@0a4a:  lda     near wTargetProp2::w7e3aa0,x
        bit     #$10
        bne     @0a90       ; return if $3aa0.4 is set
        lda     #STATUS2::NEAR_FATAL
        bit     near wTargetProp3::w7e3ee5,x     ; current status 2
        beq     @0a90       ; return if not near fatal
        bit     near wTargetProp1::w7e3205,x
        beq     @0a90       ; return if $3205.1 is clear (near-fatal spell has already been cast this battle)
        eor     near wTargetProp1::w7e3205,x
        sta     near wTargetProp1::w7e3205,x     ; clear $3205.1
        lda     near wTargetProp2::RelicEffect5,x  ; RELIC_EFFECT5::SHELL_HP_LOW
        lsr
        bcc     @0a74       ; branch unless barrier ring or czarina ring equipped (casts shell)
        pha
        lda     #ATTACK::SHELL
        sta     zb8_L
        lda     #ACTION_BATTLE_CMD::IMMEDIATE_ACTION
        jsr     CreateImmediateAction
        pla
@0a74:  lsr                             ; RELIC_EFFECT5::SAFE_HP_LOW
        bcc     @0a82       ; branch unless mithril glove or czarina ring equipped (casts safe)
        pha
        lda     #ATTACK::SAFE
        sta     zb8_L
        lda     #ACTION_BATTLE_CMD::IMMEDIATE_ACTION
        jsr     CreateImmediateAction
        pla
@0a82:  lsr
        bcc     @0a90       ; branch unless ??? equipped (casts rflect)
        pha
        lda     #ATTACK::REFLECT
        sta     zb8_L
        lda     #ACTION_BATTLE_CMD::IMMEDIATE_ACTION
        jsr     CreateImmediateAction
        pla
@0a90:  rts

; ------------------------------------------------------------------------------

; [ clear all pending actions ]

; when gau appears on the veldt

ResetForVeldtGau:
@0a91:  ldx     #$06
@0a93:  lda     near wTargetMask,x     ; character mask
        bit     near w7e3a74_L
        beq     @0aa3       ; branch if character is not alive
        bit     near w7e3f2c       ; ignore characters that are temporarily out of combat ???
        bne     @0aa3
        jsr     RemoveAllActions
@0aa3:  dex2                ; next character
        bpl     @0a93
        rts

; ------------------------------------------------------------------------------

; [ update menu after morph/revert ]

UpdateMorph:
@0aa8:  lda     zb1         ; branch if counter attack
        lsr
        bcs     @0ab7
        lda     near wTargetProp1::w7e3218_H,x     ; atb gauge
        bne     @0ab7
        lda     #$88
        jsr     SetFlag0     ; set $3aa0.3 and $3aa0.7 (atb gauge full, battle menu can open)
@0ab7:  phx
        lda     near wTargetProp3::w7e3ef9,x     ; carry = inverse of morph status
        eor     #STATUS4::MORPH
        lsr4
        php
        clr_a
        adc     #$03
        sta     $ee         ; $ee = 3 if morphed, 4 if not morphed
        txa
        xba
        lda     #$06
        jsr     MultAB
        tax
        ldy     #$04
@0ad1:  lda     near wCmdList::CmdID,x
        cmp     $ee
        bne     @0add       ; look for morph or revert command in character's battle command list
        eor     #BATTLE_CMD::MORPH ^ BATTLE_CMD::REVERT
        sta     near wCmdList::CmdID,x     ; change from morph to revert or vice-versa
@0add:  inx3
        dey
        bne     @0ad1
        plp
        plx
        bcc     @0b01       ; branch if character is morphed

; revert
        php
        jsr     SaveMorphCounter
        lda     #$ff
        sta     near w7e3ee2       ; no character is morphed
        stz     near wTargetProp2::w7e3b04,x     ; morph gauge is not shown
        cpx     #$08
        bcs     @0afa       ; branch if a monster
        jsr     UpdateCmdList
@0afa:  longa
        stz     near w7e3f30       ; clear morph counter
        plp
        .a8
        rts

; morph
@0b01:  phx
        php
        lda     near w7e3ee2
        bpl     @0b33       ; return if a character is already morphed
        lda     near w7e3eb0 + 11
        lsr2
        ror
        bcs     @0b33       ; return if morph is permanent (phunbaba battle)
        asl
        stx     near w7e3ee2       ; set morphed character
        clr_a
        longa
        dec
        sta     near w7e3f30       ; morph counter
        ldx     $1cf6       ; sram morph counter
        jsr     Div
        bcc     @0b24       ; branch if morph lasts twice as long (after phunbaba battle)
        lsr
@0b24:  lsr3
        cmp     #$0800
        bcc     @0b2f
        lda     #$07ff
@0b2f:  inc
        sta     near wMorphRate
@0b33:  plp
        .a8
        plx
        rts

; ------------------------------------------------------------------------------

; [ update morph counter in SRAM ]

SaveMorphCounter:
@0b36:  lda     near w7e3ee2       ; morphed character
        bmi     @0b49       ; return if not valid
        lda     $1cf6       ; sram morph counter
        xba
        lda     near w7e3f30_H       ; battle morph counter
        jsr     MultAB
        xba
        sta     $1cf6       ; set remaining morph counter
@0b49:  rts

; ------------------------------------------------------------------------------

; [ remove all queued actions (quetzalli/palidor effect) ]

; X: pointer to character/monster data

QuetzEffect:
@0b4a:  longa
        lda     near wTargetMask,x
        tsb     near w7e3f2c       ;
        shorta
        lda     near wTargetProp2::w7e3aa0,x     ; stop atb gauge
        and     #$9b        ; clear $3aa0.2, $3aa0.5, $3aa0.6
        ora     #$08        ; set $3aa0.3
        sta     near wTargetProp2::w7e3aa0,x
        ldy     near w7e3a66       ; action queue start
@0b61:  txa
        cmp     near w7e3820,y     ; look for character/monster in action queue
        bne     @0b6c
        lda     #$ff
        sta     near w7e3820,y     ; remove all queued actions
@0b6c:  iny
        cpy     near w7e3a67
        bcc     @0b61
        lda     near wTargetProp1::w7e3205,x     ; clear $3205.7
        and     #$7f
        sta     near wTargetProp1::w7e3205,x
        stz     near wTargetProp2::w7e3ab4_H,x     ; clear advance wait counter
        lda     #224
        sta     near wTargetProp1::AdvanceWaitDur,x     ; set advance wait timer to $e0 (advance wait duration for jump)
        rts

; ------------------------------------------------------------------------------
