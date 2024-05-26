
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: battle/battle_main.asm                                               |
; |                                                                            |
; | description: battle program                                                |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"
.include "code_ext.inc"

; ------------------------------------------------------------------------------

.include "battle/ai_script.inc"
.include "gfx/battle_bg.inc"
.include "btlgfx/char_ai.inc"
inc_lang "text/monster_name_%s.inc"

.import BushidoLevelTbl, CharProp, LevelUpExp, LevelUpHP, LevelUpMP
.import RNGTbl, GenjuProp, ItemProp, NaturalMagic

; ------------------------------------------------------------------------------

.segment "battle_code"
.a8
.i16

; ------------------------------------------------------------------------------

Battle_ext:
@0000:  jmp     BattleMain

UpdateBattleTime_ext:
@0003:  jmp     UpdateBattleTime

UpdateEquip_ext:
@0006:  jmp     UpdateEquip

CalcMagicEffect_ext:
@0009:  jmp     CalcMagicEffect

; ------------------------------------------------------------------------------

; [ battle ]

BattleMain:
@000c:  php
        shortai
        lda     #$7e
        pha
        plb
        jsr     InitRAM

RestartBattle:
@0016:  jsr     InitBattle

; start of main battle loop
BattleLoop:
@0019:  inc     $be                     ; increment random number
        lda     $3402                   ; decrement quick counter
        bne     @0023
        dec     $3402
@0023:  lda     #$01                    ; battle graphics $01 (wait for vblank)
        jsr     ExecBtlGfx
        jsr     UpdateCharProp
        lda     $3a58                   ; branch if no menus need to be updated
        beq     @0033
        jsr     _c200cc
@0033:  lda     $340a                   ; immediate action
        cmp     #$ff
        jne     _c22163                   ; execute immediate action
        lda     #$04
        trb     $3a46
        beq     @0049                   ; branch if gau just appeared ($3a46.2)
        jsr     ResetForVeldtGau
        bra     @0019

; counterattack
@0049:  ldx     $3407                   ; current counterattacker
        bpl     @005f
@004e:  ldx     $3a68                   ; counterattack queue pointer
        cpx     $3a69
        beq     @0062
        inc     $3a68
        lda     $3920,x                 ; counterattack queue
        bmi     @004e                   ; continue if empty
        tax
@005f:  jmp     ExecRetal

;
@0062:  lda     $3a3a
        and     $2f2f
        beq     @006f
        trb     $2f2f
        bra     @0019
@006f:  lda     #$20
        trb     $b0
        beq     @007d
        jsr     UpdateMonsterGfxBuf
        lda     #$06                    ; battle graphics $06 (update monster names)
        jsr     ExecBtlGfx
@007d:  lda     #$04
        trb     $b0
        jsr     CheckBattleEnd
        lda     #$ff
        ldx     #$03
@0088:  sta     $33fc,x                 ; clear ??? targets
        dex
        bpl     @0088
        lda     #$01                    ; clear counterattack flag
        trb     $b1

; advance wait command
@0092:  ldx     $3a64                   ; advance wait queue start
        cpx     $3a65
        beq     @00a6                   ; branch if equal to advance wait queue end
        inc     $3a64                   ; increment advance wait queue start
        lda     $3720,x                 ; get next advance wait queue action
        bmi     @0092                   ; loop if no action
        tax
        jmp     _c22188                   ; execute advance wait action

; action
@00a6:  ldx     $3406                   ; currently acting character/monster
        bpl     @00c2                   ; branch if valid
@00ab:  ldx     $3a66                   ; action queue start
        cpx     $3a67                   ; branch if not equal to action queue end
        bne     @00b9
        stz     $3a95                   ; all actions are complete, allow battle to end
        jmp     @0019
@00b9:  inc     $3a66                   ; increment action queue pointer
        lda     $3820,x                 ; action queue
        bmi     @00ab                   ; branch if not a valid action
        tax
@00c2:  jmp     ExecAction

; ------------------------------------------------------------------------------

; [ fade out and terminate battle ]

TerminateBattle:
@00c5:  lda     #$09        ; battle graphics $09 (fade out and terminate battle)
        jsr     ExecBtlGfx
        plp
        rtl

; ------------------------------------------------------------------------------

; [ update menus ]

_c200cc:
_commandwrite:
@00cc:  ldx     #$06
@00ce:  lda     $3018,x     ; character mask
        trb     $3a58       ; disable menu update for character
        beq     @00df       ; skip if menu doesn't need to be updated
        stx     $10
        lsr     $10
        lda     #$0b        ; battle graphics $0b (update menu)
        jsr     ExecBtlGfx
@00df:  dex2                ; next character
        bpl     @00ce
        rts

; ------------------------------------------------------------------------------

; [ create advance wait action for jump ]

_00e4:  tsb     $3f2c
        shorta
        lda     $3aa0,x
        ora     #$08        ; set $3aa0.3
        and     #$df        ; clear $3aa0.5
        sta     $3aa0,x
        stz     $3ab5,x     ; clear advance wait counter
        jmp     _c24e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ execute action ]

; called when an action reaches the top of the queue
; x = pointer to character/monster data

ExecAction:
@00f9:  sec
        ror     $3406       ;
        pea     BattleLoop-1
@0100:  lda     #$12
        sta     $b5
        sta     $3a7c
        lda     $32cc,x     ; command list pointer
        bmi     @0183       ; branch if not valid
        asl
        tay
        lda     $3420,y     ; command index
        cmp     #$12
        bne     @0118       ; branch if not mimic
        jsr     _c201d9
@0118:  sec
        jsr     InitPlayerAction
        cmp     #$1f
        bne     @013e       ; branch if command is not $1f (random attack)
        jsr     RemoveAction
        lda     $3a97
        bne     @0134       ; branch if a colosseum battle
        lda     $3395,x
        bpl     @0134
        lda     $3ee5,x
        bit     #$30
        beq     @0139
@0134:  jsr     RandMonsterAction
        bra     @0100
@0139:  jsr     ExecMonsterAction
        bra     @0100
@013e:  cmp     #$16        ; branch if command is not $16 (jump)
        bne     @014e
        longa
        lda     $3018,x
        trb     $3f2c
        beq     _00e4       ; create advance wait action for jump
        shorta
@014e:  lda     $32cc,x     ; command list pointer
        tay
        lda     $3184,y     ; command list
        cmp     $32cc,x
        bne     @016d       ; branch if more than one action pending
        lda     #$80        ;
        trb     $b1
        lda     #$ff
        cpx     $3404
        bne     @016d       ; branch if target is not quick
        dec     $3402       ; decrement quick counter
        bne     @016d       ; branch if this wasn't the last quick action
        sta     $3404       ; clear quick target
@016d:  xba                 ; b = next pending action in command list ($ff if no actions pending)
        lda     $3aa0,x
        bit     #$50
        beq     @017a       ; branch if $3aa0.4 and $3aa0.6 are clear
        lda     #$80        ; set $3aa1.7
        jmp     SetFlag1
@017a:  lda     #$ff        ; clear entry in command list
        sta     $3184,y
        xba
        sta     $32cc,x     ; set new command list pointer ($ff if no actions pending)
@0183:  lda     $3aa0,x     ;
        and     #$d7        ; clear $3aa0.3 and $3aa0.5
        ora     #$40        ; set $3aa0.6
        sta     $3aa0,x
        lsr
        bcc     @01a6       ; branch if target is not present
        lda     $3204,x
        ora     #$04
        sta     $3204,x
        lda     $3205,x     ; set $3205.7
        ora     #$80
        sta     $3205,x
        jsr     ExecCmd
        jsr     SaveForMimic
@01a6:  lda     #$a0        ;
        tsb     $b0
        lda     #$10
        trb     $3a46
        bne     @01b7       ; branch if $3a46.4 is set (sonic dive)
        lda     $32cc,x     ; branch if target still has pending actions
        inc
        bne     @01d5
@01b7:  lda     $3aa0,x     ; $3aa0.3 branch if atb gauge is stopped
        bit     #$08
        bne     @01c6
        inc     $3219,x     ; reset atb gauge
        bne     @01c6
        dec     $3219,x
@01c6:  lda     #$ff
        sta     $322c,x     ; disable advance wait
        stz     $3ab5,x     ; clear advance wait counter
        lda     #$80        ;
        trb     $b0
        jmp     EndAction
@01d5:  stx     $3406       ; currently acting character/monster
_01d8:  rts

; ------------------------------------------------------------------------------

; [  ]

; replace mimic command with the previous command that is getting mimicked

_c201d9:
mimicreplace:
@01d9:  lda     $3f28
        cmp     #$16        ; branch if command wasn't jump
        bne     @01f1
        longa
        lda     $3f28
        sta     $3420,y
        lda     $3f2a
        sta     $3520,y
        shorta
        rts
@01f1:  longa
        lda     $3f20
        sta     $3420,y
        lda     $3f22
        sta     $3520,y
        shorta
        lda     $3f24
        cmp     #$12
        beq     _01d8                   ; return (can't mimic mimic)
        longa
        lda     $3f24                   ; copy command and attack
        sta     $3a7a
        lda     $3f26                   ; copy targets
        sta     $b8
        shorta
        lda     #$40
        tsb     $b1
        jmp     CreateNormalAction

; ------------------------------------------------------------------------------

; [ update mimic data ]

SaveForMimic:
_mimicinstall:
@021e:  phx
        php
        cpx     #$08
        bcs     @0264       ; return if attacker was a monster
        lda     $3a7c
        cmp     #$1e
        bcs     @0264       ; return for command >= $1e
        asl
        tax
        lda     f:BattleCmdProp,x   ; return if command can't be mimicked
        bit     #BATTLE_CMD_FLAG::MIMIC
        beq     @0264
        lda     #$12        ; command $12 (mimic)
        sta     $3f28
        lda     $3a7c       ; branch if command is $17 (x-magic)
        cmp     #$17
        beq     @0256
        lda     #$12
        sta     $3f24       ;
        longa
        lda     $3a7c       ; save last command/attack
        sta     $3f20
        lda     $3a30       ; save last targets
        sta     $3f22
        bra     @0264
@0256:  longa
        lda     $3a7c       ; save last command/attack (x-magic)
        sta     $3f24
        lda     $3a30       ; save last targets (x-magic)
        sta     $3f26
@0264:  plp
        .a8
        plx
        rts

; ------------------------------------------------------------------------------

; [ move character back after attacking ]

EndAction:
@0267:  lda     #$0d        ; battle script command $0d
        sta     $2d6e
        lda     #$ff        ; battle script command $ff (end of script)
        sta     $2d72
        lda     #$04        ; battle graphics $04 (execute battle script)
        jmp     ExecBtlGfx

; ------------------------------------------------------------------------------

; [ init queued action ]

; carry set: ???, carry clear: ???
; A: command (out)

InitPlayerAction:
@0276:  php
        longa
        lda     $3520,y     ; targets
        sta     $b8
        lda     $3420,y     ; command/attack
        sta     $3a7c
        sta     $b5
        plp
        .a8
        pha
        bcc     @029a       ; branch if ??? (carry set or cleared when subroutine called)
        cmp     #$1d
        bcs     @029a       ; branch if command >= $1d (magitek)
        lda     $3018,x     ; character mask
        trb     $3a4a       ; remove attacker from characters/monsters with changed status
        beq     @029a       ; branch if there were no changed statuses
        stz     $b8         ; clear targets ???
        stz     $b9
@029a:  lda     $3620,y     ; mp cost
        sta     $3a4c
        lda     $3ee4,x     ; current status 1
        bit     #$20
        beq     @02da       ; return if not imp
        lda     $b5
        cmp     #$1e        ; return if command >= $1e (ai)
        bcs     @02da
        phx
        asl
        tax
        lda     f:BattleCmdProp,x   ; battle command data
        plx
        bit     #BATTLE_CMD_FLAG::IMP
        bne     @02da       ; return if command can't be used by imp
        stz     $3a4c       ; clear mp cost
        phx
        clr_a
        cpx     #$08        ; check if attacker is a character or monster
        rol
        tax
        lda     $b8,x       ; get target byte ($b8 or $b9)
        and     $3a40,x     ; remove ally targets
        sta     $b8,x
        longa
        stz     $3a7c       ; change command to fight
        stz     $b5
        lda     $b8
        jsr     RandBit
        sta     $b8         ; random target
        shorta
        plx
@02da:  pla
        rts

; ------------------------------------------------------------------------------

; [ execute ai ]

ExecMonsterAction:
@02dc:  longa
        stz     $3a98
        lda     $3254,x
        sta     $f0
        lda     $3d0c,x
        sta     $f2
        lda     $3240,x
        sta     $f4
        clc
        jsr     ExecAI
        lda     $f2
        sta     $3d0c,x
        shorta
        lda     $f5
        sta     $3240,x
        rts

; ------------------------------------------------------------------------------

; [ remove next pending action from command list ]

RemoveAction:
@0301:  lda     $32cc,x     ; command list pointer
        bmi     @031b       ; return if no pending actions
        phy
        tay
        lda     $3184,y     ; command list
        cmp     $32cc,x
        bne     @0312       ; branch if multiple commands are pending
        lda     #$ff
@0312:  sta     $32cc,x     ; set new command list pointer ($ff if no commands pending)
        lda     #$ff
        sta     $3184,y     ; clear old command list slot
        ply
@031b:  rts

; ------------------------------------------------------------------------------

; [ create advance wait action ]

QueueAction:
@031c:  stz     $b8         ; clear targets
        stz     $b9
        inc     $322c,x     ; set the advance wait duration to zero, but only if is disabled
        beq     @0328
        dec     $322c,x
@0328:  jsr     ClearDef
        lda     $3e4c,x     ; clear runic and retort ($3e4c.0 and $3e4c.2)
        and     #$fa
        sta     $3e4c,x
        cpx     #$08
        bcc     @0344       ; branch if a character

; random monster action
        lda     $32cc,x
        bpl     @0357       ; branch if command list pointer is valid
        lda     #$1f        ; command $1f (random attack)
        sta     $3a7a
        jmp     CreateNormalAction

; random character action
@0344:  lda     $3018,x     ; character mask
        trb     $3a4a       ; clear in targets with changed status
        lda     $3255,x
        jpl     ExecMonsterAction

; no ai script
        lda     $32cc,x     ; command list pointer
        bmi     @037b       ; branch if no pending actions
@0357:  pha
        asl
        tay
        longa
        lda     $3520,y
        sta     $b8
        lda     $3420,y
        jsr     CalcCmdDelay
        lda     $b8
        sta     $3520,y
        shorta
        pla
        tay
        cmp     $3184,y     ; command list
        beq     @037a       ; return if this is the last pending action for this character/monster
        lda     $3184,y     ; check the next pending action
        bra     @0357
@037a:  rts

; no pending actions
@037b:  lda     $3ef8,x     ; status 3
        lsr
        bcs     RandDanceAction
        lda     $3ef9,x     ; status 4
        lsr
        bcs     RandRageAction
        lda     $3ee4,x     ; status 1
        bit     #$08
        bne     RandMagitekAction
        jsr     RandCharAction
        cmp     #$17
        bne     @03b0       ; branch if not x-magic
        pha
        xba
        pha
        pha
        txy
        jsr     RandMagic
        sta     $01,s
        pla
        xba
        lda     #$02
        jsr     CalcCmdDelay
        jsr     CreateNormalAction
        stz     $b8
        stz     $b9
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
        cmp     #$8c0c      ; roulette (lore/enemy skill)
        bne     @03c4
        lda     #$8c1e      ; roulette (ai)
@03c4:  plp
        .a8
        rts

; ------------------------------------------------------------------------------

; random magitek action
RandMagitekAction:
@03c6:  jsr     RandMagitek
        xba
        lda     #$1d
        bra     _03de

; random rage
RandRageAction:
@03ce:  txy
        jsr     RandRage
        xba
        lda     #$10
        bra     _03de

; random dance
RandDanceAction:
@03d7:  txy
        jsr     RandDance
        xba
        lda     #$13
_03de:  jsr     CalcCmdDelay
        jmp     CreateNormalAction

; ------------------------------------------------------------------------------

; [ set advance wait timer ]

CalcCmdDelay:
@03e4:  php
        shortai
        sta     $3a7a       ; command
        xba
        sta     $3a7b       ; attack
        xba
        cmp     #$1e        ; return if command >= $1e (ai)
        bcs     @041e
        pha
        phx
        tax
        lda     f:CmdDelayTbl,x   ; advance wait duration for command
        plx
        clc
        adc     $322c,x     ; add to advance wait duration (max $fe)
        bcs     @0404
        inc
        bne     @0406
@0404:  lda     #$ff
@0406:  dec
        sta     $322c,x
        pla
        jsr     InitTarget
        lda     #$04
        trb     $ba         ; clear "no retarget if target becomes invalid" flag
        longa
        lda     $b8         ;
        bne     @041e
        stz     $3a4e
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
        lda     $202e,y                 ; $f6 = command 1
        sta     $f6
        lda     $2031,y                 ; $f8 = command 2
        sta     $f8
        lda     $2034,y                 ; $fa = command 3
        sta     $fa
        lda     $2037,y                 ; $fc = command 4
        sta     $fc
        lda     #$05
        sta     $f5
        lda     $3ee5,x                 ; status 2
        asl2
        sta     $f4
        asl
        bpl     @0452                   ; branch if berserk
        stz     $f4
        bra     @045e
@0452:  lda     $3395,x                 ; charm attacker
        eor     #$80
        tsb     $f4
        lda     $3a97                   ; colosseum characters
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
        lda     $01,s                   ; command
        clc
        jsr     GetBitPtr
        and     f:BerserkCmdTbl,x
        bne     @0488
@0482:  lda     #$ff                    ; clear command
        sta     $01,s
        dec     $f5                     ; decrement number of available commands
@0488:  clr_a
        lda     $01,s                   ; command
        ldx     #$08
@048d:  cmp     f:RandCmdIDTbl,x
        bne     @0499
        jsr     (.loword(RandCmdTbl),x)
        xba
        bra     @04a9
@0499:  cmp     f:RandCmdIDTbl+1,x
        bne     @04a5
        jsr     (.loword(RandCmdTbl)+10,x)
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

; bitmask of muddled/charmed/colosseum commands:
;  fight, magic, morph, steal, capture, swdtech
;  tools, blitz, runic, lore, sketch
;  rage, mimic, dance, row, jump, x-magic
;  gp rain, health, shock, magitek
ConfusedCmdTbl:
@04d0:  .byte     $ed,$3e,$dd,$2d

; bitmask of berserk/zombie commands:
;  fight, capture, rage, jump, magitek
BerserkCmdTbl:
@04d4:  .byte     $41,$00,$41,$20

; commands with special code when used randomly
RandCmdIDTbl:
@04d8:  .byte     $02,$17,$07,$0a,$10,$13,$0c,$03,$1d,$09

; command special code jump pointers
RandCmdTbl:
@04e2:  .addr     RandMagic
        .addr     RandBushido
        .addr     RandRage
        .addr     RandLore
        .addr     RandMagitek
@04ec:  .addr     RandMagic
        .addr     RandBlitz
        .addr     RandDance
        .addr     RandMorph
        .addr     RandTools

; ------------------------------------------------------------------------------

; [ lore command (random) ]

RandLore:
@04f6:  lda     $3ee5,y
        bit     #$08
        bne     RandCmdInvalid
        lda     $3a87
        beq     RandCmdInvalid
        pha
        longa_clc
        lda     $302c,y
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
@051a:  lda     $3ee5,y
        bit     #$08
        bne     RandCmdInvalid
        lda     $3cf8,y
        beq     RandCmdInvalid
        pha
        longa
        lda     $302c,y
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
        sta     $03,s
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
@0560:  lda     $3ba4,y
        ora     $3ba5,y
        bit     #$02
        beq     RandCmdInvalid
        lda     $2020
        inc
        jsr     RandA
        clc
        adc     #$55        ; dispatch (first swdtech)
        rts

; ------------------------------------------------------------------------------

; [ blitz command (random) ]

RandBlitz:
@0575:  clr_a
        lda     $1d28       ; known blitzes
        jsr     RandBit
        jsr     GetBitID
        txa
        clc
        adc     #$5d        ; pummel (first blitz)
        rts

; ------------------------------------------------------------------------------

; [ magitek command (random) ]

RandMagitek:
@0584:  lda     #$03
        jsr     RandA
        clc
        adc     #$83        ; fire beam (first magitek)
        rts

; ------------------------------------------------------------------------------

; [ tools command (random) ]

RandTools:
@058d:  clr_a
        lda     $3a9b       ; tools owned
        jsr     RandBit
        jsr     GetBitID
        txa
        clc
        adc     #$a3        ; noiseblaster item (first tool)
        rts

; ------------------------------------------------------------------------------

; [ dance command (random) ]

RandDance:
@059c:  phx
        lda     $32e1,y
        cmp     #$ff
        bne     @05b2
        clr_a
        lda     $1d4c       ; known dances
        jsr     RandBit
        jsr     GetBitID
        txa
        sta     $32e1,y
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

.pushseg
.segment "dance_prop"

; cf/fe80
        .include "dance_prop.asm"

.popseg

; ------------------------------------------------------------------------------

; [ rage command (random) ]

RandRage:
@05d1:  phx
        php
        clr_a
        sta     $33a9,y
        lda     $33a8,y
        cmp     #$ff
        bne     @0600
        inc
        sta     $33a8,y
        lda     $3a9a
        jsr     RandA
        inc
        sta     $ee
        ldx     #$00
@05ed:  lda     $257e,x     ; known rages
        cmp     #$ff
        beq     @0600
        dec     $ee
        beq     @05fd
        inx
        bne     @05ed
        bra     @0600
@05fd:  sta     $33a8,y
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
        lda     $33a8,y
        tax
        xba
        lda     f:MonsterSpecialAnim,x
        sta     $3c81,y
        lda     #$20
        jsr     MultAB
        longi
        tax
        lda     f:MonsterProp+26,x
        sta     $3ca8,y
        sta     $3ca9,y
        jsr     LoadRageProp
        plp
        rts

; ------------------------------------------------------------------------------

; [ choose monster confused attack ]

RandMonsterAction:
@0634:  phx
        longai
        lda     $1ff9,x     ; monster id (actually $2001)
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
        lda     $3ee5,x
        bit     #$10
        beq     @0671
        lda     #$ee
        sta     $01,s
@0671:  pla
        jsr     GetCmdForAI
        jsr     CalcCmdDelay
        jmp     CreateNormalAction

; ------------------------------------------------------------------------------

; advance wait durations for each command
CmdDelayTbl:
@067b:  .byte   $10,$10,$20,$00,$00,$10,$10,$10,$10,$10,$10,$10,$20,$10,$10,$10
        .byte   $10,$10,$10,$10,$10,$10,$e0,$20,$10,$10,$20,$20,$10,$10,$00,$00

; ------------------------------------------------------------------------------

; [ update special status (seize, control, love token, etc.) ]

AfterAction1:
@069b:  ldx     #$12
@069d:  lda     $3aa0,x
        lsr
        bcc     @0700       ; $3aa0.0 branch if target is not present
        longa
        lda     $3018,x
        bit     $2f4e
        shorta
        bne     @0700       ; branch if target can't be targetted
        jsr     ValidateControl
        lda     $3ee4,x
        bit     #$82
        beq     @06bf       ; branch if target doesn't have wound or zombie status
        stz     $3bf4,x     ; set current hp to 0
        stz     $3bf5,x
@06bf:  lda     $3ee4,x
        bit     #$c2
        beq     @06cf       ; branch if target doesn't have wound, petrify, or zombie status
        lda     $3019,x
        tsb     $3a3a       ; target has died/escaped
        jsr     _c207c8
@06cf:  lda     $3ee4,x
        bpl     @0700       ; branch if target does not have wound status
        cpx     #$08
        bcs     @06e4       ; branch if a monster
        lda     $3ed8,x     ; actor index
        cmp     #$0e
        bne     @06e4       ; branch if not $0e (banon)
        lda     #$06        ; end of battle special event 3 (banon died)
        sta     $3a6e
@06e4:  jsr     CheckJump
        lda     $3ee4,x
        bit     #$02
        beq     @06f1       ; branch if target has zombie status
        jsr     FixDeadStatus
@06f1:  lda     $3ee4,x
        bpl     @0700       ; branch if target does not have wound status
        lda     $3ef9,x
        bit     #$04
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

; [ make jumping/seized character die when they land ]

CheckJump:
@0710:  longa
        lda     $3018,x
        bit     $3f2c       ; jump/seize targets
        shorta
        beq     @0727       ; return if not jump/seize
        jsr     FixDeadStatus
        lda     $3205,x     ; set air anchor effect ($3205.2)
        and     #$fb
        sta     $3205,x
@0727:  rts

; ------------------------------------------------------------------------------

; [ remove wound status (jumping/seized/zombie target) ]

FixDeadStatus:
@0728:  lda     $3ee4,x     ; remove wound status
        and     #$7f
        sta     $3ee4,x
        lda     $3204,x     ; don't remove all advance wait actions
        and     #$bf
        sta     $3204,x
        rts

; ------------------------------------------------------------------------------

; [ remove control status (target) ]

RemoveControlTarget:
@0739:  lda     $32b9,x     ; target controlling you
        cmp     #$ff
        beq     @0748       ; branch if not valid
        bpl     @0748       ; branch if msb set ???
        and     #$7f
        tay
        jsr     RemoveControlAttacker
@0748:  lda     $32b8,x     ; target you control
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
@075b:  lda     $3e4d,y     ; don't use control battle menu ($3e4d.0)
        and     #$fe
        sta     $3e4d,y
.endif
        lda     $3ef9,y     ; clear trance status
        and     #$ef
        sta     $3ef9,y
        lda     #$ff
        sta     $32b9,x     ; clear target controlling you (target)
        sta     $32b8,y     ; clear target you control (attacker)
        lda     $3019,x
        trb     $2f54       ; clear horizontal flip for targets being controlled
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
        lda     $3204,x
        ora     #$40
        sta     $3204,x     ; remove all advance wait actions
        lda     #$7f

ClearFlag0:
@0792:  and     $3aa0,x     ; clear $3aa0.7 (don't allow battle menu to open)
        sta     $3aa0,x
        rts

; ------------------------------------------------------------------------------

; [ life 3 effect (monster) ]

ReraiseEffect:
@0799:  and     #$fb
        sta     $3ef9,x     ; clear life 3 status
        lda     $3019,x     ; monster mask
        trb     $2f2f       ; make monster alive
        lda     #$30        ; attack $30 (life)
        sta     $b8
        lda     #$26        ; command $26 (attack with no caster)
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; [ update control status ]

ValidateControl:
@07ad:  peaflg  STATUS12, {DEAD, PETRIFY, ZOMBIE, BERSERK, CONFUSE, SLEEP}
        peaflg  STATUS34, {DANCE, STOP, RAGE, FROZEN}
        txy
        jsr     CheckStatus
        bcs     @07c7
        asl     $32b8,x     ; set msb of "target you control"
        sec
        ror     $32b8,x
        asl     $32b9,x     ; set msb of "target controlled by you"
        sec
        ror     $32b9,x
@07c7:  rts

; ------------------------------------------------------------------------------

; [ update zinger, love token, charm status ]

_c207c8:
_dead:
@07c8:  cpx     $33f9
        bne     @07f5       ; branch if not zinger target
        phx
        ldx     $33f8
        lda     $3019,x     ; entrance effects b2 is mask of affected monster
        sta     $b9
        lda     #$04        ; entrance effects b1 $04 (hide monsters but don't allow battle to end)
        sta     $b8
        ldx     #$00        ; entrance effects b0 $00 (enter/exit immediately)
        lda     #$24        ; command $24 (monster entrance/exit)
        jsr     CreateImmediateAction
        lda     #$02        ; entrance effects b1 $02 (revive monsters at current hp)
        sta     $b8
        ldx     #$08        ; entrance effects b0 $08 (fade in/out, top to bottom)
        lda     #$24        ; command $24 (monster entrance/exit)
        jsr     CreateImmediateAction
        lda     #$ff
        sta     $33f8
        sta     $33f9
        plx
@07f5:  lda     $336c,x     ; love token target
        bmi     @07fe       ; branch if a monster
        tay
        jsr     RemoveLoveToken
@07fe:  lda     $336d,x     ; love token attacker
        bmi     @080a       ;
        phx
        txy
        tax
        jsr     RemoveLoveToken
        plx
@080a:  lda     $3394,x
        bmi     @0813
        tay
        jsr     RemoveCharm
@0813:  lda     $3395,x
        bmi     @081f
        phx
        txy
        tax
        jsr     RemoveCharm
        plx
@081f:  cpx     $3404
        bne     @082c
        lda     #$ff
        sta     $3404
        sta     $3402
@082c:  rts

; ------------------------------------------------------------------------------

; [ clear love token status ]

RemoveLoveToken:
@082d:  lda     #$ff
        sta     $336c,x     ; clear love token target/attacker
        sta     $336d,y
        rts

; ------------------------------------------------------------------------------

; [ clear charm status ]

RemoveCharm:
@0836:  lda     #$ff
        sta     $3394,x     ; clear charm target/attacker
        sta     $3395,y
        rts

; ------------------------------------------------------------------------------

; [ update targets after each command ]

AfterAction2:
@083f:  ldx     #$12        ; loop through all characters/monsters
@0841:  lda     $3aa0,x
        lsr
        bcc     @08be       ; skip if $3aa0.0 is clear (target is not present)
        asl     $32e0,x     ; clear MSB of previous attacker byte
        lsr     $32e0,x
        lda     $3ee4,x
        bmi     @0859       ; branch if target has wound status
        lda     $3aa1,x
        bit     #$40
        beq     @085c       ; $3aa1.6 branch if no pending run/control/psyche/seize action
@0859:  jsr     DisableATB
@085c:  lda     $3204,x
        beq     @08ab
        lsr
        bcc     @0867
        jsr     QuetzEffect
@0867:  asl     $3204,x
        bcc     @086f
        jsr     UpdateEnabledMagic
@086f:  asl     $3204,x
        bcc     @087c
        jsr     RemoveAllActions
        lda     #$80
        jsr     SetFlag1       ; set $3aa1.7
@087c:  asl     $3204,x
        bcc     @0884
        jsr     StartCondemn
@0884:  asl     $3204,x
        bcc     @088c
        jsr     StopCondemn
@088c:  asl     $3204,x
        bcc     @0898
        cpx     #$08        ; skip if a monster
        bcs     @0898
        jsr     UpdateCmdList
@0898:  asl     $3204,x
        bcc     @08a0
        jsr     CalcSpeed
@08a0:  asl     $3204,x
        bcc     @08a8
        jsr     UpdateMorph
@08a8:  asl     $3204,x
@08ab:  jsr     CheckPlayerAction
        jsr     _c208c6
        lda     $3aa0,x
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
        lda     $3404
        bmi     @08d5       ; branch if there is no quick target
        cpx     $3404
        bne     _08c5       ; return if this target is not quick
@08d5:  lda     $3ee4,x
        bit     #$c0
        bne     _08c5       ; return if target has wound or petrify status
        lda     $3ef8,x
        bit     #$10
        bne     _08c5       ; return if target has stop status
        lda     #$ef
        jsr     ClearFlag0       ; clear $3aa0.4
        lda     $32b9,x
        bpl     _08c5       ; return if target controlling you msb clear
        lda     $3ee5,x
        bmi     _08c5       ; return if target has psyche status
        lda     $3ef9,x
        bit     #$02
        bne     _08c5       ; return if target has frozen status
        lda     $3359,x
        bpl     _08c5       ; return if seize attacker is valid
        lda     #$bf
        jsr     ClearFlag0       ; clear $3aa0.6
        lda     $3aa1,x
        bpl     _08c5       ; return if $3aa1.7 clear
        and     #$7f
        sta     $3aa1,x     ; clear $3aa1.7
        lda     $32cc,x     ; command list pointer
        inc
        beq     _08c5       ; return if there are no pending actions in the command list
        lda     $3aa1,x
        lsr
        jcs     _c24e77       ; add action to queue
        jmp     _c24e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ add pending advance wait action to queue ]

CheckPlayerAction:
_inputcheck:
@091f:  cpx     #$08
        bcs     _08c5                   ; return if a monster
        lda     $3ed8,x
        cmp     #CHAR::UMARO
        beq     _08c5                   ; return if umaro
        lda     $3255,x
        bpl     _08c5                   ; return if character has a valid ai script
        lda     $3a97
        bne     _08c5                   ; return if characters are in colosseum
        lda     #$02                    ; set $3aa0.1
        sta     $ee
        cpx     $3404                   ; branch if target is not quick
        bne     @0941
        lda     #$88                    ; set $3aa0.3 and $3aa0.7 (atb gauge is full, allow battle menu to open)
        tsb     $ee
@0941:  lda     $ee
        jsr     SetFlag0                 ; set bits in $3aa0
        lda     $3018,x
        bit     $2f4c
        bne     CancelAction            ; try to add action to advance wait queue if character can't be targetted (zinger etc.)
        lda     $3359,x
        and     $3395,x
        bpl     CancelAction            ; try to add action to advance wait queue if seize or charm attacker is valid
        peaflg  STATUS12, {DEAD, PETRIFY, ZOMBIE, SLEEP, CONFUSE, BERSERK}
        peaflg  STATUS34, {DANCE, HIDE, RAGE}
        txy
        jsr     CheckStatus
        bcc     CancelAction            ; try to add action to advance wait queue if status set
        lda     $3aa0,x
        bpl     _09cd                   ; return if $3aa0.7 is clear (battle menu will not open)
        lda     $32cc,x                 ; command list pointer
        bpl     _09cd                   ; return if character/monster has an action pending
        lda     $3aa0,x
        ora     #$08
        sta     $3aa0,x                 ; set $3aa0.3 (stop atb gauge)
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
        sta     $3219,x     ; empty atb gauge
; fall through

; ------------------------------------------------------------------------------

; [  ]

CancelAction:
_cancelcommand:
@0986:  lda     #$f9        ; -> $3aa0 (clear $3aa0.1, $3aa0.2)
        xba
        lda     $3ef9,x
        bit     #$20
        bne     @09a3       ; branch if hide status is set
        lda     $3018,x
        bit     $2f4c
        bne     @09a3       ; branch if can't be targetted
        lda     $3aa0,x
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
        lda     #$03        ; battle graphics $03 (close battle menu)
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
        sta     $3b05,x     ; set condemned number
_09cd:  rts

; ------------------------------------------------------------------------------

; [ stop condemned counter ]

StopCondemn:
@09ce:  stz     $3b05,x     ; clear condemned number
        rts

; ------------------------------------------------------------------------------

; [ update atb gauge constant ]

CalcSpeed:
@09d2:  php
        ldy     #$20
        lda     $3ef8,x
        bit     #$04
        bne     @09e4
        ldy     #$40        ; y = haste/normal/slow constant (32/64/82)
        bit     #$08
        beq     @09e4
        ldy     #$54
@09e4:  tya
        sta     $3add,x     ; set haste/normal/slow constant (for status counters)
        tya
        pha
        clc
        lsr
        adc     $01,s       ; haste/normal/slow constant * 1.5
        sta     $01,s
        lda     $3b19,x     ; speed + 20
        adc     #$14
        xba
        cpx     #$08
        bcc     @0a00       ; branch if a character
        lda     $3a90       ; 255 - (battle_speed * 24)
        jsr     MultAB       ; b = (speed + 20) * (255 - (battle_speed * 24)) / 255 for monsters
@0a00:  pla                 ; b = (speed + 20) for characters
        jsr     MultAB       ; multiply b * (haste/normal/slow constant * 1.5)
        longa
        lsr4
        sta     $3ac8,x     ; set atb gauge constant
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ clear all pending actions ]

; doesn't clear counterattacks

RemoveAllActions:
@0a0f:  jsr     RemoveAction
        lda     $32cc,x     ; branch if character/monster still has actions pending
        bpl     @0a0f
        ldy     $3a64       ; advance wait queue start
@0a1a:  txa
        cmp     $3720,y     ; look for character in advance wait queue
        bne     @0a25
        lda     #$ff
        sta     $3720,y     ; remove character
@0a25:  iny
        cpy     $3a65
        bcc     @0a1a
        lda     $3219,x     ; atb gauge
        bne     @0a38
        dec     $3219,x
        lda     #$d3
        jsr     ClearFlag0       ; clear $3aa0.2, $3aa0.3, $3aa0.5
@0a38:  cpx     #$08        ; return if not a character
        bcs     _0a49
        lda     #$2c        ; action $2c (set character graphical action to 0)
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; [ clear def. status ]

ClearDef:
@0a41:  lda     #$fd
; fallthrough

ClearFlag1:
@0a43:  and     $3aa1,x     ; clear $3aa1.1
        sta     $3aa1,x
_0a49:  rts

; ------------------------------------------------------------------------------

; [ update near-fatal relic effects ]

NearFatalEffect:
@0a4a:  lda     $3aa0,x
        bit     #$10
        bne     @0a90       ; return if $3aa0.4 is set
        lda     #$02
        bit     $3ee5,x     ; current status 2
        beq     @0a90       ; return if not near fatal
        bit     $3205,x
        beq     @0a90       ; return if $3205.1 is clear (near-fatal spell has already been cast this battle)
        eor     $3205,x
        sta     $3205,x     ; clear $3205.1
        lda     $3c59,x     ; relic effects 4
        lsr
        bcc     @0a74       ; branch unless barrier ring or czarina ring equipped (casts shell)
        pha
        lda     #$25        ; attack $25 (shell)
        sta     $b8
        lda     #$26        ; action $26 (spell with no caster)
        jsr     CreateImmediateAction
        pla
@0a74:  lsr
        bcc     @0a82       ; branch unless mithril glove or czarina ring equipped (casts safe)
        pha
        lda     #$1c        ; attack $1c (safe)
        sta     $b8
        lda     #$26        ; action $26 (spell with no caster)
        jsr     CreateImmediateAction
        pla
@0a82:  lsr
        bcc     @0a90       ; branch unless ??? equipped (casts rflect)
        pha
        lda     #$24        ; attack $24 (rflect)
        sta     $b8
        lda     #$26        ; action $26 (spell with no caster)
        jsr     CreateImmediateAction
        pla
@0a90:  rts

; ------------------------------------------------------------------------------

; [ clear all pending actions ]

; when gau appears on the veldt

ResetForVeldtGau:
@0a91:  ldx     #$06
@0a93:  lda     $3018,x     ; character mask
        bit     $3a74
        beq     @0aa3       ; branch if character is not alive
        bit     $3f2c       ; ignore characters that are temporarily out of combat ???
        bne     @0aa3
        jsr     RemoveAllActions
@0aa3:  dex2                ; next character
        bpl     @0a93
        rts

; ------------------------------------------------------------------------------

; [ update menu after morph/revert ]

UpdateMorph:
@0aa8:  lda     $b1         ; branch if counter attack
        lsr
        bcs     @0ab7
        lda     $3219,x     ; atb gauge
        bne     @0ab7
        lda     #$88
        jsr     SetFlag0     ; set $3aa0.3 and $3aa0.7 (atb gauge full, battle menu can open)
@0ab7:  phx
        lda     $3ef9,x     ; carry = inverse of morph status
        eor     #$08
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
@0ad1:  lda     $202e,x
        cmp     $ee
        bne     @0add       ; look for morph or revert command in character's battle command list
        eor     #$07
        sta     $202e,x     ; change from morph to revert or vice-versa
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
        sta     $3ee2       ; no character is morphed
        stz     $3b04,x     ; morph gauge is not shown
        cpx     #$08
        bcs     @0afa       ; branch if a monster
        jsr     UpdateCmdList
@0afa:  longa
        stz     $3f30       ; clear morph counter
        plp
        .a8
        rts

; morph
@0b01:  phx
        php
        lda     $3ee2
        bpl     @0b33       ; return if a character is already morphed
        lda     $3ebb
        lsr2
        ror
        bcs     @0b33       ; return if morph is permanent (phunbaba battle)
        asl
        stx     $3ee2       ; set morphed character
        clr_a
        longa
        dec
        sta     $3f30       ; morph counter
        ldx     $1cf6       ; sram morph counter
        jsr     Div
        bcc     @0b24       ; branch if morph lasts twice as long (after phunbaba battle)
        lsr
@0b24:  lsr3
        cmp     #$0800
        bcc     @0b2f
        lda     #$07ff
@0b2f:  inc
        sta     $3f32       ; set morph counter speed
@0b33:  plp
        .a8
        plx
        rts

; ------------------------------------------------------------------------------

; [ update morph counter in SRAM ]

SaveMorphCounter:
@0b36:  lda     $3ee2       ; morphed character
        bmi     @0b49       ; return if not valid
        lda     $1cf6       ; sram morph counter
        xba
        lda     $3f31       ; battle morph counter
        jsr     MultAB
        xba
        sta     $1cf6       ; set remaining morph counter
@0b49:  rts

; ------------------------------------------------------------------------------

; [ remove all queued actions (quetzalli/palidor effect) ]

; X: pointer to character/monster data

QuetzEffect:
@0b4a:  longa
        lda     $3018,x
        tsb     $3f2c       ;
        shorta
        lda     $3aa0,x     ; stop atb gauge
        and     #$9b        ; clear $3aa0.2, $3aa0.5, $3aa0.6
        ora     #$08        ; set $3aa0.3
        sta     $3aa0,x
        ldy     $3a66       ; action queue start
@0b61:  txa
        cmp     $3820,y     ; look for character/monster in action queue
        bne     @0b6c
        lda     #$ff
        sta     $3820,y     ; remove all queued actions
@0b6c:  iny
        cpy     $3a67
        bcc     @0b61
        lda     $3205,x     ; clear $3205.7
        and     #$7f
        sta     $3205,x
        stz     $3ab5,x     ; clear advance wait counter
        lda     #$e0
        sta     $322c,x     ; set advance wait timer to $e0 (advance wait duration for jump)
        rts

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
        lda     $3ee4,y
        asl
        bmi     @0bfa
        lda     $11a4
        sta     $f2
        lda     $11a2
        bit     #$08
        beq     @0bd3
        lda     $3c95,y
        bpl     @0bbf
        lda     $11aa
        bit     #$82
        bne     @0c2b
        stz     $f2
        bra     @0bc6
@0bbf:  lda     $3ee4,y
        bit     #$02
        beq     @0bd3
@0bc6:  lda     $11a4
        bit     #$02
        beq     @0bd3       ; branch if not a drain attack
        lda     $f2
        eor     #$01
        sta     $f2
@0bd3:  lda     $11a1
        beq     @0c1e
        lda     $3ec8
        eor     #$ff
        and     $11a1
        beq     @0bfa
        lda     $3bcc,y
        bit     $11a1
        beq     @0bf2
        lda     $f2
        eor     #$01
        sta     $f2
        bra     @0c1e
@0bf2:  lda     $3bcd,y
        bit     $11a1
        beq     @0c00
@0bfa:  stz     $f0
        stz     $f1
        bra     @0c1e
@0c00:  lda     $3be1,y
        bit     $11a1
        beq     @0c0e
        lsr     $f1
        ror     $f0
        bra     @0c1e
@0c0e:  lda     $3be0,y
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
        lda     $3a82
        and     $3a83
        bpl     @0c5d       ; branch if blocked by golem or interceptor
        lda     $3ee4,x
        bit     #$02
        beq     @0c45       ; branch if attacker is not a zombie
        jsr     ZombieEffect
@0c45:  lda     $11ab
        eor     #$a0
        and     #$a0
        and     $3ee5,y     ; remove sleep and muddled status from target
        ora     $3dfd,y
        sta     $3dfd,y
        lda     $32b9,y     ; invalidate target's controller
        ora     #$80
        sta     $32b9,y
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
        lda     $33d0,y     ; damage taken/healed
        inc
        beq     @0c8b       ; branch if it's $ffff (no damage)
        dec
@0c8b:  clc
        adc     $f0         ; add damage
        bcs     @0c95       ; branch on overflow
        cmp     #10000
        bcc     @0c98       ; branch if less than 10,000
@0c95:  lda     #9999       ; cap at 9999
@0c98:  sta     $33d0,y     ; set damage taken/healed
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
        lda     $3414
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
        lda     $3bb9,y
        bcc     @0cd4
        lda     $3bb8,y
@0cd4:  inc
        beq     @0ce7
        xba
        lda     $3a82
        and     $3a83
        bmi     @0ce3
        lda     #$c1
        xba
@0ce3:  xba
        dec
        eor     #$ff
@0ce7:  sta     $e8
        jsr     MultDmg
        lda     $01,s
        lsr
        lda     $3ef8,y
        bcs     @0cf5
        asl
@0cf5:  asl
        bpl     @0cff
        lda     #$aa
        sta     $e8
        jsr     MultDmg
@0cff:  plp
        bcc     @0d17
        lda     $3aa1,y
        bit     #$02
        beq     @0d0d       ; branch if $3aa1.1 is clear
        lsr     $f1
        ror     $f0
@0d0d:  bit     #$20
        beq     @0d22
        lsr     $f1
        ror     $f0
        bra     @0d22
@0d17:  lda     $3ef9,y
        bit     #$08
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
        lda     $11a4
        lsr
        bcs     @0d85
        lda     $11a3
        bmi     @0d5a
        lda     $11a2
        lsr
@0d5a:  longa
        lda     $11b0
        sta     $ee
        lda     $3c44,x
        shorta
        bcs     @0d6e
        bit     #$02
        bne     @0d75
        xba
        lsr
@0d6e:  lsr
        bcc     @0d85
        lsr     $ef
        ror     $ee
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
        lda     $33d0,y
        inc
        beq     @0d93
        dec
@0d93:  sta     $ee
        shorta
        jsr     FixMPDmg
        lda     $11a6
        sta     $e8
        lda     $b5
        cmp     #$01
        beq     @0dab
        lda     $11a2
        lsr3
@0dab:  longa
        bcs     @0dba
        sec
        lda     $3bf4,y
        sbc     $ee
        bcs     @0dbd
        clr_a
        bra     @0dbd
@0dba:  lda     $3c1c,y
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
        lda     $3414
        bpl     @0e1d       ; branch if damage modification is disabled
        longa
        lda     $f2
        lsr
        bcc     @0e02
        phx
        tyx
        ply
@0e02:  lda     $3bf4,y
        cmp     $f0
        bcs     @0e0b
        sta     $f0
@0e0b:  lda     $b1
        bpl     @0e1d
        txy
        sec
        lda     $3c1c,y
        sbc     $3bf4,y
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
@0e32:  ora     $3dd4,y
        sta     $3dd4,y
        rts

; ------------------------------------------------------------------------------

; [ calculate atma weapon damage ]

UltimaEffect:
@0e39:  php
        phx
        phy
        txy
        lda     $3bf5,y     ; b = current hp (hi byte) + 1
        inc
        xba
        lda     $3b18,y     ; a = level
        jsr     MultAB       ; a = (current hp + 1) * level
        ldx     $3c1d,y     ; x = max hp (hi byte) + 1
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
@0e6e:  stx     $b7         ; set atma weapon length ($5b or $5c -> $626a)
        jsr     _c235bb
@0e73:  ply
        plx
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ update character battle stats ]

; A: character number

UpdateEquip:
@0e77:  phx
        phy
        phb
        php
        shortai
        pha
        and     #$0f
        lda     #$7e
        pha
        plb
        pla
        ldx     #$3e
@0e87:  stz     $11a0,x                 ; clear $11a0-$11de
        dex
        bpl     @0e87
        inc                             ; increment character number
        xba
        lda     #$25
        jsr     MultAB
        longi
        tax
        lda     $15db,x                 ; actor number
        xba
        lda     #$16
        jsr     MultAB
        phx
        tax
        lda     f:CharProp+10,x         ; battle power
        sta     $11ac
        sta     $11ad
        longa
        lda     f:CharProp+11,x         ; defense & magic defense
        sta     $11ba
        lda     f:CharProp+13,x         ; evade & magic block
        shorta
        sta     $11a8
        xba
        sta     $11aa
        lda     f:CharProp+21,x         ; run factor
        and     #RUN_FACTOR_MASK
        eor     #RUN_FACTOR_MASK
        inc2
        sta     $11dc
        plx
        ldy     #$0006                  ; magic power, stamina, speed, and vigor
@0ed3:  lda     $15f5,x
        sta     $11a0,y
        inx
        dey2
        bpl     @0ed3
        lda     $15eb,x                 ; current status 1
        sta     $fe
        ldy     #5
@0ee6:  lda     $15fb,x                 ; equipment
        sta     $11c6,y
        jsr     CalcEquipEffect
        dex
        dey
        bpl     @0ee6                   ; next item
        lda     $15ed,x                 ; high byte of mp
        and     #$3f
        sta     $ff
        lda     #$40
        jsr     CheckHPBoost
        ora     $ff
        sta     $15ed,x
        lda     $15e9,x                 ; high byte of hp
        and     #$3f
        sta     $ff
        lda     #$08
        jsr     CheckHPBoost
        ora     $ff
        sta     $15e9,x
        ldx     #$000a                  ; get high byte of each stat
@0f18:  lda     $11a1,x
        beq     @0f26                   ; branch if 0
        asl
        clr_a
        bcs     @0f23                   ; branch if negative (set to 0)
        lda     #$ff                    ; max 255
@0f23:  sta     $11a0,x
@0f26:  dex                             ; next stat
        dex
        bpl     @0f18
        ldx     $11ce                   ; weapon hands
        jsr     (.loword(UpdateEquipTbl),x)
        lda     $11d7                   ; hyper wrist effect
        bpl     @0f42
        longa
        lda     $11a6                   ; vigor *= 1.5
        lsr
        clc
        adc     $11a6
        sta     $11a6
@0f42:  plp
        .a8
        plb
        ply
        plx
        rtl

; ------------------------------------------------------------------------------

; 2-handed weapon effects jump table
UpdateEquipTbl:
@0f47:  .addr   UpdateEquip_00
        .addr   UpdateEquip_01
        .addr   UpdateEquip_02
        .addr   UpdateEquip_03
        .addr   UpdateEquip_04
        .addr   UpdateEquip_05
        .addr   UpdateEquip_06
        .addr   UpdateEquip_07
        .addr   UpdateEquip_08
        .addr   UpdateEquip_09
        .addr   UpdateEquip_0a
        .addr   UpdateEquip_0b
        .addr   UpdateEquip_0c

; ------------------------------------------------------------------------------

; [ update 2-handed weapon effects ]

; $01: weapon in off-hand, $04: unarmed in main hand
UpdateEquip_01:
UpdateEquip_04:
@0f61:  jsr     Disable2Hand

; $09: unarmed in main hand, weapon in off hand
UpdateEquip_09:
@0f64:  stz     $11ac       ; main hand battle power = 0 (attack with off-hand)

; $00, $05, $07, $0a, $0b: impossible combinations
UpdateEquip_00:
UpdateEquip_05:
UpdateEquip_07:
UpdateEquip_0a:
UpdateEquip_0b:
@0f67:  rts

; $02: weapon in main hand, $08: unarmed in main hand, $0c: unarmed in both hands
UpdateEquip_02:
UpdateEquip_08:
UpdateEquip_0c:
@0f68:  jsr     Disable2Hand

; $06: weapon in main hand, unarmed in off-hand
UpdateEquip_06:
@0f6b:  stz     $11ad       ; off-hand battle power = 0 (attack with main hand)
        rts

; $03: weapon in main hand and off-hand (genji glove)
UpdateEquip_03:
@0f6f:  lda     #$10
        tsb     $11cf

Disable2Hand:
@0f74:  lda     #$40
        trb     $11da
        trb     $11db
        rts

; ------------------------------------------------------------------------------

; [ update hp/mp boost flag ]

CheckHPBoost:
@0f7d:  bit     $11d5
        beq     @0f85
        lda     #$80        ; +50%
        rts
@0f85:  lsr
        bit     $11d5
        beq     @0f8e
        lda     #$40        ; +25%
        rts
@0f8e:  asl2
        bit     $11d5
        beq     @0f98
        lda     #$c0        ; +12.5%
        rts
@0f98:  clr_a               ; no boost
        rts

; ------------------------------------------------------------------------------

; [ update equipped item effects ]

; A: item number

CalcEquipEffect:
@0f9a:  phx
        phy
        xba
        lda     #$1e                    ; multiply by 30 to get pointer to item data
        jsr     MultAB
        tax
        lda     f:ItemProp+5,x          ; field effects
        tsb     $11df
        longa
        lda     f:ItemProp+6,x          ; status 1 & 2 protection
        tsb     $11d2
        lda     f:ItemProp+8,x          ; status 3 set and relic effects
        tsb     $11d4
        lda     f:ItemProp+10,x         ; relic effects
        tsb     $11d6
        lda     f:ItemProp+12,x
        tsb     $11d8
        lda     f:ItemProp+16,x         ; stat boosts
        ldy     #$0006
@0fcf:  pha
        and     #$000f
        bit     #$0008
        beq     @0fdc                   ; branch if positive boost
        eor     #$fff7
        inc
@0fdc:  clc
        adc     $11a0,y                 ; add to stat
        sta     $11a0,y
        pla
        lsr4
        dey2
        bpl     @0fcf
        lda     f:ItemProp+26,x         ; evade/mblock
        phx
        pha
        and     #$000f
        asl
        tax
        lda     f:EquipEvadeTbl,x       ; add boost value
        clc
        adc     $11a8
        sta     $11a8
        pla
        and     #$00f0
        lsr3
        tax
        lda     f:EquipEvadeTbl,x
        clc
        adc     $11aa
        sta     $11aa
        plx
        shorta
        lda     f:ItemProp+20,x         ; battle/defense power
        xba
        lda     f:ItemProp+2,x          ; imp bit
        asl2
        lda     $fe
        bcs     @1029                   ; branch if imp item
        eor     #STATUS1::IMP           ; toggle imp status
@1029:  bit     #STATUS1::IMP
        bne     @1030                   ; branch if imp
        lda     #$01
        xba
@1030:  xba
        sta     $fd                     ; $fd = battle/defense power (or 0 if imp)
        lda     f:ItemProp,x            ; item type
        and     #$07
        dec
        beq     @10b2                   ; branch if weapon

; shield, helmet, armor, or relic
        lda     f:ItemProp+25,x         ; status 2 set
        tsb     $11bc
        lda     f:ItemProp+15,x         ; elements halved
        xba
        lda     f:ItemProp+24,x         ; element weak point
        longa
        tsb     $11b8
        lda     f:ItemProp+22,x         ; absorbed and nullified elements
        tsb     $11b6
        shorta
        clc
        lda     $fd
        adc     $11ba                   ; add item defense to character defense
        bcc     @1064
        lda     #$ff                    ; max 255
@1064:  sta     $11ba
        clc
        lda     f:ItemProp+21,x         ; add item magic defense to character magic defense
        adc     $11bb
        bcc     @1073
        lda     #$ff                    ; max 255
@1073:  sta     $11bb

; weapon jumps back in here
@1076:  ply
        lda     #$02                    ; clear earrings effect
        trb     $11d5                   ; clear double earring effect
        beq     @1086
        tsb     $11d7                   ; set single earring effect
        beq     @1086
        tsb     $11d5                   ; set double earring effect
@1086:  clr_a
        lda     f:ItemProp+27,x         ; block animation
        sta     $11be,y
        bit     #$0c
        beq     @10b0                   ; branch if item can't block
        pha
        and     #$03                    ; block graphic
        tax
        clr_a
        sec
@1098:  rol                             ; a = 1 << block graphic index
        dex
        bpl     @1098
        xba
        pla
        bit     #$04
        beq     @10a7                   ; branch if item doesn't block physical attacks
        xba
        tsb     $11d0                   ; set physical block graphic
        xba
@10a7:  bit     #$08
        beq     @10b0                   ; branch if item doesn't block magic attacks
        xba
        tsb     $11d1                   ; set magical block graphic
        xba
@10b0:  plx
        rts

; weapon
@10b2:  clr_a
        inc
        tay
        inc
        sta     $ff
        lda     $01,s                   ; item slot
        cmp     #$02
        bcs     @1076                   ; branch if not in a hand
        dec
        beq     @10c4                   ; branch if off-hand
        dey
        asl     $ff
@10c4:  lda     $11c6,y                 ; weapon number
        inc
        bne     @10ce                   ; branch if not unarmed
        asl     $ff
        asl     $ff
@10ce:  lda     $ff
        tsb     $11ce                   ; set weapon hand bit
        lda     f:ItemProp+22,x         ;
        sta     $11b2,y
        lda     f:ItemProp+15,x         ; elemental properties
        sta     $11b0,y
        lda     $fd
        adc     $11ac,y                 ; add item battle power to character battle power
        bcc     @10ea
        lda     #$ff                    ; max 255
@10ea:  sta     $11ac,y
        lda     f:ItemProp+21,x         ; hit rate
        sta     $11ae,y
        lda     f:ItemProp+18,x         ; spell cast
        sta     $11b4,y
        lda     f:ItemProp+19,x         ; weapon special effects
        sta     $11da,y
        jmp     @1076

; ------------------------------------------------------------------------------

; evade/mblock boost values
EquipEvadeTbl:
@1105:  .word   0
        .word   10
        .word   20
        .word   30
        .word   40
        .word   50
        .word   .loword(-10)
        .word   .loword(-20)
        .word   .loword(-30)
        .word   .loword(-40)
        .word   .loword(-50)

; ------------------------------------------------------------------------------

; [ update battle time ]

UpdateBattleTime:
@111b:  php
        shortai
        jsr     GetPlayerAction
        lda     $2f41       ; check if battle time is stopped by battle program
        and     $3a8f       ; wait mode
        bne     @118b
        lda     $3a6c       ; previous frame counter value
        ldx     #$02
@112e:  cmp     $0e         ; current frame counter value
        beq     @1190       ; return if less than 2 frames have elapsed
        inc
        dex
        bne     @112e
        inc     $3a3e       ; increment turn counter
        bne     @113e
        inc     $3a3f
@113e:  jsr     DecCounters
        ldx     #$12
@1143:  cpx     $3ee2
        bne     @114b
        jsr     DecMorphCounter
@114b:  lda     $3aa0,x
        lsr
        bcc     @1184       ; branch if $3aa0.0 is clear
        cpx     $33f8
        beq     @1184
        bit     #$3a
        bne     @1184
        bit     #$04
        beq     @117c
        lda     $2f45
        beq     @1179
        lda     $3ee4,x
        bit     #$02
        bne     @1179
        lda     $3018,x
        beq     @1179
        bit     $3f2c
        bne     @1179
        bit     $3a40
        beq     @117c
@1179:  jsr     _c21193
@117c:  lda     $3219,x
        beq     @1184       ; branch if atb gauge is full
        jsr     _c211bb
@1184:  dex2                ; next target
        bpl     @1143
        jsr     UpdateCounterGfxBuf
@118b:  lda     $0e         ; current frame counter value
        sta     $3a6c       ; previous frame counter value
@1190:  clr_a
        plp
        .i16
        rtl

; ------------------------------------------------------------------------------

; [ update advance wait counter ]

_c21193:
gaugefull:
@1193:  longa
        lda     $3ac8,x     ; atb gauge constant / 2
        lsr
        clc
        adc     $3ab4,x     ; add to atb gauge counter
        sta     $3ab4,x
        shorta
        bcs     @11aa       ; branch if it overflowed
        xba
        cmp     $322c,x
        bcc     _11ba       ; return if less than advance wait duration
@11aa:  lda     #$ff
        sta     $322c,x     ; disable advance wait
        jsr     _c24e77       ; add action to queue
        lda     #$20

SetFlag0:
@11b4:  ora     $3aa0,x     ; set $3aa0.5
        sta     $3aa0,x
_11ba:  rts

; ------------------------------------------------------------------------------

; [ update atb gauge ]

_c211bb:
actioncounter:
        .i8
@11bb:  longa_clc
        lda     $3218,x     ; atb gauge %
        adc     $3ac8,x     ; add atb constant
        sta     $3218,x
        shorta
        bcc     _11ba       ; return if it didn't overflow
        cpx     #$08
        bcs     @11d1       ; branch if a monster
        jsr     CreateRunAwayAction
@11d1:  stz     $3219,x     ; clear atb gauge %
        stz     $3ab5,x     ; clear advance wait counter
        lda     #$ff
        sta     $322c,x     ; disable advance wait
        lda     #$08
        bit     $3aa0,x
        bne     @11ea       ; branch if $3aa0.3 is set
        jsr     SetFlag0     ; set $3aa0.3
        bit     #$02
        beq     _120e       ; branch if $3aa0.1 is clear (advance wait is enabled)
@11ea:  lda     #$80
        jsr     SetFlag0     ; set $3aa0.7 (allow battle menu to open)
; fall through

; ------------------------------------------------------------------------------

; [ open battle menu (character) or add action to advance wait queue (monster) ]

_c211ef:
_inputwindowopen:
@11ef:  cpx     #$08
        bcs     _120e       ; branch if a monster
        lda     $3205,x
        bpl     _11ba       ; return if $3205.7 is clear
        lda     $b1
        bmi     _11ba       ; return if battle menus are disabled
        lda     #$04
        jsr     SetFlag0     ; set $3aa0.2 (ogre nix can't break)
.if LANG_EN
        lda     $3e4d,x     ; set carry if using control battle menu ($3e4d.0)
        lsr
.else
        lda     $3ef9,x
        asl4
.endif
        txa
        ror
        sta     $10         ; $10 = attacker, msb set if using control
        lda     #$02        ; battle graphics $02 (open battle menu)
        jmp     ExecBtlGfx

autocommand:
_120e:  jmp     _c24e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ decrement morph counter ]

DecMorphCounter:
@1211:  longa
        sec
        lda     $3f30       ; morph counter
        sbc     $3f32       ; subtract morph counter speed
        sta     $3f30
        shorta
        bcs     @1234       ; branch if counter didn't expire
        stz     $3f31       ; clear morph counter
        jsr     SaveMorphCounter
        lda     #$ff
        sta     $3ee2       ; clear morphed character index
        lda     #$04
        sta     $3a7a       ; command $04 (revert)
        jsr     CreateRetalAction
@1234:  lda     $3f31
        sta     $3b04,x     ; update visible morph gauge value
        rts

; ------------------------------------------------------------------------------

; [ check true knight/love token (cover effect) ]

CoverEffect:
        .a16
@123b:  phx
        php
        lda     $b2
        bit     #$0002
        bne     @12a5       ; return if not critical
        lda     $b8
        beq     @12a5       ; return if there are no targets
        ldy     #$ff
        sty     $f4         ; $f4 = bodyguard target
        jsr     BitToTargetID
        sty     $f8         ; $f8 = original target
        stz     $f2         ; +$f2 = hp of bodyguard target with highest hp remaining
        phx
        ldx     $336c,y
        bmi     @125f       ; branch if bodyguard target is invalid
        jsr     CheckCoverTarget
        jsr     SetCoverTarget
@125f:  plx
        lda     $3ee4,y
        bit     #$0200
        beq     @12a5
        bit     #$0010
        bne     @12a5
        lda     $3358,y
        bpl     @12a5       ; return if seize target is valid
        lda     #$000f      ; +$f0 = character bit masks
        cpy     #$08
        bcc     @127c       ; branch if a character
        lda     #$3f00
@127c:  sta     $f0         ; +$f0 = monster bit masks
        lda     $3018,y
        ora     $3018,x
        trb     $f0
        ldx     #$12
@1288:  lda     $3c58,x
        bit     #$0040
        beq     @129a       ; branch if no true knight
        lda     $3018,x
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
        sty     $a8
        lsr     $a8
        php
        longa
        lda     $3018,x
        sta     $b8
        plp
        .a8
@12bf:  rts

; ------------------------------------------------------------------------------

; [ check true knight/love token target ]

CheckCoverTarget:
@12c0:  php
        longa
        lda     $3aa0,x
        lsr
        bcc     @12f3       ; branch if $3aa0.0 is clear (target is not present)
        lda     $32b8,x
        bpl     @12f3       ; branch if controlling something
        lda     $3358,x
        bpl     @12f3
        lda     $3ee4,x
        bit     #$a0d2
        bne     @12f3
        lda     $3ef8,x
        bit     #$3210
        bne     @12f3
        lda     $3018,x
        tsb     $a6
        lda     $3bf4,x     ; current hp
        cmp     $f2
        bcc     @12f3
        sta     $f2
        stx     $f4
@12f3:  plp
        .a8
        rts

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
@1300:  jsr     (.loword(ApplyDmgTbl),x)   ; hp/mp damage
        shorta
        bcc     @131c       ; return if target didn't die
        lda     $02,s       ; attacker
        tax
        stx     $ee
        jsr     _c2362f       ; save previous attacker
        cpy     $ee
        beq     @131c       ; branch if attacker was target
        sta     $327c,y     ; set target that just attacked you
        lda     $3018,y
        trb     $3419       ; disable black belt effect
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
        adc     $3bf4,y
        bcs     @1335
        cmp     $3c1c,y
        bcc     @1338
@1335:  lda     $3c1c,y
@1338:  sta     $3bf4,y
_133b:  clc
_133c:  rts
_133d:  eor     #$ffff
        sta     $ee
        lda     $3bf4,y
        sbc     $ee
        sta     $3bf4,y
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
        adc     $3c08,y     ; add to current mp
        bcs     @1362
        cmp     $3c30,y
        bcc     @1365
@1362:  lda     $3c30,y
@1365:  sta     $3c08,y
        clc
        bra     @138a
@136b:  eor     #$ffff
        sta     $ee
        lda     $3c08,y     ; subtract from current mp
        sbc     $ee
        sta     $3c08,y
        beq     @137c
        bcs     @138a
@137c:  clr_a
        sta     $3c08,y
        lda     $3c95,y
        lsr
        bcc     @1389       ; branch if target doesn't die at 0 mp
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
        stx     $3a89       ; disable random weapon spellcast
        sta     $3bf4,y     ; set current hp to zero
        lda     $3ee4,y
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
@13a7:  lda     $33d0,y     ; damage taken
        inc
        beq     @13bc       ; branch if invalid
        lda     $3018,y
        bit     $3a3c
        beq     @13b9       ; branch if target is not invincible
        clr_a
        sta     $33d0,y
@13b9:  lda     $33d0,y     ; damage taken
@13bc:  sta     $ee
        lda     $3a81       ; golem block targets ($3a82)
        and     $3a82       ; dog block targets ($3a83)
        bmi     @13c8       ; branch if both are invalid
        stz     $ee         ; 0 damage taken
@13c8:  lda     $33e4,y     ; damage healed
        inc
        beq     @13cf
        dec
@13cf:  sec
        sbc     $ee
        rts
        .a8

; ------------------------------------------------------------------------------

; [ execute command ]

ExecCmd:
_dispatcher:
@13d3:  phx
        php
        jsr     InitGfxScript
        lda     #$10
        tsb     $b0         ; disable pre-magic swirly animation
        lda     #$06
        sta     $b4         ; battle script command $06 (show battle animation)
        stz     $bd         ; clear extra damage multiplier
        stz     $3a89       ; disable random weapon spellcast
        stz     $3ec9       ; clear number of targets
        stz     $3a8e       ; disable dragon horn effect
        txy
        lda     #$ff        ; set lots of flags
        sta     $b2
        sta     $b3
        ldx     #$0f
@13f4:  sta     $3410,x     ; clear some variables
        dex
        bpl     @13f4
        lda     $b5         ; command
        asl
        tax
        jsr     (.loword(CmdTbl),x)
        lda     #$ff
        sta     $3417       ; clear character using sketch
        jsr     _c2629b       ; add battle script command to queue
        jsr     AfterAction1
        jsr     CheckRetal
        jsr     CheckDeadMonsters
        lda     #$04        ; battle graphics $04 (execute battle script)
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
@142b:  lda     $3021,x     ; monster mask
        bit     $3a3a
        beq     @144a       ; skip if monster is still alive
        xba
        lda     $3f01,x     ; status 4
        bit     #STATUS4::HIDE
        bne     @1446       ; mark monster as dead if it has hide status
        lda     $3e54,x
        bmi     @1446       ; skip if piranha status $3e4c.7
        lda     $32d5,x     ; pointer to next pending counterattack
        inc
        bne     @144a       ; branch if there is a counterattack pending
@1446:  xba
        trb     $2f2f       ; mark monster as dead
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
@1454:  lda     $3018,x     ; character/monster mask
        trb     $2f4c       ; clear "can't be targetted" flag
        beq     @1474       ; skip if it wasn't set
        shorta
        xba
        trb     $2f2f       ; clear "monster not dead" flag
        lda     #$fe
        jsr     ClearFlag0       ; clear $3aa0.0 (make target not present)
        lda     $3ef9,x     ; set hide status
        ora     #STATUS4::HIDE
        sta     $3ef9,x
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
@147f:  lda     $3018,x     ; character/monster mask
        trb     $2f4e       ; clear "can be targetted" flag
        beq     @14a7       ; skip if it wasn't set
        shorta
        xba
        tsb     $2f2f       ; set "monster not dead" flag
        lda     #$01
        jsr     SetFlag0     ; set $3aa0.0 (make target present)
        lda     $3ee4,x     ; status 1
        clrflg  STATUS1, {DEAD, PETRIFY, IMP, ZOMBIE}
        sta     $3ee4,x
        lda     $3ef9,x     ; status 4
        clrflg  STATUS4, HIDE
        sta     $3ef9,x
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
        lda     $201f
        cmp     #$03
        bne     @1511       ; return if a side attack
        lda     $3018,x
        and     $2f50
        sta     $ee
        ldy     #$0a
@14c8:  lda     $ee
        xba
        lda     $3021,y
        bit     $2f51
        beq     @14d8
        xba
        eor     $3018,x
        xba
@14d8:  xba
        bne     @14df
        xba
        tsb     $3a55       ; monster getting hit in the back
@14df:  dey2
        bpl     @14c8
        bra     @1511

; monster attacker
@14e5:  lda     $201f
        cmp     #$02
        bne     @1511       ; return if a pincer attack
        lda     $3019,x
        and     $2f51
        sta     $ee
        ldy     #$06
@14f6:  lda     $ee
        xba
        lda     $3018,y
        bit     $2f50
        beq     @1506
        xba
        eor     $3019,x
        xba
@1506:  xba
        bne     @150d
        xba
        tsb     $3a54       ; character getting hit in the back
@150d:  dey2
        bpl     @14f6
@1511:  rts

; ------------------------------------------------------------------------------

; [ double damage for spears (when using jump) ]

; A: item index

SpearEffect:
@1512:  cmp     #$1d        ; mithril pike
        bcc     CmdNoEffect
        cmp     #$25        ; imperial (after imp halberd)
        bcs     CmdNoEffect
        lda     #$02
        sta     $bd         ; other damage multiplier
; fallthrough

; ------------------------------------------------------------------------------

; [ command with no effect ]

CmdNoEffect:
@151e:  rts

; ------------------------------------------------------------------------------

; [ command $0d: sketch ]

Cmd_0d:
@151f:  tyx
        jsr     _c2298a
        lda     #$ff
        sta     $b7
        lda     #$aa        ; special effect $55 (sketch)
        sta     $11a9
        jsr     ExecAttack
        ldy     $3417       ; return if no character used sketch
        bmi     CmdNoEffect
        stx     $3417
        lda     $3c81,y
        sta     $3c81,x
        lda     $322d,y
        sta     $322d,x
        stz     $3415
        lda     $3400
        sta     $b6
        lda     #$ff
        sta     $3400
        lda     #$01
        tsb     $b2

_c21554:
@1554:  lda     $b6
        jsr     GetCmdForAI
        sta     $b5         ; command
        asl
        tax
        jmp     (.loword(CmdTbl),x)

; ------------------------------------------------------------------------------

; [ command $10: rage ]

Cmd_10:
@1560:  lda     $33a8,y
        inc
        bne     @1579
        ldx     $3a93
        cpx     #$14
        bcc     @156f
        ldx     #$00
@156f:  lda     $33a8,x
        sta     $33a8,y
        clr_a
        sta     $33a9,y
@1579:  sty     $3a93
        lda     $3ef9,y
        ora     #$01
        sta     $3ef9,y
        jsr     SetRage
        tyx
        jsr     FixImmuneStatus
        jsr     _c21554
        jmp     UpdateImmuneStatus

; ------------------------------------------------------------------------------

; [ command $05: steal ]

Cmd_05:
@1591:  tyx
        jsr     _c2298a
        lda     #$a4        ; special effect $52 (steal)
        sta     $11a9
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $0a: blitz ]

Cmd_0a:
@159d:  lda     $b6
        bpl     @15b0
        lda     #$01
        trb     $b3
        lda     #$43
        sta     $3401
        lda     #$5d
        sta     $b6
        bra     @15b5
@15b0:  lda     #$08
        sta     $3412
@15b5:  lda     $b6
        pha
        sec
        sbc     #$5d
        sta     $b6
        pla
        tyx
        jsr     InitCmdTarget
        jsr     InitAttacker
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $00: fight ]

Cmd_00:
@15c8:  cpy     #$08
        bcs     _1610
        lda     $3a3f
        cmp     #$03
        bcc     _1610
        lda     $3ee5,y
        bit     #$02
        beq     _1610
        bit     #$24
        bne     _1610
        lda     $3ee4,y
        bit     #$12
        bne     _1610
        lda     $b9
        beq     _1610
        jsr     Rand
        and     #$0f
        bne     _1610
        lda     $3018,y
        tsb     $3f2f
        bne     _1610
        lda     $3ed8,y                 ; calculate desperation attack id
        cmp     #CHAR::GOGO
        beq     @1604
        cmp     #CHAR::GAU
        bcs     _1610
        inc
@1604:  dec
        ora     #$f0                    ; first desperation attack
        sta     $b6
        lda     #$10
        trb     $b0
        jmp     DesperationAttack

; ------------------------------------------------------------------------------

; [ command $06: capture ]

; normal fight attack enters here
Cmd_06:
_1610:  cpy     #$08
        bcs     FightAttack
        lda     $3ed8,y
        cmp     #CHAR::UMARO
        beq     _163b                   ; branch if Umaro

FightAttack:
_161b:  tyx
        lda     $3c58,x
        lsr
        lda     #$01
        bcc     @1626
        lda     #$07
@1626:  sta     $3a70
        jsr     CheckTargetsPresent
        jsr     _c23865
        lda     #$02
        trb     $b2
        lda     $b5
        sta     $3413
        jmp     ExecAttack

; choose umaro's attack
_163b:  stz     $fe
        lda     #$c6
        cmp     $3cd0,y
        beq     @1649
        cmp     $3cd1,y
        bne     @1656
@1649:  clr_a
        lda     $3018,y
        eor     $3a74
        beq     @1656
        lda     #$04
        tsb     $fe
@1656:  lda     #$c5
        cmp     $3cd0,y
        beq     @1662
        cmp     $3cd1,y
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
        jmp     (.loword(UmaroAttackTbl),x)

; ------------------------------------------------------------------------------

UmaroAttackTbl:
@1676:  .addr   UmaroAttack_00
        .addr   UmaroAttack_01
        .addr   UmaroAttack_02
        .addr   FightAttack

; ------------------------------------------------------------------------------

; [ umaro's charge attack ]

UmaroAttack_02:
@167e:  tyx
        jsr     InitUmaroAttack
        lda     #$20
        tsb     $11a2
        lda     #$02
        trb     $b2
        lda     #$23
        sta     $b5
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ umaro's throw attack ]

UmaroAttack_00:
@1692:  tyx
        jsr     InitUmaroAttack
        lda     $3018,x
        eor     $3a74
        ldx     #$06
@169e:  bit     $3018,x
        beq     @16bf
        xba
        lda     $3ef9,x
        bit     #$20
        beq     @16b2
        xba
        eor     $3018,x
        xba
        bra     @16be
@16b2:  lda     $3ee5,x
        bit     #$a0
        beq     @16be
        xba
        lda     $3018,x
        xba
@16be:  xba
@16bf:  dex2
        bpl     @169e
        pha
        clr_a
        pla
        beq     UmaroAttack_02
        jsr     RandBit
        jsr     BitToTargetID
        tyx
        lda     $3ed8,x
        cmp     #$0a
        bne     @16da
        lda     #$02
        trb     $b3
@16da:  lda     $3b68,x
        adc     $3b69,x
        bcc     @16e4
        lda     #$fe
@16e4:  adc     $11a6
        bcc     @16eb
        lda     #$ff
@16eb:  sta     $11a6
        lda     #$24
        sta     $b5
        lda     #$20
        tsb     $11a2
        lda     #$02
        trb     $b2
        lda     #$01
        tsb     $ba
        lda     $3ee5,x
        and     #$a0
        ora     $3dfd,x
        sta     $3dfd,x
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ umaro's storm attack ]

UmaroAttack_01:
@170d:  stz     $3415
        lda     #$54
        sta     $b6
; fallthrough

; ------------------------------------------------------------------------------

; [ character desperation attack ]

DesperationAttack:
@1714:  lda     #$02
        sta     $b5
        bra     _175f

.pushseg
.segment "desperation_attack"

; cf/fea0 desperation attacks for each character (unused)
        .byte   ATTACK::RIOT_BLADE
        .byte   ATTACK::MIRAGER
        .byte   ATTACK::BACK_BLADE
        .byte   ATTACK::SHADOWFANG
        .byte   ATTACK::ROYALSHOCK
        .byte   ATTACK::TIGERBREAK
        .byte   ATTACK::SPIN_EDGE
        .byte   ATTACK::SABRESOUL
        .byte   ATTACK::STAR_PRISM
        .byte   ATTACK::RED_CARD
        .byte   ATTACK::MOOGLERUSH
        .byte   ATTACK::NONE            ; gau
        .byte   ATTACK::X_METEO
        .byte   ATTACK::NONE            ; umaro

.popseg

; ------------------------------------------------------------------------------

; [ command $1b: shock ]

Cmd_1b:
@171a:  lda     #$82        ; attack $82 (shock)
        bra     _1720

; ------------------------------------------------------------------------------

; [ command $1a: health ]

Cmd_1a:
@171e:  lda     #$2e        ; attack $2e (cure 2)
_1720:  sta     $b6
        lda     #$05        ; attack name type = 5 (???)
        bra     _1765

; ------------------------------------------------------------------------------

; [ command $0f: slot ]

Cmd_0f:
@1726:  lda     #$10
        trb     $b0
        lda     $b6
        cmp     #$94        ; attack $94 (l.5 doom)
        bne     @1734
        lda     #$07        ; attack name type = 7 (joker doom [slot])
        bra     _1765
@1734:  cmp     #$51        ; attack $51 (fire skean)
        bcc     Cmd_19
        cmp     #$fe        ; attack $fe (lagomorph)
        bne     Cmd_02
        lda     #$07        ; battle message $07 (mugu mugu?)
        sta     $3401

; ------------------------------------------------------------------------------

; [ command $02/$17: magic/x-magic ]

Cmd_02:
Cmd_17:
@1741:  cpy     #$08
        bcs     _175f
        lda     $3ed8,y
        cmp     #$00
        bne     _175f
        lda     #$02
        trb     $3ebc
        beq     _175f
        ldx     #$06        ; battle event $06 (locke/edgar/terra magic)
        lda     #$23        ; command $23 (battle event)
        jsr     CreateImmediateAction
        lda     #$20
        tsb     $11a4

; ------------------------------------------------------------------------------

; [ command $0c/$1d: lore/magitek ]

Cmd_0c:
Cmd_1d:
_actbluemagic0:
_175f:  lda     #$00        ; attack name type = 0 (normal)
        bra     _1765

; ------------------------------------------------------------------------------

; [ command $19: summon ]

Cmd_19:
@1763:  lda     #$02        ; attack name type = 2 (esper)

magic_atmk:
_1765:  sta     $3412
        tyx
        lda     $b6
        jsr     InitCmdTarget
        jsr     InitAttacker
        lda     $b5
        cmp     #$0f
        bne     @177a       ; branch if not slot (magicite)
        stz     $11a5       ; for slot espers, set mp cost to zero
@177a:  jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $13: dance ]

Cmd_13:
@177d:  lda     $3ef8,y     ; set dance status
        ora     #STATUS3::DANCE
        sta     $3ef8,y
        lda     #$ff        ; no background change
        sta     $b7
        lda     $32e1,y
        bpl     @1794       ; branch if valid
        lda     $3a6f       ; default dance battle background
        sta     $32e1,y
@1794:  ldx     $11e2       ; current battle background
        cmp     f:BattleBGDance,x   ; dance for current background
        beq     Cmd_02      ; branch if dance matches
        jsr     RandCarry
        bcc     @17af       ; 50% chance to branch
        tax
        lda     f:DanceBG,x   ; change battle background
        sta     $b7
        sta     $11e2
        jmp     Cmd_02
@17af:  lda     $3ef8,y     ; clear dance status
        clrflg  STATUS3, DANCE
        sta     $3ef8,y
        tyx
        lda     #$06        ; battle message $06 (stumbled!!)
        sta     $3401
        lda     #$20        ;
        sta     $b5
        jsr     _c2298d
        jmp     ExecSelfAttack

.pushseg
.segment "dance_bg"

; d1/f9ab
DanceBG:
        .byte   BATTLE_BG_FIELD_WOB                     ; 0: wind song
        .byte   BATTLE_BG_FOREST_WOB                    ; 1: forest suite
        .byte   BATTLE_BG_DESERT_WOB                    ; 2: desert aria
        .byte   BATTLE_BG_TOWN_INT                      ; 3: love sonata
        .byte   BATTLE_BG_MOUNTAINS_EXT                 ; 4: earth blues
        .byte   BATTLE_BG_UNDERWATER                    ; 5: water rondo
        .byte   BATTLE_BG_CAVES                         ; 6: dusk requium
        .byte   BATTLE_BG_SNOWFIELDS                    ; 7: snowman jazz
        .byte   BATTLE_BG_FOREST_WOR                    ; unused
        .byte   BATTLE_BG_FOREST_WOR                    ; unused

.segment "battle_bg_dance"

; ed/8e5b
BattleBGDance:
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_FIELD_WOB
        .byte   DANCE::FOREST_SUITE      ; BATTLE_BG_FOREST_WOR
        .byte   DANCE::DESERT_ARIA       ; BATTLE_BG_DESERT_WOB
        .byte   DANCE::FOREST_SUITE      ; BATTLE_BG_FOREST_WOB
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_ZOZO_INT
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_FIELD_WOR
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_VELDT
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_CLOUDS
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_NARSHE_EXT
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_NARSHE_CAVES_1
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_CAVES
        .byte   DANCE::EARTH_BLUES       ; BATTLE_BG_MOUNTAINS_EXT
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_MOUNTAINS_INT
        .byte   DANCE::WATER_RONDO       ; BATTLE_BG_RIVER
        .byte   DANCE::DESERT_ARIA       ; BATTLE_BG_IMP_CAMP
        .byte   DANCE::FOREST_SUITE      ; BATTLE_BG_TRAIN_EXT
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_TRAIN_INT
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_NARSHE_CAVES_2
        .byte   DANCE::SNOWMAN_JAZZ      ; BATTLE_BG_SNOWFIELDS
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_TOWN_EXT
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_IMP_CASTLE
        .byte   DANCE::EARTH_BLUES       ; BATTLE_BG_FLOATING_ISLAND
        .byte   DANCE::EARTH_BLUES       ; BATTLE_BG_KEFKAS_TOWER_EXT
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_OPERA_STAGE
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_OPERA_CATWALK
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_BURNING_BUILDING
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_CASTLE_INT
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_MAGITEK_LAB
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_COLOSSEUM
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_MAGITEK_FACTORY
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_VILLAGE_EXT
        .byte   DANCE::WATER_RONDO       ; BATTLE_BG_WATERFALL
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_OWZERS_HOUSE
        .byte   DANCE::FOREST_SUITE      ; BATTLE_BG_TRAIN_TRACKS
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_SEALED_GATE
        .byte   DANCE::WATER_RONDO       ; BATTLE_BG_UNDERWATER
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_ZOZO
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_AIRSHIP_CENTER
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_DARILLS_TOMB
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_CASTLE_EXT
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_KEFKAS_TOWER_INT
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_AIRSHIP_WOR
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_FIRE_CAVES
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_TOWN_INT
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_MAGITEK_TRAIN
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_FANATICS_TOWER
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_CYANS_DREAM
        .byte   DANCE::DESERT_ARIA       ; BATTLE_BG_DESERT_WOR
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_AIRSHIP_WOB
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_31
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_GHOST_TRAIN
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_FINAL_BATTLE_1
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_FINAL_BATTLE_2
        .byte   DANCE::DUSK_REQUIUM      ; BATTLE_BG_FINAL_BATTLE_3
        .byte   DANCE::WIND_SONG         ; BATTLE_BG_FINAL_BATTLE_4
        .byte   DANCE::LOVE_SONATA       ; BATTLE_BG_TENTACLES
        .byte   DANCE::DUSK_REQUIUM
        .byte   DANCE::DUSK_REQUIUM
        .byte   DANCE::DUSK_REQUIUM
        .byte   DANCE::DUSK_REQUIUM
        .byte   DANCE::DUSK_REQUIUM
        .byte   DANCE::DUSK_REQUIUM
        .byte   DANCE::DUSK_REQUIUM
        .byte   DANCE::DUSK_REQUIUM

.popseg

; ------------------------------------------------------------------------------

; [ init umaro's attack power ]

InitUmaroAttack:
@17c7:  jsr     _c2298a
        clc
        lda     $3b68,x
        adc     $3b69,x
        bcc     @17d5
        lda     #$ff
@17d5:  sta     $11a6
        lda     $3b18,x     ; level
        sta     $11af
        lda     $3b2c,x     ; vigor * 2
        sta     $11ae       ; hit rate
        rts

; ------------------------------------------------------------------------------

; [ command $1c: possess ]

Cmd_1c:
@17e5:  tyx
        jsr     InitCmdTarget
        lda     #$20
        tsb     $11a4
        lda     #$a0        ; special effect $50 (possess)
        sta     $11a9
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $16: jump ]

Cmd_16:
@17f6:  tyx
        jsr     InitCmdTarget
        lda     $3b69,x
        beq     @1808
        sec
        lda     $3b68,x
        beq     @1808
        jsr     RandCarry
@1808:  jsr     _c2299f
        lda     #$20
        sta     $11a4
        tsb     $b3
        inc     $bd
        lda     $3ca8,x     ; main hand item
        jsr     SpearEffect
        lda     $3ca9,x     ; off-hand item
        jsr     SpearEffect
        lda     $3c44,x     ; relic effects 1
        bpl     @183c       ; branch if no dragon horn
        dec     $3a8e       ; enable dragon horn effect
        jsr     Rand
        inc     $3a70
        cmp     #$40
        bcs     @183c
        inc     $3a70
        cmp     #$10
        bcs     @183c
        inc     $3a70
@183c:  lda     $3ef9,x
        and     #$df
        sta     $3ef9,x
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $07: swdtech ]

Cmd_07:
@1847:  tyx
        lda     $b6
        pha
        sec
        sbc     #$55
        sta     $b6
        pla
        jsr     InitCmdTarget
        jsr     InitAttacker
        lda     $b6
        cmp     #$01
        bne     @187d       ; branch if not retort
        lda     $3e4c,x     ; toggle $3e4c.0 (retort)
        eor     #$01
        sta     $3e4c,x
        lsr
        bcc     @1879
        ror     $b6
        stz     $11a6
        lda     #$20
        tsb     $11a4
        lda     #$01
        trb     $11a2
        bra     @1882
@1879:  lda     #$10
        trb     $b0
@187d:  lda     #$04
        sta     $3412
@1882:  jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $09: tools ]

Cmd_09:
@1885:  lda     $b6
        sbc     #$a2
        sta     $b6
        bra     _189e

; ------------------------------------------------------------------------------

; [ command $08: throw ]

Cmd_08:
@188d:  lda     #$02
        sta     $bd
        lda     #$10
        trb     $b3
        bra     _189e

; ------------------------------------------------------------------------------

; [ command $01: item ]

Cmd_01:
@1897:  stz     $3414       ; disable damage modification
        lda     #$80
        trb     $b3
_189e:  tyx
        lda     #$01
        sta     $3412
        lda     $3a7d
        jsr     InitCmdTarget
        lda     #$10
        trb     $b1
        bne     @18b5
        lda     #$ff
        sta     $32f4,x
@18b5:  lda     $3018,x
        tsb     $3a8c
        lda     $b5
        bcc     @18e3       ; carry was set or cleared in $26d3 subroutine

; items that do not use a spell
        cmp     #$02
        lda     $3411
        jsr     CalcItemEffect
        lda     $11aa
        bit     #$c2
        bne     @18e0
        longa
        lda     $3a74
        ora     $3a42
        and     $b8
        sta     $b8
        shorta
        lda     #$04
        trb     $b3
@18e0:  jmp     ExecAttack

; items that use a spell (bio blaster/flash, rods, shields, water/fire/bolt edge)
@18e3:  cmp     #$01
        bne     @18ee
        inc     $b5
        lda     $3410
        sta     $b6
@18ee:  stz     $bd
        jsr     InitAttacker
        lda     #$02
        tsb     $11a3
        lda     #$20
        tsb     $11a4
        lda     #$08
        trb     $ba
        stz     $11a5
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $18: gp rain ]

Cmd_18:
@1907:  tyx
        jsr     _c2298a
        inc     $11a6
        lda     #$60
        tsb     $11a2
        stz     $3414       ; disable damage modification
        cpx     #$08
        bcc     @191f
        lda     #$05
        sta     $3412
@191f:  lda     #$a2        ; special effect $51 (gp rain)
        sta     $11a9
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $04: revert ]

Cmd_04:
@1927:  lda     $3ef9,y
        bit     #$08
        bne     _1937

_c2192e:
@192e:  tya
        lsr
        xba
        lda     #$0e
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $03: morph ]

Cmd_03:
@1936:  sec
_1937:  php
        tyx
        jsr     _c2298a
        plp
        lda     #$08
        sta     $11ad
        bcc     @1945
        clr_a
@1945:  lsr
        tsb     $11a4
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $14: row ]

Cmd_14:
@194c:  tyx
        lda     $3aa1,x     ; toggle battle row
        eor     #$20
        sta     $3aa1,x
        jsr     _c2298a
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $0b: runic ]

Cmd_0b:
@195b:  tyx
        lda     $3e4c,x     ; set $3e4c.2 (runic)
        ora     #$04
        sta     $3e4c,x
        jsr     _c2298a
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $15: def. ]

Cmd_15:
@196a:  tyx
        lda     #$02
        jsr     SetFlag1       ; set $3aa1.1
        jsr     _c2298a
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $0e: control ]

Cmd_0e:
@1976:  lda     $3ef9,y
        bit     #$10
        beq     @1987
        jsr     _c2192e
        lda     $32b8,y
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

Cmd_11:
@199d:  tyx
        jsr     _c2298a
        lda     #$a8        ; special effect $54 (leap)
        sta     $11a9
        lda     #$01
        trb     $11a2
        lda     #$40
        sta     $bb
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; [ command $1e: ai ]

Cmd_1e:
@19b2:  lda     #$0c
        sta     $b5
        jsr     _175f
        lda     #$21
        xba
        lda     #$06
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [  ]

InitCmdTarget:
@19c1:  xba
        lda     $b5
        jmp     InitTarget

; ------------------------------------------------------------------------------

; command jump table
CmdTbl:
@19c7:  .addr   Cmd_00
        .addr   Cmd_01
        .addr   Cmd_02
        .addr   Cmd_03
        .addr   Cmd_04
        .addr   Cmd_05
        .addr   Cmd_06
        .addr   Cmd_07
        .addr   Cmd_08
        .addr   Cmd_09
        .addr   Cmd_0a
        .addr   Cmd_0b
        .addr   Cmd_0c
        .addr   Cmd_0d
        .addr   Cmd_0e
        .addr   Cmd_0f
        .addr   Cmd_10
        .addr   Cmd_11
        .addr   CmdNoEffect
        .addr   Cmd_13
        .addr   Cmd_14
        .addr   Cmd_15
        .addr   Cmd_16
        .addr   Cmd_17
        .addr   Cmd_18
        .addr   Cmd_19
        .addr   Cmd_1a
        .addr   Cmd_1b
        .addr   Cmd_1c
        .addr   Cmd_1d
        .addr   Cmd_1e
        .addr   CmdNoEffect
        .addr   Cmd_20
        .addr   Cmd_21
        .addr   Cmd_22
        .addr   Cmd_23
        .addr   Cmd_24
        .addr   Cmd_25
        .addr   Cmd_26
        .addr   Cmd_27
        .addr   CmdNoEffect
        .addr   Cmd_29
        .addr   Cmd_2a
        .addr   Cmd_2b
        .addr   Cmd_2c
        .addr   Cmd_2d
        .addr   Cmd_2e
        .addr   Cmd_2f
        .addr   Cmd_30
        .addr   CmdNoEffect
        .addr   CmdNoEffect
        .addr   CmdNoEffect

; ------------------------------------------------------------------------------

; [ execute ai script ]

ExecAI:
@1a2f:  phx
        php
        lda     $b8
        sta     $fc
        sta     $fe
        shorta
        stz     $f5
        stx     $f6
        jsr     ExecAICmd
        plp
        plx
_1a42:  rts

; ------------------------------------------------------------------------------

; [ find ai script terminator ]

FindAIScriptEnd:
@1a43:  clr_a
@1a44:  lda     f:AIScript,x
        inx
        cmp     #$fe
        bcs     _1a42                   ; return if $fe or $ff
        sbc     #$ef
        bcc     @1a44
        phx
        tax
        lda     f:AICmdSizeTbl,x
        plx
        dex
@1a59:  inx
        dec
        bne     @1a59
        bra     @1a44

; ------------------------------------------------------------------------------

; [ load next ai script command ]

GetNextAICmd:
@1a5f:  php
        longa
        ldx     $f0         ; pointer to ai script
        lda     f:AIScript+2,x   ; load next 4 bytes of ai script
        sta     $3a2e
        lda     f:AIScript,x
        sta     $3a2c
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ ai script command $fd: wait until end of turn ]

AICmd_fd:
@1a74:  longa
        lda     $f0
        sta     $f2
        rts
        .a8

; ------------------------------------------------------------------------------

; [ ai script command $fe/$ff: end if/end of script ]

AICmd_fe:
AICmd_ff:
@1a7b:  lda     #$ff
        sta     $f5
        rts

; ------------------------------------------------------------------------------

; [ choose random ai data byte ]

AIRand3:
@1a80:  lda     #$03
        jsr     RandA
        tax
        lda     $3a2d,x     ; random ai data byte (0..2)
        cmp     #$fe
        bne     _1a42
        pla                 ; return if not nothing
        pla
        bra     NextAICmd

; ------------------------------------------------------------------------------

; [ ai script command $fc: conditional ]

AICmd_fc:
@1a91:  lda     $3a2d
        asl
        tax
        jsr     (.loword(AICondTbl),x)
        bcs     NextAICmd

conditionmiss:
_c31a9b:
@1a9b:  longai
        lda     $fe
        sta     $fc
        shorta
        ldx     $f0
        jsr     FindAIScriptEnd
        inc
        beq     AICmd_fe
        stx     $f0
        inc     $f5
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

ExecAICmd:
@1aaf:  lda     $3a98
        sta     $f8
; fallthrough

; ------------------------------------------------------------------------------

; [ next ai command ]

NextAICmd:
@1ab4:  shorta
        longi
        jsr     GetNextAICmd
        cmp     #$fc        ; branch if conditional, wait, end if, or end of script
        bcs     @1ad0
        lda     $f5         ; loop counter
        cmp     $f4
        bne     @1ad0       ; branch if not done looping
        lda     #$ff
        sta     $f4         ;
        ldx     $f2         ; set ai script pointer to loop address
        stx     $f0
        jsr     GetNextAICmd
@1ad0:  clr_a
        sec
        txy
        lda     $3a2c       ; ai script command
        sbc     #$f0
        bcs     @1adc       ; branch if > $f0
        lda     #$0f        ; normal command -> one data byte
@1adc:  tax
        lda     f:AICmdSizeTbl,x
        tax
@1ae2:  iny                 ; increment ai script address
        dex
        bne     @1ae2
        sty     $f0
        shorti
        lda     $f8         ; branch if not a counterattack
        beq     @1af5
        lda     $3a2c       ; current ai command
        cmp     #$fc
        bcc     _c31a9b     ; branch if < $fc
@1af5:  ldy     $f6         ; y = pointer to character/monster data in ram
        lda     $3a2c
        cmp     #$f0
        bcc     _1b25       ; branch if ai command < $f0 (single attack)
        and     #$0f
        asl
        tax
        jmp     (.loword(AICmdTbl),x)

; ------------------------------------------------------------------------------

; [ ai script command $f6: use/throw item ]

; b0: 0 = use, 1 = throw
; b1: item 1 (2/3 chance)
; b2: item 2 (1/3 chance)

AICmd_f6:
@1b05:  lda     #$01        ; item command
        xba
        lda     $3a2d
        beq     @1b10       ; branch if using item (not throwing)
        lda     #$08        ; throw command
        xba
@1b10:  lda     $3a2e       ; copy first item to double its likelihood of being chosen
        sta     $3a2d
        jsr     AIRand3
        xba
        bra     _1b28

; ------------------------------------------------------------------------------

; [ ai script command $f4: do command ]

; b0: command 1 (1/3 chance)
; b1: command 2 (1/3 chance)
; b2: command 3 (1/3 chance)

AICmd_f4:
@1b1c:  clr_a                           ; clear attack index (this shouldn't be used anyway)
        jsr     AIRand3
        bra     _1b28

; ------------------------------------------------------------------------------

; [ ai script command $f0: use attack ]

; b0: attack 1 (1/3 chance)
; b1: attack 2 (1/3 chance)
; b2: attack 3 (1/3 chance)

AICmd_f0:
@1b22:  jsr     AIRand3
_1b25:  jsr     GetCmdForAI

; use ai attack/command
_1b28:  tyx
        longa
        pha
        lda     $fc
        sta     $b8
        lda     $3ee4,x     ; current status 1,2
        bit     #STATUS12::CONFUSE
        beq     @1b3a       ; branch if not muddled
        stz     $b8         ; clear targets
@1b3a:  pla
        jsr     FixRoulette
        jsr     CalcCmdDelay
        jsr     CreateDefaultAction
        jmp     NextAICmd

; ------------------------------------------------------------------------------

; [ ai script command $f1: targetting ]

AICmd_f1:
@1b47:  lda     $3a2d
        clc
        jsr     CheckAITarget
        longa
        lda     $b8
        sta     $fc
        jmp     NextAICmd
        .a8

; ------------------------------------------------------------------------------

; [ ai script command $f5: monster death/entry ]

AICmd_f5:
@1b57:  lda     $3a2f
        bne     @1b62
        lda     $3019,y
        sta     $3a2f
@1b62:  lda     #$24
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f3: display short battle dialog ]

AICmd_f3:
@1b66:  lda     #$21
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $fb: misc. battle effects ]

AICmd_fb:
@1b6a:  lda     #$30
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f2: battle change ]

AICmd_f2:
@1b6e:  lda     #$20
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f8: byte-wise variable manipulation ]

AICmd_f8:
@1b72:  lda     #$2e
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f9: bit-wise variable manipulation ]

AICmd_f9:
@1b76:  lda     #$2f
_1b78:  xba
        lda     $3a2d
        xba
        longa
        sta     $3a7a
        lda     $3a2e
        sta     $b8
        tyx
        jsr     CreateDefaultAction
        jmp     NextAICmd
        .a8

; ------------------------------------------------------------------------------

; [ ai script command $f7: execute battle event ]

AICmd_f7:
@1b8e:  tyx
        lda     #$23
        sta     $3a7a
        lda     $3a2d
        sta     $3a7b
        jsr     CreateDefaultAction
        jmp     NextAICmd

; ------------------------------------------------------------------------------

; [ ai script command $fa: misc. monster animations ]

AICmd_fa:
@1ba0:  tyx
        lda     $3a2d
        xba
        lda     #$2b        ; command $2b (misc. monster animations)
        longa
        sta     $3a7a
        lda     $3a2e
        sta     $b8
        jsr     CreateDefaultAction
        jmp     NextAICmd

; ------------------------------------------------------------------------------

; [ ai conditional $06: if target's hp is below a value ]

AICond_06:
@1bb7:  jsr     AICond_17
        bcc     @1bc7
        clr_a
        lda     $3a2f
        xba
        longa
        lsr
        cmp     $3bf4,y
@1bc7:  rts
        .a8

; ------------------------------------------------------------------------------

; [ ai conditional $07: if target's mp is below a value ]

AICond_07:
@1bc8:  jsr     AICond_17
        bcc     @1bd6
        clr_a
        lda     $3a2f
        longa
        cmp     $3c08,y
@1bd6:  rts
        .a8

; ------------------------------------------------------------------------------

; [ ai conditional $08: if target has a status ]

AICond_08:
costatus:
@1bd7:  jsr     AICond_17
        bcc     @1c25
        lda     $3a2f
        cmp     #$10
        bcc     @1bee
        longa
        lda     $3a74
        and     $fc
        sta     $fc
        shorta
@1bee:  lda     #$10
        trb     $3a2f
        longa
        bne     @1bfc
        lda     #$3ee4
        bra     @1bff
@1bfc:  lda     #$3ef8
@1bff:  sta     $fa
        ldx     $3a2f
        jsr     AIGetBit
        sta     $ee
        ldy     #$12
@1c0b:  lda     ($fa),y
        bit     $ee
        bne     @1c16
        lda     $3018,y
        trb     $fc
@1c16:  dey2
        bpl     @1c0b
        clc
        lda     $fc
        beq     @1c25
        jsr     RandBit
        sta     $fc
        sec
@1c25:  rts
        .a8

; ------------------------------------------------------------------------------

; [ ai conditional $09: if target doesn't have a status ]

AICond_09:
@1c26:  jsr     AICond_08
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [ ai conditional $1a: if target is weak against element ]

AICond_1a:
@1c2c:  jsr     AICond_17
        bcc     @1c3a
        lda     $3be0,y     ; weak elements
        bit     $3a2f
        bne     @1c3a
        clc
@1c3a:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $03: if item was used against monster ]

AICond_03:
@1c3b:  tya
        adc     #$13
        tay

; ------------------------------------------------------------------------------

; [ ai conditional $02: if attack was used against monster ]

AICond_02:
@1c3f:  iny
; fallthrough

; ------------------------------------------------------------------------------

; [ ai conditional $01: if command was used against monster ]

AICond_01:
@1c40:  tyx
        ldy     $3290,x
        bmi     @1c53
        lda     $3d48,x
        cmp     $3a2e
        beq     _1c55
        cmp     $3a2f
        beq     _1c55
@1c53:  clc
        rts
_1c55:  longa
        lda     $3018,y
        sta     $fc
        sec
        rts
        .a8

; ------------------------------------------------------------------------------

; [ ai conditional $04: if element was used against monster ]

AICond_04:
@1c5e:  tya
        adc     #$15                    ; add $15 to attacker data pointer
        tax
        ldy     $3290,x                 ; $32a5,x (previous attacker)
        bmi     @1c6f
        lda     $3d48,x                 ; $3d5d,x (previous element used)
        bit     $3a2e
        bne     _1c55
@1c6f:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $05: if any attack was used against monster ]

AICond_05:
@1c70:  tyx
        ldy     $327c,x
        bmi     @1c7e
        longa
        lda     $3018,y
        sta     $fc
        sec
@1c7e:  rts

; ------------------------------------------------------------------------------

; [  ]

AICond_16:
@1c7f:  longa
        lda     $3a44
        bra     _1c8b

AICond_0b:
@1c86:  longa
        lda     $3dc0,y
_1c8b:  lsr
        cmp     $3a2e
        rts
        .a8

; ------------------------------------------------------------------------------

; [  ]

coflagcc:
AICond_0d:
@1c90:  ldx     $3a2e
        jsr     GetBattleVar
        lda     $ee
        cmp     $3a2f
        rts

; ------------------------------------------------------------------------------

; [  ]

AICond_0c:
@1c9c:  jsr     AICond_0d
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [  ]

AICond_14:
coflagbit:
@1ca2:  ldx     $3a2f
        jsr     AIGetBit
        ldx     $3a2e
        jsr     GetBattleVar
        bit     $ee
        beq     @1cb3
        sec
@1cb3:  rts

; ------------------------------------------------------------------------------

; [  ]

AICond_15:
@1cb4:  jsr     AICond_14
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [  ]

AICond_0f:
colevelcc:
@1cba:  jsr     AICond_17
        bcc     @1cc5
        lda     $3b18,y
        cmp     $3a2f
@1cc5:  rts

; ------------------------------------------------------------------------------

; [  ]

AICond_0e:
@1cc6:  jsr     AICond_0f
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [  ]

AICond_10:
@1ccc:  lda     #$01
        cmp     $3eca
        rts

; ------------------------------------------------------------------------------

; [ ai conditional $19: continue based on this monster's slot ]

AICond_19:
@1cd2:  lda     $3019,y
        bit     $3a2e
        beq     @1cdb
        sec
@1cdb:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $11:  ]

AICond_11:
@1cdc:  jsr     GetAITargetMask
        lda     $3a75
        bra     _1cef

; ------------------------------------------------------------------------------

; [ ai conditional $12:  ]

AICond_12:
@1ce4:  stz     $f8
        jsr     GetAITargetMask
        lda     $3a73
        eor     $3a75
_1cef:  and     $3a2e
        cmp     $3a2e
        clc
        bne     @1cf9
        sec
@1cf9:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $13: continue based on number of characters/monsters remaining ]

AICond_13:
@1cfa:  lda     $3a2e
        bne     @1d06       ; branch if comparing number of monsters
        lda     $3a76       ; number of characters alive
        cmp     $3a2f
        rts
@1d06:  lda     $3a2f
        cmp     $3a77       ; number of monsters alive
        rts

; ------------------------------------------------------------------------------

; [ ai conditional $18:  ]

AICond_18:
@1d0d:  lda     $1edf
        bit     #$08
        bne     @1d15
        sec
@1d15:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $1b:  ]

AICond_1b:
@1d16:  longa
        lda     $3a2e
        cmp     $11e0
        beq     @1d21
        clc
@1d21:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $1c: always continue ]

AICond_1c:
@1d22:  stz     $f8
        sec
        rts

; ------------------------------------------------------------------------------

; [ invert carry flag ]

InvertCarry:
@1d26:  shorta
        rol
        eor     #$01
        lsr
; fallthrough

; ------------------------------------------------------------------------------

; [ ai conditional $00: never continue ]

AICond_00:
AICond_0a:
@1d2c:  rts

; ------------------------------------------------------------------------------

; [  ]

AIGetBit:
@1d2d:  clr_a
        sec
@1d2f:  rol
        dex
        bpl     @1d2f
        rts

; ------------------------------------------------------------------------------

; [ ai conditional $17: if target is valid ]

AICond_17:
cotarget:
@1d34:  lda     $3a2e
        pha
        sec
        jsr     CheckAITarget
        bcc     @1d49
        longa
        lda     $b8
        sta     $fc
        jsr     BitToTargetID
        shorta_sec
@1d49:  pla
        php
        cmp     #$36
        bne     @1d53
        stz     $fc
        stz     $fc
@1d53:  plp
        rts

; ------------------------------------------------------------------------------

; ai conditional jump table (ai command $fc)
AICondTbl:
@1d55:  .addr   AICond_00
        .addr   AICond_01
        .addr   AICond_02
        .addr   AICond_03
        .addr   AICond_04
        .addr   AICond_05
        .addr   AICond_06
        .addr   AICond_07
        .addr   AICond_08
        .addr   AICond_09
        .addr   AICond_0a
        .addr   AICond_0b
        .addr   AICond_0c
        .addr   AICond_0d
        .addr   AICond_0e
        .addr   AICond_0f
        .addr   AICond_10
        .addr   AICond_11
        .addr   AICond_12
        .addr   AICond_13
        .addr   AICond_14
        .addr   AICond_15
        .addr   AICond_16
        .addr   AICond_17
        .addr   AICond_18
        .addr   AICond_19
        .addr   AICond_1a
        .addr   AICond_1b
        .addr   AICond_1c

; ------------------------------------------------------------------------------

; ai script command jump table
AICmdTbl:
@1d8f:  .addr   AICmd_f0
        .addr   AICmd_f1
        .addr   AICmd_f2
        .addr   AICmd_f3
        .addr   AICmd_f4
        .addr   AICmd_f5
        .addr   AICmd_f6
        .addr   AICmd_f7
        .addr   AICmd_f8
        .addr   AICmd_f9
        .addr   AICmd_fa
        .addr   AICmd_fb
        .addr   AICmd_fc
        .addr   AICmd_fd
        .addr   AICmd_fe
        .addr   AICmd_ff

; ------------------------------------------------------------------------------

; number of bytes for each ai script command
AICmdSizeTbl:
@1daf:  .byte   4,2,4,3,4,4,4,2,3,4,4,3,4,1,1,1

; ------------------------------------------------------------------------------

; [ get command for ai attack ]

GetCmdForAI:
@1dbf:  phx
        pha
        xba
        pla
        ldx     #$0a
@1dc5:  cmp     f:AttackForAITbl,x   ; compare attack index
        bcc     @1dd1
        lda     f:CmdForAITbl,x   ; get command index
        bra     @1dd6
@1dd1:  dex
        bpl     @1dc5
        lda     #$02
@1dd6:  plx
        rts

; ------------------------------------------------------------------------------

; first attack index for each command
AttackForAITbl:
@1dd8:  .byte   $36,$51,$55,$5d,$65,$7d,$82,$83,$8b,$ee,$f0

; ------------------------------------------------------------------------------

; corresponding command index
CmdForAITbl:
@1de3:  .byte   $19,$02,$07,$0a,$02,$09,$1b,$1d,$0c,$00,$02

; ------------------------------------------------------------------------------

; [  ]

GetAITargetMask:
@1dee:  lda     $3a2e
        bne     @1df9
        lda     $3019,y
        sta     $3a2e
@1df9:  rts

; ------------------------------------------------------------------------------

; [ command $2e: load/add/subtract variable (ai command $f8) ]

Cmd_2e:
@1dfa:  ldx     $b6         ; variable index
        jsr     GetBattleVar
        lda     #$80
        trb     $b8
        bne     @1e0a       ; branch if adding or subtracting
        lsr
        trb     $b8         ; clear bit 6 (add)
        stz     $ee         ; set the current value to zero
@1e0a:  lda     $b8
        bit     #$40
        beq     @1e13       ; branch if adding
        eor     #$bf
        inc
@1e13:  adc     $ee         ; add/subtract
        sta     $ee
        jmp     _1e38

; ------------------------------------------------------------------------------

; [ command $2f: set/clear variable bit (ai command $f9) ]

Cmd_2f:
@1e1a:  ldx     $b9
        jsr     _c21e57
        ldx     $b8
        jsr     GetBattleVar
        dec     $b6
        bpl     @1e2c
        eor     $ee
        bra     _1e38
@1e2c:  dec     $b6
        bpl     @1e34
        ora     $ee
        bra     _1e38
@1e34:  eor     #$ff
        and     $ee

_elstorework:
_1e38:  cpx     #$24        ; store the battle variable
        bcs     @1e41
        sta     $3eb0,x
        bra     @1e44
@1e41:  sta     $3dac,y
@1e44:  rts

; ------------------------------------------------------------------------------

; [ load battle variable ]

;   X: variable index
;   Y: monster index
; $ee: variable value (out)

GetBattleVar:
@1e45:  pha
        cpx     #$24
        bcs     @1e4f
        lda     $3eb0,x
        bra     @1e52
@1e4f:  lda     $3dac,y
@1e52:  sta     $ee
        pla
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c21e57:
_elnumtobit:
@1e57:  clr_a
        sec
@1e59:  rol
        dex
        bpl     @1e59
        rts

; ------------------------------------------------------------------------------

; [ command $30: misc. effects (ai command $fb) ]

Cmd_30:
@1e5e:  lda     $b6
        asl
        tax
        lda     $b8
        jmp     (.loword(MiscAIEffectTbl),x)

; ------------------------------------------------------------------------------

; subcommand $00: set monster counter to 0
MiscAIEffect_00:
@1e67:  clr_a
        sta     $3dc0,y
        sta     $3dc1,y
        rts

; ------------------------------------------------------------------------------

; subcommand $09: end battle and do gau event
MiscAIEffect_09:
@1e6f:  lda     #$0a        ; end of battle special event 5 (gau learns rages)
        bra     _1e75

; ------------------------------------------------------------------------------

; subcommand $02: end battle immediately
MiscAIEffect_02:
@1e73:  lda     #$08        ; end of battle special event 4 (end battle immediately)
_1e75:  sta     $3a6e
        rts

; ------------------------------------------------------------------------------

; subcommand $01: make target invincible
MiscAIEffect_01:
@1e79:  php
        sec
        jsr     CheckAITarget
        longa
        lda     $b8
        tsb     $3a3c
        plp
        rts

; ------------------------------------------------------------------------------

; subcommand $05: make target not invincible
MiscAIEffect_05:
@1e87:  php
        sec
        jsr     CheckAITarget
        longa
        lda     $b8
        trb     $3a3c
        plp
        rts
        .a8

; ------------------------------------------------------------------------------

; subcommand $06: target can be targetted
MiscAIEffect_06:
@1e95:  sec
        jsr     CheckAITarget
        lda     $b9
        tsb     $2f46
        rts

; ------------------------------------------------------------------------------

; subcommand $07: target can't be targetted
MiscAIEffect_07:
@1e9f:  sec
        jsr     CheckAITarget
        lda     $b9
        trb     $2f46
        rts

; ------------------------------------------------------------------------------

; subcommand $03: add gau to the party
MiscAIEffect_03:
@1ea9:  lda     #$08
        tsb     $1edf
        lda     $3ed9,y
        tax
        lda     $1850,x
        ora     #$40
        and     #$e0
        ora     $1a6d
        sta     $ee
        tya
        asl2
        ora     $ee
        sta     $1850,x
        rts

; ------------------------------------------------------------------------------

; subcommand $04: set battle counter to 0
MiscAIEffect_04:
@1ec7:  stz     $3a44
        stz     $3a45
        rts

; ------------------------------------------------------------------------------

; subcommand $08: fill target's atb gauge (use in a counterattack script to immediately queue the normal script)
MiscAIEffect_08:
@1ece:  sec
        jsr     CheckAITarget
        bcc     @1ed9       ; branch if no targets are valid
        lda     #$ff
        sta     $3ac9,y     ; fill this monster's atb gauge
@1ed9:  rts

; ------------------------------------------------------------------------------

; subcommand $0c: clear status
MiscAIEffect_0c:
@1eda:  jsr     _c21eeb
        lda     #$04
        tsb     $11a4
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; subcommand $0b: set status
MiscAIEffect_0b:
@1ee5:  jsr     _c21eeb
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [  ]

_c21eeb:
gestatussub:
@1eeb:  jsr     _c2298a
        clc
        lda     $b8
        jsr     GetBitPtr
        ora     $11aa,x
        sta     $11aa,x
        tyx
        lda     #$12
        sta     $b5
        rts

; ------------------------------------------------------------------------------

; subcommand $0d: hide target
MiscAIEffect_0d:
@1f00:  lda     $3ef9,y
        ora     #$20
        sta     $3ef9,y

MiscAIEffect_0a:
@1f08:  rts

; ------------------------------------------------------------------------------

; command $30 jump table (ai command $fb)
MiscAIEffectTbl:
@1f09:  .addr   MiscAIEffect_00
        .addr   MiscAIEffect_01
        .addr   MiscAIEffect_02
        .addr   MiscAIEffect_03
        .addr   MiscAIEffect_04
        .addr   MiscAIEffect_05
        .addr   MiscAIEffect_06
        .addr   MiscAIEffect_07
        .addr   MiscAIEffect_08
        .addr   MiscAIEffect_09
        .addr   MiscAIEffect_0a
        .addr   MiscAIEffect_0b
        .addr   MiscAIEffect_0c
        .addr   MiscAIEffect_0d

; ------------------------------------------------------------------------------

; [ check if any targets are valid ]

;     A: target
; carry: set = at least one target is valid, clear = no targets are valid (out)

CheckAITarget:
@1f25:  phx
        phy
        pha
        stz     $b8         ; clear character targets
        ldx     #$06
@1f2c:  lda     $3ed8,x     ; actor in character slot
        bmi     @1f36       ; branch if not present
        lda     $3018,x
        tsb     $b8         ; set bit for character
@1f36:  dex2
        bpl     @1f2c
        stz     $b9         ; clear monster targets
        ldx     #$0a
@1f3e:  lda     $2002,x     ; monster flag
        bmi     @1f48       ; branch if not present
        lda     $3021,x
        tsb     $b9         ; set bit for monster
@1f48:  dex2
        bpl     @1f3e
        bcs     @1f54
        jsr     CheckTargetsPresent
        jsr     _c25917
@1f54:  pla
        cmp     #$30
        bcs     @1f6d       ; branch if not looking for a specific actor
        ldx     #$06
@1f5b:  cmp     $3ed8,x
        bne     @1f67
        lda     $3018,x
        sta     $b8
        bra     AITarget_43
@1f67:  dex2
        bpl     @1f5b
        bra     AITarget_47
@1f6d:  cmp     #$36
        bcs     @1f81       ; branch if not looking for a particular monster slot
        sbc     #$2f
        asl
        tax
        lda     $2002,x
        bmi     AITarget_47
        lda     $3021,x
        sta     $b9
        bra     AITarget_38
@1f81:  sbc     #$36
        asl
        tax
        jmp     (.loword(AITargetTbl),x)

; ------------------------------------------------------------------------------

; [  ]

AITarget_44:
@1f88:  stz     $b9
_1f8a:  longa
        lda     $b8
        jsr     RandBit
        sta     $b8

AITarget_46:
@1f93:  longa
        lda     $b8
        shorta_sec
        bne     @1f9c       ; branch if there are valid targets
        clc
@1f9c:  ply
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

AITarget_47:
@1f9f:  stz     $b8

AITarget_43:
@1fa1:  stz     $b9
        bra     AITarget_46

; ------------------------------------------------------------------------------

; target $37: all monsters except self
AITarget_37:
@1fa5:  jsr     _c2202d

; ------------------------------------------------------------------------------

; target $38: all monsters
AITarget_38:
@1fa8:  stz     $b8
        bra     AITarget_46

AITarget_39:
@1fac:  jsr     _c2202d

AITarget_3a:
@1faf:  stz     $b8
        bra     _1f8a

AITarget_3b:
@1fb3:  jsr     _c22037
        bra     AITarget_43

AITarget_3c:
@1fb8:  jsr     _c22037
        bra     AITarget_44

AITarget_3d:
@1fbd:  jsr     _c22037
        bra     AITarget_38

AITarget_3e:
@1fc2:  jsr     _c22037
        bra     AITarget_3a

AITarget_3f:
@1fc7:  jsr     _c2204e
_1fca:  bra     AITarget_43

AITarget_40:
@1fcc:  jsr     _c2204e
        bra     AITarget_44

AITarget_41:
@1fd1:  jsr     _c2204e
        bra     AITarget_38

AITarget_42:
@1fd6:  jsr     _c2204e
        bra     AITarget_3a

AITarget_4c:
@1fdb:  jsr     _c2202d
        jsr     RandCarry
        bcc     _1f8a
        bra     AITarget_46

AITarget_4d:
@1fe5:  ldx     $32f5,y
        bmi     AITarget_47
        lda     #$ff
        sta     $32f5,y
        longa
        lda     $3018,x
        sta     $b8
        jsr     CheckTargetsPresent
        bra     AITarget_46
        .a8

AITarget_45:
@1ffb:  stz     $b8
        stz     $b9
        lda     $32e0,y
        cmp     #$0a
        bcs     AITarget_46             ; branch if not attacked by a character
        asl
        tax
        longa
        lda     $3018,x
        sta     $b8
        bra     AITarget_46
        .a8

; ------------------------------------------------------------------------------

; [  ]

AITarget_48:
AITarget_49:
AITarget_4a:
AITarget_4b:
@2011:  txa
        sec
        sbc     #$24
        tax
        lda     $3aa0,x
        lsr
        bcc     AITarget_47       ; branch if $3aa0.0 is clear
        lda     $3018,x
        sta     $b8
        bra     _1fca

; ------------------------------------------------------------------------------

; target $36: self
AITarget_36:
@2023:  longa
        lda     $3018,y
        sta     $b8
        jmp     AITarget_46
        .a8

; ------------------------------------------------------------------------------

; remove self as a target
_c2202d:
@202d:  php
        longa
        lda     $3018,y
        trb     $b8
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [  ]

_c22037:
@2037:  php
        longa
        stz     $b8
        ldx     #$12
@203e:  lda     $3ee3,x
        bpl     @2048
        lda     $3018,x
        tsb     $b8
@2048:  dex2
        bpl     @203e
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2204e:
@204e:  php
        longa
        stz     $b8
        ldx     #$12
@2055:  lda     $3ef7,x
        bpl     @205f
        lda     $3018,x
        tsb     $b8
@205f:  dex2
        bpl     @2055
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

AITargetTbl:
@2065:  .addr   AITarget_36
        .addr   AITarget_37
        .addr   AITarget_38
        .addr   AITarget_39
        .addr   AITarget_3a
        .addr   AITarget_3b
        .addr   AITarget_3c
        .addr   AITarget_3d
        .addr   AITarget_3e
        .addr   AITarget_3f
        .addr   AITarget_40
        .addr   AITarget_41
        .addr   AITarget_42
        .addr   AITarget_43
        .addr   AITarget_44
        .addr   AITarget_45
        .addr   AITarget_46
        .addr   AITarget_47
        .addr   AITarget_48
        .addr   AITarget_49
        .addr   AITarget_4a
        .addr   AITarget_4b
        .addr   AITarget_4c
        .addr   AITarget_4d

; ------------------------------------------------------------------------------

; [ update character battle stats ]

UpdateCharProp:
_equipchange:
@2095:  ldx     #3
@2097:  lda     $2f30,x
        beq     @20da
        stz     $2f30,x
        phx
        phy
        txa
        sta     $ee
        asl
        sta     $ef
        asl
        adc     $ee
        tax
        lda     $2b86,x
        xba
        lda     $2b9a,x
        ldx     $ef
        longi
        ldy     $3010,x
        sta     $1620,y
        xba
        sta     $161f,y
        lda     $3ee4,x
        sta     $1614,y
        shorti
        lda     $3ed9,x
        jsl     UpdateEquip
        jsr     UpdateEquipBattle
        jsr     UpdateCmdList
        jsr     UpdateImmuneStatus
        ply
        plx
@20da:  dex                 ; next character
        bpl     @2097
        rts

; ------------------------------------------------------------------------------

; [ command $2a: run ]

Cmd_2a:
_escape:
@20de:  lda     $2f45       ; return if characters are not running
        beq     @2162
        longa
        lda     #$0902      ; battle command $02 (battle message $09: "can't run away!!")
        sta     $3a28
        shorta
        lda     $b1
        bit     #$02
        bne     @215f       ;
        lda     $3a38
        beq     @2162       ; return if no characters just escaped
        sta     $b8         ; set targets
        stz     $3a38       ; clear character that just escaped
        jsr     ClearGfxParams
        ldx     #$06
@2102:  lda     $3018,x     ; bit mask
        trb     $b8
        beq     @2144       ; skip if that character didn't just escape
        xba
        lda     $3219,x
        bne     @2144       ; skip if atb gauge is not full
        lda     $3aa0,x
        bit     #$50
        bne     @2144       ; skip if $3aa0.4 or $3aa0.6 is set
        lsr
        bcc     @2144       ; skip if character is not present
        lda     $3ee4,x
        bit     #STATUS1::ZOMBIE
        bne     @2144       ; skip if character has zombie status
        lda     $3ef9,x
        bit     #STATUS4::HIDE
        bne     @2144       ; skip if character has hide status
        xba
        tsb     $b8         ; add target
        tsb     $3a39       ; characters that have left the battle
        tsb     $2f4c       ; characters that can be targetted
        lda     $3aa1,x     ; set $3aa1.6 (pending run action)
        ora     #$40
        sta     $3aa1,x
        lda     $3204,x     ; remove all advance wait actions
        ora     #$40
        sta     $3204,x
        jsr     _c207c8
        txy
@2144:  dex2                ; next character
        bpl     @2102
        lda     $b8
        beq     @2162       ; branch if no characters ran away
        stz     $b9         ; clear monster targets
        tyx
        jsr     InitGfxParams
        jsr     CopyGfxParamsToBuf
        longa
        lda     #$2206      ; battle command $06 (battle animation for command $22: characters run away ???)
        sta     $3a28
        shorta
@215f:  jsr     _c2629e       ; add battle script command to queue
@2162:  rts

; ------------------------------------------------------------------------------

; [ execute immediate action ]

; A: pointer to command list (+$3184)

_c22163:
_event:
@2163:  pea     BattleLoop-1
        pha
        asl
        tay
        clc
        jsr     InitPlayerAction
        pla
        tay
        lda     $3184,y     ; command list
        cmp     $340a       ; immediate action
        bne     @2179       ; branch if they don't match
        lda     #$ff
@2179:  sta     $340a       ; set immediate action
        lda     #$ff
        sta     $3184,y     ; clear command list slot
        lda     #$01        ; set counterattack flag
        tsb     $b1
        jmp     ExecCmd

; ------------------------------------------------------------------------------

; [ execute advance wait action ]

; called when an advance wait action reaches the top of the queue

_c22188:
_gaugefull:
@2188:  lda     #$80
        jsr     SetFlag1       ; set $3aa1.7
        lda     $3aa0,x
        bit     #$50
        bne     @220a       ; return if $3aa0.4 or $3aa0.6 are set
        lda     $3aa1,x     ; clear $3aa1.7, set $3aa1.0
        and     #$7f
        ora     #$01
        sta     $3aa1,x
        jsr     QueueAction
        lda     $32cc,x     ; return if character/monster has no actions pending in the command list
        bmi     @220a
        asl
        tay
        lda     $3420,y     ; command
        cmp     #$1e
        bcs     @220a       ; return if >= $1e (ai)
        sta     $2d6f       ; battle script command (byte 1)
        cmp     #$16
        beq     @21bc       ; branch if command is $16 (jump)
        cpx     #$08
        bcc     @21e6       ; branch if a character
        bra     @220a       ; return if a monster

; jump
@21bc:  lda     $3205,x
        bpl     @220a       ; branch if $3205.7 is clear
        longa
        cpx     #$08
        bcs     @21d3
        lda     #$0016
        sta     $3f28
        lda     $3520,y
        sta     $3f2a
@21d3:  lda     $3018,x
        tsb     $3f2c
        shorta
        lda     $3ef9,x
        ora     #$20
        sta     $3ef9,x
        jsr     UpdateCharGfxBuf

; all character commands + monsters using jump
@21e6:  jsr     InitGfxScript
        jsr     ClearGfxParams
        longa
        lda     $3520,y     ; load targets
        sta     $b8
        shorta
        lda     #$0c        ; battle script command $0c (ready stance/jump)
        sta     $2d6e
        lda     #$ff        ; battle script command $ff (end of script)
        sta     $2d72
        jsr     InitGfxParams
        jsr     CopyGfxParamsToBuf
        lda     #$04        ; battle graphics $04 (execute battle script)
        jsr     ExecBtlGfx
@220a:  jmp     BattleLoop

; ------------------------------------------------------------------------------

; [ check if attack hits ]

CheckHit:
@220d:  pha
        phx
        clc
        php
        shorta
        stz     $fe
        lda     $b3
        bpl     @2235
        lda     $3ee4,y
        bit     #$10
        beq     @2235
        lda     $11a4
        asl
        bmi     @222d
        lda     $11a2
        lsr
        jmp     @22b3
@222d:  lda     $3dfc,y
        ora     #$10
        sta     $3dfc,y
@2235:  lda     $11a3
        bit     #$02
        bne     @224b
        lda     $3ef8,y
        bpl     @224b
        longa
        lda     $3018,y
        tsb     $a6
        jmp     @22e5

@224b:  .a8
        lda     $11a2
        bit     #$02
        beq     @2259
        lda     $3aa1,y
        bit     #$04
        bne     @22b5       ; branch if $3aa1.2 is set (instant death protection)
@2259:  lda     $11a2
        bit     #$04
        beq     @2268
        lda     $3ee4,y
        eor     $3c95,y
        bpl     @22b5
@2268:  lda     $b5
        cmp     #$00
        beq     @2272
        cmp     #$06
        bne     @22a1
@2272:  lda     $11a9
        bne     @22a1
        lda     $3ec9
        cmp     #$01
        bne     @22a1       ; branch if there is not one target

; single target
        cpy     #$08
        bcs     @22a1
        lda     $3ef9,y
        asl
        bpl     @2293
        jsr     RandCarry
        bcc     @2293
        lda     #$40
        sta     $fe
        bra     @22b5
@2293:  lda     $3a36
        ora     $3a37
        beq     @22a1
        lda     #$20
        sta     $fe
        bra     @22b5

; multiple targets
@22a1:  lda     $11a4
        bit     #$20
        bne     @22e8
        bit     #$40
        bne     @22ec
        bit     #$10
        beq     @22fb
        jsr     _c2239c
@22b3:  bcc     @22e8
@22b5:  lda     $3ee4,y
        bit     #$1a
        bne     @22d1
        cpy     #$08
        bcs     @22d1
        jsr     _c223bf
        cmp     #$06
        bcc     @22d1
        ldx     #$03
@22c9:  stz     $11aa,x
        dex
        bpl     @22c9
        bra     @22e8
@22d1:  lda     #$02
        tsb     $b2
        stz     $3a89
        lda     $341c
        beq     @22e5
        longa
        lda     $3018,y
        tsb     $3a5a
@22e5:  plp
        sec
        php
@22e8:  plp
        plx
        pla
        rts
@22ec:  ldx     $11a8
        clr_a
        lda     $3b18,y
        jsr     Div
        txa
        bne     @22d1
        bra     @22e8
@22fb:  peaflg  STATUS12, {PETRIFY, SLEEP}
        peaflg  STATUS34, {STOP, FROZEN}
        jsr     CheckStatus
        bcc     @22e8
        longa
        lda     $3018,y
        bit     $3a54
        shorta
        bne     @22e8
        lda     $11a8
        cmp     #$ff
        beq     @22e8
        sta     $ee
        lda     $11a2
        lsr
        bcc     @233f
        lda     $3e4c,y
        lsr
        bcs     @22e8       ; branch if $3e4c.0 is set (retort)
        lda     $3ee5,y
        bit     #$04
        beq     @233f
        jsr     Rand
        cmp     #$40
        bcs     @22d1
        lda     $3dfd,y
        ora     #$04
        sta     $3dfd,y
        bra     @22d1
@233f:  lda     $3b54,y
        bcs     @2347
        lda     $3b55,y
@2347:  pha
        bcc     @2388
        lda     $3ee4,x
        lsr
        bcc     @2352
        lsr     $ee
@2352:  lda     $3c58,y
        bit     #$04
        beq     @235b
        lsr     $ee
@235b:  peaflg  STATUS12, {BLIND, ZOMBIE, CONFUSE}
        peaflg  STATUS34, {SLOW, RERAISE}
        jsr     CheckStatus
        bcs     @2372
        lda     $ee
        lsr2
        adc     $ee
        bcc     @2370
        lda     #$ff
@2370:  sta     $ee
@2372:  peaflg  STATUS12, {POISON, SAP, NEAR_FATAL}
        peaflg  STATUS34, HASTE
        jsr     CheckStatus
        bcs     @2388
        lda     $ee
        lsr     $ee
        lsr     $ee
        sec
        sbc     $ee
        sta     $ee
@2388:  pla
        xba
        lda     $ee
        jsr     MultAB
        xba
        sta     $ee
        lda     #$64
        jsr     RandA
        cmp     $ee
        jmp     @22b3

; ------------------------------------------------------------------------------

; [  ]

_c2239c:
; death:
@239c:  lda     $3b55,y
        xba
        lda     $11a8
        jsr     MultAB
        xba
        sta     $ee
        lda     #$64
        jsr     RandA
        cmp     $ee
        bcs     _23be
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_c223b2:
@23b2:  jsr     Rand
        and     #$7f        ; random number (0..127)
        sta     $ee
        lda     $3b40,y
        cmp     $ee
_23be:  rts

; ------------------------------------------------------------------------------

; [  ]

_c223bf:
_setevasionanima:
@23bf:  phy
        lda     $11a2
        lsr
        bcs     @23c7
        iny
@23c7:  clr_a
        lda     $3ce4,y
        ora     $fe
        beq     @23eb
        jsr     RandBit
        bit     #$40
        beq     @23d9
        sty     $3a83
@23d9:  bit     #$20
        beq     @23e0
        sty     $3a82
@23e0:  jsr     GetBitID
        tya
        lsr
        tay
        txa
        inc
        sta     $00aa,y
@23eb:  ply
        rts

; ------------------------------------------------------------------------------

; [ init battle ram ]

InitBattle:
@23ed:  php
        longai
        ldx     #$0258      ; $3a20-$3ed3 = #$00
@23f3:  stz     $3a20,x
        stz     $3c7a,x
        dex2
        bpl     @23f3
        clr_a
        dec
        ldx     #$0a0e
@2402:  sta     $2000,x     ; $2000-$341f = #$ff
        sta     $2a10,x
        dex2
        bpl     @2402
        stz     $2f44       ; clear invisible monsters (clear status)
        stz     $2f4c       ; clear untargettable characters/monsters
        stz     $2f4e       ; clear targettable characters/monsters
        stz     $2f53       ; clear h-flip for controlled targets (relm) and muddled characters
        stz     $b0         ; clear flags
        stz     $b2
        ldx     #.loword(TargetMaskTbl)
        ldy     #$3018
        lda     #$001b
        mvn     #^TargetMaskTbl,#$7e
        lda     $11e0       ; battle index
        cmp     #$01d7
        shortai
        bne     @2435       ; branch if not first statue of final battle
        stz     $3ee0       ; disable final battle scrolling
@2435:  ldx     #$13        ; load battle event data
@2437:  lda     $1dc9,x
        sta     $3eb4,x
        dex
        bpl     @2437
        lda     $021e       ; low byte of game time (frames)
        asl2
        sta     $be         ; set random number seed
        jsr     LoadBattleProp
        jsr     InitParty
        lda     #$80        ;
        trb     $3ebb
        lda     #$91        ; disable zone eater, time up, game over flags
        trb     $3ebc
        ldx     #$12
@2459:  jsr     Rand
        sta     $3af0,x     ;
        lda     #$bc        ; flags to update character (spell list, condemned counter, command list)
        cpx     $3ee2
        bne     @2468       ; branch if character is not morphed
        ora     #$02        ; update command list (morph/revert)
@2468:  sta     $3204,x
        dex2                ; next character/monster
        bpl     @2459
        jsr     InitChars
        lda     $1d4d       ; command setting
        bmi     @247a       ; branch if short
        stz     $2f2e       ; window
@247a:  bit     #$08        ; battle mode
        beq     @2481       ; branch if active
        inc     $3a8f       ; enable wait mode
@2481:  and     #$07        ; battle speed
        asl3
        sta     $ee
        asl
        adc     $ee
        eor     #$ff
        sta     $3a90       ; set battle speed constant
        lda     $1d4e       ; gauge setting
        bpl     @2498       ; branch if on
        stz     $2021       ; set atb gauge setting
@2498:  stz     $2f41       ; start battle time
        jsr     InitInventory
        jsr     InitSkills
        jsr     InitMonsters
        jsr     UpdateStatus
        jsr     AfterAction1
        lda     #$14
        sta     $11af       ; level 20
        jsr     AfterAction2
        jsr     UpdateDead
        jsr     ChooseBattleType
        jsr     InitStatus
        jsr     InitBattleType
        jsr     InitGauge
        ldx     #$00
        lda     $2f4b
        bit     #$04
        bne     @24ea
        lda     $201f
        cmp     #$01
        bne     @24d5
        ldx     #$23        ; battle message $23 (back attack)
        bra     @24ea
@24d5:  cmp     #$02
        bne     @24dd
        ldx     #$25        ; battle message $25 (pincer attack)
        bra     @24ea
@24dd:  cmp     #$03
        bne     @24e3
        ldx     #$24        ; battle message $24 (side attack)
@24e3:  lda     $b0
        asl
        bpl     @24ea
        ldx     #$22        ; battle message $22 (preemptive attack)
@24ea:  txy
        beq     @24f2
        lda     #$25        ; command $25 (display battle message)
        jsr     CreateImmediateAction
@24f2:  jsr     UpdateMonsterGfxBuf
        jsr     UpdateCounterGfxBuf
        stz     $b8
        stz     $b9
        ldx     #$06
@24fe:  lda     $3018,x     ; check for jump/seize characters
        bit     $3f2c
        beq     @251c
        lda     $3aa0,x     ; set $3aa0.3 and $3aa0.5
        ora     #$28
        sta     $3aa0,x
        stz     $3219,x
        jsr     _c24e77       ; add action to queue
        lda     #$16        ; command $16 (jump)
        sta     $3a7a
        jsr     CreateNormalAction
@251c:  dex2                ; next character
        bpl     @24fe
        lda     $3ee1       ; data byte for final battle scrolling
        inc
        beq     @253f       ; branch if not scrolling, do battle graphics command $00 (init battle graphics)
        dec
        sta     $2d6f
        lda     #$12        ; battle script command $12 (scroll background between bosses in final battle)
        sta     $2d6e
        lda     $3a75
        sta     $2d71
        lda     #$ff
        sta     $2d70
        sta     $2d72
        lda     #$04        ; battle graphics $04 (execute battle script)
@253f:  jsr     ExecBtlGfx
        plp
        rts

; ------------------------------------------------------------------------------

; [ init characters ]

InitChars:
_loadplayer:
@2544:  jsr     InitSpellList
        ldx     #6
@2549:  lda     $3ed8,x     ; actor number
        bmi     @2570       ; skip if character slot is empty
        cmp     #$10
        bcs     @2557       ; branch if >= $10 (ghost #1)
        tay
        txa
        sta     $3000,y     ; set actor's character slot
@2557:  lda     $3018,x
        tsb     $3a8d       ; set characters present
        lda     $3ed9,x     ; character index
        jsl     UpdateEquip
        jsr     UpdateEquipBattle
        jsr     LoadCharProp
        jsr     ValidateSpellList
        jsr     InitCmdList
@2570:  dex2                ; next character
        bpl     @2549
        rts

; ------------------------------------------------------------------------------

; [ init ATB gauges ]

InitGauge:
@2575:  php
        stz     $f3
        ldy     #$12
@257a:  lda     $3aa0,y
        lsr
        bcs     @2587       ; branch if $3aa0.0 is set
        clc
        lda     #$10
        adc     $f3
        sta     $f3
@2587:  dey2
        bpl     @257a
        longa
        lda     #$03ff
        sta     $f0
        ldy     #$12
@2594:  lda     $f0
        jsr     RandBit
        trb     $f0
        jsr     GetBitID
        shorta
        txa
        asl3
        sta     $f2
        lda     $3219,y
        inc
        bne     @25fa
        lda     $3ee1
        inc
        bne     @25fa
        ldx     $201f
        lda     $3018,y
        bit     $3a40
        bne     @25d1
        cpy     #$08
        bcs     @25d1
        lda     $b0
        asl
        bmi     @25fa
        dex
        bmi     @25de
        dex2
        beq     @25fa
        lda     $f2
        bra     @25f3
@25d1:  lda     $b0
        asl
        bmi     @25da
        cpx     #$03
        bne     @25de
@25da:  lda     #$01
        bra     @25f3
@25de:  lda     $3b19,y
        jsr     RandA
        adc     $3b19,y
        bcs     @25f1
        adc     $f2
        bcs     @25f1
        adc     $f3
        bcc     @25f3
@25f1:  lda     #$ff
@25f3:  inc
        bne     @25f7
        dec
@25f7:  sta     $3219,y
@25fa:  longa
        dey2
        bpl     @2594
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; character masks
TargetMaskTbl:
@2602:  .word   $0001,$0002,$0004,$0008

; monster masks
@260a:  .word   $0100,$0200,$0400,$0800,$1000,$2000

; pointers to character spell lists in ram (unused)
@2616:  .word   $208e,$21ca,$2306,$2442

; ------------------------------------------------------------------------------

; [ clear battle data ]

InitRAM:
_initkernel2:
@261e:  clr_a
        ldx     #$5f
@2621:  sta     $3ee4,x     ; $3ee4-$3f43 = #$00
        dex
        bpl     @2621
        dec
        ldx     #$0f
@262a:  sta     $3ed4,x     ; $3ed4-$3ee3 = #$ff
        dex
        bpl     @262a
        lda     #$12
        sta     $3f28       ; set previous attack to mimic
        sta     $3f24
        rts

; ------------------------------------------------------------------------------

; [ init graphics script ]

InitGfxScript:
_initanima:
@2639:  php
        stz     $3a72       ; clear battle script command queue pointer
        stz     $3a70       ; clear number of attacks (0 = 1 attack)
        longa
        stz     $3a32       ; clear pointer to battle script data
        stz     $3a34       ; clear counter for damage variables
        stz     $3a30       ; clear targets
        stz     $3a4e       ; clear backup targets
        plp
        rts

; ------------------------------------------------------------------------------

; [ update death/poison immunity ]

; change death status immunity into instant death protection
; change poison element resistance into poison status immunity

_initstatus3:
FixImmuneStatus:
        .a8
@2650:  lda     $3aa1,x     ; clear $3aa1.2 (instant death protection)
        and     #$fb
        xba
        lda     $331c,x
        bmi     @2661       ; branch if not immune to wound status
        ora     #STATUS1::DEAD
        xba
        ora     #$04
        xba
@2661:  xba
        sta     $3aa1,x     ; set $3aa1.2 (instant death protection)
        lda     $3bcd,x
        bit     #ELEMENT::POISON
        beq     @2670       ; branch if not immune to poison element
        xba
        clrflg  STATUS1, POISON
        xba
@2670:  xba
        sta     $331c,x     ; set immune to poison status
        rts

; ------------------------------------------------------------------------------

; [ update status immunity ]

UpdateImmuneStatus:
_initstatus2:
@2675:  lda     $3331,x                 ; blocked status 4
        xba
        lda     $3c6d,x                 ; equipment status 3
        lsr
        bcc     @2683                   ; branch if no float
        xba
        clrflg  STATUS4, FLOAT
        xba

; check permanent morph
@2683:  lda     $3ebb                   ; permanent morph
        bit     #$04
        beq     @268e
        xba
        clrflg  STATUS4, MORPH
        xba
@268e:  xba
        sta     $3331,x

; block both regen and sap if immune to either
        lda     $3330,x
        xba
        lda     $331d,x
        longa
        sta     $ee
        lda     $3c6c,x
        and     #$ee78
        eor     #$ffff
        and     $ee
        bit     #STATUS23::REGEN
        beq     @26b2
        bit     #STATUS23::SAP
        bne     @26b5
@26b2:  clrflg  STATUS23, {SAP, REGEN}

; block both slow and haste if immune to either
@26b5:  shorta
        sta     $331d,x
        xba
        bit     #STATUS3::SLOW
        beq     @26c3
        bit     #STATUS3::HASTE
        bne     @26c5
@26c3:  clrflg  STATUS3, {SLOW, HASTE}
@26c5:  sta     $3330,x
        rts

; ------------------------------------------------------------------------------

; [ init status immunity ]

InitStatus:
_initstatus:
@26c9:  ldx     #$12
@26cb:  jsr     UpdateImmuneStatus
        dex2                ; next character/monster
        bpl     @26cb
        rts

; ------------------------------------------------------------------------------

; [ init attack target ]

; _inittarget:
InitTarget:
@26d3:  phx
        phy
        pha
        stz     $ba
        ldx     #$40
        stx     $bb
        ldx     #$00
        cmp     #$1e
        bcs     @2701
        tax
        lda     f:CmdTargetTbl,x
        pha
        and     #$e1
        sta     $ba
        lda     $01,s
        and     #$18
        lsr
        tsb     $ba
        txa
        asl
        tax
        lda     f:BattleCmdProp+1,x   ; targetting byte
        sta     $bb
        pla
        and     #$06
        tax
        xba
@2701:  jsr     (.loword(InitTargetTbl),x)
        pla
        ply
        plx
_2707:  rts

; ------------------------------------------------------------------------------

; 3: throw/tools
InitTarget_03:
@2708:  ldx     #$04
@270a:  cmp     f:ThrowToolsItemTbl,x
        bne     @2716
        sbc     f:ThrowToolsOffsetTbl,x
        bra     _274d
@2716:  dex
        bpl     @270a
        sec
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

InitItemTarget:
; itemcursor:
@271a:  sta     $3411
        jsr     GetItemPropPtr
        longi
        tax
        lda     f:ItemProp+14,x   ; targetting
        sta     $bb
        lda     f:ItemProp+21,x   ;
        bit     #$c2
        bne     @2735
        lda     #$08
        trb     $ba
@2735:  lda     f:ItemProp+18,x   ;
        shorti
        rts

; ------------------------------------------------------------------------------

; 1: item
InitTarget_01:
@273c:  cmp     #$e6
        jsr     InitItemTarget
        bcs     _2707
        bmi     @274b
        xba
        lda     #$10
        tsb     $b1
        xba
@274b:  and     #$3f
; fall through

; ------------------------------------------------------------------------------

; 2: commands that use a spell/attack
; magic, swdtech, blitz, lore, slot, rage, dance, x-magic, summon, health, shock, magitek
InitTarget_02:
_274d:  sta     $3410       ; set last spell used
        bra     _2754

; ------------------------------------------------------------------------------

; 0: commands that don't use a spell attack
; fight, morph, revert, steal, capture, runic, sketch, control, leap, mimic, row, def, jump, gp rain, possess
InitTarget_00:
@2752:  lda     #$ee        ; attack $ee (battle)
_2754:  jsr     LoadMagicProp
        lda     $bb
        inc
        bne     @2761       ;
        lda     $11a0
        sta     $bb
@2761:  lda     $11a2       ;
        pha
        and     #$04        ; isolate resurrection targetting flag
        asl
        tsb     $ba         ; copy to "can hit dead targets flag"
        lda     $01,s
        and     #$10        ; random target flag
        asl2
        tsb     $ba         ; copy to $ba
        pla
        and     #$80        ; can't target characters flag
        tsb     $ba
        rts

; ------------------------------------------------------------------------------

; bio blaster, flash, fire skean, water edge, bolt edge
ThrowToolsItemTbl:
@2778:  .byte   $a4,$a5,$ab,$ac,$ad

; ------------------------------------------------------------------------------

; spell offsets for above items
ThrowToolsOffsetTbl:
@277d:  .byte   $27,$27,$5a,$5a,$5a

; ------------------------------------------------------------------------------

; command init jump table
InitTargetTbl:
@2782:  .addr   InitTarget_00
        .addr   InitTarget_01
        .addr   InitTarget_02
        .addr   InitTarget_03

; ------------------------------------------------------------------------------

; command targetting data (one byte per command)
CmdTargetTbl:
@278a:  .byte   $20,$1a,$04,$18,$18,$00,$20,$24,$06,$06,$04,$18,$04,$80,$80,$04
        .byte   $04,$80,$18,$04,$18,$18,$21,$04,$01,$04,$04,$04,$81,$04

; ------------------------------------------------------------------------------

; [ load character properties ]

LoadCharProp:
@27a8:  php
        longai
        ldy     $3010,x
        lda     $1609,y
        sta     $3bf4,x
        lda     $160d,y
        sta     $3c08,x
        lda     $160b,y
        jsr     CalcMaxHPMP
        cmp     #10000
        bcc     @27c8
        lda     #9999
@27c8:  sta     $3c1c,x
        lda     $160f,y
        jsr     CalcMaxHPMP
        cmp     #1000
        bcc     @27d9
        lda     #999
@27d9:  sta     $3c30,x
        lda     $3018,x
        bit     $b8
        beq     @27f8
        lda     $3c1c,x
        sta     $3bf4,x
        lda     $3c30,x
        sta     $3c08,x
        lda     $1614,y
        and     #$ff2d
        sta     $1614,y
@27f8:  lda     $3c6c,x
        shorta
        sta     $3dd5,x
        lsr
        bcc     @280b
        lda     $3204,x
        and     #$ef
        sta     $3204,x
@280b:  lda     $1614,y
        sta     $3dd4,x
        bit     #$08
        beq     @281f
        lda     #$1d
        sta     $3f20
        lda     #$83
        sta     $3f21
@281f:  lda     $1615,y
        and     #$c0
        xba
        lsr
        bcc     @282c
        xba
        ora     #$80
        xba
@282c:  asl
        sta     $3de8,x
        xba
        sta     $3de9,x
        lda     $1608,y
        sta     $3b18,x
        plp
        rts

; ------------------------------------------------------------------------------

; [ calculate boosted max hp/mp ]

CalcMaxHPMP:
_decodehp:
@283c:  .a16
        phx
        asl
        rol
        sta     $ee
        rol2
        and     #$0006
        tax
        lda     $ee
        lsr2
        sta     $ee
        jmp     (.loword(MaxHPMPTbl),x)

; ------------------------------------------------------------------------------

; 0: no boost
MaxHPMP_00:
@2850:  clr_a

; 3: +12.5%
MaxHPMP_03:
@2851:  lsr

; 1: +25%
MaxHPMP_01:
@2852:  lsr

; 2: +50%
MaxHPMP_02:
@2853:  lsr
        clc
        adc     $ee
        plx
        rts

; ------------------------------------------------------------------------------

MaxHPMPTbl:
@2859:  .addr   MaxHPMP_00
        .addr   MaxHPMP_01
        .addr   MaxHPMP_02
        .addr   MaxHPMP_03

; ------------------------------------------------------------------------------

; [ invert evade/mblock ]

_evasionconv:
InvertEvade:
@2861:  .a8
        asl
        bcc     @2866
        lda     #$ff
@2866:  eor     #$ff
        inc
        bne     @286c
        dec
@286c:  rts

; ------------------------------------------------------------------------------

; [ init battle equipment effects ]

UpdateEquipBattle:
; _loadcharcter2:
@286d:  phd
        pea     $1100       ; set direct page to $1100
        pld
        lda     $c9         ; armor
        cmp     #$9f
        bne     @2883       ; branch if not $9f (moogle suit)
        txa
        asl4
        tay
        lda     #$0a        ; use mog sprite
        sta     $2eae,y     ; character graphics index
@2883:  txa
        lsr
        tay
        lda     $d8         ; genji glove
        and     #$10
        sta     $2e6e,y
        clc
        lda     $a6         ; vigor * 2 (max $ff)
        adc     $a6
        bcc     @2896
        lda     #$ff
@2896:  sta     $3b2c,x     ; set vigor
        lda     $a4
        sta     $3b2d,x     ; set speed (dummy)
        sta     $3b19,x     ; set speed
        lda     $a2
        sta     $3b40,x     ; set stamina
        lda     $a0
        sta     $3b41,x     ; set mag.pwr
        lda     $a8
        jsr     InvertEvade
        sta     $3b54,x     ; set evade
        lda     $aa
        jsr     InvertEvade
        sta     $3b55,x     ; set mblock
        lda     $cf         ;
        trb     $d8
        lda     $bc
        sta     $3c6c,x     ; status 2 effects
        lda     $d4
        sta     $3c6d,x     ; status 3 effects
        lda     $dc
        sta     $3d71,x     ; run factor
        lda     $d9
        and     #$80
        ora     #$10
        sta     $3c95,x     ; undead (relic ring), human (always)
        lda     $d5         ; relic effects 1
        asl
        xba
        lda     $d6
        tsb     $3a6d       ; set relic effects 2 (party)
        asl
        lda     $d7         ; relic effects 3
        xba
        ror
        longa
        sta     $3c44,x     ; relic effects 1
        lda     $ac
        sta     $3b68,x     ; bat.pwr
        lda     $ae
        sta     $3b7c,x     ; hit rate
        lda     $b4
        sta     $3d34,x     ; weapon spell cast
        lda     $b0
        sta     $3b90,x     ; weapon element
        lda     $d8
        bit     #$0008
        bne     @290a       ; branch if gauntlet equipped
        lda     #$4040
        trb     $da         ; clear 2-hand effect
@290a:  lda     $da
        sta     $3ba4,x     ; weapon effects
        lda     $ba
        sta     $3bb8,x     ; defense/magic defense
        lda     #$ffff
        sta     $331c,x
        eor     $d2
        sta     $331c,x     ; blocked status 1 & 2
        lda     $b6
        sta     $3bcc,x     ; absorbed/nullified elements
        lda     $b8
        sta     $3be0,x     ; weak/halved elements
        lda     $be
        sta     $3cbc,x     ; block effects
        lda     $c6
        sta     $3ca8,x     ; weapon/shield
        lda     $ca
        sta     $3cd0,x     ; relic 1/relic 2
        lda     $d0
        sta     $3ce4,x     ; physical block graphic
        lda     $d8
        sta     $3c58,x     ; relic effects 4
        shorta
        asl     $3a21,x     ;
        asl3
        ror     $3a21,x     ;
        pld
        jmp     FixImmuneStatus

; ------------------------------------------------------------------------------

; [ update hit rate and level ]

InitAttacker:
; _loadmagic:
@2951:  lda     $11a2
        lsr
        lda     $3b41,x     ; mag.pwr * 1.5
        bcc     @295d       ; branch if magic-based attack
        lda     $3b2c,x     ; vigor * 2
@295d:  sta     $11ae       ; set hit rate
        stz     $3a89       ; disable random weapon spellcast
        jmp     InitAttackerLevel

; ------------------------------------------------------------------------------

; [ load spell data ]

; A: spell index

LoadMagicProp:
@2966:  phx
        php
        xba
        lda     #$0e        ; 14 bytes each
        jsr     MultAB
        longai_clc
        adc     #.loword(MagicProp)      ; +$c46ac0
        tax
        ldy     #$11a0
        lda     #$000d      ; 14 bytes -> $11a0
        mvn     #^MagicProp,#$7e
        shorta
        asl     $11a9       ; multiply special effect by 2 to get pointer to jump tables
        bcc     @2987
        stz     $11a9       ; if special effect was $ff, disable special effect
@2987:  plp
        plx
        rts

.pushseg
.segment "magic_prop"

.export MagicProp

; c4/6ac0
MagicProp:
        .incbin "magic_prop.dat"

.popseg

; ------------------------------------------------------------------------------

; [  ]

_c2298a:
_simplemagic:
@298a:  lda     $3a7c
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_c2298d:
_simplemagic2:
@298d:  jsr     InitTarget
        lda     #$20
        tsb     $11a4
        stz     $11a9
        stz     $11af       ; clear level
        stz     $11ae       ; clear hit rate
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2299f:
_magicpunch:
@299f:  .i8
        php
        lda     $3b2c,x     ; vigor * 2
        sta     $11ae
        jsr     InitAttackerLevel
        lda     $3c45,x
        bit     #$10
        beq     @29b5
        lda     #$20
        tsb     $11a4
@29b5:  lda     $b6
        cmp     #$ef
        bne     @29c7
        lda     $3ee4,x
        bit     #$20
        bne     @29c7
        lda     #$06
        sta     $3412
@29c7:  plp
        phx
        ror     $b6
        bpl     @29ce
        inx
@29ce:  lda     $3b68,x
        sta     $11a6
        lda     #$62
        tsb     $b3
        lda     $3ba4,x
        and     #$60
        eor     #$20
        trb     $b3
        lda     $3b90,x
        sta     $11a1
        lda     $3b7c,x
        sta     $11a8
        lda     $3d34,x
        sta     $3a89
        lda     $3cbc,x     ; special effect (weapons can only use $00-$0f)
        and     #$f0
        lsr3
        sta     $11a9
        lda     $3ca8,x
        inc
        sta     $b7
        plx
        lda     $3c58,x
        lsr
        bcc     @2a1b
        lda     #$20
        tsb     $11a4
        lda     #$40
        tsb     $ba
        lda     #$02
        tsb     $b2
        stz     $3a89
@2a1b:  lda     $11a6
        beq     @2a36
        cpx     #$08
        bcc     @2a36
        lda     #$20
        bit     $3ee4,x
        beq     @2a36
        asl
        bit     $3c95,x
        bne     @2a36
        lda     #$01
        sta     $11a6
@2a36:  rts

; ------------------------------------------------------------------------------

; [ calculate item effect ]

; c: 0 = normal, 1 = tools/throw

CalcItemEffect:
_magicitem:
@2a37:  phx
        php
        pha
        phx
        ldx     #$0f
@2a3d:  stz     $11a0,x     ; clear $11a0-$11af
        dex
        bpl     @2a3d
        plx
        lda     #$21
        sta     $11a2       ; ignore defense, physical damage
        lda     #$22
        sta     $11a3       ; re-target if target invalid, ignore reflect
        lda     #$20
        sta     $11a4       ; can't dodge
        bcc     @2a5e       ; branch if not tools/throw
        lda     $3b2c,x     ; hit rate = vigor * 2
        sta     $11ae
        jsr     InitAttackerLevel
@2a5e:  lda     $01,s
        jsr     GetItemPropPtr
        longi
        tax
        lda     f:ItemProp+20,x   ; battle/defense power
        sta     $11a6
        lda     f:ItemProp+15,x   ; item element
        sta     $11a1
        bcs     @2adc       ; branch if tools/throw
        lda     #$01
        trb     $11a2
        lda     f:ItemProp+27,x   ; item special effect
        asl
        bcs     @2a87
        adc     #$90        ; offset by $48 in special effect list
        sta     $11a9
@2a87:  longa
        lda     f:ItemProp+21,x   ; status 1 and 2
        sta     $11aa
        lda     f:ItemProp+23,x   ; status 3 and 4
        sta     $11ac
        shorta
        lda     f:ItemProp+19,x   ; item properties
        sta     $fe
        asl     $fe
        bcc     @2aa8       ; damage is a fraction of total hp/mp
        lda     #$80
        tsb     $11a4
@2aa8:  asl     $fe
        asl     $fe
        bcc     @2ab3       ; item removes status
        lda     #$04
        tsb     $11a4
@2ab3:  asl     $fe
        bcc     @2abe       ; restore mp
        lda     #$80
        tsb     $11a3
        tsb     $fe
@2abe:  asl     $fe
        bcc     @2ac7       ; restore hp
        lda     #$01
        tsb     $11a4
@2ac7:  asl     $fe
        asl     $fe
        bcc     @2ad2       ; invert damage to undead
        lda     #$08
        tsb     $11a2
@2ad2:  lda     $11aa
        bpl     @2adc       ; branch if item doesn't affect wound status
        lda     #$0c
        tsb     $11a2       ; invert damage to undead, resurrection targetting
@2adc:  lda     $01,s
        cmp     #$ae
        bne     @2ae9       ; branch if not inviz edge
        lda     #$10
        tsb     $11aa
        bra     @2af2
@2ae9:  cmp     #$af
        bne     @2af2       ; branch if not shadow edge
        lda     #$04
        tsb     $11ab
@2af2:  lda     f:ItemProp,x
        and     #$07
        bne     @2b16       ; return if not a tool
        lda     #$20
        trb     $11a2
        trb     $11a4
        lda     f:ItemProp+21,x
        sta     $11a8
        clr_a
        lda     $01,s
        sec
        sbc     #$a3
        and     #$07
        asl
        tax
        jsr     (.loword(ToolsEffectTbl),x)
@2b16:  pla
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; tool effect jump table
machinetable_loadmagic:
ToolsEffectTbl:
@2b1a:  .addr   ToolsEffect_00
        .addr   ToolsEffect_01
        .addr   ToolsEffect_02
        .addr   ToolsEffect_03
        .addr   ToolsEffect_04
        .addr   ToolsEffect_05
        .addr   ToolsEffect_06
        .addr   ToolsEffect_07

; ------------------------------------------------------------------------------

; 0: noiseblaster
ToolsEffect_00:
@2b2a:  lda     #STATUS2::CONFUSE
        sta     $11ab
; fallthrough

; ------------------------------------------------------------------------------

ToolsEffect_01:
ToolsEffect_02:
@2b2f:  rts

; ------------------------------------------------------------------------------

; 3: chain saw
ToolsEffect_03:
@2b30:  jsr     Rand
        and     #$03
        bne     _2b4d       ; 3/4 chance to branch
        lda     #$08
        sta     $b6         ; spell $08 (alternate chainsaw)
        stz     $11a6
        lda     #$80
        tsb     $11aa
        lda     #$10
        sta     $11a4
        lda     #$02
        tsb     $11a2
; fall through

; ------------------------------------------------------------------------------

; 5: drill
ToolsEffect_05:
_2b4d:  lda     #$20
        tsb     $11a2       ; ignore defense
        rts

; ------------------------------------------------------------------------------

; 4: debilitator
ToolsEffect_04:
@2b53:  lda     #$ac        ; special effect $56 (debilitator)
        bra     _2b59

; ------------------------------------------------------------------------------

; 6: air anchor
ToolsEffect_06:
@2b57:  lda     #$ae        ; special effect $57 (air anchor)
_2b59:  sta     $11a9
        rts

; ------------------------------------------------------------------------------

; 7: autocrossbow
ToolsEffect_07:
@2b5d:  lda     #$40
        tsb     $11a2       ; don't split damage
        rts

; ------------------------------------------------------------------------------

; [ get pointer to item data ]

_itemindex:
GetItemPropPtr:
@2b63:  xba
        lda     #$1e
        jmp     MultAB

; ------------------------------------------------------------------------------

; [ magical damage ]

CalcMagicDmg:
_initdamage:
@2b69:  lda     $11af       ; level
        sta     $e8
        cmp     #$01
        clr_a
        lda     $11a6
        longa
        bcc     @2b7a
        asl2
@2b7a:  sta     $11b0
        shorta
        lda     $11ae       ; hit rate
        xba
        lda     $11a6
        jsr     MultAB
        jsr     Mult24
        lda     #$04
        longa
        jsr     LsrA
        clc
        adc     $11b0
        sta     $11b0
        shorta
        rts

; ------------------------------------------------------------------------------

; [ calculate base damage ]

_initdamage2:
CalcDmg:
@2b9d:  .i8
        lda     $11a2
        lsr
        jcc     CalcMagicDmg

; physical damage
@2ba6:  php
        lda     $11af       ; level
        pha
        sta     $e8
        clr_a
        lda     $11a6
        longa
        cpx     #$08
        bcc     @2bb9
        asl2
@2bb9:  pha
        lda     $b2
        bit     #$4000
        bne     @2bcd
        lda     $01,s
        lsr
        clc
        adc     $01,s
        lsr
        clc
        adc     $01,s
        sta     $01,s
@2bcd:  pla
        shorta
        adc     $11ae       ; hit rate
        xba
        adc     #$00
        xba
        jsr     Mult24
        lda     $e8
        sta     $ea
        pla
        sta     $e8
        longa
        lda     $e9
        xba
        jsr     Mult24
        sta     $11b0
        cpx     #$08
        bcs     @2c1f
        lda     $11a6
        and     #$00ff
        asl
        adc     $11b0
        lsr
        clc
        adc     $11b0
        sta     $11b0
        lda     $3c58,x
        lsr
        bcc     @2c0b
        lsr     $11b0
@2c0b:  bit     #$0008
        beq     @2c1f
        lda     $11b0
        lsr2
        eor     #$ffff
        sec
        adc     $11b0
        sta     $11b0
@2c1f:  plp
        rts

; ------------------------------------------------------------------------------

; [ update attacker level ]

InitAttackerLevel:
@2c21:  phx
        lda     $3417       ; character using sketch
        bmi     @2c28       ; branch if invalid
        tax
@2c28:  lda     $3b18,x     ; level
        sta     $11af       ; set attacker level
        plx
        rts

; ------------------------------------------------------------------------------

; [ init monster data ]

; +A: monster index

LoadMonsterProp:
@2c30:  phx
        php
        longai
        sta     $1ff9,y     ; set monster index (+$2001)
        sta     $33a8,y
        jsr     InitAI
        asl2
        pha
        tax
        lda     f:MonsterItems,x   ; items stolen
        sta     $3308,y
        pla
        asl
        pha
        phx
        phy
        tax
        lda     $1ff9,y     ; monster index for name display
        sta     $3380,y
        clr_ay
@2c56:  lda     f:MonsterName,x   ; monster name
        sta     $00f8,y
        inx2
        iny2
        cpy     #8
        bcc     @2c56
        ldy     #$0012
@2c69:  lda     $1ff9,y
        bmi     @2c96
        phy
        asl3
        tax
        clr_ay
@2c75:  lda     $00f8,y
        cmp     f:MonsterName,x   ; monster name
        clc
        bne     @2c88
        inx2
        iny2
        cpy     #8
        bcc     @2c75
@2c88:  ply
        bcc     @2c96
        lda     $01,s
        tax
        lda     $1ff9,y
        sta     $3380,x
        bra     @2c9d
@2c96:  dey2
        cpy     #8
        bcs     @2c69
@2c9d:  ply
        plx
        pla
        asl2
        tax
        lda     f:MonsterProp+5,x   ; defense/magic defense
        sta     $3bb8,y
        lda     f:MonsterProp+12,x   ; experience points
        sta     $3d84,y
        lda     f:MonsterProp+14,x   ; gold
        sta     $3d98,y
        lda     $3a46
        bmi     @2ce4       ; branch if monsters get returned to full hp/mp ($3a47.7)
        lda     f:MonsterProp+10,x   ; mp
        sta     $3c08,y
        sta     $3c30,y
        lda     f:MonsterProp+8,x   ; hp
        sta     $3bf4,y
        sta     $3c1c,y
        lda     $3ed4       ; battle index
        cmp     #$01cf
        bne     @2ce4       ; branch if not $01cf (doom gaze)
        sty     $33fa       ; set target that is doom gaze
        lda     $3ebe       ; get doom gaze's hp
        beq     @2ce4       ; branch if zero
        sta     $3bf4,y     ; set hp
@2ce4:  shorta_sec
        lda     $3c1d,y     ; high byte of max hp
        lsr
        cmp     #$19        ; stamina = max hp / 512 + 16 (max 39)
        bcc     @2cf0
        lda     #$17
@2cf0:  adc     #$10
        sta     $3b40,y
        lda     f:MonsterProp+1,x   ; attack power
        sta     $3b68,y
        lda     f:MonsterProp+26,x   ; attack type (item number for graphics)
        sta     $3ca8,y
        lda     f:MonsterProp+3,x   ; evade %
        jsr     InvertEvade
        sta     $3b54,y
        lda     f:MonsterProp+4,x   ; mblock %
        jsr     InvertEvade
        sta     $3b55,y
        lda     f:MonsterProp+2,x   ; hit %
        sta     $3b7c,y
        lda     f:MonsterProp+16,x   ; level
        sta     $3b18,y
        lda     f:MonsterProp,x   ; speed
        sta     $3b19,y
        lda     f:MonsterProp+7,x   ; mag.pwr
        jsr     AddHalf
        sta     $3b41,y
        lda     f:MonsterProp+30,x   ; special status 1 (piranha/enemy runic)
        and     #$82
        ora     $3e4c,y     ; $3e4c.1 and $3e4c.7
        sta     $3e4c,y
        lda     f:MonsterProp+19,x   ; special status 2
        sta     $3c80,y
        jsr     LoadRageProp
        ldx     $33a8,y
        lda     f:MonsterSpecialAnim,x   ; special attack
        sta     $3c81,y
        shorti
        jsr     InitFirstStrike
        clr_a
        ror
        tsb     $b1
        jsr     Rand
        and     #$07
        clc
        adc     #$38
        sta     $3b2c,y
        tyx
        jsr     FixImmuneStatus
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ init ai script ]

InitAI:
@2d71:  phx
        pha
        php
        longa
        asl
        tax
        lda     f:AIScriptPtr,x   ; pointer to ai script
        sta     $3254,y
        tax
        shorta
@2d82:  jsr     FindAIScriptEnd
        inc
        bne     @2d82
        lda     f:AIScript,x
        inc
        beq     @2d95
        longa
        txa
        sta     $3268,y                 ; start of retaliation script
@2d95:  plp
        .a8
        pla
        plx
        rts

; ------------------------------------------------------------------------------

; [ init monster first strike (pointer in y) ]

InitFirstStrike:
@2d99:  phx
        tyx
        jsr     CheckFirstStrike
        plx
        rts

; ------------------------------------------------------------------------------

; [ init monster first strike ]

CheckFirstStrike:
@2da0:  clc
        lda     $3c80,x     ; return if monster doesn't have first strike
        bit     #$02
        beq     @2dc0
        lda     $3aa0,x
        bit     #$01
        beq     @2dc0       ; branch if $3aa0.0 is clear (target is not present)
        ora     #$08
        sta     $3aa0,x     ; $3aa0.3 stop atb gauge
        stz     $3219,x     ; clear atb gauge
        lda     #$ff
        sta     $3ab5,x     ; set advance wait counter to max
        jsr     _c24e66       ; add action to advance wait queue
        sec
@2dc0:  rts

; ------------------------------------------------------------------------------

; [ init monster/rage data ]

LoadRageProp:
@2dc1:  php
        lda     f:MonsterProp+31,x   ; special attack data
        sta     $322d,y
        lda     f:MonsterProp+25,x   ; weak elements
        ora     $3be0,y
        sta     $3be0,y
        lda     f:MonsterProp+22,x   ; blocked status 3
        eor     #$ff
        and     $3330,y
        sta     $3330,y
        lda     #$ff
        and     $3331,y     ; blocked status 4
        sta     $3331,y
        longa
        lda     f:MonsterProp+27,x   ; status 1 & 2
        sta     $3dd4,y
        lda     f:MonsterProp+29,x   ; status 3 & 4
        pha
        and     #$0001                  ; flying flag
        lsr
        ror
        ora     $01,s
        and     #$84fe      ; ignore "character-only" statuses
        sta     $3de8,y
        pla
        xba
        lsr
        bcc     @2e10
        lda     $3c58,y     ; true knight effect (rage only ???)
        ora     #$0040
        sta     $3c58,y
@2e10:  lda     f:MonsterProp+28,x   ; status 2 & 3
        ora     $3c6c,y
        sta     $3c6c,y
        lda     f:MonsterProp+20,x   ; blocked status 1 & 2
        eor     #$ffff
        and     $331c,y
        sta     $331c,y
        lda     f:MonsterProp+23,x   ; absorbed elements
        ora     $3bcc,y
        sta     $3bcc,y
        lda     f:MonsterProp+17,x   ; metamorph info
        sta     $3c94,y
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ choose battle type ]

ChooseBattleType:
@2e3a:  lda     $3a6d       ; relic effects 2 (party)
        lsr2
        lda     $2f48       ; possible battle types
        bcc     @2e50       ; branch if no back guard
        bit     #$b0
        beq     @2e4a
        and     #$b0        ; disable pincer attacks (unless that is the only available option)
@2e4a:  bit     #$d0
        beq     @2e50
        and     #$d0        ; disable back attacks (unless that is the only available option)
@2e50:  pha
        lda     $3a76       ; number of allies that are alive
        cmp     #$03
        pla
        bcs     @2e5f       ; branch if 3 or 4
        bit     #$70
        beq     @2e5f
        and     #$70        ; disable side attacks (unless that is the only available option)
@2e5f:  ldx     #$10
        jsr     RandBitWithRate
        stx     $201f       ; set type of battle
        rts

; ------------------------------------------------------------------------------

; [ battle type special effects ]

InitBattleType:
@2e68:  ldx     $201f       ; battle type
        cpx     #$00
        beq     @2e74       ; branch if normal
        lda     #$01
        trb     $11e4       ; gau can't be obtained
@2e74:  txa
        asl
        tax
        jsr     (.loword(InitBattleTypeTbl),x)
        ldx     #6
@2e7c:  phx
        lda     $3aa1,x     ; $3aa1.5 character row
        and     #$20
        pha
        txa
        asl4
        tax
        pla
        sta     $2ec5,x     ; set row (for graphics)
        plx
        dex2
        bpl     @2e7c
        rts

; ------------------------------------------------------------------------------

; battle type special function jump table
InitBattleTypeTbl:
@2e93:  .addr   InitBattleType_00
        .addr   InitBattleType_01
        .addr   InitBattleType_02
        .addr   InitBattleType_03

; ------------------------------------------------------------------------------

; normal/side attack
InitBattleType_00:
InitBattleType_03:
@2e9b:  lda     $b1
        bmi     @2ec0       ; return if battle menus are disabled
        lda     $2f4b
        bit     #$04
        bne     @2ec0       ; return if preemptive attacks are disabled
        txa
        asl2
        ora     #$20        ; 1/8 chance to get preemptive strike (7/32 chance for side attack)
        sta     $ee
        lda     $3a6d       ; relic effects 2 (party)
        lsr
        bcc     @2eb5       ; branch if no gale hairpin
        asl     $ee         ; double chance for preemptive attack
@2eb5:  jsr     Rand
        cmp     $ee
        bcs     @2ec0
        lda     #$40        ; set preemptive attack
        tsb     $b0
@2ec0:  rts

; ------------------------------------------------------------------------------

; pincer attack
InitBattleType_02:
@2ec1:  ldx     #$06
@2ec3:  lda     #$df        ; clear $3aa1.5
        jsr     ClearFlag1       ; put all characters in the front row
        dex2
        bpl     @2ec3
        bra     _2edc

; ------------------------------------------------------------------------------

; back attack
InitBattleType_01:
@2ece:  ldx     #$06
@2ed0:  lda     $3aa1,x     ; $3aa1.5 toggle row for all characters
        eor     #$20
        sta     $3aa1,x
        dex2
        bpl     @2ed0
_2edc:  lda     #$20
        tsb     $b1         ; set back attack
        rts

; ------------------------------------------------------------------------------

; [ init monsters ]

InitMonsters:
@2ee1:  php
        longi
        lda     $3f45
        ldx     #10
        asl2
@2eec:  stz     $3aa8,x     ; set monster present flag
        asl
        rol     $3aa8,x
        dex2                ; next monster
        bpl     @2eec
        lda     $3f52       ; msb of monster index
        asl2
        sta     $ee
        ldx     #5
        ldy     #$0012
@2f04:  clr_a
        asl     $3a73
        asl     $ee
        rol
        xba
        lda     $3a97       ; colosseum mode
        asl
        lda     $3f46,x     ; monster index
        bcc     @2f1a       ; branch if not in colosseum
        lda     $0206       ; monster number (colosseum)
        bra     @2f1e
@2f1a:  cmp     #$ff
        bne     @2f22       ; branch if monster slot is not empty
@2f1e:  xba
        bne     @2f28       ; branch if monster slot is empty ($01ff)
        xba
@2f22:  jsr     LoadMonsterProp
        inc     $3a73       ; increment number of monsters
@2f28:  dey2                ; next monster
        dex
        bpl     @2f04
        plp
        rts

; ------------------------------------------------------------------------------

; [ init party ]

InitParty:
@2f2f:  php
        longi
        stz     $fc
        stz     $b8
        lda     $3ee0
        bne     @2f75
        ldx     #$0000
@2f3e:  lda     #$ff
        sta     $3ed9,x
        cmp     $3ed8,x
        bne     @2f6c
        ldy     #$0000
@2f4b:  lda     $0205,y
        cmp     #$ff
        beq     @2f66
        xba
        lda     #$ff
        sta     $0205,y
        lda     #$25
        jsr     MultAB
        tay
        lda     $1600,y
        sta     $3ed8,x
        bra     @2f6c
@2f66:  iny
        cpy     #$000c
        bcc     @2f4b
@2f6c:  inx2
        cpx     #8
        bcc     @2f3e
        bra     @2fd9
@2f75:  ldx     $3ed4
        cpx     #$023e
        bcc     @2f8c                   ; branch if not a colosseum battle
        lda     $0208
        sta     $3ed8                   ; put colosseum character in slot 1
        lda     #$01
        tsb     $b8                     ; make character slot 1 a valid target
        dec     $3a97                   ; enable colosseum mode
        bra     @2fd9
@2f8c:  ldy     #$000f
@2f8f:  lda     $1850,y
        sta     $fe
        and     #$07
        cmp     $1a6d
        bne     @2fad
        phy
        inc     $fc
        clr_a
        lda     $fe
        and     #$18
        lsr2
        tax
        jsr     GetCharID
        sta     $3ed8,x
        ply
@2fad:  dey
        bpl     @2f8f
        lda     $1edf
        bit     #$08
        bne     @2fc3
        lda     $3f4b
        inc
        bne     @2fc3
        lda     $fc
        cmp     #$04
        bcc     @2fc8                   ; branch if less than 4 characters in the party
@2fc3:  lda     #$01
        trb     $11e4
@2fc8:  lda     #$01
        bit     $11e4
        beq     @2fd9                   ; branch if gau can't appear after battle
        lda     #$0a                    ; character ai $0a (gau returning from the veldt)
        sta     $2f4a
        lda     #$80
        tsb     $2f49                   ; enable character ai
@2fd9:  lda     $2f49
        bpl     @304a
        lda     $2f4a                   ; character ai index
        xba
        lda     #$18
        jsr     MultAB
        tax
        lda     f:CharAI,x
        bpl     @2ffa                   ; branch if party is not hidden
        ldy     #6
@2ff1:  lda     #$ff
        sta     $3ed8,y                 ; clear all for actors
        dey2
        bpl     @2ff1
@2ffa:  ldy     #4
@2ffd:  phy
        lda     f:CharAI+4,x            ; actor index
        cmp     #$ff
        beq     @3041                   ; branch if no character ai
        and     #$3f
        ldy     #$0006
@300b:  cmp     $3ed8,y
        beq     @3023                   ; find matching party character
        dey2
        bpl     @300b

; a.i. character not in party
@3014:  iny2
        lda     $3ed8,y                 ; find an empty slot
        inc
        beq     @3023
        cpy     #$0006
        bcc     @3014
        bra     @3041                   ; use slot 4 if no slots are empty

; a.i. character matches a party character
@3023:  lda     $3018,y
        tsb     $b8
        longa
        lda     f:CharAI+4,x            ; character properties and graphics id
        sta     $3ed8,y
        shorta
        lda     #$01                    ; msb of ai script index always set for character ai
        xba
        lda     f:CharAI+6,x            ; character ai script index
        cmp     #$ff
        beq     @3041                   ; branch if no ai script
        jsr     InitAI
@3041:  ply
        inx5                            ; next character
        dey
        bne     @2ffd
@304a:  ldx     #$0006

; start of character loop
@304d:  lda     $3ed8,x                 ; loop through each character slot
        cmp     #$ff
        beq     @30d3                   ; skip if empty slot
        asl
        bcs     @305a                   ; skip if not in the party
        inc     $3aa0,x                 ; $3aa0.0 set "target present" flag
@305a:  asl
        bcc     @3065
        pha
        lda     $3018,x
        tsb     $3a40                   ; toggle enemy character flag
        pla
@3065:  lsr2
        sta     $3ed8,x                 ; set actor number
        ldy     #$000f
@306d:  phy
        pha
        lda     $1850,y                 ; get battle row
        and     #$20
        sta     $fe
        jsr     GetCharID
        cmp     $01,s
        bne     @30ce
        phx
        pha
        lda     $fe
        sta     $3aa1,x                 ; $3aa1.5 character row (other flags are cleared)
        lda     $3ed9,x                 ;
        pha
        lda     $06,s
        sta     $3ed9,x
        clr_a
        txa
        asl4
        tax
        pla
        cmp     #$ff
        bne     @309c
        lda     $1601,y                 ; set character graphic index
@309c:  sta     $2eae,x
        clr_a
        pla
        sta     $2ec6,x                 ; set actor index
        cmp     #$0e
        longa
        pha
        lda     $1602,y                 ; copy character name
        sta     $2eaf,x
        lda     $1604,y
        sta     $2eb1,x
        lda     $1606,y
        sta     $2eb3,x
        plx
        bcs     @30c4                   ; branch if actor index >= $0e
        clr_a
        sec
@30c0:  rol
        dex
        bpl     @30c0
@30c4:  plx
        sta     $3a20,x                 ; set actor mask
        tya
        sta     $3010,x                 ; pointer to character data
        shorta
@30ce:  pla                             ; next character
        ply
        dey
        bpl     @306d
@30d3:  dex2
        jpl     @304d
        plp
        rts

; ------------------------------------------------------------------------------

; [ get actor index ]

; y: character number

GetCharID:
@30dc:  tya
        xba
        lda     #$25
        jsr     MultAB
        tay
        lda     $1600,y     ; actor index
        rts

; ------------------------------------------------------------------------------

; [ load battle properties ]

LoadBattleProp:
@30e8:  php
        longai
        lda     $3eb9       ; conditional battle flags
        sta     $ee
        ldx     #$001c
@30f3:  lda     $ee
        bpl     @3107
        lda     f:CondBattle,x   ; check conditional battles
        cmp     $11e0
        bne     @3107
        lda     f:CondBattle+2,x   ; switch to next battle
        sta     $11e0
@3107:  asl     $ee
        dex4
        bpl     @30f3
        lda     #$8000      ; branch if not loading one of the next four battles
        trb     $11e0
        beq     @3127
        shortai
        clr_a
        jsr     Rand
        and     #$03        ; (0..3)
        longai_clc
        adc     $11e0       ; add to battle index
        sta     $11e0
@3127:  lda     $3ed4       ;
        asl
        lda     $11e0
        bcc     @3133
        sta     $3ed4
@3133:  asl2
        tax
        lda     f:BattleProp+2,x   ; load auxiliary battle data
        sta     $2f4a
        lda     f:BattleProp,x
        eor     #$00f0      ; toggle battle type flags
        sta     $2f48
        lda     $11e0
        asl4
        sec
        sbc     $11e0
        tax
        clr_ay
@3155:  lda     f:BattleMonsters,x   ; load battle data
        sta     $3f44,y
        inx2
        iny2
        cpy     #$0010
        bcc     @3155
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ execute attacks (self-target) ]

ExecSelfAttack:
@3167:  .i8
        lda     #$80        ; don't ignore vanish
        trb     $b3
        lda     #$0c        ; retarget if target invalid, no friendly targets
        tsb     $ba
        stz     $341b       ; ???
        longa
        lda     $3018,x
        sta     $b8
        shorta
; fall through

; ------------------------------------------------------------------------------

; [ execute attacks ]

ExecAttack:
@317b:  phx
        lda     $bd         ; damage multiplier
        sta     $bc
        lda     #$ff
        sta     $3a82       ;
        sta     $3a83
        lda     $3400
        inc
        bne     @31b3
        lda     $3413
        bmi     @31b3
        sta     $b5
        jsr     InitTarget
        lda     $3a70
        inc
        lsr
        jsr     _c2299f
        lda     $11a6
        jeq     @3275       ; jump if no damage
        lda     $b5
        cmp     #$06
        bne     @31b3       ; branch if command is not capture
        lda     #$a4        ; special effect $52 (steal)
        sta     $11a9
@31b3:  jsr     _c237eb
        lda     #$20
        trb     $b2
        beq     @31c1
        bit     $11a3
        bne     @31c5
@31c1:  lda     #$04
        tsb     $ba
@31c5:  lda     $b8
        ora     $b9
        bne     @31d3
        lda     #$04
        bit     $b3
        beq     @31d3
        trb     $ba
@31d3:  lda     $3415
        bmi     @31dc
        lda     #$40
        tsb     $ba
@31dc:  lda     $b3
        lsr
        bcs     @31e9
        lda     #$04
        tsb     $ba
        stz     $b8
        stz     $b9
@31e9:  jsr     ShowAttackName
        lda     $3417
        bmi     @31f2
        tax
@31f2:  lda     $3a7c
        cmp     #$1e
        bne     @3201
        stz     $b8
        stz     $b9
        lda     #$04
        sta     $ba
@3201:  lda     $11a5
        beq     @3225
        lda     $3ee5,x
        bit     #$08
        bne     @321b
        lda     $3ee4,x
        bit     #$20
        beq     @3225
        lda     $3410       ; last spell cast
        cmp     #$23
        beq     @3225       ; branch if imp
@321b:  txa
        lsr
        xba
        lda     #$0e        ; battle script command $0e (clear character graphical action)
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
        lda     $a6
        beq     @3243       ; branch if no targets were refleced off of
        jsr     CalcReflectDmg
@3243:  lda     $3a30
        sta     $b8         ;
        shorta
        jsr     UpdateStatus
        jsr     CheckWeaponMagic
        lda     $3401
        cmp     #$ff
        beq     @3262       ; branch if there is no battle message
        xba
        lda     #$02        ; battle script command $02 (show battle message)
        jsr     _c262bf       ; add battle script command to queue
        lda     #$ff
        sta     $3401       ; disable battle message
@3262:  lda     $11a7
        bit     #$02
        beq     @3275       ; branch if battle message based on attack index is disabled
        cpx     #$08
        bcc     @3275       ; branch if attacker is a character
        lda     $b6         ; attack index
        xba
        lda     #$02        ; battle script command $02 (show battle message)
        jsr     _c262bf       ; add battle script command to queue
@3275:  lda     #$ff
        sta     $3414       ; enable damage modification
        sta     $3415
        sta     $341c
        lda     $3a83
        bmi     @3288
        sta     $3416
@3288:  plx                 ; next attack
        dec     $3a70
        bmi     @3291
        pea     ExecAttack-1
@3291:  rts

; ------------------------------------------------------------------------------

; [ calculate attack effect ]

; yama_magic_magic:
CalcAttackEffect:
@3292:  .a16
        .i8
        stz     $3a5a
        stz     $3a54
        jsr     ClearGfxParams
        jsr     ChooseTarget
        phx
        lda     $b8         ; targets
        jsr     CountBits
        stx     $3ec9       ; set number of targets
        plx
        jsr     CoverEffect
        jsr     InitGfxParams
        jsr     _c23865
        lda     $3a4c
        beq     @32ec
        sec
        lda     $3c08,x
        sbc     $3a4c
        stz     $3a4c
        bcs     @32e0
        cpx     #$08
        bcc     @32ca
        ldy     #$12
        sty     $b5
@32ca:  jsr     _c235ad
        stz     $a2
        stz     $a4
        lda     #$0002
        trb     $11a7
        lda     #$2802
        jsr     _c2629b       ; add battle script command to queue
        jmp     CopyGfxParamsToBuf
@32e0:  sta     $3c08,x
        lda     #$0080
        ora     $3204,x
        sta     $3204,x
@32ec:  shorta
        lda     $3412
        cmp     #$06
        bne     @334f
        phx
        lda     #$02
        tsb     $b2
        lsr
        tsb     $a0
        lda     $3c81,x
        sta     $b7
        lda     $322d,x     ; special attack
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
        adc     $bc         ; add to damage multiplier
        sta     $bc
        bra     @334e

; $00-$1f: status
@3345:  jsr     GetBitPtr
        ora     $11aa,x
        sta     $11aa,x
@334e:  plx
@334f:  lda     #$40
        tsb     $b2
        bne     @3364
        lda     #$25        ;
        xba
        lda     #$06        ; battle script command $06 (show animation)
        jsr     _c262bf       ; add battle script command to queue
        jsr     CopyGfxParamsToBuf
        lda     #$10
        trb     $a0
@3364:  lda     #$08
        bit     $3ef9,x
        beq     @336f
        inc     $bc
        inc     $bc
@336f:  lda     $11a2
        lsr
        bcc     @337e
        lda     #$10
        bit     $3ee5,x
        beq     @337e
        inc     $bc
@337e:  lda     $11a2
        bit     #$40
        bne     @3392
        lda     $3ec9
        cmp     #$02
        bcc     @3392       ; branch if there are less than 2 targets
        lsr     $11b1
        ror     $11b0
@3392:  lda     #$20
        bit     $b3
        bne     @33a3
        bit     $3aa1,x
        beq     @33a3       ; branch if $3aa1.5 is clear (character row)
        lsr     $11b1
        ror     $11b0
@33a3:  jsr     UpdateFacingDirection
        jsr     DoAttackerEffect
        longa
        ldy     $3405
        bmi     @33b1
        rts
@33b1:  ldy     #$12
@33b3:  lda     $3018,y
        bit     $a4
        beq     @33c1
        jsr     CheckHit
        bcc     @33c1
        trb     $a4
@33c1:  dey2
        bpl     @33b3
        shorta
        lda     $341c
        bmi     @33d6
        lda     $a4
        ora     $a5
        bne     @33d6
        lda     #$12
        sta     $b5
@33d6:  lda     $341d
        bmi     @33e5
        lda     $a2
        ora     $a3
        bne     @33e5
        lda     #$12
        sta     $b5
@33e5:  lda     #$40
        bit     $3c95,x
        beq     @33f2
        lsr
        bit     $3ee4,x
        bne     @340c
@33f2:  lda     #$02
        bit     $b3
        beq     @340c
        bit     $b2
        bne     @3414
        bit     $ba
        beq     @3414
        jsr     Rand
        cmp     #$08
        bcs     @3414       ; 31/32 chance to branch
        lda     $3ec9
        beq     @3414       ; branch if there are no targets
@340c:  inc     $bc         ; damage x2
        inc     $bc
        lda     #$20        ; flash screen (critical)
        tsb     $a0
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
@342e:  ldy     $32b9,x
        bmi     @343c
        phx
        tyx
        ldy     $32b8,x
        jsr     SetControlCmd
        plx
@343c:  longa
        ldy     #$12
@3440:  lda     $3018,y
        trb     $a4
        beq     @346c
        bit     $3a54
        beq     @344e
        inc     $bc
@344e:  jsr     _c235e3
        cpy     $33f8
        beq     @346c
        stz     $3a48
        jsr     MagicStatusEffect
        jsr     DoTargetEffect
        lda     $3a48
        bne     @346c
        lda     $3018,y
        tsb     $a4
        jsr     CalcTargetDmg
@346c:  dey2
        bpl     @3440
        jsr     _c262ef       ; apply and display damage
        jsr     LearnLore
        lda     $a4
        bne     @3480
        lda     #$0002
        trb     $11a7
@3480:  jmp     CopyGfxParamsToBuf

; ------------------------------------------------------------------------------

; [ calculate damage (reflected attack) ]

CalcReflectDmg:
@3483:  phx
        pha
        jsr     ClearGfxParams
        stz     $3a5a
        shorta
        lda     #$22
        tsb     $11a3
        lda     #$40
        sta     $bb
        lda     #$50
        tsb     $ba
        lda     $b6
        sta     $3a2a
        ldx     $3405
        bmi     @34ac
        lda     #$10
        trb     $ba
        lda     #$15
        bra     @34ae
@34ac:  lda     #$09
@34ae:  jsr     _c2629b       ; add battle script command to queue
        lda     #$ff
        ldy     #$09
@34b5:  sta     $00a0,y
        dey
        bpl     @34b5
        longa
        lsr     $11b0
        ldy     #$12
@34c2:  lda     $3018,y
        and     $01,s
        beq     @350f
        tyx
        jsr     ChooseTarget
        lda     $b8
        beq     @350f
        phy
        jsr     BitToTargetID
        phx
        shorta
        txa
        lsr
        tax
        lda     $3405
        bmi     @34e4
        dec     $3405
        tax
@34e4:  tya
        lsr
        sta     $a0,x
        longa
        plx
        jsr     CheckHit
        bcs     @3509
        stz     $3a48
        jsr     _c235e3
        jsr     MagicStatusEffect
        jsr     DoTargetEffect
        lda     $3a48
        bne     @3509
        lda     $3018,x
        tsb     $ae
        jsr     CalcTargetDmg
@3509:  ply
        ldx     $3405
        bpl     @34c2
@350f:  dey2
        bpl     @34c2
        pla
        plx
        lda     #$0010
        bit     $ba
        bne     @3525
        lda     $3018,x
        sta     $ae
        stz     $aa
        stz     $ac
@3525:  jsr     _c262ef       ; apply and display damage
        jmp     CopyGfxParamsToBuf

; ------------------------------------------------------------------------------

; [ runic effect ]

RunicEffect:
@352b:  .a8
        .i8
        lda     $11a3
        bit     #$08
        beq     @35ac
        stz     $ee
        stz     $ef
        ldy     #$12
@3538:  lda     $3aa0,y
        lsr
        bcc     @355e       ; branch if $3aa0.0 is clear (target is not present)
        lda     $3e4c,y
        bit     #$06
        beq     @355e       ; branch if $3e4c.1 and $3e4c.2 are clear (runic and enemy runic)
        and     #$fb
        sta     $3e4c,y     ; clear $3e4c.2 (character runic)
        peaflg  STATUS12, {DEAD, PETRIFY, SLEEP}
        peaflg  STATUS34, {STOP, FROZEN, HIDE}
        jsr     CheckStatus
        bcc     @355e
        longa
        lda     $3018,y
        tsb     $ee
        shorta
@355e:  dey2
        bpl     @3538
        lda     $ee
        ora     $ef
        beq     @35ac       ; return if no targets have runic
        phx
        jsr     _c23865
        stz     $3415
        longa
        lda     $ee
        sta     $b8
        jsr     CountBits
        stz     $11aa
        stz     $11ac
        lda     #$2182      ; affect mp, ignore reflect, can't dodge, restore mp
        sta     $11a3
        shorta
        lda     #$60
        sta     $11a2
        clr_a
        lda     $11a5
        jsr     Div
        sta     $11a6
        jsr     _c2385e       ; clear level/hit rate
        stz     $3414       ; disable damage modification
        lda     #$40
        trb     $b2         ; enable runic sword animation
        lda     #$04
        sta     $ba         ; no retarget if target invalid
        lda     #$03
        trb     $11a7       ; don't display battle message, don't automatically miss if target immune to status
        stz     $11a9       ; no special effect
        plx
@35ac:  rts

; ------------------------------------------------------------------------------

; [  ]

_c235ad:
_setattackmes:
@35ad:  phx
        ldx     $3a72
        stx     $3a71
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
        ldx     $3a72       ; save battle script command queue pointer
        phx
        ldx     $3a71       ;
        stx     $3a72
        jsr     _c2629e       ; add battle script command to queue
        plx
        stx     $3a72       ; restore battle script command queue pointer
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ copy battle script command to buffer ]

_c235d4:
attackmessub:
@35d4:  php
        longa
        lda     $b4
        sta     $3a28
        lda     $b6
        sta     $3a2a
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
        sta     $3290,y
        lda     $3a7c
        sta     $3d48,y

; set last attack
        lda     $3410
        cmp     #$ff
        beq     @3601
        sta     $3d49,y
        txa
        sta     $3291,y

; set previous item used
@3601:  lda     $3411
        cmp     #$ff
        beq     @360f
        sta     $3d5c,y
        txa
        sta     $32a4,y

; set previous element used
@360f:  lda     $11a1
        sta     $3d5d,y
        txa
        sta     $32a5,y
        plp
        .i16
        rts

; ------------------------------------------------------------------------------

; [ set retaliation target (50% chance) ]

_c2361b:
_setblacklist2:
@361b:  php
        shorta_sec
        lda     $32e0,y
        bpl     @3628                   ; branch if waiting to retaliate
        jsr     RandCarry               ; 50% chance to retaliate
        bcc     @362d
@3628:  txa
        ror
        sta     $32e0,y
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
        lda     $32e0,y                 ; last target that attacked you
        bmi     @363b                   ; return if waiting to retaliate
        txa
        ror                             ; set flag for waiting to retaliate
        sta     $32e0,y                 ; set last target that attacked you
@363b:  plp
        pla
        rts

; ------------------------------------------------------------------------------

; [ random weapon spellcast ]

CheckWeaponMagic:
@363e:  lda     $b5
        cmp     #$16
        bne     @3649       ; branch if command was not jump
        lda     $3a70
        bne     _3665       ; return if there is more than one attack (dragon horn)
@3649:  lda     $3a89
        bit     #$40
        beq     _3665       ; return if random weapon spellcast is disabled
        xba
        jsr     Rand
        cmp     #$40
        bcs     _3665       ; 3/4 chance to return
        xba
        and     #$3f
        sta     $3400       ; set spell index
        lda     #$10
        trb     $b2         ; follow-up spell hits same target
        inc     $3a70       ; increment number of attacks

ShowAttackName_03:
_3665:  rts

; ------------------------------------------------------------------------------

; [ display attack name ]

ShowAttackName:
@3666:  lda     #$01
        trb     $b2
        beq     _3665       ; return if attack name has already been displayed (quadra slam, etc.)
        lda     $3412       ; attack name type
        bmi     _3665       ; return if disabled
        phx
        txy
        sta     $3a29       ; b2 = attack name type
        asl
        tax
        lda     #$01        ; battle script command $01 (display attack name)
        sta     $3a28
        jsr     (.loword(ShowAttackNameTbl),x)
        sta     $3a2a       ; b3 = return value
        plx
        jmp     _c2629e       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ attack name type $00: normal ]

ShowAttackName_00:
ShowAttackName_04:
@3687:  lda     $b6         ; spell/attack index
        rts

; ------------------------------------------------------------------------------

; [ attack name type $01: item ]

ShowAttackName_01:
@368a:  lda     $3a7d       ; item index ???
        rts

; ------------------------------------------------------------------------------

; [ attack name type $02: esper ]

ShowAttackName_02:
@368e:  sec
        lda     $b6         ; spell/attack index - 54
        sbc     #$36
        rts

; ------------------------------------------------------------------------------

; [ attack name type $05: command ]

ShowAttackName_05:
@3694:  lda     $b5         ; command index
        rts

; ------------------------------------------------------------------------------

; [ attack name type $06: monster special attack ]

ShowAttackName_06:
@3697:  lda     #$11
        sta     $3a28       ; b1 = battle script command $11 (display monster special attack name
        lda     $33a8,y
        sta     $3a29       ; +b2 = monster index
        lda     $33a9,y
        rts

; ------------------------------------------------------------------------------

; [ attack name type $07: joker doom ]

ShowAttackName_07:
@36a6:  lda     #$02
        tsb     $3a46       ; set $3a46.1
        trb     $11a2       ;
        lda     #$20
        tsb     $11a4       ;
        lda     #$00        ; attack name type = 0 (normal)
        sta     $3a29
        lda     #$55        ; b3 = attack $55 (joker doom)
        rts

; ------------------------------------------------------------------------------

; [ attack name type $08: blitz ]

ShowAttackName_08:
@36bb:  lda     #$00        ; attack name type = 0 (normal)
        sta     $3a29
        lda     $3a7d       ; blitz index ???
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
        ldy     $3007
        bmi     @3708
        peaflg  STATUS12, {DEAD, PETRIFY, BLIND, ZOMBIE, SLEEP, CONFUSE, BERSERK}
        peaflg  STATUS34, {STOP, FROZEN, RAGE, HIDE}
        jsr     CheckStatus
        bcc     @3708
        lda     $b6
        sbc     #$8b
        clc
        jsr     GetBitPtr
        cpx     #$03
        bcs     @3708
        bit     $1d29,x
        bne     @3708
        ora     $3a84,x
        sta     $3a84,x
@3708:  plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ apply damage multiplier ]

; +A *= (1 + ($bc / 2))

ApplyDmgMult:
@370b:  phy
        ldy     $bc
        beq     @372d
        pha
        lda     $b2                     ; ignore damage multiplier flag (in $b3)
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
        sty     $bc
@372d:  ply
        rts

; ------------------------------------------------------------------------------

; [ set command for control ]

SetControlCmd:
@372f:  phx
        phy
        php
        longai_clc
        lda     f:CmdPropPtrTbl,x
        adc     #$0030
        sta     f:hWMADDL
        tyx
        lda     $3c08,x
        inc
        sta     $ee
        lda     $1ff9,x
        asl2
        tax
        shorta
        clr_a
        sta     f:hWMADDH
        ldy     #$0004
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
        sta     $01,s
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
        lda     $3b18,y     ; target's level
        bcc     @379f
        xba
        lda     #$aa        ; multiply by (170/255) if coronet is equipped
        jsr     MultAB
        xba
@379f:  pha
        clr_a
        lda     $3b18,x     ; attacker's level
        xba
        plx
        jsr     Div
        pha
        clc
        xba
        bne     @37b3
        jsr     Rand
        cmp     $01,s
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
        sbc     $01,s
        sta     $1860
        shorta
        lda     $1862
        sbc     #$00
        sta     $1862
        longa
        bcs     @37da
        lda     $ee
        sta     $01,s
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
@37eb:  lda     $3400
        cmp     #$ff
        beq     @3837
        sta     $b6
        jsr     GetCmdForAI
        sta     $b5
        jsr     InitTarget
        jsr     InitAttacker
        stz     $11a5
        lda     #$ff
        sta     $3400
        lda     #$02
        tsb     $b2
        lda     #$10
        bit     $b2
        beq     @3814
        stz     $3415
@3814:  bne     @382d
        lda     #$0c
        trb     $11a3
        tsb     $ba
        lda     #$40
        sta     $bb
        lda     #$10
        bit     $11a4
        beq     @382d
        stz     $341c
        bra     @3832
@382d:  lda     #$20
        tsb     $11a4
@3832:  lda     #$02
        tsb     $11a3
@3837:  rts

; ------------------------------------------------------------------------------

; [ air anchor effect ]

AirAnchorEffect:
@3838:  lda     $3205,x
        bit     #$04
        bne     @3849       ; return if $3205.2 is set (air anchor effect)
        ora     #$04
        sta     $3205,x     ; set $3205.2 (disable air anchor effect)
        lda     #$40
        tsb     $11a3       ; attacker dies after attack
@3849:  rts

; ------------------------------------------------------------------------------

; [  ]

_c2384a:
_deatherase:
@384a:  lda     $3de9,x
        ora     #$20
        sta     $3de9,x
; fallthrough

; ------------------------------------------------------------------------------

_c23852:
_setdeath:
@3852:  jsr     _c2362f
        lda     #$80
        ora     $3dd4,x
        sta     $3dd4,x
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
        lda     $3414       ; damage modification
        bmi     @3874
        lda     $3a30
        sta     $b8
        bra     @387c
@3874:  lda     $b8
        sta     $3a30
        tsb     $3a4e
@387c:  plp
        rts

; ------------------------------------------------------------------------------

; [ execute target special effect ]

DoTargetEffect:
@387e:  phx
        phy
        php
        shortai
        ldx     $11a9
        jsr     (.loword(TargetEffectTbl),x)
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
        lda     $3aa1,y
        bit     #$04
        bne     TargetEffectNone     ; branch if $3aa1.2 is set (instant death protection)
        bcs     @389f
        lda     $3c95,y
        bmi     @38ab
@389f:  jsr     Rand
        cmp     #$40
        bcs     TargetEffectNone     ; 3/4 chance to return
        jsr     _c223b2
        bcs     TargetEffectNone
@38ab:
.if LANG_EN
        lda     $3a70
        beq     @38b6
        lda     $b5
        cmp     #$16
        beq     TargetEffectNone
.endif
@38b6:  lda     $3018,y
        tsb     $a4
        trb     $3a4e
        lda     $3019,y
        tsb     $a5
        trb     $3a4f
        lda     #$10
        tsb     $a0
        lda     #$80
        jsr     SetStatus1
        stz     $341d
        stz     $11a6
        lda     #$02
        sta     $b5
        xba
        sta     $b6
        cmp     #$ee
        bne     @38ec
        cpy     #$08
        bcc     @38ec
        lda     $3de9,y
        ora     #$20
        sta     $3de9,y
@38ec:  jsr     _c235ad
        jmp     CopyGfxParamsToBuf

; ------------------------------------------------------------------------------

; [ target special effect $04: man eater ]

TargetEffect_04:
@38f2:  lda     $3c95,y
        bit     #$10
        beq     _38fd       ; return if not human
        inc     $bc         ; 2x damage multiplier
        inc     $bc
_38fd:  rts

; ------------------------------------------------------------------------------

; [ target special effect $08: sniper/hawkeye ]

; 1/2 chance to deal +50% damage or +150% damage vs. flying target (changes command to throw)

TargetEffect_08:
@38fe:  jsr     RandCarry
        bcc     _38fd       ; 1/2 chance to return
        inc     $bc         ; +50% damage
        lda     $3ef9,y     ; return if target does not have float status
        bpl     _38fd
        lda     $b5         ; return if command is not fight
        cmp     #$00
        bne     _38fd
        inc     $bc         ; +150% damage
        inc     $bc
        inc     $bc
        lda     #$08        ; change command to throw
        sta     $b5
        lda     $b7         ;
        dec
        sta     $b6
        jmp     _c235bb

; ------------------------------------------------------------------------------

; [ target special effect $22: stone ]

TargetEffect_22:
@3922:  lda     $05,s
        tax
        lda     $3b18,x
        cmp     $3b18,y
        bne     @3933
        lda     #$0d
        adc     $bc
        sta     $bc
@3933:  rts

; ------------------------------------------------------------------------------

; [ target special effect $13: palidor ]

TargetEffect_13:
@3934:  lda     #$01        ; flag for character that just jumped - remove all actions from action queue
        jsr     SetCharFlag
        lda     $32cc,y     ; old command list pointer
        pha
        jsr     AddToQueue
        sta     $32cc,y     ; set new command list pointer
        tay
        asl
        tax
        pla
        cmp     #$ff
        beq     @394e       ; branch if character/monster had no pending actions in the command list
        sta     $3184,y     ; clear the old command list slot
@394e:  clr_a
        sta     $3620,x     ; clear old command mp cost
        longa
        sta     $3520,x     ; clear old command targets
        lda     #$0016      ; command $16 (jump)
        sta     $3420,x     ; set old command/action
        rts

; ------------------------------------------------------------------------------

; [ target special effect $39: engulf ]

TargetEffect_39:
@395e:  .a8
        lda     $3018,y
        tsb     $3a8a       ; set target as engulfed
        bra     _396c

; ------------------------------------------------------------------------------

; [ target special effect $33: bababreath ]

TargetEffect_33:
@3966:  lda     $3018,y
        tsb     $3a88
; fall through

; ------------------------------------------------------------------------------

; [ target special effect $27/$38/$4b: escape/sneeze/smoke bomb ]

TargetEffect_27:
TargetEffect_38:
TargetEffect_4b:
_396c:  longa
        lda     $3018,y
        tsb     $2f4c
        tsb     $3a39
        rts

; ------------------------------------------------------------------------------

; [ target special effect $1f: dischord ]

TargetEffect_1f:
@3978:  tyx
        inc     $3b18,x
        lsr     $3b18,x
        rts

; ------------------------------------------------------------------------------

; [ target special effect $2b: r. polarity ]

TargetEffect_2b:
@3980:  .a8
        lda     $3aa1,y     ; $3aa1.5 toggle target's row
        eor     #$20
        sta     $3aa1,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $26: wallchange ]

TargetEffect_26:
        .a8
@3989:  clr_a
        lda     #$ff
        jsr     RandBit
        sta     $3be0,y
        eor     #$ff
        sta     $3bcd,y
        jsr     RandBit
        sta     $3bcc,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $52: steal ]

TargetEffect_52:
@399e:  lda     $05,s
        tax
        lda     #$01
        sta     $3401
        cpx     #$08
        bcs     @3a09
        longa
        lda     $3308,y
        inc
        shorta_sec
        beq     @3a01
        inc     $3401
        lda     $3b18,x
        adc     #$32
        bcs     @39d8
        sbc     $3b18,y
        bcc     @3a01
        bmi     @39d8
        sta     $ee
        lda     $3c45,x
        lsr
        bcc     @39cf
        asl     $ee
@39cf:  lda     #$64
        jsr     RandA
        cmp     $ee
        bcs     @3a01
@39d8:  phy
        jsr     Rand
        cmp     #$20
        bcc     @39e1
        iny
@39e1:  lda     $3308,y
        ply
        cmp     #$ff
        beq     @3a01
        sta     $2f35
        sta     $32f4,x
        lda     $3018,x
        tsb     $3a8c
        lda     #$ff
        sta     $3308,y
        sta     $3309,y
        inc     $3401
        rts
@3a01:  shorta
        lda     #$00
        sta     $3d48,y
        rts
@3a09:  stz     $2f3a
        inc     $3401
        jsr     Rand
        cmp     #$c0
        bcs     @3a01
        dec     $3401
        lda     $3b18,x
        xba
        lda     #$14
        longa
        jsr     TakeGil
        beq     @3a01
        sta     $2f38
        clc
        adc     $3d98,x
        bcc     @3a31
        clr_a
        dec
@3a31:  sta     $3d98,x
        shorta
        lda     #$3f
        sta     $3401
        rts

; ------------------------------------------------------------------------------

; [ target special effect $12: metamorph ]

TargetEffect_12:
@3a3c:  cpy     #$08
        bcc     _3a8a
        lda     $3c94,y     ;
        pha
        and     #$1f
        jsr     RandCarry
        rol
        jsr     RandCarry
        rol
        tax
        lda     f:MetamorphProp,x
        sta     $2f35
        lda     #$02
        sta     $3a28
        lda     #$1d
        sta     $3a29
        jsr     _c235be
        jsr     _c235ad
        pla
        lsr5
        tax
        jsr     Rand
        cmp     f:MetamorphRateTbl,x
        bcs     _3a8a
        lda     $05,s
        tax
        lda     $2f35
        sta     $32f4,x
        lda     $3018,x
        tsb     $3a8c
        lda     #STATUS1::DEAD
        jmp     SetStatus1
_3a8a:  jmp     _c23b1b

.pushseg
.segment "metamorph_prop"

; c4/7f40
MetamorphProp:
        .incbin "metamorph_prop.dat"

.popseg

; ------------------------------------------------------------------------------

; [ target special effect $56: debilitator ]

TargetEffect_56:
@3a8d:  clr_a
        lda     $3be0,y
        ora     $3ec8
        eor     #$ff
        beq     _3a8a
        jsr     RandBit
        pha
        jsr     GetBitID
        txa
        clc
        adc     #$0b
        sta     $3401
        lda     $01,s
        ora     $3be0,y
        sta     $3be0,y
        pla
        eor     #$ff
        pha
        and     $3be1,y
        sta     $3be1,y
        lda     $01,s
        xba
        pla
        longa
        and     $3bcc,y
        sta     $3bcc,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $53: control ]

TargetEffect_53:
@3ac5:  .a8
        .i8
        cpy     #$08
        bcc     @3b16       ; miss if target is a character
        lda     $3c80,y
        bmi     @3b16       ; miss if monster can't be controlled
        peaflg  STATUS12, {DEAD, PETRIFY, INVISIBLE, ZOMBIE, SLEEP, CONFUSE, BERSERK}
        peaflg  STATUS34, {RAGE, HIDE, MORPH}
        jsr     CheckStatus
        bcc     @3b16       ; miss if set
        lda     $32b9,y
        bpl     @3b16       ; miss if already controlled
        lda     $05,s
        tax
        lda     $3c45,x     ; get coronet effect from attacker's relic effects 2
        lsr4
        jsr     CheckSketchHit
        bcs     _c23b1b       ; branch if attack failed
        tya
        sta     $32b8,x     ; target you control (attacker)
        txa
        sta     $32b9,y     ; target controlling you (target)
        lda     $3019,y
        tsb     $2f54       ; h-flip for targets being controlled (target)
.if LANG_EN
        lda     $3e4d,x     ; use control battle menu for attacker $3e4d.0
        ora     #$01
        sta     $3e4d,x
.endif
        lda     $3ef9,x     ; set trance status (attacker)
        ora     #$10
        sta     $3ef9,x
        lda     $3aa1,y     ; set $3aa1.6 pending control action (target)
        ora     #$40
        sta     $3aa1,y
        jmp     SetControlCmd

@3b16:  lda     #$04
        sta     $3401
; fallthrough

_c23b1b:
@3b1b:  longa        ; make attack miss this target
        lda     $3018,y
        sta     $3a48       ; missed target due to status
        tsb     $3a5a       ; add missed target
        trb     $a4         ; remove from targets hit
        rts

; ------------------------------------------------------------------------------

; [ target special effect $55: sketch ]

TargetEffect_55:
@3b29:  .a8
        cpy     #$08
        bcc     _c23b1b
        lda     $3c80,y
        bit     #$20
        bne     @3b64       ; branch if target can't be sketched
        lda     $05,s
        tax
        lda     $3c45,x
        lsr3
        jsr     CheckSketchHit
        bcs     _c23b1b
        sty     $3417
        tya
        sbc     #$07
        lsr
        sta     $b7
        jsr     _c235bb
        jsr     Rand
        cmp     #$40
        longai
        lda     $1ff9,y
        rol
        tax
        lda     f:MonsterSketch,x
        shortai
        sta     $3400
        rts
@3b64:  lda     #$1f
        sta     $3401
        bra     _c23b1b

; ------------------------------------------------------------------------------

; [ target special effect $25: misses floating targets ]

TargetEffect_25:
@3b6b:  lda     $3ef9,y
        bmi     _c23b1b       ; branch if target has float status
        rts

; ------------------------------------------------------------------------------

; [ target special effect $54: leap ]

TargetEffect_54:
@3b71:  lda     $2f49
        bit     #$08
        bne     @3b90       ; branch if leap is disabled
        lda     $3a76
        cmp     #$02
        bcc     @3b90
        lda     $05,s
        tax
        lda     $3de9,x
        ora     #$20
        sta     $3de9,x
        lda     #$04        ; end of battle special event 2 (gau leaped)
        sta     $3a6e
        rts
@3b90:  lda     #$05
        sta     $3401
        jmp     _c23b1b

; ------------------------------------------------------------------------------

; [ target special effect $50: possess ]

TargetEffect_50:
@3b98:  lda     $05,s
        tax
        lda     $3018,x
        tsb     $2f4c
        tsb     $3a88
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
        lda     $3018,y
        ldx     #$06
@3bba:  bit     $3a5c,x
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
        ora     $3de8,y
        sta     $3de8,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $21: rippler ]

TargetEffect_21:
@3c04:  lda     $05,s
        tax
        longa
        lda     $3ee4,x
        and     $3ee4,y
        eor     #$ffff
        sta     $ee
        lda     $3ee4,x
        and     $ee
        sta     $3dd4,y
        sta     $3dfc,x
        lda     $3ee4,y
        and     $ee
        sta     $3dd4,x
        sta     $3dfc,y
        lda     $3ef8,x
        and     $3ef8,y
        eor     #$ffff
        sta     $ee
        lda     $3ef8,x
        and     $ee
        sta     $3de8,y
        sta     $3e10,x
        lda     $3ef8,y
        and     $ee
        sta     $3de8,x
        sta     $3e10,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $19: exploder ]

TargetEffect_19:
@3c4c:  .a8
        lda     $05,s
        tax
        stx     $ee
        cpy     $ee
        bne     _3c5a
        lda     $3018,x
        trb     $a4
_3c5a:  rts

; ------------------------------------------------------------------------------

; [ target special effect $10: scan ]

TargetEffect_10:
@3c5b:  lda     $3c80,y
        bit     #$10
        bne     @3c68       ; branch if target can't be scanned
        tyx
        lda     #$27        ; command $27 (display scan info)
        jmp     CreateImmediateAction
@3c68:  lda     #$2c
        sta     $3401
        rts

; ------------------------------------------------------------------------------

; [ target special effect $30: suplex ]

TargetEffect_30:
@3c6e:  lda     $3c80,y
        bit     #$04
        beq     _3c5a       ; branch if not immune to suplex
_3c75:  jmp     _c23b1b

; ------------------------------------------------------------------------------

; [ target special effect $57: air anchor ]

TargetEffect_57:
@3c78:  lda     $3aa1,y
        bit     #$04
        bne     _3c75       ; branch if $3aa1.2 set (instant death protection)
        lda     #$13        ; battle message $13: "move, and you're dust!"
        sta     $3401
        lda     $3205,y     ; clear air anchor effect ($3205.2)
        and     #$fb
        sta     $3205,y
; fall through

; ------------------------------------------------------------------------------

; [ target special effect $23: disable counterattack ]

TargetEffect_23:
@3c8c:  stz     $341a       ; disable counterattack
        rts

; ------------------------------------------------------------------------------

; [ target special effect $1c: reflect??? ]

TargetEffect_1c:
@3c90:  rts

; ------------------------------------------------------------------------------

; [ target special effect $34: charm ]

TargetEffect_34:
@3c91:  lda     $05,s       ; attacker
        tax
        lda     $3394,x     ; charm target
        bpl     _3c75       ; return if attacker already has a charm target
        tya
        sta     $3394,x     ; set attacker's charm target
        txa
        sta     $3395,y     ; set target's charm attacker
        rts

; ------------------------------------------------------------------------------

; [ target special effect $17: tapir ]

TargetEffect_17:
@3ca2:  lda     $3ee5,y
        bpl     _3c75
        longa
        lda     $3c1c,y
        sta     $3bf4,y
_3caf:  longa
        lda     $3c30,y
        sta     $3c08,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $20: pep up ]

TargetEffect_20:
@3cb8:  lda     $05,s
        tax
        jsr     _c2384a
        longa
        lda     $3018,x
        tsb     $2f4c
        stz     $3bf4,x
        stz     $3c08,x
        bra     _3caf

; ------------------------------------------------------------------------------

; [ target special effect $2e: seize ]

TargetEffect_2e:
@3cce:  .a8
        lda     $05,s       ; attacker
        tax
        lda     $3358,x     ; seize target
        bpl     _3c75       ; return if attacker already has a seize target
        cpy     #$08
        bcs     _3c75       ; return if target is a monster
        tya
        sta     $3358,x     ; set attacker's seize target
        txa
        sta     $3359,y     ; set target's seize attacker
        lda     $3dac,x     ; set msb of attacker's character/monster variable
        ora     #$80
        sta     $3dac,x
        lda     $3018,y     ; target's character/monster mask
        trb     $3403       ; set target that is seized
        lda     $3aa0,y     ; clear $3aa0.7 (target's battle menu can't open)
        and     #$7f
        sta     $3aa0,y
        lda     #$40        ; remove all advance wait actions (set $3204.6)
        jmp     SetCharFlag

; ------------------------------------------------------------------------------

; [ target special effect $44: discard ]

TargetEffect_44:
@3cfd:  lda     $05,s       ; attacker
        tax
        lda     $3dac,x     ; clear msb of attacker's character/monster variable
        and     #$7f
        sta     $3dac,x
        lda     #$ff
        sta     $3358,x     ; invalidate attacker's seize target
        sta     $3359,y     ; invalidate target's seize attacker
        lda     $3018,y
        tsb     $3403       ; clear target that is seized
        rts

; ------------------------------------------------------------------------------

; [ target special effect $4c: elixir/megalixir ]

TargetEffect_4c:
@3d17:  lda     #$80        ; update enabled spells/espers
        jsr     SetCharFlag
        bra     _3caf

; ------------------------------------------------------------------------------

; [ target special effect $37: overcast ]

TargetEffect_37:
@3d1e:  lda     $3e4d,y     ; set overcast status ($3e4d.1)
        ora     #$02
        sta     $3e4d,y
        rts

; ------------------------------------------------------------------------------

; [ target special effect $3a: zinger ]

TargetEffect_3a:
@3d27:  lda     $05,s       ; attacker
        tax
        stx     $33f8       ; zinger attacker
        sty     $33f9       ; zinger target
        lda     $3019,x
        tsb     $2f4d       ; attacker can't be targetted
        rts

; ------------------------------------------------------------------------------

; [ target special effect $2d: love token ]

TargetEffect_2d:
@3d37:  lda     $05,s       ; attacker
        tax
        tya
        sta     $336c,x     ; love token target
        txa
        sta     $336d,y     ; love token attacker
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
@3d49:  lda     $3c95,y
        bpl     @3d62
        cpy     #$08
        bcs     @3d63
        lda     $3dd4,y
        and     #$7f
        sta     $3dd4,y
        longa
        lda     $3c1c,y
        sta     $3bf4,y
@3d62:  rts

@3d63:  .a8
        clr_a
        lda     $3de9,y
        ora     #$20
        sta     $3de9,y
        lda     $3019,y
        xba
        longa
        sta     $b8
        ldx     #$0a        ; monster entry/exit effects $0a (fade in/out, materialize)
        lda     #$0024      ; command $24 (monster entrance/exit)
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; [ target special effect $3e: phantasm ]

TargetEffect_3e:
@3d7c:  .a8
        lda     $3e4d,y
        ora     #$40
        sta     $3e4d,y     ; set phantasm status ($3e4d.6)
        rts

; ------------------------------------------------------------------------------

; [ target special effect $3f: stunner ]

TargetEffect_3f:
@3d85:  jsr     Rand
        cmp     $11a8
        bcc     @3da7
        longa
        lda     $11aa
        eor     #$ffff
        and     $3dd4,y
        sta     $3dd4,y
        lda     $11ac
        eor     #$ffff
        and     $3de8,y
        sta     $3de8,y
@3da7:  rts

; ------------------------------------------------------------------------------

; [ target special effect $2f: targetting ]

TargetEffect_2f:
@3da8:  .a8
        lda     $05,s
        tax
        tya
        sta     $32f5,x     ; set "targetting" target
        rts

; ------------------------------------------------------------------------------

; [ target special effect $40: fallen one ]

TargetEffect_40:
@3db0:  longa
        clr_a
        inc
        sta     $3bf4,y     ; set hp to 1
        rts

; ------------------------------------------------------------------------------

; [ target special effect $4a: super ball ]

TargetEffect_4a:
@3db8:  .a8
        jsr     Rand
        and     #$07        ; (1..8)
        inc
        sta     $11b1       ; item damage ???
        stz     $11b0
        rts

; ------------------------------------------------------------------------------

; metamorph probabilities
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

; [ execute attacker special effect ]

DoAttackerEffect:
_magicfunc3:
@3e7d:  phx
        php
        shortai
        txy
        ldx     $11a9
        jsr     (.loword(AttackerEffectTbl),x)
        plp
        plx

AttackerEffectNone:
@3e8a:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $01: thiefknife ]

AttackerEffect_01:
@3e8b:  jsr     RandCarry
        bcs     @3e9f
        lda     #$a4        ; special effect $52 (steal)
        sta     $11a9
        lda     $b5
        cmp     #$00
        bne     @3e9f
        lda     #$06
        sta     $b5
@3e9f:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $1e: step mine ]

AttackerEffect_1e:
@3ea0:  stz     $3414       ; disable damage modification
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

AttackerEffect_0e:
@3eca:  lda     $b1         ; counterattack flag
        lsr
        bcs     AttackerEffect_07       ; branch if a counterattack
        lda     $3aa0,y
        bit     #$04
        bne     AttackerEffect_07       ; branch if $3aa0.2 is set (ogre nix can't be broken)
        lda     $3bf5,y
        xba
        lda     $3bf4,y
        ldx     #$0a
        jsr     Div
        inx
        txa
        jsr     RandA
        dec
        bpl     AttackerEffect_07
        tya
        lsr
        tax
        inc     $2f30,x
        xba
        lda     #$05
        jsr     MultAB
        sta     $ee
        tyx
        lda     $3a70
        lsr
        bcs     @3f06
        inx
        lda     $ee
        adc     #$14
        sta     $ee
@3f06:  stz     $3b68,x
        ldx     $ee
        lda     $2b86,x
        cmp     #$17
        bne     AttackerEffect_07
        lda     #$ff
        sta     $2b86,x
        sta     $2b87,x
        stz     $2b89,x
        lda     #$44        ; battle message $44: "ogre nix was broken!"
        sta     $3401
; fall through

; ------------------------------------------------------------------------------

; [ attacker special effect $07: use mp for critical ]

; rune edge, illumina, ragnarok, punisher

AttackerEffect_07:
@3f22:  lda     #$0c        ; use 12 mp
_3f24:  sta     $ee
        lda     $b2
        bit     #$02
        bne     @3f4f
        lda     $3ec9
        beq     @3f4f       ; return if there are no targets
        clr_a
        jsr     Rand
        and     #$07
        clc
        adc     $ee
        longa
        sta     $ee
        lda     $3c08,y
        cmp     $ee
        bcc     @3f4f
        sbc     $ee
        sta     $3c08,y
        lda     #$0200
        trb     $b2
@3f4f:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0f: use more mp for critical (unused) ]

AttackerEffect_0f:
@3f50:  .a8
        lda     #$1c        ; use 26 mp
        bra     _3f24

; ------------------------------------------------------------------------------

; [ attacker special effect $1b: pearl wind ]

AttackerEffect_1b:
@3f54:  lda     #$60
        tsb     $11a2
        stz     $3414       ; disable damage modification
        longa
        lda     $3bf4,y
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $11: scan ]

AttackerEffect_11:
@3f65:  longa
        lda     $3bf4,y
        sta     $3a36
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $06: soul sabre ]

AttackerEffect_06:
@3f6e:  .a8
        lda     #$80
        tsb     $11a3
; fall through

; ------------------------------------------------------------------------------

; [ attacker special effect $05: drainer ]

AttackerEffect_05:
@3f73:  lda     #$08
        tsb     $11a2
        lda     #$02
        tsb     $11a4       ; drain effect
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0c: heal rod ]

AttackerEffect_0c:
@3f7e:  lda     #$20
        tsb     $11a2
        lda     #$01
        tsb     $11a4
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0a: valiantknife ]

; increase damage by (max hp - current hp)

AttackerEffect_0a:
@3f89:  lda     #$20
        tsb     $11a2
        longa
        sec
        lda     $3c1c,y
        sbc     $3bf4,y
        clc
        adc     $11b0
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $0b: tempest ]

AttackerEffect_0b:
@3f9f:  .a8
        jsr     Rand
        cmp     #$80
        bcs     _3fb6       ; 50% chance to return
        stz     $11a6       ; clear attack power
        lda     #$65        ; cast wind slash
        bra     _3fb0

; ------------------------------------------------------------------------------

; [ attacker special effect $49: magicite ]

AttackerEffect_49:
@3fad:  jsr     RandGenju
_3fb0:  sta     $3400       ; current spell
        inc     $3a70       ; increment number of attacks
_3fb6:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $51: gp rain ]

AttackerEffect_51:
@3fb7:  lda     $3b18,y
        xba
        lda     #$1e
        jsr     MultAB
        longa
        cpy     #$08
        bcs     @3fd3
        jsr     TakeGil
        bne     @3fe9
@3fcb:  stz     $a4
        ldx     #$08
        stx     $3401
        rts
@3fd3:  sta     $ee
        lda     $3d98,y
        beq     @3fcb
        sbc     $ee
        bcs     @3fe4
        lda     $3d98,y
        sta     $ee
        clr_a
@3fe4:  sta     $3d98,y
        lda     $ee
@3fe9:  ldx     #$02
        stx     $e8
        jsr     Mult24
        lda     $e8
        ldx     $3ec9       ; number of targets
        jsr     Div
        sta     $11b0       ; damage
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $19: exploder ]

AttackerEffect_19:
@3ffc:  .a8
        tyx
        stz     $bc
        lda     #$10
        tsb     $b0
        stz     $3414       ; disable damage modification
        longa
        lda     $a4
        pha
        lda     $3018,x
        sta     $b8
        jsr     InitGfxParams
        jsr     CopyGfxParamsToBuf
        lda     $01,s
        sta     $b8
        jsr     InitGfxParams
        pla
        ora     $3018,x
        sta     $a4
        lda     $3bf4,x
        sta     $11b0
        jmp     _c235ad

; ------------------------------------------------------------------------------

; [ attacker special effect $4a: super ball ]

AttackerEffect_4a:
@402c:  .a8
        lda     #$7d
        sta     $b6
        jsr     Rand
        and     #$03
        bra     _4039

; ------------------------------------------------------------------------------

; [ attacker special effect $2c: launcher ]

AttackerEffect_2c:
@4037:  lda     #$07
_4039:  sta     $3405
        longa
        lda     $3018,y
        sta     $a6
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $02: atma weapon ]

AttackerEffect_02:
@4044:  .a8
        lda     #$20
        tsb     $11a2       ; ignore target's defense
        lda     #$02
        tsb     $b2         ; no critical
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $18/$4d: warp/warp stone ]

AttackerEffect_18:
AttackerEffect_4d:
@404e:  lda     $b1
        bit     #$04
        bne     @405a       ; branch if can't run away
        lda     #$02        ; end of battle special event 1 (ran out of time before emperor's banquet)
        sta     $3a6e
        rts
@405a:  lda     #$0a        ; battle message $0a "can't escape!!"
        sta     $3401
        bra     AttackerEffectMiss

; ------------------------------------------------------------------------------

; [ attacker special effect $33: bababreath ]

AttackerEffect_33:
@4061:  stz     $ee
        ldx     #$06
@4065:  lda     $3aa0,x
        lsr
        bcc     @407c       ; branch if $3aa0.0 is clear
        lda     $3ee4,x
        bit     #$c2
        beq     @407c
        lda     $3018,x
        bit     $3f2c
        bne     @407c
        sta     $ee
@407c:  dex2
        bpl     @4065
        lda     $ee
        bne     @408d
        lda     $3a76
        cmp     #$02
        bcs     _40ba
        bra     AttackerEffectMiss
@408d:  sta     $b8
        stz     $b9
        tyx
        jmp     InitGfxParams

; ------------------------------------------------------------------------------

; [ attacker special effect $50: possess ]

AttackerEffect_50:
@4095:  jsr     Rand
        cmp     #$96
        bcc     _40ba       ; ~60% chance to return (40% chance to miss)

miss_atmk:
AttackerEffectMiss:
@409c:  stz     $a4         ; clear targets hit
        stz     $a5
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $1d: l? pearl ]

; hits targets with level divisble by last digit of gp

AttackerEffect_1d:
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

AttackerEffect_27:
@40bb:  cpy     #$08
        bcs     _40ba       ; return if attacker is a monster
        lda     #$22
        sta     $b5         ; command $22 (enemy roulette ???)
        lda     #$10
        tsb     $a0         ; disable pre-attack swirly animation
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $4b: smoke bomb ]

; characters run away

AttackerEffect_4b:
@40c8:  lda     #$04
        bit     $b1
        beq     _40ba       ; return if party can run away
        jsr     AttackerEffectMiss
        stz     $11a9       ; disable attack special effect
        lda     #$09        ; battle message $09 "can't run away!!"
_40d6:  sta     $3401
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $31: forcefield ]

AttackerEffect_31:
@40da:  clr_a
        lda     #$ff
        eor     $3ec8       ; elements nullified by forcefield
        beq     AttackerEffectMiss
        jsr     RandBit
        tsb     $3ec8
        jsr     GetBitID
        txa
        clc
        adc     #$37        ; battle message ($37..$3e) "...-element ineffectual"
        bra     _40d6

; ------------------------------------------------------------------------------

; [ attacker special effect $32: quadra slam/slice ]

AttackerEffect_32:
@40f1:  lda     #$03
        sta     $3a70       ; 4 attacks
        lda     #$40
        tsb     $ba         ; random target
        stz     $11a9       ; disable special effect
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $1a: blow fish ]

AttackerEffect_1a:
@40fe:  lda     #$60        ;
        tsb     $11a2
        stz     $3414       ; disable damage modification
        longa
        lda     #1000       ; set damage to 1000
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $2a: flare star ]

AttackerEffect_2a:
@410f:  stz     $3414       ; disable damage modification
        longa
        lda     $a2
        jsr     RandBit
        jsr     BitToTargetID
        lda     $a2
        jsr     CountBits
        shorta
        lda     $3b18,y
        xba
        lda     $11a6
        jsr     MultAB
        jsr     Div
        longa
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $4c: elixir/megalixir ]

AttackerEffect_4c:
@4136:  .a8
        lda     #$80
        trb     $11a3
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $28: mind blast ]

AttackerEffect_28:
@413c:  longa
        ldy     #$06
@4140:  lda     $a4         ; character targets hit
        jsr     RandBit
        sta     $3a5c,y     ; set mind blast status
        dey2
        bpl     @4140
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $29: n. cross ]

AttackerEffect_29:
@414d:  .a8
        jsr     Rand
        trb     $a4         ; random character targets
        jsr     Rand
        trb     $a5         ; random monster targets
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $09: dice/fixed dice ]

AttackerEffect_09:
@4158:  stz     $3414       ; disable damage modification
        lda     #$20
        tsb     $11a4       ; can't dodge
        lda     #$0f
        sta     $b6         ; disable 3rd die roll
        clr_a
        jsr     Rand
        pha
        and     #$0f
        ldx     #6
        jsr     Div
        stx     $b7
        inx
        stx     $ee         ; +$ee = die 1
        pla
        ldx     #$60
        jsr     Div
        txa
        and     #$f0
        ora     $b7
        sta     $b7         ; dice rolls (low/high nybble)
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
        sta     $b6         ; set 3rd die roll (low nybble)
        inc
        xba
        lda     $ee
        jsr     MultAB
        sta     $ee         ; +$ee = die 1 * die 2 * die 3
@41ab:  ldx     #$00        ; bonus multiplier = 0
        lda     $b6
        asl4
        ora     $b6
        cmp     $b7
        bne     @41bb       ; branch unless all dice match (only if there are 3 dice)
        ldx     $b6         ; bonus multiplier = matching dice value
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
        lda     $b5
        cmp     #$00
        bne     @41e3
        lda     #$26        ; command $26 (set dice roll)
@41e3:  sta     $b5
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $3d: revenge ]

AttackerEffect_3d:
@41e6:  stz     $3414       ; disable damage modification
        longa
        sec
        lda     $3c1c,y     ; damage = max hp - current hp
        sbc     $3bf4,y
        sta     $11b0
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $13: sonic dive ]

AttackerEffect_13:
@41f6:  .a8
        lda     #$10
        tsb     $3a46       ; set $3a46.4
        longa
        ldx     #$12
@41ff:  lda     $3ee4,x
        bit     #$8040
        bne     @420f
        lda     $3ef8,x
        bit     #$2210
        beq     @4216
@420f:  lda     $3018,x
        trb     $a2
        trb     $a4
@4216:  dex2
        bpl     @41ff
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $36: empowerer ]

AttackerEffect_36:
@421b:  .a8
        lda     $11a3       ; toggle "affect mp" flag
        eor     #$80
        sta     $11a3
        bpl     @422a
        lda     #$12        ; command $12 (mimic)
        sta     $b5
        rts
@422a:  inc     $3a70       ; increment number of attacks
        lsr     $11a6       ; divide attack power by 4
        lsr     $11a6
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $16: spiraler ]

AttackerEffect_16:
@4234:  tyx
        lda     $3018,x
        trb     $a2
        trb     $a4
        tsb     $2f4c
        jsr     _c2384a
        longa
        stz     $3bf4,x     ; set hp and mp to zero
        stz     $3c08,x
_424a:  rts

; ------------------------------------------------------------------------------

; [ attacker special effect $44: discard ]

AttackerEffect_44:
@424b:  .a8
        jsr     AttackerEffectMiss
        lda     #$20
        tsb     $11a4       ; can't dodge
        ldx     $3358,y
        bmi     _424a       ; return if seize target is not valid
        lda     $3018,x
        sta     $b8         ; set target
        stz     $b9
        tyx
        jmp     InitGfxParams

; ------------------------------------------------------------------------------

; [ attacker special effect $15: mantra ]

AttackerEffect_15:
@4263:  .a8
        lda     #$60
        tsb     $11a2
        stz     $3414       ; disable damage modification
        longa
        lda     $3018,y
        trb     $a4
        ldx     $3ec9       ; number of targets - 1
        dex
        lda     $3bf4,y     ; current hp
        jsr     Div
        sta     $11b0       ; damage
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $42: quarter damage ]

; unused

AttackerEffect_42:
@4280:  longa
        lsr     $11b0       ; divide damage by 4
; fall through

; ------------------------------------------------------------------------------

; [ attacker special effect $41: halve damage ]

; unused

AttackerEffect_41:
@4285:  longa
        lsr     $11b0       ; divide damage by 2
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $30: suplex ]

AttackerEffect_30:
@428b:  .a8
        lda     #$10
        tsb     $b0
        longa
        lda     $a2
        sta     $ee
        ldx     #$0a
@4297:  lda     $3c88,x
        bit     #$0004
        beq     @42a4       ; skip if target can be suplex'ed
        lda     $3020,x
        trb     $ee         ; remove target
@42a4:  dex2
        bpl     @4297
        lda     $ee
        bne     @42ae
        lda     $a2
@42ae:  jsr     RandBit
        sta     $b8
        tyx
        jmp     InitGfxParams

; ------------------------------------------------------------------------------

; [ attacker special effect $1c: reflect??? ]

; misses targets that do not have reflect status

AttackerEffect_1c:
@42b7:  longa
        ldx     #$12
@42bb:  lda     $3ef7,x     ; check each character/monster's status 3
        bmi     @42c5       ; branch if it has reflect status
        lda     $3018,x
        trb     $a4         ; clear target
@42c5:  dex2
        bpl     @42bb
        rts

; ------------------------------------------------------------------------------

; [ attacker special effect $43: quick ]

AttackerEffect_43:
        .a8
@42ca:  lda     $3402       ; quick counter
        bpl     @42d8       ; branch if another target is already quick
        sty     $3404       ; set quick target
        lda     #$02        ; set quick counter to 2
        sta     $3402
        rts
@42d8:  longa
        lda     $3018,y     ; make attack miss
        tsb     $3a5a
        rts

; ------------------------------------------------------------------------------

; attacker special effect jump table
AttackerEffectTbl:
@42e1:  .addr   AttackerEffectNone
        .addr   AttackerEffect_01
        .addr   AttackerEffect_02
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_05
        .addr   AttackerEffect_06
        .addr   AttackerEffect_07
        .addr   AttackerEffectNone
        .addr   AttackerEffect_09
        .addr   AttackerEffect_0a
        .addr   AttackerEffect_0b
        .addr   AttackerEffect_0c
        .addr   AttackerEffectNone
        .addr   AttackerEffect_0e
        .addr   AttackerEffect_0f
        .addr   AttackerEffectNone
        .addr   AttackerEffect_11
        .addr   AttackerEffectNone
        .addr   AttackerEffect_13
        .addr   AttackerEffectNone
        .addr   AttackerEffect_15
        .addr   AttackerEffect_16
        .addr   AttackerEffectNone
        .addr   AttackerEffect_18
        .addr   AttackerEffect_19
        .addr   AttackerEffect_1a
        .addr   AttackerEffect_1b
        .addr   AttackerEffect_1c
        .addr   AttackerEffect_1d
        .addr   AttackerEffect_1e
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_27
        .addr   AttackerEffect_28
        .addr   AttackerEffect_29
        .addr   AttackerEffect_2a
        .addr   AttackerEffectNone
        .addr   AttackerEffect_2c
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_30
        .addr   AttackerEffect_31
        .addr   AttackerEffect_32
        .addr   AttackerEffect_33
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_36
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_3d
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_41
        .addr   AttackerEffect_42
        .addr   AttackerEffect_43
        .addr   AttackerEffect_44
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_49
        .addr   AttackerEffect_4a
        .addr   AttackerEffect_4b
        .addr   AttackerEffect_4c
        .addr   AttackerEffect_4d
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffect_50
        .addr   AttackerEffect_51
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone
        .addr   AttackerEffectNone

; ------------------------------------------------------------------------------

; [ update status ]

UpdateStatus:
@4391:  phx
        php
        longa
        ldy     #$12
@4397:  lda     $3aa0,y     ; $3aa0.0 skip if target is not present
        lsr
        bcc     @43ff
        jsr     InitStatusVars
        lda     $fc         ; +$fc = status 1/2 to set
        beq     @43b3
        sta     $f0
        ldx     #$1e
@43a8:  asl     $f0
        bcc     @43af
        jsr     (.loword(SetStatusTbl),x)   ; status 1/2 to set
@43af:  dex2
        bpl     @43a8
@43b3:  lda     $fe         ; +$fe = status 3/4 to set
        beq     @43c6
        sta     $f0
        ldx     #$1e
@43bb:  asl     $f0
        bcc     @43c2
        jsr     (.loword(SetStatusTbl+$20),x)   ; status 3/4 to set
@43c2:  dex2
        bpl     @43bb
@43c6:  lda     $f4         ; +$f4 = status 1/2 to clear
        and     $331c,y
        sta     $f4
        beq     @43de
        sta     $f0
        ldx     #$1e
@43d3:  asl     $f0
        bcc     @43da
        jsr     (.loword(RemoveStatusTbl),x)   ; status 1/2 to clear
@43da:  dex2
        bpl     @43d3
@43de:  lda     $f6         ; +$f6 = status 3/4 to clear
        and     $3330,y
        sta     $f6
        beq     @43f6
        sta     $f0
        ldx     #$1e
@43eb:  asl     $f0
        bcc     @43f2
        jsr     (.loword(RemoveStatusTbl+$20),x)   ; status 3/4 to clear
@43f2:  dex2
        bpl     @43eb
@43f6:  jsr     CalcStatus
        jsr     _c24585
        jsr     ResetStatusMod
@43ff:  dey2                ; next character/monster
        bpl     @4397
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

MagicStatusEffect:
@4406:  php
        longa
        lda     $3ee4,y
        sta     $f8
        lda     $3ef8,y
        sta     $fa
        jsr     ApplyStatusMod
        shorta
        lda     $b3
        bmi     @4420
        lda     #$10
        trb     $f4
@4420:  lda     $3c95,y
        bpl     @443d
        lda     #$08
        bit     $11a2
        beq     @443d
        lsr
        bit     $11a4
        beq     @443d
        lda     $11aa
        bit     #$82
        beq     @443d
        lda     #$80
        tsb     $fc
@443d:  longa
        lda     $fc
        jsr     SetStatus1
        lda     $fe
        ora     $3de8,y
        sta     $3de8,y
        lda     $f4
        ora     $3dfc,y
        sta     $3dfc,y
        lda     $f6
        ora     $3e10,y
        sta     $3e10,y
        lda     $11a7
        lsr
        bcc     @447d
        lda     $fc
        ora     $f4
        and     $331c,y
        bne     @447d
        lda     $fe
        ora     $f6
        and     $3330,y
        bne     @447d
        lda     $3018,y
        sta     $3a48
        tsb     $3a5a
@447d:  plp
        rts

; ------------------------------------------------------------------------------

; [ calculate new status ]

CalcStatus:
_storestatus2:
@447f:  lda     $f8
        tsb     $fc
        lda     $f4
        trb     $fc
        lda     $fa
        tsb     $fe
        lda     $f6
        trb     $fe
        rts

; ------------------------------------------------------------------------------

; [ apply status modifications ]

ApplyStatusMod:
@4490:  phx
        shorta
        lda     $11a4
        and     #$0c
        lsr
        tax
        longa
        stz     $fc
        stz     $fe
        stz     $f4
        stz     $f6
        jsr     (.loword(StatusModTbl),x)
        lda     $11a2
        lsr
        bcs     @44bb
        lda     #$0010
        bit     $f8
        beq     @44bb
        bit     $11aa
        bne     @44bb
        tsb     $f4
@44bb:  lda     $11a1
        lsr
        bcc     @44cf
        lda     #$0200
        bit     $fa
        beq     @44cf
        bit     $11ac
        bne     @44cf
        tsb     $f6
@44cf:  plx
        rts

; ------------------------------------------------------------------------------

; status effect jump table
StatusModTbl:
@44d1:  .addr   StatusMod_00
        .addr   StatusMod_01
        .addr   StatusMod_02

; ------------------------------------------------------------------------------

; 0: set status
StatusMod_00:
@44d7:  lda     $11aa
        sta     $fc
        lda     $f8
        trb     $fc
        lda     $11ac
        sta     $fe
        lda     $fa
        trb     $fe
        rts

; ------------------------------------------------------------------------------

; 1: remove status
StatusMod_01:
@44ea:  lda     $11aa
        and     $f8
        sta     $f4
        lda     $11ac
        and     $fa
        sta     $f6
        rts

; ------------------------------------------------------------------------------

; 2: toggle status
StatusMod_02:
@44f9:  jsr     StatusMod_00
        jmp     StatusMod_01

; ------------------------------------------------------------------------------

; [ reset status mod flags ]

ResetStatusMod:
@44ff:  clr_a
        sta     $3dd4,y
        sta     $3de8,y
        sta     $3dfc,y
        sta     $3e10,y
        rts

; ------------------------------------------------------------------------------

; [ init status variables ]

InitStatusVars:
magicstatus_sub:
@450d:  lda     $3dfc,y     ; status 1/2 to clear
        sta     $f4
        lda     $3e10,y     ; status 3/4 to clear
        sta     $f6
        lda     $3dd4,y     ; status 1/2 to set
        and     $331c,y     ; blocked status 1/2
        sta     $fc
        lda     $3de8,y     ; status 3/4 to set
        and     $3330,y     ; blocked status 3/4
        sta     $fe
        lda     $3ee4,y     ; current status 1/2
        sta     $f8
        and     #$0040      ; isolate petrify bit
        tsb     $fc         ; set in status to set
        lda     $3ef8,y     ; current status 3/4
        sta     $fa
        lda     $3c1c,y     ; max hp / 8
        lsr3
        cmp     $3bf4,y     ; current hp
        lda     #$0200
        bit     $f8         ; branch if character is already near fatal
        bne     @454a
        bcc     @454e
        tsb     $fc         ; add near fatal in status to set
@454a:  bcs     @454e
        tsb     $f4         ; otherwise, add near fatal in status to clear
@454e:  lda     $fb         ; branch if wound is not in status to set ???
        bpl     @4566
        lda     $3e4d,y     ; branch if overcast flag is not set ($3e4d.1)
        and     #$0002
        beq     @4566
        ora     $fc         ; add zombie in status to set
        and     #$ff7f      ; remove wound from status to set
        sta     $fc
        lda     #$0100      ; add condemned in status to clear
        tsb     $f4
@4566:  lda     $32df,y     ;
        bpl     @4584
        lda     $fc
        pha
        lda     $fe
        pha
        jsr     CalcStatus
        lda     $fc
        sta     $3e60,y
        lda     $fe
        sta     $3e74,y
        pla
        sta     $fe
        pla
        sta     $fc
@4584:  rts

; ------------------------------------------------------------------------------

; [  ]

_c24585:
magicstatus_sub2:
@4585:  lda     $fc
        bit     #$0002
        beq     @458f
        and     #$4dfa
@458f:  sta     $3ee4,y
        lda     $fe
        sta     $3ef8,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c24598:
setrstatus0:
@4598:  pha
        lda     $f8
        ora     $fc
        and     $01,s
        tsb     $f4         ; status to clear
        pla
        rts

; ------------------------------------------------------------------------------

; [ zombie set ]

SetStatus_01:
@45a3:  lda     #$0080
        jsr     _c24598
        jsr     _c246a9       ; set character/monster dead flag
        bra     _45c1

; ------------------------------------------------------------------------------

; [ zombie clear ]

RemoveStatus_01:
@45ae:  jsr     _c2469c
        bra     _45c1

; ------------------------------------------------------------------------------

; [ muddled set ]

SetStatus_0d:
@45b3:  lda     $3018,y
        tsb     $2f53
        bra     _45c1

; ------------------------------------------------------------------------------

; [ muddled clear ]

RemoveStatus_0d:
@45bb:  lda     $3018,y
        trb     $2f53
_45c1:  phx
        ldx     $3018,y     ; character/monster flag
        txa
        tsb     $3a4a       ; characters/monsters with changed status
        plx
        rts

; ------------------------------------------------------------------------------

; [ clear set ]

SetStatus_04:
@45cb:  phx
        ldx     $3019,y
        txa
        tsb     $2f44       ; monsters with clear status (graphics)
        plx
        rts

; ------------------------------------------------------------------------------

; [ remove clear status ]

RemoveStatus_04:
@45d5:  phx
        ldx     $3019,y
        txa
        trb     $2f44       ; monsters with clear status (graphics)
        plx
        rts

; ------------------------------------------------------------------------------

; [ imp set/clear ]

SetStatus_05:
RemoveStatus_05:
@45df:  lda     #$0088      ; update enabled spells/espers and enabled commands
        jsr     SetCharFlag
; fall through

; ------------------------------------------------------------------------------

; [ rage clear ]

RemoveStatus_18:
@45e5:  cpy     #$08
        bcs     @45f1       ; return if a monster
        phx
        tya
        lsr
        tax
        inc     $2f30,x     ; set equipment change flag
        plx
@45f1:  rts

; ------------------------------------------------------------------------------

; [ petrify/wound clear ]

RemoveStatus_06:
RemoveStatus_07:
@45f2:  jsr     _c2469c
        lda     #$4000
        jsr     _c24656
        lda     #$0040      ; remove all advance wait actions
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ wound set ]

SetStatus_07:
@4600:  lda     #$0140      ; clear petrify/condemned
        jsr     _c24598
        lda     #$0080      ; don't clear wound
        trb     $f4
; fall through

; ------------------------------------------------------------------------------

; [ petrify set ]

SetStatus_06:
@460b:  jsr     _c246a9       ; set character/monster dead flag
        lda     #$fe15
        jsr     _c24598
        lda     $fa
        ora     $fe
        and     #$9bff
        tsb     $f6
        lda     $3e4c,y     ; clear $3e4d.6 (phantasm status)
        and     #$bfff
        sta     $3e4c,y
_4626:  lda     $3aa0,y     ; clear $3aa0.7 (battle menu can't open)
        and     #$ff7f
        sta     $3aa0,y
        lda     #$0040      ;
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ psyche set ]

SetStatus_0f:
@4634:  php
        shorta
        lda     #$12
        sta     $3cf9,y     ; set psyche counter to $12
        plp
        .a16
        bra     _4626       ;

; ------------------------------------------------------------------------------

; [ condemned set ]

SetStatus_08:
@463f:  lda     #$0020      ; set condemned counter
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ condemned clear ]

RemoveStatus_08:
@4644:  lda     #$0010      ; clear condemned counter
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ mute set/clear ]

SetStatus_0b:
RemoveStatus_0b:
@4649:  lda     #$0008      ; update enabled commands
; fall through

; ------------------------------------------------------------------------------

; [ set character update flag(s) ]

SetCharFlag:
@464c:  ora     $3204,y
        sta     $3204,y
        rts

; ------------------------------------------------------------------------------

; [ psyche clear ]

RemoveStatus_0f:
@4653:  lda     #$4000      ; set $3aa1.6 pending psyche action

_c24656:
@4656:  ora     $3aa0,y
        sta     $3aa0,y
        rts

; ------------------------------------------------------------------------------

; [ seizure set ]

SetStatus_0e:
@465d:  lda     #$0002
        tsb     $f6
        rts

; ------------------------------------------------------------------------------

; [ regen set ]

SetStatus_11:
@4663:  lda     #$4000
        tsb     $f4
        rts

; ------------------------------------------------------------------------------

; [ slow set ]

SetStatus_12:
@4669:  lda     #$0008
        bra     _4671

; ------------------------------------------------------------------------------

; [ haste set ]

SetStatus_13:
@466e:  lda     #$0004
_4671:  tsb     $f6
; fall through

; ------------------------------------------------------------------------------

; [ slow/haste cleared ]

RemoveStatus_12:
RemoveStatus_13:
@4673:  lda     #$0004      ; update atb gauge constant
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ morph/revert set/clear ]

SetStatus_1b:
RemoveStatus_1b:
@4678:  lda     #$0002      ; update character after morph/revert
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ stop set ]

SetStatus_14:
@467d:  php
        shorta
        lda     #$12
        sta     $3af1,y
        plp
        rts

; ------------------------------------------------------------------------------

; [ reflect set ]

SetStatus_17:
@4687:  php
        shorta
        lda     #$1a        ; set reflect counter to 26
        sta     $3f0c,y
        plp
        rts

; ------------------------------------------------------------------------------

; [ frozen set ]

SetStatus_19:
@4691:  php
        shorta
        lda     #$22
        sta     $3f0d,y
        plp
        rts

; ------------------------------------------------------------------------------

; [ status set/clear: no effect ]

SetStatusNoEffect:
RemoveStatusNoEffect:
@469b:  rts

; ------------------------------------------------------------------------------

; [ revive monster ]

_c2469c:
removeerase:
@469c:  phx
        ldx     $3019,y     ; monster flag
        txa
        tsb     $2f2f       ; monsters that are not dead
        trb     $3a3a       ; monsters that have died
        plx
        rts

; ------------------------------------------------------------------------------

; [ set character/monster dead flag ]

_c246a9:
setnowdead:
@46a9:  lda     $3018,y     ; character/monster mask
        tsb     $3a56       ; characters/monsters that have died
        rts

; ------------------------------------------------------------------------------

; set status jump table
SetStatusTbl:
@46b0:  .addr   SetStatusNoEffect
        .addr   SetStatus_01
        .addr   SetStatusNoEffect
        .addr   SetStatusNoEffect
        .addr   SetStatus_04
        .addr   SetStatus_05
        .addr   SetStatus_06
        .addr   SetStatus_07
        .addr   SetStatus_08
        .addr   SetStatusNoEffect
        .addr   SetStatusNoEffect
        .addr   SetStatus_0b
        .addr   SetStatusNoEffect
        .addr   SetStatus_0d
        .addr   SetStatus_0e
        .addr   SetStatus_0f
        .addr   SetStatusNoEffect
        .addr   SetStatus_11
        .addr   SetStatus_12
        .addr   SetStatus_13
        .addr   SetStatus_14
        .addr   SetStatusNoEffect
        .addr   SetStatusNoEffect
        .addr   SetStatus_17
        .addr   SetStatusNoEffect
        .addr   SetStatus_19
        .addr   SetStatusNoEffect
        .addr   SetStatus_1b
        .addr   SetStatusNoEffect
        .addr   SetStatusNoEffect
        .addr   SetStatusNoEffect
        .addr   SetStatusNoEffect

; remove status jump table
RemoveStatusTbl:
@46f0:  .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_01
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_04
        .addr   RemoveStatus_05
        .addr   RemoveStatus_06
        .addr   RemoveStatus_07
        .addr   RemoveStatus_08
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_0b
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_0d
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_0f
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_12
        .addr   RemoveStatus_13
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_18
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatus_1b
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect
        .addr   RemoveStatusNoEffect

; ------------------------------------------------------------------------------

; [ calculate item/spell effect (from menu) ]

; X: 0 = spell, 2 = item

CalcMagicEffect:
_menumagic:
@4730:  phx
        phy
        phb
        php
        shortai
        pha
        lda     #$7e
        pha
        plb
        pla
        clc
        jsr     (.loword(MenuEffectTbl),x)
        jsr     ApplyStatusMod
        jsr     CalcStatus
        plp
        plb
        ply
        plx
        rtl

; ------------------------------------------------------------------------------

; jump table for item/spell
table_menumagic:
MenuEffectTbl:
@474b:  .addr   MenuMagicEffect
        .addr   MenuItemEffect

; ------------------------------------------------------------------------------

; x = 0: cast spell
MenuMagicEffect:
@474f:  jsr     LoadMagicProp
        lda     $11a4
        bpl     @4775                   ; branch if not a fraction of hp
        lda     $11a6
        sta     $e8
        longai
        lda     $11b2
        jsr     CalcMaxHPMP
        cmp     #10000                  ; max 9999
        bcc     @476c
        lda     #9999
@476c:  shorti
        jsr     CalcRatio
        sta     $11b0
        rts
@4775:  jmp     CalcMagicDmg

; ------------------------------------------------------------------------------

; x = 2: use item
MenuItemEffect:
@4778:  .a8
        jsr     CalcItemEffect
        lda     #$01
        tsb     $11a2       ; physical damage
        rts

; ------------------------------------------------------------------------------

; [ multiply a * b ]

MultAB:
@4781:  php
        longa
        sta     f:hWRMPYA
        nop4
        lda     f:hRDMPYL
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ divide +a / x ]

; +A: result
;  X: remainder

Div:
@4792:  phy
        php
        longa
        sta     f:hWRDIVL
        shortai
        txa
        sta     f:hWRDIVB
        nop8
        lda     f:hRDMPYL
        tax
        longa
        lda     f:hRDDIVL
        plp
        ply
        rts

; ------------------------------------------------------------------------------

; [ +a *= $e8 / 256 ]

; ++$e8 = +a * $e8

Mult24:
@47b7:  php
        shorta
        stz     $ea
        sta     $e9
        lda     $e8
        jsr     MultAB
        longa_clc
        sta     $ec
        lda     $e8
        jsr     MultAB
        sta     $e8
        lda     $ec
        adc     $e9
        sta     $e9
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ a *= 1.5 ]

AddHalf:
@47d6:  pha
        lsr
        clc
        adc     $01,s
        bcc     @47df
        lda     #$ff
@47df:  sta     $01,s
        pla
        rts

; ------------------------------------------------------------------------------

; [ remove character from party ]

RemoveChar:
@47e3:  phx
        lda     $3ed9,x     ; character number
        tax
        stz     $1850,x     ; remove character from party
        plx
_47ec:  rts

; ------------------------------------------------------------------------------

; [ check if battle is over ]

CheckBattleEnd:
@47ed:  lda     $3ee0       ; branch if end of battle special events are disabled
        beq     @47fb
        lda     $3a6e       ; end of battle special event
        beq     @47fb
        tax
        jmp     (.loword(BattleEndTbl-2),x)

; no special event
@47fb:  lda     $1dd1       ; end battle if timer expires flag
        and     #$20
        beq     @4807
        tsb     $3ebc       ; update battle termination flag
        bra     @4820
@4807:  lda     $3a95       ; return if last monster is hidden (ai command $f5)
        bne     _47ec
        lda     $3a74       ; branch if any characters are still alive
        bne     @4833
        lda     $3a8a       ; engulfed targets
        beq     @4822       ; branch if no one was engulfed
        cmp     $3a8d
        bne     @4822       ; branch if not everyone was engulfed
        lda     #$80        ; set "zone eater just ate you" flag
        tsb     $3ebc
@4820:  bra     BattleEnd_04
@4822:  lda     $3a39       ; branch if there are any sneezed targets
        bne     BattleEnd_01
        lda     $3a97       ; branch if any characters are in colosseum mode
        bne     @482e
        lda     #$29        ; battle message $29 "annihilated"
@482e:  jsr     LoseBattle
        bra     _488f
@4833:  lda     $3a77       ; return if any monsters are still alive
        bne     _47ec
        lda     $3ee0       ; branch if end of battle special event is enabled
        bne     @4840
        jsr     CheckFinalBattle
@4840:  ldx     $300b       ; gau's character slot
        bmi     @4861       ; branch if gau is not in the party
        lda     #$01
        trb     $11e4
        beq     @4861       ; branch if gau can't appear after battle
        jsr     Rand
        cmp     #$a0
        bcs     @4861       ; 5/8 chance to branch
        lda     $3ebd
        bit     #$02
        bne     GauAppears       ; branch if gau has been obtained
        lda     $3a76
        cmp     #$02
        bcs     GauAppears       ; branch if more than 2 characters are left
@4861:  ldx     $3003
        bmi     @488c       ; branch if shadow is not in the party
        jsr     Rand
        cmp     #$10
        bcs     @488c       ; 15/16 chance to branch
        lda     $201f
        bne     @488c
        lda     $3a76
        cmp     #$02
        bcc     @488c
        lda     $3ee4,x
        bit     #$c2
        bne     @488c
        lda     #$08
        bit     $3ebd       ; shadow won't leave after battle
        bne     @488c
        bit     $1ede       ; shadow is an available character
        bne     ShadowLeaves
@488c:  jsr     WinBattle
_488f:  jsr     UpdateSRAM
        pla                 ; remove return address from stack
        pla
        jmp     TerminateBattle

; ------------------------------------------------------------------------------

; [ end of battle special event $01: ran out of time before emperor's banquet ]

; also warp/warp stone

BattleEnd_01:
@4897:  lda     #$ff
        sta     $0205
        lda     #$10        ; set "ran out of time before emperor's banquet" flag
        tsb     $3ebc
; fall through

; ------------------------------------------------------------------------------

; [ end of battle special event $04: end battle immediately ]

BattleEnd_04:
@48a1:  jsr     _c24903       ; init graphics for end of battle
        bra     _488f

; ------------------------------------------------------------------------------

; shadow leaves the party
ShadowLeaves:
@48a6:  trb     $1ede       ; available characters (remove shadow)
        jsr     RemoveChar
        longi
        ldy     $3010,x
        lda     #$ff
        sta     $161e,y
        shorti
        lda     #$fe
        jsr     ClearFlag0       ; clear $3aa0.0 (make target not present)
        lda     #$02
        tsb     $2f49       ; disable fanfare
        ldx     #$0b        ; battle event $0b (shadow leaves party)
_48c4:  pla
        pla
        lda     #$23        ; command $23 (battle event)
        jsr     CreateImmediateAction
        jmp     BattleLoop

; gau shows up
GauAppears:
@48ce:  lda     $3018,x     ; gau's character mask
        tsb     $2f4e       ; gau can be targetted
        tsb     $3a40       ; gau acts like an enemy
        lda     #$04
        tsb     $3a46       ; clear all pending actions ($3a46.2)
        ldx     #$1b        ; battle event $1b (gau appears on veldt)
        bra     _48c4

; ------------------------------------------------------------------------------

; [ end of battle special event $02: gau leaped ]

BattleEnd_02:
@48e0:  ldx     $300b       ; gau character slot
        jsr     RemoveChar
        lda     #$08
        trb     $1edf       ; remove from available characters
; fall through

; ------------------------------------------------------------------------------

; [ end of battle special event $05: gau learned rages ]

BattleEnd_05:
@48eb:  jsr     LearnRage
        bra     _488f

; ------------------------------------------------------------------------------

; [ end of battle special event $03: banon died ]

BattleEnd_03:
@48f0:  lda     #$36        ; battle message $36 "banon fell_"
        jsr     LoseBattle
        bra     _488f

; ------------------------------------------------------------------------------

; jump code for end of battle special events
BattleEndTbl:
@48f7:  .addr   BattleEnd_01
        .addr   BattleEnd_02
        .addr   BattleEnd_03
        .addr   BattleEnd_04
        .addr   BattleEnd_05
        .addr   BattleEnd_06

; ------------------------------------------------------------------------------

; [ init graphics for end of battle ]

_c24903:
_winallclose:
@4903:  jsr     SaveMorphCounter
        ldx     #$06
@4908:  stz     $3b04,x     ; hide morph gauge
        txa
        lsr
        sta     $10
        lda     #$03        ; battle graphics $03 (close battle menu)
        jsr     ExecBtlGfx
        dex2                ; next character
        bpl     @4908
        lda     #$80        ; disable battle menus opening
        tsb     $b1
        ldx     #$20        ; wait 32 frames
@491e:  lda     #$01        ; battle graphics $01 (wait for vblank)
        jsr     ExecBtlGfx
        dex
        bne     @491e
        lda     #$0f        ; check if any characters obtained an item
        tsb     $3a8c
        jsr     _c262c7       ; add obtained items to inventory
        lda     #$0a        ; battle graphics $0a (update inventory with obtained items)
        jsr     ExecBtlGfx
        jmp     UpdateCharProp

; ------------------------------------------------------------------------------

; [ update sram after battle ]

UpdateSRAM:
@4936:  ldx     #$06
@4938:  lda     $3ed8,x     ; actor number
        bmi     @497b       ; skip if no character in this slot
        cmp     #$10
        beq     @4945       ; branch if $10 (ghost #1)
        cmp     #$11
        bne     @494c       ; branch if not $11 (ghost #2)
@4945:  lda     $3ee4,x     ; status 1
        bit     #$c2
        bne     @4954       ; branch if zombie, petrify, or wound
@494c:  lda     $3018,x
        bit     $3a88
        beq     @4957       ; branch if not posessed
@4954:  jsr     RemoveChar
@4957:  lda     $3ef9,x     ; status 4
        and     #$c0        ; isolate float and interceptor
        xba
        lda     $3ee4,x     ; status 1
        longai
        ldy     $3010,x     ; pointer to character data
        sta     $1614,y     ; set character status
        lda     $3bf4,x     ; current hp
        sta     $1609,y
        lda     $3c30,x     ; branch if max mp is 0
        beq     @4979
        lda     $3c08,x     ; current mp
        sta     $160d,y
@4979:  shortai
@497b:  dex2                ; next character
        bpl     @4938
        longi
        ldx     #$00ff
        ldy     #$04fb
@4987:  lda     $2686,y     ; copy item number
        sta     $1869,x
        inc
        beq     @4993       ; branch if item slot is empty
        lda     $2689,y     ; copy item quantity
@4993:  sta     $1969,x
        dey5                ; next item
        dex
        bpl     @4987
        lda     $3a97
        beq     @49c4       ; branch if colosseum battle
        lda     $0205       ; item wagered
        cmp     #$ff
        beq     @49c4       ; branch if empty
        ldx     #$00ff
@49ad:  cmp     $1869,x     ; find the item in inventory
        bne     @49c1
        dec     $1969,x     ; decrement quantity
        beq     @49b9
        bpl     @49c1
@49b9:  lda     #$ff
        sta     $1869,x     ; set empty if there are none remaining
        stz     $1969,x     ; set quantity to zero
@49c1:  dex
        bpl     @49ad
@49c4:  shorti
        ldx     $33fa       ; doom gaze
        bmi     @49d5       ; branch if not present
        longa
        lda     $3bf4,x     ; save doom gaze's hp
        sta     $3ebe
        shorta
@49d5:  ldx     #$13        ; copy global battle variables
@49d7:  lda     $3eb4,x
        sta     $1dc9,x
        dex
        bpl     @49d7
        lda     $2f4b
        bit     #$02
        bne     @4a06       ; return if formation can't appear on the veldt
        ldx     #$0a
@49e9:  lda     $2002,x     ; high byte of monster index
        bne     @4a02       ; skip if monster index >= 256 (can't appear on the veldt)
        lda     $3ed5       ; high byte of battle index
        lsr
        bne     @4a06       ; branch if battle index >= 512 (can't appear on the veldt)
        lda     $3ed4       ; battle index
        jsr     GetBitPtr
        ora     $1ddd,x     ; add to available veldt battles
        sta     $1ddd,x
        bra     @4a06
@4a02:  dex2                ; check next monster
        bpl     @49e9
@4a06:  rts

; ------------------------------------------------------------------------------

; [ learn rages ]

LearnRage:
@4a07:  ldx     #$0a
@4a09:  lda     $2002,x     ; high bit of monster index
        bne     @4a1d       ; skip if monster index > 255 (can't learn rage)
        phx
        clc
        lda     $2001,x     ; monster number
        jsr     GetBitPtr
        ora     $1d2c,x     ; add to known rages
        sta     $1d2c,x
        plx
@4a1d:  dex2                ; next monster
        bpl     @4a09
        rts

; ------------------------------------------------------------------------------

; [ end of battle special event $06: scroll background for final battle ]

BattleEnd_06:
@4a22:  jsr     EndAction
        jsr     _c24903       ; init graphics for end of battle
        jsr     UpdateSRAM
        ldx     #$12
@4a2d:  cpx     #$08
        bcs     @4a65       ; branch if a monster
        lda     $3aa0,x
        lsr
        bcc     @4a54       ; $3aa0.0 branch if character is not present
        lda     $3ee4,x
        bit     #$c2
        bne     @4a54       ; branch if character has zombie, poison, or wound status
        lda     $3205,x
        bit     #$04
        beq     @4a54       ; branch if character has air anchor effect ($3205.2)
        longa
        lda     $3ef8,x     ; status 3 & 4
        and     #$eefe      ; remove dance, rage, and trance status
        sta     $3ef8,x
        shorta
        bra     @4a68
@4a54:  lda     #$ff
        sta     $3ed8,x     ; clear actor
        lda     $3018,x
        trb     $3f2c       ; clear jump/seize characters
        trb     $3f2e       ; clear characters with an esper equipped
        trb     $3f2f       ; clear characters that have used a desperation attack
@4a65:  jsr     FinalBattleClearStatus
@4a68:  dex2                ; next character
        bpl     @4a2d
        lda     #$0c        ; battle graphics $0c (scroll background for final battle)
        jsr     ExecBtlGfx
        pla
        pla
        jmp     RestartBattle

; ------------------------------------------------------------------------------

; [ check final battle progression ]

CheckFinalBattle:
@4a76:  longa
        ldx     #$04
@4a7a:  lda     f:FinalBattleIDTbl,x
        cmp     $11e0
        bne     @4a97
        lda     f:FinalBattleIDTbl+2,x   ; load the next battle
        sta     $11e0
        shorta
        lda     f:FinalBattleScrollTbl,x
        sta     $3ee1
        pla                             ; remove return address from stack
        pla
        bra     BattleEnd_06
@4a97:  dex2
        bpl     @4a7a
        shorta
        rts

; ------------------------------------------------------------------------------

; [ clear all statuses ]

FinalBattleClearStatus:
@4a9e:  stz     $3ee4,x
        stz     $3ee5,x
        stz     $3ef8,x
        stz     $3ef9,x
        rts

; ------------------------------------------------------------------------------

; final battles
FinalBattleIDTbl:
@4aab:  .word   $01d7,$0200,$0201,$0202

; ------------------------------------------------------------------------------

; final battle scrolling data
FinalBattleScrollTbl:
@4ab3:  .byte   $90,$90,$90,$90,$8f,$8f

; ------------------------------------------------------------------------------

; [ update living/dead targets ]

UpdateDead:
@4ab9:  longa
        lda     $2f4c       ; characters/monsters that can't be targetted
        eor     #$ffff      ; invert
        and     $2f4e       ; clear bits in characters/monsters that can be targetted
        sta     $2f4e
        sta     $3a78       ;
        stz     $3a74       ; clear characters/monsters that are alive
        stz     $3a42       ; clear targets that are monsters ???
        shorta

; check characters
        ldx     #$06
@4ad4:  lda     $3aa0,x     ; $3aa0.0 move "target present" flag to carry
        lsr
        lda     $3018,x     ; character mask
        bit     $2f4c
        bne     @4b02       ; skip if character can't be targetted
        bit     $2f4e
        bne     @4af3       ; branch if character can be targetted
        bcc     @4b02       ; skip if character is not present
        tsb     $3a78       ;
        xba
        lda     $3ee4,x     ; status 1
        bit     #$c2
        bne     @4b02       ; skip if wound, petrify, or zombie
        xba
@4af3:  and     $3408       ;
        tsb     $3a74       ; set character as alive
        and     $3a40       ; clear characters acting as enemies
        tsb     $3a42       ; set characters that are monsters
        trb     $3a74       ; clear characters that are alive
@4b02:  dex2                ; next character
        bpl     @4ad4

; check monsters
        ldx     #$0a
@4b08:  lda     $3aa8,x     ; move "target present" flag to carry
        lsr
        lda     $3021,x     ; monster mask
        bit     $2f4d
        bne     @4b32       ; skip if monster can't be targetted
        bit     $2f4f
        bne     @4b2c       ; branch if monster can be targetted
        bcc     @4b32       ; skip if monster is not present
        tsb     $3a79       ;
        bit     $3a3a
        bne     @4b32       ;
        xba
        lda     $3eec,x     ; status 1
        bit     #$c2
        bne     @4b32       ; skip if wound, petrify, or zombie
        xba
@4b2c:  and     $3409       ;
        tsb     $3a75       ; set monster as alive
@4b32:  dex2                ; next monster
        bpl     @4b08
        phx
        php
        lda     $3a74       ; allies that are alive
        jsr     CountBits
        stx     $3a76       ; set number of allies that are alive
        lda     $3a75       ; monsters that are alive
        xba
        lda     $3a42       ; enemy characters that are alive
        longa
        jsr     CountBits
        stx     $3a77       ; set number of enemies that are alive
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ random number (carry) ]

RandCarry:
@4b53:  pha
        jsr     Rand
        lsr
        pla
        rts

; ------------------------------------------------------------------------------

; [ random number (0..255) ]

Rand:
@4b5a:  phx
        inc     $be
        ldx     $be
        lda     f:RNGTbl,x
        plx
        rts

; ------------------------------------------------------------------------------

; [ random number (0..a-1) ]

RandA:
@4b65:  phx
        php
        shortai
        xba
        pha
        inc     $be
        ldx     $be
        lda     f:RNGTbl,x
        jsr     MultAB
        pla
        xba
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ execute counterattack ]

ExecRetal:
@4b7b:  sec
        ror     $3407
        lda     #$01        ; set counterattack flag
        tsb     $b1
        pea     BattleLoop-1       ; push return address (start of main code loop)
@4b86:  lda     $32cd,x
        bmi     @4bf3       ; return if counterattack command list pointer is invalid
        asl
        tay
        jsr     InitPlayerAction
        cmp     #$1f
        bne     @4b9c       ; branch if not command $1f (random attack)
        jsr     RemoveRetal
        jsr     ExecAIRetal
        bra     @4b86
@4b9c:  lda     $32cd,x     ; command list pointer
        tay
        lda     $3184,y     ; command list
        cmp     $32cd,x
        bne     @4baa       ; branch if character/monster has more than one action pending
        lda     #$ff
@4baa:  sta     $32cd,x     ; set new command list pointer
        lda     #$ff
        sta     $3184,y     ; clear old command list slot
        lda     $b5
        cmp     #$1e
        bcs     @4bd5       ; branch if command >= $1e (ai)
        cpx     #$08
        bcs     @4bd5       ; branch if a monster
        lda     $3018,x
        bit     $3a39
        bne     @4be3       ; branch if character has been sneezed away
        bit     $3a40
        bne     @4bd5       ; branch if character is an enemy
        lda     $3a77
        beq     @4be3       ; branch if no enemies are still alive
        lda     $3aa0,x
        bit     #$50
        bne     @4be3       ; branch if $3aa0.4 or $3aa0.6 are set (atb gauge needs to be updated ???)
@4bd5:  lda     $3204,x
        ora     #$04
        sta     $3204,x
        jsr     ExecCmd
        jsr     SaveForMimic
@4be3:  lda     $32cd,x
        inc
        bne     @4bf0       ; branch if command list pointer is still valid (more pending counterattacks)
        lda     $b0
        bmi     @4bf3       ;
        jmp     EndAction
@4bf0:  stx     $3407       ; set currently counterattacking character/monster
@4bf3:  rts

; ------------------------------------------------------------------------------

; [ ai counterattack ]

ExecAIRetal:
@4bf4:  php
        longa
        stz     $3a98
        lda     $3018,x
        trb     $33fc
        beq     @4c52
        trb     $3a56
        bne     @4c28
        lda     $3403
        bmi     @4c11       ; branch if quick target is invalid
        cpx     $3404
        bne     @4c30
@4c11:  lda     $3e60,x     ; status 1 & 2
        bit     #$b000
        bne     @4c30       ; branch if psyche, muddled, or berserk status
        lda     $3e74,x     ; status 3 & 4
        bit     #$0210
        bne     @4c30       ; branch if frozen or stop status
        lda     $3394,x
        bpl     @4c30
        bra     @4c33
@4c28:  lda     $3018,x
        tsb     $33fe
        beq     @4c11
@4c30:  dec     $3a98       ; only execute until the first "wait until next turn", "end if", or "end of script"
@4c33:  lda     $3268,x     ; start of counterattack ai script
        sta     $f0
        lda     $3d20,x     ; ai script loop address (counterattack)
        sta     $f2
        lda     $3241,x     ; ai loop counter
        sta     $f4
        clc
        jsr     ExecAI
        lda     $f2
        sta     $3d20,x     ; update ai script loop address (counterattack)
        shorta
        lda     $f5
        sta     $3241,x     ; update ai loop counter
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
@4c5b:  ldx     #$12        ; loop through all targets
@4c5d:  lda     $3aa0,x     ; $3aa0.0 skip if target is not present
        lsr
        bcc     @4cbe
        lda     $341a       ; skip if counterattacks are disabled
        beq     @4cbe
        stz     $b8         ; clear targets
        stz     $b9
        lda     $32e0,x     ; last character/monster that targetted this target
        bpl     @4c86       ; branch if not waiting to retaliate
        asl
        sta     $ee
        cpx     $ee
        beq     @4c86
        tay
        longa
        lda     $3018,y
        sta     $b8             ; set retaliation target
        lda     $3018,x
        trb     $33fe           ; set retaliation attacker
@4c86:  longa
        lda     $3018,x
        bit     $3a56
        shorta
        bne     @4c9d
        lda     $b1         ; counterattack flag
        lsr
        bcs     @4cbe       ; skip if a counterattack (can't counter a counter)
        lda     $b8
        ora     $b9
        beq     @4cbe       ; branch if there are no retaliation targets
@4c9d:  lda     $3269,x     ; pointer to ai counterattack script
        bmi     @4cb1
        lda     $32cd,x     ; counter queue pointer
        bpl     @4cb1       ; branch if waiting to execute a counter alread
        lda     #$1f
        sta     $3a7a
        jsr     CreateRetalAction
        bra     @4cbe
@4cb1:  cpx     #$08
        bcs     @4cbe       ; skip if a monster
        lda     $11a2       ;
        lsr
        bcc     @4cbe
        jsr     @4cc3
@4cbe:  dex2                ; next character/monster
        bpl     @4c5d
@4cc2:  rts

; check retort and black belt
@4cc3:  lda     $3e4c,x     ; branch if retort flag is not set ($3e4c.0)
        lsr
        bcc     @4cd6
        lda     #$07
        sta     $3a7a
        lda     #$56
        sta     $3a7b
        jmp     CreateRetalAction
@4cd6:  lda     $b9         ; return if attacker was a character
        beq     @4cc2
        cpx     $3416       ; branch if target is not protected by interceptor
        bne     @4cf4
        jsr     Rand
        lsr
        bcc     @4cf4
        lsr
        clr_a
        adc     #$fc
        sta     $3a7b
        lda     #$02
        sta     $3a7a
        jmp     CreateRetalAction
@4cf4:  lda     $3018,x     ; return if not a black belt target
        bit     $3419
        bne     @4cc2
        lda     $3c58,x     ; return if black belt not equipped
        bit     #$02
        beq     @4cc2
        jsr     Rand
        cmp     #$c0
        bcs     @4cc2       ; 3/4 chance to return
        txy
        peaflg  STATUS12, {DEAD, PETRIFY, MAGITEK, ZOMBIE, SLEEP, CONFUSE}
        peaflg  STATUS34, {DANCE, STOP, FROZEN, CHANT, HIDE}
        jsr     CheckStatus
        bcc     @4cc2       ; return if any are set
        stz     $3a7a       ; clear command and attack
        stz     $3a7b
        jmp     CreateRetalAction

; ------------------------------------------------------------------------------

; [ create pending user actions ]

GetPlayerAction:
@4d1f:  ldy     $3a6a       ; pointer to pending user action queue
        lda     $2bae,y     ; character slot
        bmi     @4d6c       ; return if there are no pending actions
        asl
        tax
        jsr     _c24e66       ; add action to advance wait queue
        lda     #$7b        ; should this be #$7d to skip advance wait ???
        jsr     ClearFlag0       ; clear $3aa0.2 and $3aa0.7 (ogre nix can break, battle menu can't open)
        lda     #$ff
        sta     $2bae,y     ; clear queue slot
        tya
        adc     #$08        ; loop through 4 characters
        and     #$18
        sta     $3a6a
        jsr     GetPlayerTargets
        lda     $2bb0,y     ; attack
        xba
        lda     $2baf,y     ; command
        jsr     FixPlayerAttack
        jsr     FixPlayerCmd
        jsr     CreateNormalAction
        lda     $2baf,y
        cmp     #$17
        bne     @4d1f       ; go to next queue slot if not x-magic
        iny3                ; get secondary attack
        jsr     GetPlayerTargets
        lda     $2bb0,y     ; attack
        xba
        lda     #$17        ; x-magic
        jsr     FixPlayerCmd
        jsr     CreateNormalAction
        bra     @4d1f       ; go to next queue slot
@4d6c:  rts

; ------------------------------------------------------------------------------

; [ get targets ]

GetPlayerTargets:
@4d6d:  php
        longa
        lda     $2bb1,y     ; targets
        sta     $b8
        plp
        rts

; ------------------------------------------------------------------------------

; [ fix command ]

FixPlayerCmd:
@4d77:  php
        longa
        sta     $3a7a       ; set command index
        lda     $3ee4,x     ; status 1 and 2
        bit     #$2002      ; return if not muddled or zombie
        beq     @4d87
        stz     $b8         ; clear targets
@4d87:  plp
        rts

; ------------------------------------------------------------------------------

; [ fix attack index ]

FixPlayerAttack:
@4d89:  .a8
        phx
        phy
        txy
        cmp     #$17
        bne     @4d92       ; branch if not x-magic
        lda     #$02
@4d92:  cmp     #$19
        bne     @4da7       ; branch if not summon
        pha
        xba
        cmp     #$ff
        bne     @4d9f
        lda     $3344,y
@4d9f:  xba
        lda     $3018,y
        tsb     $3f2e
        pla
@4da7:  cmp     #$01
        beq     @4daf       ; branch if item
        cmp     #$08
        bne     @4db4       ; branch if not throw
@4daf:  xba
        sta     $32f4,y
        xba
@4db4:  cmp     #$0f
        bne     @4ddb       ; branch if not slot
        pha
        xba
        tax
        lda     f:SlotAttackTbl,x   ; slot spell numbers
        cpx     #$02
        bcs     @4dd2       ; branch if not joker doom
        pha
        lda     f:JokerTargetTbl,x
        sta     $b8,x
        lda     $b8
        eor     $3a40
        sta     $b8
        pla
@4dd2:  cmp     #$ff
        bne     @4dd9       ; branch if not esper
        jsr     RandGenju
@4dd9:  xba
        pla
@4ddb:  cmp     #$13
        bne     @4dec       ; branch if not dance
        pha
        xba
        sta     $32e1,y
        sta     $3a6f
        jsr     RandDance
        xba
        pla
@4dec:  cmp     #$10
        bne     @4dfa       ; branch if not rage
        pha
        xba
        sta     $33a8,y
        jsr     RandRage
        xba
        pla
@4dfa:  cmp     #$0a
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
        sta     $01,s
@4e10:  pla
        xba
        pla
@4e13:  ldx     #$04
@4e15:  cmp     f:CmdWithAttackTbl,x
        bne     @4e26
        xba
        clc
        adc     f:CmdAttackOffsetTbl,x  ; add attack offset
        bcc     @4e25
        lda     #$ee        ; use command $ee on overflow (battle)
@4e25:  xba
@4e26:  dex                 ; check next command
        bpl     @4e15
        pha
        clc
        jsr     GetBitPtr
        and     f:RetargetCmdTbl,x   ; commands that need to retarget
        beq     @4e38       ; branch if no retarget
        stz     $b8         ; clear targets
        stz     $b9
@4e38:  pla
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; commands with attack numbers (summon, lore, magitek, blitz, swdtech)
CmdWithAttackTbl:
@4e3c:  .byte   $19,$0c,$1d,$0a,$07

; attack offset for above commands
CmdAttackOffsetTbl:
@4e41:  .byte   $36,$8b,$83,$5d,$55

; bitmask of commands that need to retarget (swdtech, blitz, rage, leap, dance)
RetargetCmdTbl:
@4e46:  .byte   $80,$04,$0b,$00

; slot spell numbers ($ff is esper)
SlotAttackTbl:
@4e4a:  .byte   $94,$94,$43,$ff,$80,$7f,$81,$fe

; joker doom targetting (all characters or all monsters)
JokerTargetTbl:
@4e52:  .byte   $0f,$3f

; ------------------------------------------------------------------------------

; [ add to action queue ]

; A: pointer to command list (out)

AddToQueue:
@4e54:  phx
        ldx     #$7f
@4e57:  lda     $3184,x     ; command list
        bmi     @4e60
        dex
        bpl     @4e57       ; look for the first empty slot
        inx
@4e60:  txa
        sta     $3184,x     ; set pointer to command list
        plx
        rts

; ------------------------------------------------------------------------------

; [ add action to advance wait queue ]

_c24e66:
_circleinputwrite:
@4e66:  txa
        phx
        ldx     $3a65       ; advance wait queue end
        sta     $3720,x     ; add action
        plx
        inc     $3a65       ; increment advance wait queue end
        lda     #$fe
        jmp     ClearFlag1       ; clear $3aa1.0

; ------------------------------------------------------------------------------

; [ add action to action queue ]

_c24e77:
_circleactionwrite:
@4e77:  txa
        phx
        ldx     $3a67
        sta     $3820,x
        plx
        inc     $3a67
        rts

; ------------------------------------------------------------------------------

; [ add action to counterattack queue ]

; X: character/monster number

_c24e84:
_circlereactionwrite:
@4e84:  txa
        phx
        ldx     $3a69       ; counterattack queue end
        sta     $3920,x     ; add counterattack action
        plx
        inc     $3a69       ; increment counterattack queue end
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
        sta     $3a7a       ; command
        stx     $3a7b       ; attack
        jsr     AddToQueue
        pha
        lda     $340a       ; branch if there's already an immediate action
        cmp     #$ff
        bne     CreateAction
        lda     $01,s       ; set immediate action
        sta     $340a
        bra     CreateAction

; ------------------------------------------------------------------------------

; [ create action (normal or retaliation based on flag) ]

CreateDefaultAction:
@4ead:  lda     $b1         ; counterattack flag
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
        lda     $32cd,x     ; get character/monster's current command list pointer (counterattack)
        cmp     #$ff
        bne     CreateAction       ; branch if there was already a counterattack pending
        jsr     _c24e84       ; add pending action to counterattack queue
        lda     $01,s
        sta     $32cd,x     ; set the character/monster's command list pointer (counterattack)
        bra     CreateAction

; ------------------------------------------------------------------------------

; [ create normal action ]

CreateNormalAction:
@4ecb:  phy
        php
        shorta
        jsr     AddToQueue
        pha                 ; push new command list pointer
        lda     $32cc,x     ; get character/monster's current command list pointer
        cmp     #$ff
        bne     CreateAction       ; branch if there was already an action pending
        lda     $01,s
        sta     $32cc,x     ; set the character/monster's command list pointer to the new pointer

; ------------------------------------------------------------------------------

; [ common code for creating actions ]

CreateAction:
@4edf:  tay
        cmp     $3184,y     ; pending action pointer (or new pointer if none pending)
        beq     @4eec       ; branch if none pending
        lda     $3184,y     ; look for the last pending action
        bmi     @4eec
        bra     @4edf
@4eec:  pla
        sta     $3184,y     ; set the next-to-last pending action to reference the new last action
        asl
        tay
        jsr     GetMPCost
        sta     $3620,y     ; add to mp cost queue
        longa
        lda     $3a7a       ; command/attack
        sta     $3420,y     ; add to command/attack queue
        lda     $b8         ; targets
        sta     $3520,y     ; add to targets queue
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
        trb     $b1
        bne     @4f53
        lda     $3a7a       ; command
        cmp     #$19
        beq     @4f24       ; branch if command is summon
        cmp     #$0c
        beq     @4f24       ; branch if command is lore
        cmp     #$02
        beq     @4f24       ; branch if command is magic
        cmp     #$17
        bne     @4f53       ; return if command is not x-magic
@4f24:  longi
        lda     $3a7b       ; branch if attacker is a monster
        cpx     #$0008
        bcs     @4f47
        phx
        tax
        lda     $3084,x     ; pointer to master spell list
        plx
        cmp     #$ff
        beq     @4f53       ; return if spell is not in list
        longa
        asl2
        adc     $302c,x     ; calculate pointer to character spell list (at $208e)
        tax
        shorta
        lda     a:$0003,x     ; modified mp cost (byte 3)
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

Cmd_23:
_itou:
@4f57:  lda     $b6         ;
        xba
        lda     #$0f        ; battle script command $0f (execute battle event)
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $26: cast spell with no caster ]

Cmd_26:
_selfmagic:
@4f5f:  lda     $b8
        ldx     $b6
        sta     $b6
        cmp     #$0d
        bne     @4f78       ; branch if spell is not $0d (doom)
        lda     $3204,x     ; stop condemned counter
        ora     #$10
        sta     $3204,x
        lda     $3a77
        beq     _4fdf       ; return if there are no enemies alive
        lda     #$0d        ; spell $0d (doom)
@4f78:  xba
        lda     #$02        ; command $02 (magic)
        sta     $b5
        jsr     InitTarget
        jsr     InitAttacker
        lda     #$10
        trb     $b0         ;
        lda     #$02
        sta     $11a3       ;
        lda     #$20
        tsb     $11a4       ;
        stz     $11a5       ; zero mp cost
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $24: show/hide monsters ]

Cmd_24:
_death:
@4f97:  .i8
        stz     $3a2a
        stz     $3a2b
        lda     $3a73
        eor     #$ff
        trb     $b9
        lda     $b8
        asl
        tax
        ldy     #$12
@4faa:  lda     $3019,y
        bit     $b9
        beq     @4fb4
        jsr     (.loword(MonsterDeathTbl),x)
@4fb4:  dey2
        cpy     #$08
        bcs     @4faa
        lda     $b6
        xba
        lda     #$13
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; $04: hide monsters but don't allow battle to end
MonsterDeath_04:
@4fc2:  pha
        lda     #$ff
        sta     $3a95       ; don't allow battle to end
        pla
        bra     MonsterDeath_03

; ------------------------------------------------------------------------------

; $01: hide monsters
MonsterDeath_01:
@4fcb:  tsb     $2f4d       ;
; fall through

; ------------------------------------------------------------------------------

; $03: hide monsters (can still be targetted)
MonsterDeath_03:
death_local:
@4fce:  trb     $3409
        trb     $2f2f
        tsb     $3a2a
        lda     $3ef9,y     ; set hide status
        ora     #$20
        sta     $3ef9,y
_4fdf:  rts

; ------------------------------------------------------------------------------

; $00: revive and restore hp
MonsterDeath_00:
@4fe0:  pha
        longa
        lda     $3c1c,y     ; max hp
        sta     $3bf4,y     ; set current hp to max
        shorta
        pla
; fall through

; ------------------------------------------------------------------------------

; $02: revive monsters at current hp
MonsterDeath_02:
@4fec:  trb     $3a3a       ; clear "monsters that have died/escaped" flag
        tsb     $2f2f       ; set "monsters that are not dead" flag
        tsb     $3a2b       ; battle script command byte 4
        tsb     $2f4f       ; monster can be targetted
        tsb     $3409       ; monster was revived/summoned
        stz     $3a95       ; allow battle to end
        rts

; ------------------------------------------------------------------------------

; $05: hide monsters and set wound status
MonsterDeath_05:
@4fff:  jsr     MonsterDeath_03
        lda     $3ee4,y     ; set wound status
        ora     #$80
        sta     $3ee4,y
        rts

; ------------------------------------------------------------------------------

; [ command $22: enemy roulette / dot damage ]

Cmd_22:
rigene:
@500b:  lda     $3a77
        beq     _4fdf       ; return if no enemies are alive
        lda     $3aa1,y     ; clear $3aa1.4 (target no longer has a pending dot action)
        and     #$ef
        sta     $3aa1,y
        lda     $3aa0,y
        bit     #$10
        bne     _4fdf       ; branch if $3aa0.4 is set
        jsr     _c2298a
        lda     #$90
        trb     $b3
        lda     #$12
        sta     $b5
        lda     #$68
        sta     $11a2
        lsr     $11a4
        lda     $b6
        lsr2
        rol     $11a4
        lsr
        bcc     @5051
        lda     $3e24,y
        sta     $bd
        inc2
        cmp     #$0f
        bcc     @5049
        lda     #$0e
@5049:  sta     $3e24,y
        lda     #$08
        sta     $11a1
@5051:  lda     $3b40,y
        sta     $e8
        longa
        lda     $3c1c,y
        jsr     Mult24
        lsr2
        cmp     #$00fe
        shorta
        bcc     @5069
        lda     #$fc
@5069:  adc     #$02
        sta     $11a6
        tyx
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $20: battle change ]

; +$b8: battle index (restore monsters to full hp/mp if msb set)

Cmd_20:
_scenechange:
@5072:  lda     $b8
        sta     $11e0       ; battle index
        asl     $3a47
        lda     $b9
        eor     #$80        ; invert msb
        asl
        ror     $3a47       ; set $3a47.7 if msb clear
        lsr
        sta     $11e1
        jsr     LoadBattleProp
        longa
        ldx     #$0a
@508d:  stz     $3aa8,x     ; clear monster status flags
        stz     $3e54,x
        clr_a
        dec
        sta     $2001,x     ; clear monster indexes
        lda     #$ffbc
        sta     $320c,x     ; clear monster update flags
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
        lda     $3a75
        sta     $3a2b
        lda     $201e
        sta     $3a2a
        lda     $b6
        xba
        lda     #$12
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $25: display long battle dialog ]

Cmd_25:
_message2:
@50cd:  lda     #$02        ; battle script command $02 (display long battle dialog)
        bra     _50d3

; ------------------------------------------------------------------------------

; [ command $21: display short battle dialog ]

Cmd_21:
_message:
@50d1:  lda     #$10        ; battle script command $10 (display short battle dialog)

message_atmk:
_50d3:  xba
        lda     $b6         ; short battle dialog index
        xba
        stz     $3a2a       ; clear battle script command byte 3
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $27: display scan info ]

Cmd_27:
_ribra:
@50dd:  ldx     $b6
        lda     #$ff        ; battle script command $ff (end of script)
        sta     $2d72
        lda     #$02        ; battle script command $02 (show battle message)
        sta     $2d6e
        stz     $2f36
        stz     $2f37
        stz     $2f3a
        lda     $3b18,x     ; level
        sta     $2f35
        lda     #$34        ; battle message $34 "level <v0>"
        sta     $2d6f
        lda     #$04        ; battle graphics $04 (execute battle script)
        jsr     ExecBtlGfx
        longa
        lda     $3bf4,x     ; current hp
        sta     $2f35
        lda     $3c1c,x     ; max hp
        sta     $2f38
        shorta
        lda     #$30        ; battle message $30 "hp <v0>/<v1>"
        sta     $2d6f
        lda     #$04        ; battle graphics $04 (execute battle script)
        jsr     ExecBtlGfx
        longa
        lda     $3c08,x     ; current mp
        sta     $2f35
        lda     $3c30,x     ; max mp
        sta     $2f38
        shorta
        beq     @5138       ; branch if max mp = 0
        lda     #$31        ; battle message $31 "mp <v0>/<v1>"
        sta     $2d6f
        lda     #$04        ; battle graphics $04 (execute battle script)
        jsr     ExecBtlGfx
@5138:  lda     #$15        ; battle message $15 "weak against fire"
        sta     $2d6f
        lda     $3be0,x     ; set weak elements
        sta     $ee
        lda     $3be1,x     ; clear halved elements
        ora     $3bcc,x     ; clear absorbed elements
        ora     $3bcd,x     ; clear immune elements
        trb     $ee
        lda     #$01
@514f:  bit     $ee
        beq     @515a
        pha
        lda     #$04        ; battle graphics $04 (execute battle script)
        jsr     ExecBtlGfx
        pla
@515a:  inc     $2d6f       ; next element
        asl
        bcc     @514f
        rts

; ------------------------------------------------------------------------------

; [ command $29: stop, reflect, freeze, or psyche counter just word off ]

Cmd_29:
_timer:
@5161:  ldx     $3a7d
        jsr     _c2298a
        lda     #$12
        sta     $b5
        lda     #$10
        trb     $b0
        lsr     $b8
        bcc     @5178
        lda     #$10
        tsb     $11ac
@5178:  lsr     $b8
        bcc     @5181
        lda     #$80
        tsb     $11ac
@5181:  lsr     $b8
        bcc     @518a
        lda     #$02
        tsb     $11ad
@518a:  lsr     $b8
        bcc     @51a0
        lda     #$80
        and     $3ee5,x
        beq     @51a0
        tsb     $11ab
        lda     #$02
        sta     $b5
        lda     #$78
        sta     $b6
@51a0:  lda     #$04
        tsb     $11a4
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [ command $2c: reset character graphical action ]

Cmd_2c:
_cancelinputanima:
@51a8:  lda     $3a7d
        lsr
        xba
        lda     #$0e        ; battle script command $0e (clear character graphical action)
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ command $2d: seize status hp drain ]

Cmd_2d:
_capture:
@51b2:  lda     $3aa1,y     ; clear $3aa1.4 (target no longer has a pending dot action)
        and     #$ef
        sta     $3aa1,y
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
        tsb     $3a46       ; set $3a46.1
        lda     #$80        ; cap drain damage when attacker's hp is full (seize)
        trb     $b2
        lda     #$12        ; command $12 (mimic)
        sta     $b5
        jmp     ExecAttack

; ------------------------------------------------------------------------------

; monster death jump table
MonsterDeathTbl:
@51e4:  .addr   MonsterDeath_00
        .addr   MonsterDeath_01
        .addr   MonsterDeath_02
        .addr   MonsterDeath_03
        .addr   MonsterDeath_04
        .addr   MonsterDeath_05

; ------------------------------------------------------------------------------

; [ get bit number ]

GetBitID:
@51f0:  ldx     #0
@51f2:  lsr
        beq     @51f8
        inx
        bra     @51f2
@51f8:  rts

; ------------------------------------------------------------------------------

; [ get the first valid target in +A ]

; +A: valid targets (bitmask)
; +Y: pointer to target data (out)

BitToTargetID:
@51f9:  phx
        php
        longa
        shorti
        ldx     #$12
@5201:  bit     $3018,x
        bne     @520a
        dex2
        bpl     @5201
@520a:  txy
        plp
        .a8
        plx
        rts

; ------------------------------------------------------------------------------

; [ X = number of bits set in A ]

CountBits:
@520e:  ldx     #0
@5210:  lsr
        bcc     @5214
        inx
@5214:  bne     @5210
        rts

; ------------------------------------------------------------------------------

; [ get bit mask and byte number ]

; A: bit number
; A: bit mask (out)
; X: byte number (out)

GetBitPtr:
@5217:  phy
        pha
        ror
        lsr2
        tax
        pla
        and     #$07
        tay
        lda     #0
        sec
@5224:  rol
        dey
        bpl     @5224
        ply
        rts

; ------------------------------------------------------------------------------

; [ pick a random bit set in A ]

RandBit:
@522a:  phy
        php
        longa
        sta     $ee
        jsr     CountBits
        txa
        beq     @5244
        jsr     RandA
        tax
        sec
        clr_a
@523c:  rol
        bit     $ee
        beq     @523c
        dex
        bpl     @523c
@5244:  plp
        .a8
        ply
        rts

; ------------------------------------------------------------------------------

; [ choose battle type/umaro's attack ]

; X: probability type
; A: allowed bits (bitmask)
; X: battle type/umaro's attack (out)

RandBitWithRate:
@5247:  phy
        xba
        lda     #0
        ldy     #3
@524d:  xba
        asl
        xba
        bcc     @5256       ; branch if battle type is not available
        adc     f:RandBitRateTbl,x
@5256:  sta     $00fc,y
        inx
        dey
        bpl     @524d
        jsr     RandA
        ldx     #4
@5262:  dex
        cmp     $fc,x
        bcs     @5262
        ply
        rts

; ------------------------------------------------------------------------------

RandBitRateTbl:
@5269:  .byte   $9e,$5f,$ff,$ff         ; 0: umaro attack probabilities
        .byte   $5e,$3f,$ff,$5f
        .byte   $5e,$3f,$5f,$ff
        .byte   $3e,$3f,$3f,$3f
        .byte   $1e,$07,$07,$cf         ; 4: battle type probabilities

; ------------------------------------------------------------------------------

; [ update enabled commands ]

UpdateCmdList:
@527d:  phx
        php
        longai
        txy
        lda     f:CmdPropPtrTbl,x
        tax
        shorta
        lda     $3018,y
        tsb     $3a58
        lda     $3ee4,y
        and     #$20
        sta     $ef
        lda     $3ba4,y
        ora     $3ba5,y
        eor     #$ff
        and     #$82
        tsb     $ef
        lda     #$04
        sta     $ee
@52a6:  phx
        sec
        clr_a
        lda     a:$0000,x
        bmi     @52db
        pha
        clc
        lda     $ef
        bit     #$20
        beq     @52c3
        lda     $01,s
        asl
        tax
        lda     f:BattleCmdProp,x   ; battle command data
        bit     #BATTLE_CMD_FLAG::IMP
        bne     @52c3       ; branch if command can be used as imp
        sec
@52c3:  pla
        bcs     @52db
        ldx     #7
@52c9:  cmp     f:UpdateCmdIDTbl,x
        bne     @52d7
        txa
        asl
        tax
        jsr     (.loword(UpdateCmdTbl),x)
        bra     @52db
@52d7:  dex
        bpl     @52c9
        clc
@52db:  plx
        ror     a:$0001,x
        inx3
        dec     $ee
        bne     @52a6
        plp
        plx
        rts

; ------------------------------------------------------------------------------

UpdateCmdIDTbl:
@52e9:  .byte   $03,$0b,$07,$0c,$17,$02,$06,$00

UpdateCmdTbl:
@52f1:  .addr   UpdateCmd_00
        .addr   UpdateCmd_01
        .addr   UpdateCmd_02
        .addr   UpdateCmd_03
        .addr   UpdateCmd_04
        .addr   UpdateCmd_05
        .addr   UpdateCmd_06
        .addr   UpdateCmd_07

; ------------------------------------------------------------------------------

; [ capture, fight ]

UpdateCmd_06:
UpdateCmd_07:
@5301:  lda     $3c58,y
        lsr
        bcc     @5313
        longa_clc
        lda     $03,s
        tax
        shorta
        lda     #$4e
        sta     a:$0002,x
@5313:  rts

; ------------------------------------------------------------------------------

; [ lore, x-magic, magic ]

UpdateCmd_03:
UpdateCmd_04:
UpdateCmd_05:
@5314:  lda     $3ee5,y
        bit     #$08
        beq     @531c
        sec
@531c:  rts

; ------------------------------------------------------------------------------

; [ swdtech ]

UpdateCmd_02:
@531d:  lda     $ef
        lsr2
        rts

; ------------------------------------------------------------------------------

; [ runic ]

UpdateCmd_01:
@5322:  lda     $ef
        asl
        rts

; ------------------------------------------------------------------------------

; [ morph ]

UpdateCmd_00:
@5326:  lda     #$0f
        cmp     $1cf6
        rts

; ------------------------------------------------------------------------------

; [ init character command list ]

; +X: character number x 2

InitCmdList:
@532c:  phx
        php
        longai
        ldy     $3010,x     ; pointer to character data (+$001600)
        lda     f:CmdPropPtrTbl,x   ; pointer to character command list data (+$7e0000)
        sta     f:hWMADDL
        lda     $1616,y     ; +++$fc = battle commands
        sta     $fc
        lda     $1618,y
        sta     $fe
        lda     $1614,y     ; status 1
        shortai
        bit     #$08
        bne     @5354       ; branch if magitek status
        lda     $3ebb
        lsr
        bcc     @539d       ; branch if not magic only (fanatic's tower)
@5354:  lda     $3ed8,x     ; b = actor number
        xba
        ldx     #$03
@535a:  lda     $fc,x       ; a = battle command
        cmp     #$01
        beq     @539a       ; branch if item
        cmp     #$12
        beq     @539a       ; branch if mimic
        xba
        cmp     #$0b
        bne     @5371       ; branch if not gau
        xba
        cmp     #$10
        bne     @5370       ; branch if not rage
        lda     #$00        ; change command to fight
@5370:  xba
@5371:  xba
        cmp     #$00
        bne     @537a       ; branch if command is not fight
        lda     #$1d        ; change command to magitek
        bra     @5380
@537a:  cmp     #$02
        beq     @5380       ; branch if command is magic
        lda     #$ff
@5380:  sta     $fc,x       ; remove command
        lda     $3ebb
        lsr
        bcc     @539a       ; branch if not magic only
        lda     $fc,x
        cmp     #$02
        beq     @5396       ; branch if command is magic
        cmp     #$1d
        bne     @5398       ; branch if command is not magitek
        lda     #$02
        bra     @5398       ; change command to magic
@5396:  lda     #$ff        ; remove command
@5398:  sta     $fc,x
@539a:  dex                 ; next command
        bpl     @535a
@539d:  clr_a
        sta     $f8
        sta     f:hWMADDH     ; clear wram bank
        tay
@53a5:  lda     $00fc,y
        ldx     #$04        ; 5 commands with possible relic updates
        pha
        lda     #$04        ; relic command update flag
        sta     $ee
@53af:  lda     f:RelicCmdTbl1,x   ; commands with relic updates
        cmp     $01,s
        bne     @53c4       ; branch if not that command
        lda     $11d6
        bit     $ee
        beq     @53c4       ; branch if relic not equipped
        lda     f:RelicCmdTbl2,x   ; update command
        sta     $01,s
@53c4:  asl     $ee         ; next command
        dex
        bpl     @53af
        lda     $01,s       ; command number
        ldx     #$05        ; 6 commands with init functions
@53cd:  cmp     f:InitCmdIDTbl,x   ; commands with init functions
        bne     @53db
        txa
        asl
        tax
        jsr     (.loword(InitCmdTbl),x)   ; execute init function
        bra     @53de
@53db:  dex                 ; next command
        bpl     @53cd
@53de:  pla
        sta     f:hWMDATA     ; set command number ($202e)
        sta     f:hWMDATA     ; set command number ($202f)
        asl
        tax
        clr_a
        bcs     @53f0       ; branch if command was removed
        lda     f:BattleCmdProp+1,x   ; battle command data, targetting byte
@53f0:  sta     f:hWMDATA     ; set command data ($2030)
        iny                 ; next command
        cpy     #$04
        bne     @53a5
        lsr     $f8         ; branch if $f8 was set (character has mp)
        bcs     @5408
        lda     $02,s       ; pointer to character data
        tax
        longa
        stz     $3c08,x     ; clear current mp
        stz     $3c30,x     ; clear max mp
@5408:  plp
        .a8
        plx
        rts

; ------------------------------------------------------------------------------

; [ init morph command ]

InitCmd_00:
@540b:  lda     #$04
        bit     $3ebc       ; remove command if morph is not available
        beq     _5434
        bit     $3ebb       ; return if morph is not permanent
        beq     _5438
        lda     $05,s       ; pointer to character data
        tax
        lda     $3de9,x     ; set morph status
        ora     #$08
        sta     $3de9,x
        lda     #$ff
        sta     $1cf6       ; set morph gauge to max
        bra     _5434       ; remove command

; ------------------------------------------------------------------------------

; [ init magic/x-magic command ]

InitCmd_03:
InitCmd_04:
@5429:  lda     $f6
        bne     InitCmd_05
        lda     $f7
        inc
        bne     InitCmd_05
_5432:  bne     _5438
_5434:  lda     #$ff
        sta     $03,s       ; remove command
_5438:  rts

; ------------------------------------------------------------------------------

; [ init dance command ]

InitCmd_02:
@5439:  lda     $1d4c       ; dances known
        bra     _5432

; ------------------------------------------------------------------------------

; [ init leap command ]

InitCmd_01:
@543e:  lda     $11e4       ; on the veldt flag
        bit     #$02
        bra     _5432

; ------------------------------------------------------------------------------

; [ init lore command ]

InitCmd_05:
@5445:  lda     #$01        ; character has mp
        tsb     $f8
        rts

; ------------------------------------------------------------------------------

; pointers to character command list data (+$7e0000)
CmdPropPtrTbl:
@544a:  .word   $202e,$203a,$2046,$2052

; ------------------------------------------------------------------------------

; commands with possible relic updates (steal, slot, sketch, magic, fight)
RelicCmdTbl1:
@5452:  .byte   $05,$0f,$0d,$02,$00

; ------------------------------------------------------------------------------

; relic updated commands (capture, gp rain, control, x-magic, jump)
RelicCmdTbl2:
@5457:  .byte   $06,$18,$0e,$17,$16

; ------------------------------------------------------------------------------

; command init function jump table
InitCmdTbl:
@545c:  .addr   InitCmd_00
        .addr   InitCmd_01
        .addr   InitCmd_02
        .addr   InitCmd_03
        .addr   InitCmd_04
        .addr   InitCmd_05

; $540b,$543e,$5439,$5429,$5429,$5445

; ------------------------------------------------------------------------------

; commands with init functions (morph, leap, dance, magic, x-magic, lore)
InitCmdIDTbl:
@5468:  .byte   $03,$11,$13,$02,$17,$0c

; ------------------------------------------------------------------------------

; [ init battle inventory ]

InitInventory:
@546e:  php
        longai
        ldy     #$2bad      ; start at the end of the item data
        lda     #$0001      ; item quantity = 1 for equipped items
        sta     $2e75
        ldx     #$0006
@547d:  phy
        ldy     $3010,x     ; pointer to character data
        lda     $1620,y     ; equipped shield
        ply
        jsr     CopyItemProp
        dex                 ; next character
        dex
        bpl     @547d
        ldx     #$0006
@548f:  phy
        ldy     $3010,x     ; pointer to character data
        lda     $161f,y     ; equipped weapon
        ply
        jsr     CopyItemProp
        dex                 ; next character
        dex
        bpl     @548f
        ldx     #$00ff      ; loop through 255 items
@54a1:  lda     $1969,x     ; item quantity
        sta     $2e75
        lda     $1869,x     ; item number
        jsr     CopyItemProp
        dex                 ; next item
        bpl     @54a1
        shortai
        clr_ay
@54b4:  lda     $1869,y     ; item number
        cmp     #$a3
        bcc     @54c8       ; branch if less than tools
        sbc     #$a3
        cmp     #$08
        bcs     @54c8       ; branch if not a tool
        tax
        jsr     _c21e57       ; get bit mask
        tsb     $3a9b       ; set tool bit
@54c8:  iny                 ; next item
        bne     @54b4
        plp
        rts

; ------------------------------------------------------------------------------

; [ add item to battle inventory ]

; +Y = pointer to battle inventory (last byte of item)

CopyItemProp:
@54cd:  .a16
        .i16
        phx
        jsr     LoadItemProp
        ldx     #$2e76      ; source = $7e2e72-$7e2e76
        lda     #$0004      ; size = 5 bytes
        mvp     #$7e,#$7e
        plx
        rts

; ------------------------------------------------------------------------------

; [ load item data ]

; A: item number

LoadItemProp:
@54dc:  phx
        php
        longi
        shorta
        pha
        lda     #$80        ; make item unusable
        sta     $2e73
        lda     #$ff
        sta     $2e76       ; clear all equippability flags
        pla
        sta     $2e72       ; item number
        cmp     #$ff
        beq     @5546
        xba
        lda     #$1e
        jsr     MultAB
        tax
        lda     f:ItemProp+14,x   ; targetting
        sta     $2e74
        lda     f:ItemProp,x
        pha
        pha
        asl2
        and     #$80        ; item useable in battle
        trb     $2e73
        pla
        asl
        and     #$20        ; item can be thrown
        tsb     $2e73
        clr_a
        pla
        and     #$07        ; item type
        phx
        tax
        lda     f:ItemTypeMaskTbl,x   ; flags for item type
        plx
        asl
        tsb     $2e73
        bcs     @5546
        longa_clc
        stz     $ee
        lda     f:ItemProp+1,x   ; equippable characters
        ldx     #$0006
@5533:  bit     $3a20,x     ; actor mask
        bne     @5539       ; branch if character can equip this item
        sec
@5539:  rol     $ee         ; set bit in $ee
        dex2                ; next character
        bpl     @5533
        shorta
        lda     $ee
        sta     $2e76       ; set item equippability
@5546:  plp
        .i8
        plx
        rts

; ------------------------------------------------------------------------------

; flags for item types (tool, weapon, armor, shield, helm, relic, item)
ItemTypeMaskTbl:
@5549:  .byte   $a0,$08,$80,$04,$80,$80,$00,$00

; ------------------------------------------------------------------------------

; [ init spells/lores ]

InitSpellList:
@5551:  php
        ldx     #$1a
@5554:  stz     $30ba,x     ; clear espers in master spell list pointer table
        dex
        bpl     @5554
        lda     #$ff
        ldx     #$35
@555e:  sta     $11a0,x     ; clear spell data
        dex
        bpl     @555e
        ldy     #$17
        ldx     #$02
        clr_a
        sec
@556a:  ror
        bcc     @556f
        ror
        dex
@556f:  bit     $1d29,x     ; known lores
        beq     @5584
        inc     $3a87
        pha
        tya
        adc     #$37
        sta     $310f,y
        adc     #$54
        sta     $306a,y
        pla
@5584:  dey
        bpl     @556a
        ldx     #$06
@5589:  lda     $3ed8,x     ; actor index
        cmp     #$0c
        bcs     @55ae       ; branch if character has a spell list
        xba
        lda     #$36
        jsr     MultAB
        longa_clc
        adc     #$1a6e
        sta     $f0         ; pointer to spell list
        shorta
        ldy     #$35
@55a1:  lda     ($f0),y
        cmp     #$ff
        bne     @55ab
        tya
        sta     $3034,y     ; add to master spell list
@55ab:  dey
        bpl     @55a1
@55ae:  dex2
        bpl     @5589
        lda     $1d54       ; spell order
        and     #$07
        tax
        ldy     #$35
@55ba:  lda     $3034,y
        cmp     #$18
        bcs     @55c7
        adc     f:BlackMagicOrderTbl,x
        bra     @55d9
@55c7:  cmp     #$2d
        bcs     @55d1
        adc     f:EffectMagicOrderTbl,x
        bra     @55d9
@55d1:  cmp     #$36
        bcs     @55e0
        adc     f:WhiteMagicOrderTbl,x
@55d9:  phx
        tax
        tya
        sta     $11a0,x
        plx
@55e0:  dey
        bpl     @55ba
        lda     #$ff
        ldx     #$35
@55e7:  sta     $3034,x
        dex
        bpl     @55e7
        clr_axy
@55f0:  lda     $11a0,x
        inc
        bne     @5602
        lda     $11a1,x
        inc
        bne     @5602
        lda     $11a2,x
        inc
        beq     @5617
@5602:  lda     $11a0,x
        sta     $3034,y
        lda     $11a1,x
        sta     $3035,y
        lda     $11a2,x
        sta     $3036,y
        iny3
@5617:  inx3
        cpx     #$36
        bcc     @55f0
        ldx     #$35        ; loop through all spells
@5620:  lda     $3034,x     ; branch if no characters know the spell
        cmp     #$ff
        beq     @562d
        tay                 ; y = spell number
        txa                 ; a = position in master spell list + 1
        inc
        sta     $3084,y     ; set pointer to master spell list
@562d:  dex
        bpl     @5620
        longi
        ldx     #$004d      ; loop through all spells and lores
@5635:  clr_a
        lda     $3034,x     ; branch if no characters know the spell
        cmp     #$ff
        beq     @5688
        pha
        tay
        lda     $3084,y     ; get pointer to master spell list
        longa
        asl2
        shorta
        tay
        lda     $01,s
        cmp     #$8b
        bcc     @5651       ; subtract $8b if a lore
        sbc     #$8b
@5651:  sta     $208e,y     ; add to character spell/lore lists
        sta     $21ca,y
        sta     $2306,y
        sta     $2442,y
        pla
        jsr     _c25723       ; get mp cost and targetting data
        sta     $2090,y     ; targetting data
        sta     $21cc,y
        sta     $2308,y
        sta     $2444,y
        xba
        cpx     #$0044      ; mp cost for step mine
        bne     @567c
        lda     $1864       ; game time / 30
        cmp     #$1e
        lda     $1863
        rol
@567c:  sta     $2091,y     ; set mp cost
        sta     $21cd,y
        sta     $2309,y
        sta     $2445,y
@5688:  dex
        bpl     @5635
        plp
        rts

; ------------------------------------------------------------------------------

; [ validate esper and spell list for a character ]

ValidateSpellList:
@568d:  phx
        php
        longi
        lda     $3c45,x     ; relic effects 2
        sta     $f8
        stz     $f6         ; clear total number of spells
        ldy     $302c,x     ; pointer to spell list
        sty     $f2
        iny3
        sty     $f4         ; pointer to mp cost
        ldy     $3010,x
        lda     $161e,y     ; equipped esper
        sta     $f7
        bmi     @56c7       ; branch if no esper is equipped
        sta     $3344,x
        ldy     $f2
        sta     $0000,y
        clc
        adc     #$36
        jsr     _c25723       ; get mp cost and targetting data
        sta     $0002,y
        sta     $3345,x
        xba
        jsr     CalcMPCost
        sta     $0003,y
@56c7:  clr_ay
        lda     $3ed8,x
        cmp     #CHAR::GOGO
        beq     @56e5       ; branch if character is gogo
        iny2
        bcs     @56e5       ; branch if character doesn't have a spell list
        iny2
        xba
        lda     #$36
        jsr     MultAB
        longa_clc
        adc     #$1a6e
        sta     $f0
        shorta
@56e5:  tyx
        ldy     #$0138
_56e9:  clr_a
        lda     ($f2),y
        cmp     #$ff
        beq     AddToSpellList_01
        cpy     #$00dc
        jmp     (.loword(AddToSpellListTbl),x)

_56f6:  dey4
        bne     _56e9
        plp
        plx
        lda     $f6
        sta     $3cf8,x     ; number of available spells
        rts

; ------------------------------------------------------------------------------

; 2: normal character
AddToSpellList_02:
@5704:  bcs     AddToSpellList_00
        phy
        tay
        lda     ($f0),y
        ply
        inc
        beq     AddToSpellList_00
; fall through

; ------------------------------------------------------------------------------

; 1: character with no spell list
AddToSpellList_01:
@570e:  clr_a
        sta     ($f4),y
        dec
        sta     ($f2),y
        bra     _56f6

; ------------------------------------------------------------------------------

; 0: gogo
AddToSpellList_00:
@5716:  bcs     @571a
        inc     $f6
@571a:  lda     ($f4),y
        jsr     CalcMPCost
        sta     ($f4),y
        bra     _56f6

; ------------------------------------------------------------------------------

; [ get mp cost and targetting data ]

_c25723:
loadsummon:
@5723:  phx
        xba
        lda     #$0e
        jsr     MultAB
        tax
        lda     f:MagicProp+5,x   ; spell mp cost
        xba
        lda     f:MagicProp,x   ; spell targetting
        plx
        rts

; ------------------------------------------------------------------------------

; [ calculate mp cost ]

; $f8: relic effects 2
;   A: original mp cost

CalcMPCost:
@5736:  xba
        lda     $f8
        bit     #$20
        beq     @5741       ; branch if no gold hairpin
        xba
        inc                 ; add one and divide by 2
        lsr
        xba
@5741:  bit     #$40
        beq     @5749       ; branch if no economizer
        xba
        lda     #$01        ; set mp cost to 1
        xba
@5749:  xba
        rts

; ------------------------------------------------------------------------------

; spell list offsets for each magic order

BlackMagicOrderTbl:
@574b:  .byte   $09,$1e,$00,$00,$1e,$15

EffectMagicOrderTbl:
@5751:  .byte   $09,$f1,$00,$09,$e8,$e8

WhiteMagicOrderTbl:
@5757:  .byte   $d3,$d3,$00,$eb,$e8,$00

; ------------------------------------------------------------------------------

AddToSpellListTbl:
@575d:  .addr   AddToSpellList_00
        .addr   AddToSpellList_01
        .addr   AddToSpellList_02

; ------------------------------------------------------------------------------

; [ update enabled spells/espers ]

UpdateEnabledMagic:
        .i8
@5763:  cpx     #$08
        bcs     @57a9       ; return if a monster
        phx
        phy
        php
        lda     $3c09,x     ; current mp (high byte)
        bne     @5775       ; branch if not zero
        lda     $3c08,x
        inc
        bne     @5777       ; branch if character has less than 255 mp left
@5775:  lda     #$ff
@5777:  sta     $3a4c       ; max mp cost
        lda     $3ee4,x     ; status 1
        asl2
        sta     $ef
        longi
        lda     $3018,x     ; character mask
        ldy     $302c,x     ; pointer to character spell list ($208e)
        tyx
        sec
        bit     $3f2e
        bne     @5793       ; branch if character has an esper equipped
        jsr     CheckMagicEnabled
@5793:  ror     a:$0001,x
        ldy     #$004d      ; loop through 78 spells (54 spells + 24 lores)
@5799:  inx4
        jsr     CheckMagicEnabled
        ror     a:$0001,x
        dey
        bpl     @5799
        plp
        ply
        plx
@57a9:  rts

; ------------------------------------------------------------------------------

; [ check if spell is enabled ]

;  a: spell index
; +x: pointer to spell in spell list
;  c: set = disabled, clear = enabled (out)

CheckMagicEnabled:
@57aa:  lda     a:$0000,x     ; first spell in spell list
        bmi     @57b9       ; branch if spell list is empty
        xba
        lda     $ef
        bpl     @57bb       ; branch if character is not an imp
        xba
        cmp     #$23
        beq     @57bb       ; branch if spell is imp (all other spells will be disabled)
@57b9:  sec
        rts
@57bb:  lda     a:$0003,x     ; compare spell's mp cost to character's current mp
        cmp     $3a4c
        rts

; ------------------------------------------------------------------------------

; [ update battle script data ]

; X: attacker index * 2

InitGfxParams:
@57c2:  php
        shortai
        stz     $a0         ; clear flags
        txa
        lsr
        sta     $a1         ; set attacker index
        cmp     #$04
        bcc     @57d1       ; branch if attacker is a character
        ror     $a0         ; attacker is a monster
@57d1:  lda     $b9
        sta     $a3         ; set targets
        sta     $a5         ; set targets hit
        lda     $b8
        sta     $a2
        sta     $a4
        bne     @57e3       ; branch if there is at least one character target
        lda     #$40
        tsb     $a0         ; no character targets
@57e3:  lda     $a0
        asl
        bcc     @57ea       ; branch if attacker is a character
        eor     #$80
@57ea:  bpl     @57f0
        lda     #$02        ; set no friendly targets flag
        tsb     $ba
@57f0:  lda     #$10
        trb     $b0
        bne     @57f8
        tsb     $a0         ; enable pre-magic swirly animation
@57f8:  lda     $3a70
        beq     @580a       ; return if not last attack
        lda     $3a8e
        beq     @580a       ; return if dragon horn is not active
        lda     #$02
        tsb     $a0         ; set dragon horn effect
        lda     #$60
        tsb     $ba         ; random target, can hit dead target (for next attack)
@580a:  plp
        rts

; ------------------------------------------------------------------------------

; [ init skills ]

InitSkills:
@580c:  clr_a
        lda     $1cf7       ; known swdtechs
        jsr     CountBits
        dex
        stx     $2020       ; set number of swdtechs known (for swdtech gauge)
        clr_a
        lda     $1d28       ; known blitzes
        jsr     CountBits
        stx     $3a80       ; set number of known blitzes
        lda     $1d4c       ; known dances
        sta     $ee
        ldx     #$07
@5828:  asl     $ee
        lda     #$ff
        bcc     @582f
        txa
@582f:  sta     $267e,x     ; set known dances
        dex
        bpl     @5828
        longa
        lda     #$257e      ; pointer to known rages
        sta     f:hWMADDL
        shorta
        clr_ayx
        sta     f:hWMADDH
@5847:  bit     #$07
        bne     @5853
        pha
        lda     $1d2c,x     ; known rages
        sta     $ee
        inx
        pla
@5853:  lsr     $ee
        bcc     @585e
        inc     $3a9a       ; increment number of known rages
        sta     f:hWMDATA
@585e:  inc
        cmp     #$ff
        bne     @5847
        rts

; ------------------------------------------------------------------------------

; [ check if status set ]

; status to check pushed to stack (4 bytes)
; carry set: none set (out)
; carry clear: one or more set (out)

CheckStatus:
@5864:  longa_clc
        lda     $3ee4,y     ; check if status is set
        and     $05,s
        bne     @5875       ; branch if any are set
        lda     $3ef8,y
        and     $03,s
        bne     @5875
        sec                 ; set carry if none are set
@5875:  lda     $01,s       ; fix return address
        sta     $05,s
        pla
        pla
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

ChooseTarget:
@587e:  phx
        phy
        php
        shortai
        lda     $bb
        cmp     #$02
        bne     @5895
        lda     $3018,x
        sta     $b8
        lda     $3019,x
        sta     $b9
        bra     @58f6
@5895:  jsr     _c258fa
        lda     $ba
        bit     #$40
        bne     @58b9
        bit     #$08
        bne     @58a5
        jsr     CheckTargetsPresent
@58a5:  lda     $b8
        ora     $b9
        beq     @58b3
        lda     $bb
        bit     #$2c
        beq     @58ed
        bra     @58f6
@58b3:  lda     $ba
        bit     #$04
        bne     @58c8
@58b9:  jsr     Retarget
        jsr     _c258fa
        lda     $ba
        bit     #$08
        bne     @58c8
        jsr     CheckTargetsPresent
@58c8:  jsr     CheckTargetsBattleType
        lda     $ba
        bit     #$20
        beq     @58de
        longa
        lda     $b8
        bne     @58dc
        lda     $3a4e
        sta     $b8
@58dc:  shorta
@58de:  lda     $bb
        bit     #$0c
        bne     @58f6
        bit     #$20
        beq     @58ed
        jsr     RandCarry
        bcs     @58f6
@58ed:  longa
        lda     $b8
        jsr     RandBit
        sta     $b8
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
        trb     $3a46
        bne     @5915       ; return if $3a46.1 is set
        jsr     _c25917
        lda     $ba
        bpl     @590b
        stz     $b8
@590b:  lsr
        bcc     @5915
        longa
        lda     $3018,x
        trb     $b8
@5915:  plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_c25917:
_masktarget2:
@5917:  php
        lda     $2f46       ; characters that are targettable
        xba
        lda     $3403       ; seized targets
        longa
        and     $3a78       ;
        and     $3408       ; targets that were revived/summoned
        and     $b8
        sta     $b8
        lda     $341a
        bpl     @5935       ; branch if counterattacks are disabled ???
        lda     $3f2c       ; remove characters/monsters that are temporarily out of combat
        trb     $b8
@5935:  plp
        rts

; ------------------------------------------------------------------------------

; [  ]

Retarget:
@5937:  .a8
        stz     $b9
        clr_a
        cpx     #$08
        ror
        sta     $b8
        lda     $ba
        bit     #$10
        bne     @5986
        lda     $3395,x
        bmi     @5950
        lda     #$80
        eor     $b8
        sta     $b8
@5950:  lda     $3018,x
        bit     $3a40
        beq     @595e
        lda     #$80
        eor     $b8
        sta     $b8
@595e:  lda     $bb
        and     #$0c
        cmp     #$04
        bne     @596a
        lda     #$40
        tsb     $b8
@596a:  lda     $bb
        and     #$40
        asl
        eor     $b8
        sta     $b8
        lda     $3ee4,x
        lsr2
        bcc     @597e
        lda     #$40
        tsb     $b8
@597e:  lda     $3ee5,x
        asl3
        bcc     @598c
@5986:  lda     #$80
        eor     $b8
        sta     $b8
@598c:  lda     $b8
        asl
        stz     $b8
        bmi     @5995
        bcc     @59a0
@5995:  php
        lda     #$3f
        tsb     $b9
        lda     $3a40
        tsb     $b8
        plp
@59a0:  bmi     @59a4
        bcs     @59ab
@59a4:  lda     #$0f
        eor     $3a40
        tsb     $b8
@59ab:  rts

; ------------------------------------------------------------------------------

; [ target check based on battle type ]

CheckTargetsBattleType:
@59ac:  lda     $ba
        bit     #$10
        beq     @59da
        bit     #$02
        beq     @59d9
        lda     $3ee5,x
        bit     #$20
        bne     @59d9
        jsr     RandCarry
        bcs     @59d9
        phx
        ldx     $3a32
        lda     $2c5f,x
        asl
        tax
        longa
        lda     $3018,x
        bit     $b8
        beq     @59d6
        sta     $b8
@59d6:  shorta
        plx
@59d9:  rts
@59da:  lda     $bb
        and     #$0c
        pha
        bit     #$04
        bne     @5a35
        lda     $201f
        cmp     #$02
        bne     @5a0d
        lda     $2ead
        xba
        lda     $2eac
        cpx     #$08
        bcc     @59fc
        bit     $3019,x
        beq     @5a0b
        bra     @5a0a
@59fc:  bit     $b9
        beq     @5a0d
        xba
        bit     $b9
        beq     @5a0d
        jsr     RandCarry
        bcc     @5a0b
@5a0a:  xba
@5a0b:  trb     $b9
@5a0d:  lda     $201f
        cmp     #$03
        bne     @5a35
        lda     #$0c
        xba
        lda     #$03
        cpx     #$08
        bcs     @5a24
        bit     $3018,x
        beq     @5a33
        bra     @5a32
@5a24:  bit     $b8
        beq     @5a35
        xba
        bit     $b8
        beq     @5a35
        jsr     RandCarry
        bcc     @5a33
@5a32:  xba
@5a33:  trb     $b8
@5a35:  pla
        cmp     #$04
        beq     @5a4c
        lda     $b8
        beq     @5a4c
        lda     $b9
        beq     @5a4c
        jsr     Rand
        phx
        and     #$01
        tax
        stz     $b8,x
        plx
@5a4c:  rts

; ------------------------------------------------------------------------------

; [ remove invalid targets ]

CheckTargetsPresent:
@5a4d:  phx
        php
        longa
        ldx     #$12
@5a53:  lda     $3018,x     ; target mask
        bit     $b8
        beq     @5a7c       ; skip if not in targets
        lda     $3aa0,x
        lsr
        bcc     @5a77       ; branch if $3aa0.0 is clear (target is present)
        lda     #$00c2      ; check for wound, petrify, zombie status (character)
        cpx     #$08
        bcs     @5a6a       ; branch if a monster
        lda     #$0080      ; check wound status only (monster)
@5a6a:  bit     $3ee4,x
        bne     @5a77       ; branch if status is set
        lda     $3ef8,x
        bit     #$2000
        beq     @5a7c
@5a77:  lda     $3018,x
        trb     $b8         ; remove invalid target
@5a7c:  dex2                ; next target
        bpl     @5a53
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ decrement status counters ]

DecCounters:
@5a83:  .a8
        lda     $3a91       ; increment counter for checking status counters
        inc     $3a91
        and     #$0f
        cmp     #$0a
        bcs     @5ae1       ; branch if greater than 10

; frame 0-9 (status counters for each character/monster)
        asl
        tax                             ; otherwise, use it as a character/monster index
        lda     $3aa0,x
        lsr
        bcc     _5ae9                   ; return if $3aa0.0 is clear (target is not present)
        clc
        lda     $3adc,x                 ; slow/normal/haste counter
        adc     $3add,x                 ; add constant (+32/+64/+84)
        sta     $3adc,x
        bcc     _5ae9                   ; return if it didn't overflow
        lda     $3af1,x
        beq     @5ab1                   ; branch if stop counter is 0
        dec     $3af1,x                 ; decrement stop counter
        bne     _5ae9
        lda     #$01                    ; stop just wore off
        bra     _c25b06                 ; decrement reflect, freeze, sleep counters
@5ab1:  lda     $3aa0,x
        bit     #$10
        bne     _5ae9                   ; return if $3aa0.4 is set
        lda     $3b05,x
        cmp     #$02
        bcc     @5ac9                   ; branch if the condemned number is less than 2
        dec
        sta     $3b05,x                 ; decrement the condemned number
        dec
        bne     @5ac9
        jsr     CondemnDeath
@5ac9:  jsr     CheckRunAway
        jsr     _c25b4f
        clr_a                           ; stop did not just wear off
        jsr     _c25b06                 ; decrement reflect, freeze, sleep counters
        inc     $3af0,x                 ; increment dot counter
        lda     $3af0,x
        txy
        and     #$07
        asl
        tax
        jmp     (.loword(StatusCounterTbl),x)

; frame 10-15 (global counters)
@5ae1:  sbc     #$0a
        asl
        tax
        jmp     (.loword(GlobalCounterTbl),x)

; ------------------------------------------------------------------------------

StatusCounter_01:
StatusCounter_03:
StatusCounter_05:
StatusCounter_06:
StatusCounter_07:
@5ae8:  tyx

GlobalCounter_02:
GlobalCounter_03:
GlobalCounter_04:
_5ae9:  rts

; ------------------------------------------------------------------------------

; jump table for damage over time counters
StatusCounterTbl:
@5aea:  .addr   StatusCounter_00
        .addr   StatusCounter_01
        .addr   StatusCounter_02
        .addr   StatusCounter_03
        .addr   StatusCounter_04
        .addr   StatusCounter_05
        .addr   StatusCounter_06
        .addr   StatusCounter_07

; $5b45,$5ae8,$5b3b,$5ae8,$5b45,$5ae8,$5ae8,$5ae8

; jump table for frame 10-15 (enemy roulette, run away, increment battle/character/monster counters)
GlobalCounterTbl:
@5afa:  .addr   GlobalCounter_00
        .addr   GlobalCounter_01
        .addr   GlobalCounter_02
        .addr   GlobalCounter_03
        .addr   GlobalCounter_04
        .addr   GlobalCounter_05

; $5bb2,$5bfc,$5ae9,$5ae9,$5ae9,$5bd0

; ------------------------------------------------------------------------------

; [ decrement reflect, freeze, sleep counters ]

; $b8: ----pfrs (out)
;      p: psyche (sleep) just wore off
;      f: freeze just wore off
;      r: reflect just wore off
;      s: stop just wore off

_c25b06:
timer:
@5b06:  sta     $b8
        lda     $3f0c,x     ; decrement reflect counter
        beq     @5b16
        dec     $3f0c,x
        bne     @5b16
        lda     #$02
        tsb     $b8
@5b16:  lda     $3f0d,x     ; decrement freeze counter
        beq     @5b24
        dec     $3f0d,x
        bne     @5b24
        lda     #$04
        tsb     $b8
@5b24:  lda     $3cf9,x     ; decrement psyche (sleep) counter
        beq     @5b32
        dec     $3cf9,x
        bne     @5b32
        lda     #$08
        tsb     $b8
@5b32:  lda     $b8
        beq     _5ae9       ; return if no counters hit zero
        lda     #$29        ; command $29 (stop, reflect, freeze, or psyche counter just wore off)
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; 2: trigger poison damage (once every 8 frames)
StatusCounter_02:
@5b3b:  tyx
        lda     $3e4c,x     ; set $3e4c.4 (poison counter triggered)
        ora     #$10
        sta     $3e4c,x
        rts

; ------------------------------------------------------------------------------

; 0,4: trigger regen, seize, phantasm damage (twice every 8 frames)
StatusCounter_00:
StatusCounter_04:
@5b45:  tyx
        lda     $3e4c,x     ; set $3e4c.3 (regen/seize/phantasm counter triggered)
        ora     #$08
        sta     $3e4c,x
_5b4e:  rts

; ------------------------------------------------------------------------------

; [ create dot action (poison/regen/seize/phantasm) ]

_c25b4f:
rigenetimer:
@5b4f:  lda     #$10
        bit     $3aa1,x
        bne     _5b4e       ; return if $3aa1.4 is set (character already has a pending dot action)
        lda     $3e4c,x
        bit     #$10
        beq     @5b6b       ; branch if poison counter didn't just trigger ($3e4c.4)
        and     #$ef
        sta     $3e4c,x     ; clear poison trigger ($3e4c.4)
        lda     $3ee4,x
        and     #$04
        beq     _5b4e       ; return if target does not have poison status
        bra     @5b85
@5b6b:  bit     #$08
        beq     @5b92       ; branch if regen/seize/phantasm counter didn't just trigger ($3e4c.3)
        and     #$f7
        sta     $3e4c,x     ; clear regen/seize/phantasm trigger ($3e4c.3)
        lda     $3ee5,x
        ora     $3e4d,x     ; isolate phantasm and seize status
        and     #$40
        bne     @5b85       ; branch if target has phantasm or seize status
        lda     $3ef8,x
        and     #$02
        beq     _5b4e       ; return if target doesn't have regen status
@5b85:  sta     $3a7b
        lda     #$22        ; command $22 (enemy roulette/characters run away ???)
        sta     $3a7a
        jsr     CreateRetalAction
        bra     @5ba9
@5b92:  ldy     $3358,x
        bmi     _5b4e       ; return if seize target is invalid
        longa
        lda     $3018,y     ; bitmask of target
        sta     $b8
        lda     #$002d      ; command $2d (hp drain from seize)
        sta     $3a7a
        shorta
        jsr     CreateRetalAction
@5ba9:  lda     #$10
; fallthrough

SetFlag1:
@5bab:  ora     $3aa1,x     ; set $3aa1.4 (character has a pending dot action)
        sta     $3aa1,x
        rts

; ------------------------------------------------------------------------------

; 10: enemy roulette
GlobalCounter_00:
@5bb2:  lda     $2f43
        bmi     _5b4e       ; return if enemy roulette target is invalid
        longa
        lda     $2f42
        jsr     BitToTargetID
        clr_a
        dec
        sta     $2f42       ; clear enemy roulette target
        shorta
        tyx
; fallthrough

; ------------------------------------------------------------------------------

; [ condemned effect (cast doom) ]

; death:
CondemnDeath:
@5bc7:  lda     #$0d        ; spell $0d (doom)
        sta     $b8
        lda     #$26        ; command $26 (cast spell with no caster)
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; 15: run away
GlobalCounter_05:
@5bd0:  lda     $2f45
        beq     _5c1a       ; return if characters are not trying to run away
        lda     $b1
        bit     #$02
        bne     _5bf1       ;
        lda     $3a91
        and     #$70
        bne     _5c1a       ; return if ... (status counter)
; fallthrough

; ------------------------------------------------------------------------------

; [ create immediate action to run away ]

; create run away action
CreateRunAwayAction:
@5be2:  lda     $2f45
        beq     _5c1a
        lda     $3a38
        beq     _5c1a       ; return if no characters just escaped
        lda     $3a97
        bne     _5c1a       ; return if in colosseum mode
_5bf1:  lda     #$04
        tsb     $b0
        bne     _5c1a       ;
        lda     #$2a        ; command $2a (run)
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; 11: increment battle counter and character/monster timers (every 16 frames)
GlobalCounter_01:
@5bfc:  php
        longa
        inc     $3a44       ; increment battle counter
        ldx     #$12
@5c04:  lda     $3aa0,x
        lsr
        bcc     @5c15       ; branch if $3aa0.0 is clear (target is not present)
        lda     $3ee4,x
        bit     #$00c0
        bne     @5c15
        inc     $3dc0,x     ; increment character/monster timer
@5c15:  dex2
        bpl     @5c04
        plp
_5c1a:  rts

; ------------------------------------------------------------------------------

; [ try to run away ]

CheckRunAway:
@5c1b:  cpx     #$08
        bcs     @5c53        ; return if a monster
        lda     $2f45
        beq     @5c53
        lda     $3a39
        ora     $3a40
        bit     $3018,x
        bne     @5c53
        lda     $3a3b
        bne     @5c3a
        jsr     @5c4d
        jmp     CreateRunAwayAction
@5c3a:  lda     $3d71,x     ; run probability
        jsr     RandA
        inc
        clc
        adc     $3d70,x     ; add to run counter
        sta     $3d70,x
        cmp     $3a3b       ; compare to run difficulty
        bcc     @5c53
@5c4d:  lda     $3018,x
        tsb     $3a38       ; character just ran away
@5c53:  rts

; ------------------------------------------------------------------------------

; [ update gauge values/condemned number in graphics buffer ]

UpdateCounterGfxBuf:
@5c54:  shortai
        ldx     #$06
        ldy     #$03
@5c5a:  lda     $3219,x     ; atb gauge - 1
        dec
        sta     $2022,y     ; update graphics buffer
        lda     $3b04,x
        sta     $2026,y     ; update morph gauge buffer
        lda     $3b05,x
        sta     $202a,y     ; update condemned number buffer
        dex2
        dey
        bpl     @5c5a
        rts

; ------------------------------------------------------------------------------

; [ update monster graphics buffer and run difficulty ]

UpdateMonsterGfxBuf:
@5c73:  longa
        ldy     #$08
@5c77:  clr_a
        sta     $2013,y     ; clear number of monsters alive for each name
        dec
        sta     $200b,y     ; clear monster names
        dey2
        bne     @5c77
        shorta
        lda     #$06
        trb     $b1         ; clear can't run flag and harder to run flag
        lda     $201f
        cmp     #$02
        bne     @5ca4       ; branch if not a pincer attack
        lda     $2eac
        and     $2f2f
        beq     @5ca4
        lda     $2ead
        and     $2f2f
        beq     @5ca4
        lda     #$02
        tsb     $b1
@5ca4:  stz     $3a3b       ; clear run difficulty
        stz     $3eca       ; clear number of different types of monsters
@5caa:  lda     $3aa8,y
        lsr
        bcc     @5d04       ; branch if monster is not present
        lda     $3021,y     ; monster mask
        bit     $3a3a
        bne     @5d04       ; branch if monster died or escaped
        bit     $3409
        beq     @5d04       ; branch if monster was not revived or summoned
        lda     $3eec,y
        bit     #$c2
        bne     @5d04       ; branch if monster has petrify, wound, or zombie status
        lda     $3c88,y     ; ($3c80)
        lsr                 ; set carry if harder to run
        bit     #$04
        beq     @5cd0       ; branch if party can run
        lda     #$06
        tsb     $b1
@5cd0:  clr_a
        rol
        sec
        rol
        asl                 ; a = 2 (6 if monster is harder to run from)
        adc     $3a3b       ; add to run difficulty
        sta     $3a3b
        lda     $3c9d,y
        bit     #$04
        bne     @5d04
        longa
        ldx     #$00
@5ce6:  lda     $200d,x
        bpl     @5cf4
        lda     $3388,y
        sta     $200d,x
        inc     $3eca
@5cf4:  cmp     $3388,y
        bne     @5cfe
        inc     $2015,x
        bra     @5d04
@5cfe:  inx2
        cpx     #$08
        bcc     @5ce6
@5d04:  shorta
        iny2
        cpy     #$0c
        bcc     @5caa
        lda     $201f
        cmp     #$03
        beq     @5d19
        lda     $b0
        bit     #$40
        beq     @5d1c
@5d19:  stz     $3a3b
@5d1c:  lda     $3a42
        beq     @5d25
        lda     #$02
        tsb     $b1
@5d25:  rts

; ------------------------------------------------------------------------------

; [ update character hp/mp/status in graphics buffer ]

UpdateCharGfxBuf:
@5d26:  php
        longa
        shorti
        ldy     #$06
@5d2d:  lda     $3bf4,y     ; current hp
        sta     $2e78,y
        lda     $3c1c,y     ; max hp
        sta     $2e80,y
        lda     $3c08,y     ; current mp
        sta     $2e88,y
        lda     $3c30,y     ; max mp
        sta     $2e90,y
        lda     $3ee4,y     ; status 1 & 2
        sta     $2e98,y
        lda     $3ef8,y     ; status 3 & 4
        sta     $2ea0,y
        dey2
        bpl     @5d2d
        plp
        rts

; ------------------------------------------------------------------------------

; [ update party after victory ]

WinBattle:
@5d57:  .a8
        php
        jsr     EndAction
        ldx     #$06
@5d5d:  stz     $2e99,x     ; clear all status 2 for graphics
        dex2
        bpl     @5d5d
        ldx     #$0b
@5d66:  stz     $2f35,x     ; zero all message variables
        dex
        bpl     @5d66
        lda     #$08        ; battle graphics $08 (victory animation)
        jsr     ExecBtlGfx
        jsr     _c24903       ; init graphics for end of battle
        lda     $3a97
        beq     @5d91       ; branch if not a colosseum battle

; colosseum victory
        lda     #$01        ; item quantity = 1
        sta     $2e75
        lda     $0207       ; variable 0 = item number
        sta     $2f35
        jsr     LoadItemProp
        jsr     _c26279       ; add item to inventory
        lda     #$20        ; battle message $20 "got <i> x 1"
        jsr     ShowMsg
        plp
        rts

; normal victory
@5d91:  longi
        clr_a
        ldx     $3ed4       ; battle index
        cpx     #$0200
        bcs     @5da0       ; branch if >= $0200 (no magic points)
        lda     f:BattleMagicPoints,x   ; $fb = number of magic points gained from battle
@5da0:  sta     $fb
        stz     $f0
        lda     $3ebc       ; $f1 set if morph is available
        and     #$08
        sta     $f1
        longa
        ldx     #$000a
@5db0:  lda     $3eec,x     ; status 1
        bit     #$00c2
        beq     @5dde       ; skip if not zombie, petrify, or wound
        lda     $11e4
        bit     #$0002
        bne     @5dcf       ; branch if on the veldt
        clc
        lda     $3d8c,x     ; monster experience
        adc     $2f35       ; add to variable 0
        sta     $2f35
        bcc     @5dcf
        inc     $2f37       ; high byte of variable 0
@5dcf:  clc
        lda     $3da0,x     ; monster gold
        adc     $2f3e       ; add to variable 3
        sta     $2f3e
        bcc     @5dde
        inc     $2f40       ; high byte of variable 3
@5dde:  dex2                ; next monster
        bpl     @5db0
        lda     $2f35       ; total experience
        sta     $e8
        lda     $2f36
        ldx     $3a76       ; number of allies alive
        phx
        jsr     Div
        sta     $ec         ; +$ec = experience per character
        stx     $e9         ;  $e9 = remainder
        lda     $e8
        plx
        jsr     Div
        sta     $2f35
        lda     $ec
        sta     $2f36
        ora     $2f35
        beq     @5e0e
        lda     #$0027      ; battle message $27 "got <v0> exp. point(s)"
        jsr     ShowMsg
@5e0e:  shorta
        ldy     #$0006
@5e13:  lda     $3018,y     ; character mask
        bit     $3a74
        beq     @5e73       ; skip if character is not alive
        lda     $3c59,y     ; relic effects 4
        and     #$10
        beq     @5e2f       ; branch if cat hood not equipped
        tsb     $f0
        bne     @5e2f
        asl     $2f3e       ; double gold
        rol     $2f3f
        rol     $2f40
@5e2f:  lda     $3ed8,y     ; actor number
        cmp     #CHAR::TERRA
        bne     @5e49       ; branch if not terra
        lda     $f1
        beq     @5e49       ; branch if morph is not available
        tsb     $f0
        lda     $fb         ; number of magic points * 2
        asl
        adc     $1cf6       ; add to morph counter (max $ff)
        bcc     @5e46
        lda     #$ff
@5e46:  sta     $1cf6
@5e49:  ldx     $3010,y     ; character mask
        jsr     AddExp
        lda     $3c59,y     ; relic effects 4
        bit     #$08
        beq     @5e59       ; branch if exp. egg not equipped
        jsr     AddExp
@5e59:  lda     $3ed8,y     ; actor number
        cmp     #CHAR::GOGO
        bcs     @5e73       ; branch if >= $0c (gogo)
        jsr     GetSpellListPtr
        ldx     $3010,y
        phy
        jsr     LearnItemMagic
        lda     $161e,x
        bmi     @5e72       ; branch if no esper equipped
        jsr     LearnGenjuMagic
@5e72:  ply
@5e73:  dey2                ; next character
        bpl     @5e13
        lda     $f1         ;
        and     $f0
        beq     @5e8f
        lda     $fb         ; magic points
        beq     @5e8f       ; branch if no magic points gained
        sta     $2f35       ; set variable 0
        stz     $2f36
        stz     $2f37
        lda     #$35        ; battle message $35 "got <v0> magic point(s)"
        jsr     ShowMsg
@5e8f:  ldy     #$0006
@5e92:  lda     $3018,y     ; character mask
        bit     $3a74       ; skip if character is not alive
        beq     @5eb9
        lda     $3ed8,y     ; actor number
        jsr     GetSpellListPtr
        ldx     $3010,y
        tya
        lsr
        sta     $2f38       ; set variable 1 to character number
        lda     #$2e        ; battle message $2e (<n> gained a level)
        sta     $f2
        jsr     CheckLevelUp
        lda     $3ed8,y
        cmp     #CHAR::GOGO
        bcs     @5eb9       ; branch if actor >= $0c (gogo)
        jsr     ShowLearnedMagicMsg
@5eb9:  dey2                ; next character
        bpl     @5e92
        shorti
        clr_a
        sec
        ldx     #$02
        ldy     #$17
@5ec5:  ror
        bcc     @5eca
        ror
        dex
@5eca:  bit     $3a84,x     ; lores learned this battle
        beq     @5ee2       ; skip if not learned
        pha
        ora     $1d29,x     ; add to known lores
        sta     $1d29,x
        tya
        adc     #ATTACK::CONDEMNED  ; $8b (condemned, first lore)
        sta     $2f35       ; set variable 0
        lda     #$2d        ; battle message $2d "learned <s>"
        jsr     ShowMsg
        pla
@5ee2:  dey                 ; next lore
        bpl     @5ec5
        lda     $300a       ; mog character slot
        bmi     @5f00       ; branch if mog not present
        ldx     $11e2
        lda     f:BattleBGDance,x   ; dance index for each battle background
        bmi     @5f00
        jsr     GetBitPtr
        tsb     $1d4c       ; set in known dances
        bne     @5f00       ; branch if dance was already known
        lda     #$40        ; battle message $40 "mastered a new dance!"
        jsr     ShowMsg
@5f00:  lda     $f0
        lsr
        bcc     @5f0a       ; branch if cursed shield was not dispelled (see c2/6005)
        lda     #$2a        ; battle message $2a "dispelled curse on shield"
        jsr     ShowMsg
@5f0a:  ldx     #$05
@5f0c:  clr_a
        dec
        sta     $f0,x       ; clear items dropped
        stz     $f6,x       ; zero item quantities
        dex
        bpl     @5f0c
        ldy     #$0a
@5f17:  lda     $3eec,y     ; status 1
        bit     #$c2
        beq     @5f4e       ; skip if not wound, petrify, or zombie
        jsr     Rand
        cmp     #$20        ; 1/8 chance to get rare item
        longai
        clr_a
        ror
        adc     $2001,y     ; monster index
        asl
        rol
        tax
        lda     f:MonsterItems+2,x   ; monster items dropped
        shortai
        cmp     #$ff
        beq     @5f4e       ; branch if empty
        ldx     #$05
@5f39:  cmp     $f0,x
        beq     @5f4c       ; branch if one or more of this item was dropped by a different monster
        xba
        lda     $f0,x       ; item number
        inc
        bne     @5f48       ; branch if not empty
        xba
        sta     $f0,x       ; set item number
        bra     @5f4c
@5f48:  xba                 ; next item slot
        dex
        bpl     @5f39
@5f4c:  inc     $f6,x       ; increment quantity
@5f4e:  dey2                ; next monster
        bpl     @5f17
        ldx     #$05
@5f54:  lda     $f0,x       ; dropped item number
        cmp     #$ff
        beq     @5f75       ; branch if empty
        sta     $2f35       ; set variable 0
        jsr     LoadItemProp
        lda     $f6,x       ; quantity
        sta     $2f38       ; set variable 1
        sta     $2e75       ; set item quantity
        jsr     _c26279       ; add item to inventory
        lda     #$20        ; battle message $20 "got <i> x 1"
        dec     $f6,x
        beq     @5f72       ; branch if only 1 was obtained
        inc                 ; change to battle message $21 "got <i> x <v1>"
@5f72:  jsr     ShowMsg
@5f75:  dex                 ; next item
        bpl     @5f54
        lda     $2f3e       ; variable 3 (gp)
        ora     $2f3f
        ora     $2f40
        beq     @5fc5       ; return if no gp was gained
        lda     $2f3e       ; move to variable 1
        sta     $2f38
        lda     $2f3f
        sta     $2f39
        lda     $2f40
        sta     $2f3a
        lda     #$26        ; battle message $26 "got <v1> gp" (no keypress)
        jsr     ShowMsg
        clc
        ldx     #$fd
@5f9d:  lda     $1763,x     ; current gp (++$1860)
        adc     $2e41,x     ; add gained gp (max 9999999)
        sta     $1763,x
        inx
        bne     @5f9d
        ldx     #$02
@5fab:  lda     f:MaxGil,x   ; max gp
        cmp     $1860,x
        beq     @5fc2
        bcs     @5fc5
        ldx     #$02
@5fb8:  lda     f:MaxGil,x   ; max gp
        sta     $1860,x
        dex
        bpl     @5fb8
@5fc2:  dex
        bpl     @5fab
@5fc5:  plp
        rts

; ------------------------------------------------------------------------------

; max gp (9999999)
MaxGil:
@5fc7:  .faraddr 9999999

; ------------------------------------------------------------------------------

.pushseg
.segment "battle_magic_points"

; df/b400
BattleMagicPoints:
        .incbin "battle_magic_points.dat"

.popseg

; ------------------------------------------------------------------------------

; [ display battle message and end battle ]

; A: battle message index ($ff = no message)

LoseBattle:
@5fca:  pha
        lda     #$01
        tsb     $3ebc       ; game over after battle ends
        jsr     _c24903       ; init graphics for end of battle
        pla
; fall through

; ------------------------------------------------------------------------------

; [ display battle message ]

; A: battle message index ($ff = no message)

ShowMsg:
@5fd4:  php
        shorta
        cmp     #$ff
        beq     @5fed       ; branch if no message
        sta     $2d6f
        lda     #$02        ; battle script command $02 (show battle message)
        sta     $2d6e
        lda     #$ff
        sta     $2d72
        lda     #$04        ; battle graphics $04 (execute battle script)
        jsr     ExecBtlGfx
@5fed:  plp
        rts

; ------------------------------------------------------------------------------

; [ update spells taught by items ]

; X: pointer to character data (+$1600)

LearnItemMagic:
        .i16
@5fef:  phx
        ldy     #$0006      ; loop through all equipped items
@5ff3:  lda     $161f,x
        cmp     #$ff
        beq     @6024       ; skip if no item equipped
        cmp     #$66
        bne     @600c       ; branch if not cursed shield
        inc     $3ec0       ; increment cursed shield battle counter
        bne     @600c
        lda     #$01
        tsb     $f0         ; cursed shield dispelled
        lda     #$67
        sta     $161f,x     ; replace with paladin shield
@600c:  xba
        lda     #$1e        ; calculate pointer to item data
        jsr     MultAB
        phx
        phy
        tax
        clr_a
        lda     f:ItemProp+4,x   ; spell taught by item
        tay
        lda     f:ItemProp+3,x   ; spell learn rate
        jsr     IncLearnMagic
        ply
        plx
@6024:  inx
        dey
        bne     @5ff3
        plx
        rts

; ------------------------------------------------------------------------------

; [ update spells taught by espers ]

LearnGenjuMagic:
@602a:  phx
        jsr     GetGenjuPropPtr
        ldy     #$0005
@6031:  clr_a
        lda     f:GenjuProp+1,x   ; spell taught by esper
        cmp     #$ff
        beq     @6044
        phy
        tay
        lda     f:GenjuProp,x   ; spell learn rate
        jsr     IncLearnMagic
        ply
@6044:  inx2
        dey
        bne     @6031
        plx
        rts

; ------------------------------------------------------------------------------

; [ increment spell learn % ]

; A: % to learn
; Y: spell index

IncLearnMagic:
@604b:  beq     _606c       ; return if 0% to learn
        xba
        lda     $fb         ;
        jsr     MultAB
        sta     $ee
        lda     ($f4),y     ; current learned %
        cmp     #$ff
        beq     _606c       ; return if spell is already fully learned
        clc
        adc     $ee         ; add amount to learn
        bcs     @6064       ; branch on overflow (should never happen)
        cmp     #100
        bcc     @6066       ; branch if total is less than 100
@6064:  lda     #$80
@6066:  sta     ($f4),y     ; set msb in learn %
        lda     $f1         ;
        tsb     $f0
_606c:  rts

; ------------------------------------------------------------------------------

; [ check for level up ]

CheckLevelUp:
@606d:  stz     $f8         ; $f8 is the high byte of the calculated experience
        clr_a
        lda     $1608,x     ; level
        cmp     #99
        bcs     _606c       ; return if >= 99
        longa
        asl
        phx
        tax
        clr_a
@607d:  clc
        adc     f:LevelUpExp-2,x   ; character experience progression data
        bcc     @6086
        inc     $f8
@6086:  dex2
        bne     @607d
        plx
        asl                 ; multiply calculated value by 8
        rol     $f8
        asl
        rol     $f8
        asl
        rol     $f8
        sta     $f6         ; ++$f6 = experience needed to level up
        lda     $1612,x     ; current experience (high word)
        cmp     $f7
        shorta
        bcc     _606c       ; return if not enough to level up
        bne     @60a8       ; branch if high word is greater than needed
        lda     $1611,x     ; check low byte
        cmp     $f6
        bcc     _606c       ; return if not enough to level up
@60a8:  lda     $f2
        beq     @60b1       ; branch if no battle message for level up
        stz     $f2
        jsr     ShowMsg
@60b1:  jsr     DoLevelUp
        phx
        lda     $1608,x     ; B: level
        xba
        lda     $1600,x     ; A: actor
        jsr     LearnAbilities
        plx
        bra     CheckLevelUp

; ------------------------------------------------------------------------------

; [ update stats at level up ]

DoLevelUp:
@60c2:  php
        inc     $1608,x     ; increment level
        stz     $fd         ; clear high byte of hp/mp increase
        stz     $ff
        phx
        clr_a
        lda     $1608,x     ; level
        tax
        lda     f:LevelUpMP-2,x   ; character mp progression data
        sta     $fe
        lda     f:LevelUpHP-2,x   ; character hp progression data
        sta     $fc
        plx
        lda     $161e,x     ; equipped esper
        bmi     @60f6       ; branch if no esper equipped
        phy
        phx
        txy
        jsr     GetGenjuPropPtr
        clr_a
        lda     f:GenjuProp+10,x   ; esper level up bonus
        bmi     @60f4       ; branch if no bonus
        asl
        tax
        jsr     (.loword(GenjuBonusTbl),x)
@60f4:  plx
        ply
@60f6:  longa_clc
        lda     $160b,x     ; hp boost
        pha
        and     #$c000
        sta     $ee
        pla
        and     #$3fff      ; max hp
        adc     $fc         ; add increase (max 9999)
        cmp     #10000
        bcc     @610f
        lda     #9999
@610f:  ora     $ee         ; combine with hp boost
        sta     $160b,x     ; set new max hp
        clc
        lda     $160f,x     ; mp boost
        pha
        and     #$c000
        sta     $ee
        pla
        and     #$3fff      ; max mp
        adc     $fe         ; add increase (max 999)
        cmp     #1000
        bcc     @612c
        lda     #999
@612c:  ora     $ee         ; mp boost
        sta     $160f,x     ; set new max mp
        plp
        rts

; ------------------------------------------------------------------------------

; [ display learned spells ]

ShowLearnedMagicMsg:
        .a8
@6133:  phy
        ldy     #$0035
@6137:  lda     ($f4),y     ; spell learn %
        cmp     #$80
        bne     @6149       ; skip if not newly learned
        lda     #$ff
        sta     ($f4),y     ; make spell fully learned
        sty     $2f35       ; variable 0 = spell number
        lda     #$32        ; battle message $32 "<n> learned <s>"
        jsr     ShowMsg
@6149:  dey                 ; next spell
        bpl     @6137
        ply
        rts

; ------------------------------------------------------------------------------

; jump table for esper level up bonus
GenjuBonusTbl:
@614e:  .addr   GenjuBonus_00
        .addr   GenjuBonus_01
        .addr   GenjuBonus_02
        .addr   GenjuBonus_03
        .addr   GenjuBonus_04
        .addr   GenjuBonus_05
        .addr   GenjuBonus_06
        .addr   GenjuBonus_07
        .addr   GenjuBonus_08
        .addr   GenjuBonus_09
        .addr   GenjuBonus_0a
        .addr   GenjuBonus_0b
        .addr   GenjuBonus_0c
        .addr   GenjuBonus_0d
        .addr   GenjuBonus_0e
        .addr   GenjuBonus_0f
        .addr   GenjuBonus_10

; ------------------------------------------------------------------------------

; [ esper bonus $00/$03: +10% hp/mp increase ]

GenjuBonus_00:
GenjuBonus_03:
@6170:  lda     #$1a        ; 26/256 = 10.16%
        bra     _617a

; ------------------------------------------------------------------------------

; [ esper bonus $01/$04: +30% hp/mp increase ]

GenjuBonus_01:
GenjuBonus_04:
@6174:  lda     #$4e        ; 78/256 = 30.47%
        bra     _617a

; ------------------------------------------------------------------------------

; [ esper bonus $02/$05: +50% hp/mp increase ]

GenjuBonus_02:
GenjuBonus_05:
@6178:  lda     #$80        ; 128/256 = 50.00%
_617a:  cpx     #$0006
        ldx     #$0000
        bcc     @6184       ; branch if hp increase
        inx2                ; increment pointer for mp increase
@6184:  xba
        lda     $fc,x
        jsr     MultAB
        xba
        bne     _618e       ; minimum increase is 1
        inc
_618e:  clc
        adc     $fc,x       ; add to hp/mp increase
        sta     $fc,x
        bcc     _6197
        inc     $fd,x
; fallthrough

; ------------------------------------------------------------------------------

; [ esper bonus $07, $08: no effect ]

GenjuBonus_07:
GenjuBonus_08:
_6197:  rts

; ------------------------------------------------------------------------------

; [ esper bonus $09-$10: stat bonuses ]

GenjuBonus_0f:
GenjuBonus_10:
@6198:  iny                 ; mag.pwr ($161d)

GenjuBonus_0d:
GenjuBonus_0e:
@6199:  iny                 ; stamina ($161c)

GenjuBonus_0b:
GenjuBonus_0c:
@619a:  iny                 ; speed ($161b)

GenjuBonus_09:
GenjuBonus_0a:
@619b:  txa                 ; strength ($161a)
        lsr2                ; carry cleared if stat gets +2
        tyx
        lda     $161a,x     ; increment stat (max 128)
        inc
        bcs     @61a6       ; branch if not +2
        inc
@61a6:  cmp     #$81
        bcc     @61ac
        lda     #$80
@61ac:  sta     $161a,x
        rts

; ------------------------------------------------------------------------------

; [ esper bonus $06: +100% hp increase ]

GenjuBonus_06:
@61b0:  clr_ax
        lda     $fc
        bra     _618e

; ------------------------------------------------------------------------------

; [ update natural magic/skills at level up ]

; A: character id
; B: level

LearnAbilities:
@61b6:  ldx     #$0000
        cmp     #CHAR::TERRA
        beq     @61fc                   ; branch if character is terra
        ldx     #$0020
        cmp     #CHAR::CELES
        beq     @61fc                   ; branch if character is celes

; learn swdtech
        ldx     #$0000
        cmp     #CHAR::CYAN
        bne     @61e0                   ; branch if character is not cyan
        jsr     GetAbilityBit
        beq     @6221
        tsb     $1cf7
        bne     @6221
        lda     #$40
        tsb     $f0
        bne     @6221
        lda     #$42                    ; "mastered a new technique!"
        jmp     ShowMsg

; learn blitz
@61e0:  ldx     #$0008
        cmp     #CHAR::SABIN
        bne     @6221                   ; return if character is not sabin
        jsr     GetAbilityBit
        beq     @6221
        tsb     $1d28
        bne     @6221
        lda     #$80
        tsb     $f0
        bne     @6221
        lda     #$33                    ; "devised a new blitz!"
        jmp     ShowMsg

; learn spell
@61fc:  phy
        xba                             ; A: level
        ldy     #$0010                  ; 16 spells for each character
@6201:  cmp     f:NaturalMagic+1,x      ; natural magic data (level)
        bne     @621b
        pha
        phy
        clr_a
        lda     f:NaturalMagic,x        ; natural magic data (spell)
        tay
        lda     ($f4),y
        cmp     #$ff
        beq     @6219                   ; branch if spell is already known
        lda     #$80
        sta     ($f4),y                 ; learn spell
@6219:  ply
        pla
@621b:  inx2                            ; next spell
        dey
        bne     @6201
        ply
@6221:  rts

; ------------------------------------------------------------------------------

; [ check if blitz/swdtech was learned ]

; B: new level
; A: bitmask of learned blitz (out)

GetAbilityBit:
@6222:  lda     #$01
        sta     $ee
        xba
@6227:  cmp     f:BushidoLevelTbl,x   ; blitz/swdtech learn data (level)
        beq     @6232
        inx
        asl     $ee
        bcc     @6227
@6232:  lda     $ee
        rts

; ------------------------------------------------------------------------------

; [ add experience ]

; X: pointer to character data (+$1600)

AddExp:
@6235:  php
        longa_clc
        lda     $2f35       ; experience gained (low word)
        adc     $1611,x     ; add to experience
        sta     $f6
        shorta
        lda     $2f37       ; experience gained (high byte)
        adc     $1613,x     ; add to experience
        sta     $f8
        phx
        ldx     #$0002
@624e:  lda     f:MaxExp,x
        cmp     $f6,x
        beq     @6264       ; branch if equal to max experience
        bcs     @6267       ; branch if less than max experience
        ldx     #$0002
@625b:  lda     f:MaxExp,x
        sta     $f6,x
        dex                 ; check next digit
        bpl     @625b
@6264:  dex
        bpl     @624e
@6267:  plx
        lda     $f8
        sta     $1613,x     ; set new experience (3 bytes)
        longa
        lda     $f6
        sta     $1611,x
        plp
        rts

; ------------------------------------------------------------------------------

; max experience (15,000,000)
MaxExp:
@6276:  .faraddr 15000000

; ------------------------------------------------------------------------------

; [ add item to inventory ]

_c26279:
writeitem:
        .a8
@6279:  lda     #$05        ; battle graphics $05 (add item obtained in battle)
        jsr     ExecBtlGfx
        lda     #$0a        ; battle graphics $0a (update inventory with obtained items)
        jmp     ExecBtlGfx

; ------------------------------------------------------------------------------

; [ calculate pointer to character's spells in SRAM ]

; +$f4 = pointer to spells known (out)

GetSpellListPtr:
@6283:  php
        xba
        lda     #$36
        jsr     MultAB
        longa_clc
        adc     #$1a6e
        sta     $f4
        plp
        rts

; ------------------------------------------------------------------------------

; [ calculate pointer to esper data ]

; A: esper index

GetGenjuPropPtr:
        .a8
@6293:  xba
        lda     #$0b
        jsr     MultAB
        tax
        rts

; ------------------------------------------------------------------------------

; [ add battle script command to queue ]

_c2629b:
_writeanima3_mem_16:
@629b:  sta     $3a28                   ; set gfx script command id

_c2629e:
_writeanima2:
@629e:  pha
        phx
        php
        longa
        shorti
        ldx     $3a72
        lda     $3a28
        sta     $2d6e,x
        lda     $3a2a
        sta     $2d70,x
        inx4                ; increment battle script command queue pointer
        stx     $3a72
        plp
        plx
        pla
        rts

; ------------------------------------------------------------------------------

; [ add battle script command to queue (8-bit access) ]

_c262bf:
_writeanima3_mem_8:
_writeanima4:
@62bf:  php
        longa
        jsr     _c2629b       ; add battle script command to queue
        plp
        rts

; ------------------------------------------------------------------------------

; [ add obtained items to inventory ]

_c262c7:
_writeinhand:
        .a8
@62c7:  ldx     #$06
@62c9:  lda     $3018,x     ; character mask
        trb     $3a8c       ; clear "character obtained an item" flag
        beq     @62ea       ; skip if character didn't obtain an item
        lda     $32f4,x     ; item obtained
        cmp     #$ff
        beq     @62ea       ; skip if empty
        jsr     LoadItemProp
        lda     #$01
        sta     $2e75       ; item quantity = 1
        lda     #$05        ; battle graphics $05 (add item obtained in battle)
        jsr     ExecBtlGfx
        lda     #$ff
        sta     $32f4,x     ; clear item obtained
@62ea:  dex2                ; next character
        bpl     @62c9
        rts

; ------------------------------------------------------------------------------

; [ apply and display damage ]

_c262ef:
_writedamage:
        .a16
@62ef:  phx
        phy
        stz     $f0
        stz     $f2
        ldy     #$12
@62f7:  lda     $33d0,y
        cmp     $33e4,y
        bne     @6302
        inc
        beq     @6345
@6302:  lda     $3018,y
        trb     $3a5a
        jsr     ApplyDmg
        cpy     $3a82
        bne     @6323
        lda     $33d0,y
        inc
        beq     @6323
        sec
        lda     $3a36
        sbc     $33d0,y
        bcs     @6320
        clr_a
@6320:  sta     $3a36
@6323:  lda     $33e4,y
        inc
        beq     @6345
        dec
        ora     #$8000
        sta     $33e4,y
        inc     $f2
        lda     $33d0,y
        inc
        bne     @6345
        dec     $f2
        lda     $33e4,y
        sta     $33d0,y
        clr_a
        dec
        sta     $33e4,y
@6345:  lda     $3018,y
        bit     $3a5a
        beq     @6353
        lda     #$4000
        sta     $33d0,y
@6353:  lda     $33d0,y     ; damage taken
        inc
        beq     @635b
        inc     $f0
@635b:  dey2
        bpl     @62f7
        ldy     $f0
        cpy     #5
        jsr     ShowDmgNumerals
        jsr     ShowDmgNumeralsMulti
        lda     $f2
        beq     @6387
        ldx     #$12
        ldy     #$00
@6371:  lda     $33e4,x     ; coy damage healed to damage taken
        sta     $33d0,x
        inc
        beq     @637b
        iny
@637b:  dex2
        bpl     @6371
        cpy     #5
        jsr     ShowDmgNumerals
        jsr     ShowDmgNumeralsMulti
@6387:  clr_a
        dec
        ldx     #$12
@638b:  sta     $33e4,x     ; invalidate all damage
        sta     $33d0,x
        dex2
        bpl     @638b
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ display damage numerals (less than 5 targets) ]

ShowDmgNumerals:
@6398:  bcs     @63b3
        ldx     #$12
@639c:  lda     $33d0,x
        inc
        beq     @63ae       ; branch if target didn't take damage
        dec
        sta     $3a2a
        txa
        lsr
        xba
        ora     #$000b      ; battle script command $0b (single damage numerals)
        jsr     _c2629b       ; add battle script command to queue
@63ae:  dex2
        bpl     @639c
@63b3:  rts

; ------------------------------------------------------------------------------

; [ display damage numerals (5 or more targets) ]

ShowDmgNumeralsMulti:
@63b4:  bcc     @63da
        php
        shorta
        lda     #$03        ; battle script command $03 (multiple damage numerals)
        jsr     _c2629b       ; add battle script command to queue
        lda     $3a34       ; number of targets
        inc     $3a34
        xba
        lda     #$14
        jsr     MultAB
        longai_clc
        adc     #$2bce
        tay
        ldx     #$33d0
        lda     #$0013
        mvn     #$7e,#$7e     ; copy damage variables to graphics buffer
        plp
@63da:  rts

; ------------------------------------------------------------------------------

; [ copy battle script data to buffer ]

CopyGfxParamsToBuf:
@63db:  phx
        phy
        php
        shorta
        clr_a
        lda     $3a32
        pha
        longai_clc
        adc     #$2c6e
        tay
        ldx     #$00a0
        lda     #$000f
        mvn     #$7e,#$7e
        shortai
        pla
        adc     #$10
        sta     $3a32
        plp
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ clear battle script data buffer ]

ClearGfxParams:
@6400:  phx
        php
        longa
        ldx     #6
@6406:  stz     $a0,x
        stz     $a8,x
        dex2
        bpl     @6406
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ do battle graphics command ]

ExecBtlGfx:
@6411:  phx
        phy
        php
        shorta
        longi_clc
        pha
        clr_a
        pla
        cmp     #$02
        bne     @6425       ; branch if command is not $02 (open battle menu)
        lda     $b1
        bmi     @6429       ; return if battle menu is disabled
        lda     #$02
@6425:  jsl     ExecBtlGfx_ext
@6429:  plp
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ command $2b: misc. monster animations (ai command $fa) ]

Cmd_2b:
@642d:  longa
        lda     $b8
        sta     $3a2a
        shorta
        lda     $b6
        xba
        lda     #$14
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ defeat all monsters immediately (unused) ]

; debug

DebugWin:
@643e:  .i8
        longa
        lda     $1d55       ; font color
        cmp     #$7bde
        shorta
        bne     @6468       ; branch if not (30,30,30)
        lda     f:$004219   ; controller 2
        cmp     #$28
        bne     @6468       ; branch unless select and up are pressed on controller 2
        lda     #$02
        tsb     $3a96       ; make sure it's been pressed for more than one frame ???
        bne     @6468
        lda     #$ff        ; affect all monsters
        sta     $b9
        lda     #$05        ; hide monsters and set wound status
        sta     $b8
        ldx     #$00        ; enter/exit immediately
        lda     #$24        ; command $24 (monster entrance/exit)
        jsr     CreateImmediateAction
@6468:  rts

; ------------------------------------------------------------------------------

.include "ai_script.asm"

; ------------------------------------------------------------------------------

.export BattleMonsters

.segment "battle_prop"

; cf/5900
BattleProp:
        .incbin "battle_prop.dat"

; cf/6200
begin_fixed_block BattleMonsters, $2200
        .incbin "battle_monsters.dat"
end_fixed_block BattleMonsters

; ------------------------------------------------------------------------------

.segment "cond_battle"

; cf/3780
CondBattle:
        .incbin "cond_battle.dat"

; ------------------------------------------------------------------------------

.segment "monster_prop"

; cf/0000
MonsterProp:
        .incbin "monster_prop.dat"

; cf/3000
MonsterItems:
        .include "monster_items.asm"

; ------------------------------------------------------------------------------

.segment "monster_special_anim"

; cf/37c0
MonsterSpecialAnim:
        .incbin "monster_special_anim.dat"

; ------------------------------------------------------------------------------

.segment "monster_attacks"

        .include "monster_control.asm"
        .include "monster_sketch.asm"
        .include "monster_rage.asm"

; ------------------------------------------------------------------------------

.segment "battle_cmd_prop"

; cf/fe00
        .include "battle_cmd_prop.asm"

; ------------------------------------------------------------------------------
