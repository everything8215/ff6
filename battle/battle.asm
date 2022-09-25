
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: battle.asm                                                           |
; |                                                                            |
; | description: battle program                                                |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.include "battle_data.asm"

.import CharProp, ItemProp

.export Battle_ext, UpdateBattleTime_ext
.export UpdateEquip_ext, CalcMagicEffect_ext

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
        rtl
@000c:  ; php
        shortai
        lda     #$7e
        pha
        plb
        jsr     $261e                   ; clear battle data
        jsr     $23ed                   ; init battle ram

; start of main battle loop
@0019:  inc     $be                     ; increment random number
        lda     $3402                   ; decrement quick counter
        bne     @0023
        dec     $3402
@0023:  lda     #$01
        jsr     $6411                   ; do battle graphics command $01 (wait for vblank)
        jsr     $2095                   ; update character battle stats
        lda     $3a58                   ; branch if no menus need to be updated
        beq     @0033
        jsr     $00cc                   ; update menus
@0033:  lda     $340a                   ; immediate action
        cmp     #$ff
        beq     @003d
        jmp     $2163                   ; execute immediate action
@003d:  lda     #$04
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
@005f:  jmp     $4b7b                   ; execute counterattack

;
@0062:  lda     $3a3a
        and     $2f2f
        beq     @006f
        trb     $2f2f
        bra     @0019
@006f:  lda     #$20
        trb     $b0
        beq     @007d
        jsr     $5c73                   ; update run difficulty
        lda     #$06
        jsr     $6411                   ; do battle graphics command $06 (update monster names)
@007d:  lda     #$04
        trb     $b0
        jsr     $47ed                   ; check if battle is over
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
        jmp     $2188                   ; execute advance wait action

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

@00c5:  lda     #$09
        jsr     $6411       ; do battle graphics command $09 (fade out and terminate battle)
        plp
        rtl

; ------------------------------------------------------------------------------

; [ update menus ]

_commandwrite:
@00cc:  ldx     #$06
@00ce:  lda     $3018,x     ; character mask
        trb     $3a58       ; disable menu update for character
        beq     @00df       ; skip if menu doesn't need to be updated
        stx     $10
        lsr     $10
        lda     #$0b        ; graphics command $0b (update menu)
        jsr     $6411       ; do battle graphics command
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
        jmp     $4e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ execute action ]

; called when an action reaches the top of the queue
; x = pointer to character/monster data

ExecAction:
@00f9:  sec
        ror     $3406       ;
        pea     $0018       ; push return address to stack (start of main loop)
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
        jsr     $01d9       ;
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
@0134:  jsr     $0634       ; choose monster confused attack
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
        jmp     $5bab
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
        jsr     $13d3       ; execute command
        jsr     $021e       ; update mimic data
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

; something with mimic

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
        beq     _01d8
        longa
        lda     $3f24
        sta     $3a7a
        lda     $3f26
        sta     $b8
        shorta
        lda     #$40
        tsb     $b1
        jmp     $4ecb       ; create normal action

; ------------------------------------------------------------------------------

; [ update mimic data ]

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
        lda     $cffe00,x   ; return if command can't be mimicked
        bit     #$02
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
        lda     #$04
        jmp     $6411       ; do battle graphics command $04 (execute battle script)

; ------------------------------------------------------------------------------

; [ init queued action ]

; carry set = ???, carry clear = ???
; a = command (out)

InitPlayerAction:
_loadinputcommand:
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
        lda     f:$cffe00,x   ; battle command data
        plx
        bit     #$04
        bne     @02da       ; return if command can't be used by imp
        stz     $3a4c       ; clear mp cost
        phx
        tdc
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
        jsr     $522a       ; pick a random bit set in a
        sta     $b8         ; random target
        shorta
        plx
@02da:  pla
        rts

; ------------------------------------------------------------------------------

; [ execute ai ]

ExecMonsterAction:
_readaction:
@02dc:  longa
        stz     $3a98
        lda     $3254,x
        sta     $f0
        lda     $3d0c,x
        sta     $f2
        lda     $3240,x
        sta     $f4
        clc
        jsr     $1a2f       ; execute ai script
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

CreateAction:
_actioninstall:
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
        jmp     $4ecb       ; create normal action

; random character action
@0344:  lda     $3018,x     ; character mask
        trb     $3a4a       ; clear in targets with changed status
        lda     $3255,x
        bmi     @0352       ; branch if ai pointer is not valid
        jmp     ExecMonsterAction

; no ai script
@0352:  lda     $32cc,x     ; command list pointer
        bmi     @037b       ; branch if no pending actions
@0357:  pha
        asl
        tay
        longa
        lda     $3520,y
        sta     $b8
        lda     $3420,y
        jsr     $03e4       ; set advance wait timer
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
        bcs     RandRiotAction
        lda     $3ee4,x     ; status 1
        bit     #$08
        bne     RandMagitekAction
        jsr     $0420       ; select berserk/zombie/muddled/charmed/colosseum command
        cmp     #$17
        bne     @03b0       ; branch if not x-magic
        pha
        xba
        pha
        pha
        txy
        jsr     $051a       ;
        sta     $01,s
        pla
        xba
        lda     #$02
        jsr     $03e4       ; set advance wait timer
        jsr     $4ecb       ; create normal action
        stz     $b8
        stz     $b9
        pla
        xba
        pla
@03b0:  jsr     FixRoulette
        jsr     $03e4       ; set advance wait timer
        jmp     $4ecb       ; create normal action

; ------------------------------------------------------------------------------

; [ correct roulette command index ]

FixRoulette:
_changeroulette:
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
@03c6:  jsr     $0584
        xba
        lda     #$1d
        bra     _03de

; random rage
RandRiotAction:
@03ce:  txy
        jsr     RandRiot
        xba
        lda     #$10
        bra     _03de

; random dance
RandDanceAction:
@03d7:  txy
        jsr     $059c
        xba
        lda     #$13
_03de:  jsr     $03e4       ; set advance wait timer
        jmp     $4ecb       ; create normal action

; ------------------------------------------------------------------------------

; [ set advance wait timer ]

_autotarget:
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
        lda     $c2067b,x   ; advance wait duration for command
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
        jsr     $26d3       ; init attack based on command
        lda     #$04
        trb     $ba         ; clear "no retarget if target becomes invalid" flag
        longa
        lda     $b8         ;
        bne     @041e
        stz     $3a4e
        jsr     $587e       ;
@041e:  plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ select berserk/zombie/muddled/charmed/colosseum action ]

; a = command (out)
; b = attack (out)

workcommand:
@0420:  txa
        xba
        lda     #$06
        jsr     $4781       ; multiply a * b
        tay
        stz     $fe
        stz     $ff
        lda     $202e,y     ; $f6 = command 1
        sta     $f6
        lda     $2031,y     ; $f8 = command 2
        sta     $f8
        lda     $2034,y     ; $fa = command 3
        sta     $fa
        lda     $2037,y     ; $fc = command 4
        sta     $fc
        lda     #$05
        sta     $f5
        lda     $3ee5,x     ; status 2
        asl2
        sta     $f4
        asl
        bpl     @0452       ; branch if berserk
        stz     $f4
        bra     @045e
@0452:  lda     $3395,x     ; charm attacker
        eor     #$80
        tsb     $f4
        lda     $3a97       ; colosseum characters
        tsb     $f4
@045e:  txy
        phx
        ldx     #$06        ; loop through each attack
@0462:  phx
        lda     $f6,x       ; command
        pha
        bmi     @0482       ; skip if command slot is empty
        clc
        jsr     $5217       ; get bit mask and byte number
        and     $c204d0,x   ; bitmask of muddled/charmed/colosseum commands
        beq     @0482
        lda     $f4
        bmi     @0488       ; branch if not berserk
        lda     $01,s       ; command
        clc
        jsr     $5217       ; get bit mask and byte number
        and     $c204d4,x   ; bitmask of berserk/zombie commands
        bne     @0488
@0482:  lda     #$ff        ; clear command
        sta     $01,s
        dec     $f5         ; decrement number of available commands
@0488:  tdc
        lda     $01,s       ; command
        ldx     #$08
@048d:  cmp     $c204d8,x   ; commands with special code when used randomly
        bne     @0499
        jsr     ($04e2,x)   ; execute special code
        xba
        bra     @04a9
@0499:  cmp     $c204d9,x
        bne     @04a5
        jsr     ($04ec,x)
        xba
        bra     @04a9
@04a5:  dex2                ; next command
        bpl     @048d
@04a9:  pla
        plx
        sta     $f6,x       ; command
        xba
        sta     $f7,x       ; attack
        dex2
        bpl     @0462
        lda     $f5
        jsr     $4b65       ; random number (0..a-1)
        tay
        ldx     #$08
@04bc:  lda     $f6,x       ; command
        bmi     @04c3       ; skip if not valid
        dey
        bmi     @04ca       ; branch if this is the randomly selected command
@04c3:  dex2
        bpl     @04bc
        tdc
        bra     @04ce
@04ca:  xba
        lda     $f7,x       ; a = command, b = attack
        xba
@04ce:  plx
        rts

; ------------------------------------------------------------------------------

; bitmask of muddled/charmed/colosseum commands:
;  fight, magic, morph, steal, capture, swdtech
;  tools, blitz, runic, lore, sketch
;  rage, mimic, dance, row, jump, x-magic
;  gp rain, health, shock, magitek
@04d0:        .byte     $ed, $3e, $dd, $2d

; bitmask of berserk/zombie commands:
;  fight, capture, rage, jump, magitek
@04d4:        .byte     $41, $00, $41, $20

; commands with special code when used randomly
@04d8:        .byte     $02, $17, $07, $0a, $10, $13, $0c, $03, $1d, $09

; command special code jump pointers
@04e2:        .word     $051a, $0560, $05d1, $04f6, $0584
              .word     $051a, $0575, $059c, $0557, $058d

; ------------------------------------------------------------------------------

; [ lore command (random) ]

RandLore:
blue_local:
@04f6:  lda     $3ee5,y
        bit     #$08
        bne     RandCmdInvalid
        lda     $3a87
        beq     RandCmdInvalid
        pha
        longac
        lda     $302c,y
        adc     #$00d8
        sta     $ee
        shorta
        pla
        xba
        lda     #$60
        jsr     $0534
        clc
        adc     #$8b        ; condemned (first lore)
        rts

; ------------------------------------------------------------------------------

; [ magic/x-magic command (random) ]

RandMagic:
magic_local:
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
@0534:  phx
        phy
        tay
        xba
        jsr     $4b65       ; random number (0..a-1)
        tax
@053c:  lda     ($ee),y
        cmp     #$ff
        beq     @0545
        dex
        bmi     @054c
@0545:  dey4
        bne     @053c
        tdc
@054c:  ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ command invalid ]

RandCmdInvalid:
notuse:
_054f:  dec     $f5
        lda     #$ff
        sta     $03,s
        tdc
        rts

; ------------------------------------------------------------------------------

; [ morph command (random) ]

RandMorph:
trans_local:
@0557:  lda     #$0f
        cmp     $1cf6       ; morph counter
        tdc
        bcs     RandCmdInvalid
        rts

; ------------------------------------------------------------------------------

; [ swdtech command (random) ]

RandBushido:
sword_local:
@0560:  lda     $3ba4,y
        ora     $3ba5,y
        bit     #$02
        beq     RandCmdInvalid
        lda     $2020
        inc
        jsr     $4b65       ; random number (0..a-1)
        clc
        adc     #$55        ; dispatch (first swdtech)
        rts

; ------------------------------------------------------------------------------

; [ blitz command (random) ]

RandBlitz:
skill_local:
@0575:  tdc
        lda     $1d28       ; known blitzes
        jsr     $522a       ; pick a random bit set in a
        jsr     $51f0       ; get bit number
        txa
        clc
        adc     #$5d        ; pummel (first blitz)
        rts

; ------------------------------------------------------------------------------

; [ magitek command (random) ]

RandMagitek:
armor:
@0584:  lda     #$03
        jsr     $4b65       ; random number (0..2)
        clc
        adc     #$83        ; fire beam (first magitek)
        rts

; ------------------------------------------------------------------------------

; [ tools command (random) ]

RandTools:
machine_local:
@058d:  tdc
        lda     $3a9b       ; tools owned
        jsr     $522a       ; pick a random bit set in a
        jsr     $51f0       ; get bit number
        txa
        clc
        adc     #$a3        ; noiseblaster item (first tool)
        rts

; ------------------------------------------------------------------------------

; [ dance command (random) ]

RandDance:
_setdanceno:
@059c:  phx
        lda     $32e1,y
        cmp     #$ff
        bne     @05b2
        tdc
        lda     $1d4c       ; known dances
        jsr     $522a       ; pick a random bit set in a
        jsr     $51f0       ; get bit number
        txa
        sta     $32e1,y
@05b2:  asl2
        sta     $ee
        jsr     $4b5a       ; random number (0..255)
        ldx     #$02
@05bb:  cmp     f:DanceRateTbl,x
        bcs     @05c3
        inc     $ee
@05c3:  dex
        bpl     @05bb
        ldx     $ee
        lda     $cffe80,x   ; dance data
        plx
        rts

; dance attack probabilities (7/16, 3/8, 1/8, 1/16)
tabledance:
DanceRateTbl:
@05ce:        .byte     $10, $30, $90

; ------------------------------------------------------------------------------

; [ rage command (random) ]

RandRiot:
_setriotno:
@05d1:  phx
        php
        tdc
        sta     $33a9,y
        lda     $33a8,y
        cmp     #$ff
        bne     @0600
        inc
        sta     $33a8,y
        lda     $3a9a
        jsr     $4b65       ; random number (0..a-1)
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
@0600:  jsr     $4b53       ; random number (carry)
        longai
        rol                 ; 1/2 chance first or second attack will be chosen
        tax
        shorta
        lda     $cf4600,x   ; monster rage attacks
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

; something with rage

_setriot:
@0610:  php
        lda     $33a8,y
        tax
        xba
        lda     $cf37c0,x
        sta     $3c81,y
        lda     #$20
        jsr     $4781       ; multiply a * b
        longi
        tax
        lda     $cf001a,x
        sta     $3ca8,y
        sta     $3ca9,y
        jsr     $2dc1       ; init monster/rage data
        plp
        rts

; ------------------------------------------------------------------------------

; [ choose monster confused attack ]

_monconfu:
@0634:  phx
        longai
        lda     $1ff9,x     ; monster id (actually $2001)
        asl2
        tax
        lda     $cf3d00,x   ; monster control/muddled attacks
        sta     $f0
        lda     $cf3d02,x
        sta     $f2
        shortai
        stz     $ee
        jsr     $4b5a       ; random number (0..255)
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
        jsr     $1dbf
        jsr     $03e4       ; set advance wait timer
        jmp     $4ecb       ; create normal action

; ------------------------------------------------------------------------------

; advance wait durations for each command
@067b:  .byte     $10, $10, $20, $00, $00, $10, $10, $10, $10, $10, $10, $10, $20, $10, $10, $10
        .byte     $10, $10, $10, $10, $10, $10, $e0, $20, $10, $10, $20, $20, $10, $10, $00, $00

; ------------------------------------------------------------------------------

; [ update special status (seize, control, love token, etc.) ]

AfterAction1:
_afteraction1:
@069b:  ldx     #$12
@069d:  lda     $3aa0,x
        lsr
        bcc     @0700       ; $3aa0.0 branch if target is not present
        longa
        lda     $3018,x
        bit     $2f4e
        shorta
        bne     @0700       ; branch if target can't be targetted
        jsr     $07ad       ; update control status
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
        jsr     $07c8       ; update zinger, love token, charm status
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
        jsr     $0728       ; remove wound status (jumping/seized/zombie target)
@06f1:  lda     $3ee4,x
        bpl     @0700       ; branch if target does not have wound status
        lda     $3ef9,x
        bit     #$04
        beq     @0700       ; branch if target doesn't have life 3 status
        jsr     ReraiseEffect
@0700:  dex2                ; next target
        bpl     @069d
        ldx     #$12
@0706:  jsr     $0739       ; remove control status (target)
        dex2
        bpl     @0706
        jmp     $5d26       ; update character hp/mp/status in graphics buffer

; ------------------------------------------------------------------------------

; [ make jumping/seized character die when they land ]

CheckJump:
jumpcheck:
@0710:  longa
        lda     $3018,x
        bit     $3f2c       ; jump/seize targets
        shorta
        beq     @0727       ; return if not jump/seize
        jsr     $0728       ; remove wound status (jumping/seized/zombie target)
        lda     $3205,x     ; set air anchor effect ($3205.2)
        and     #$fb
        sta     $3205,x
@0727:  rts

; ------------------------------------------------------------------------------

; [ remove wound status (jumping/seized/zombie target) ]

canceldeath:
@0728:  lda     $3ee4,x     ; remove wound status
        and     #$7f
        sta     $3ee4,x
        lda     $3204,x     ; don't remove all advance wait actions
        and     #$bf
        sta     $3204,x
        rts

; ------------------------------------------------------------------------------

; [ remove control status (target) ]

_removemanage:
@0739:  lda     $32b9,x     ; target controlling you
        cmp     #$ff
        beq     @0748       ; branch if not valid
        bpl     @0748       ; branch if msb set ???
        and     #$7f
        tay
        jsr     $075b       ;
@0748:  lda     $32b8,x     ; target you control
        cmp     #$ff
        beq     @075a       ; branch if not valid
        bpl     @075a       ; branch if msb set ???
        and     #$7f
        phx
        txy
        tax
        jsr     $075b       ; remove control status (attacker)
        plx
@075a:  rts

; ------------------------------------------------------------------------------

; [ remove control status (attacker) ]

manage_sub:
@075b:  lda     $3e4d,y     ; don't use control battle menu ($3e4d.0)
        and     #$fe
        sta     $3e4d,y
        lda     $3ef9,y     ; clear trance status
        and     #$ef
        sta     $3ef9,y
        lda     #$ff
        sta     $32b9,x     ; clear target controlling you (target)
        sta     $32b8,y     ; clear target you control (attacker)
        lda     $3019,x
        trb     $2f54       ; clear horizontal flip for targets being controlled
        phx
        jsr     $0783       ; update seize status (target)
        tyx
        jsr     $0783       ; update seize status (attacker)
        plx
        rts

; ------------------------------------------------------------------------------

; [ update seize status ]

manage_sub_sub:
@0783:  lda     #$40
        jsr     $5bab       ; set $3aa1.6 pending seize action
        lda     $3204,x
        ora     #$40
        sta     $3204,x     ; remove all advance wait actions
        lda     #$7f

_andflag0x16:
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
        jmp     $4e91       ; create immediate action

; ------------------------------------------------------------------------------

; [ update control status ]

ValidateManip:
rmanage:
@07ad:  pea     $b0c2       ; check psyche, muddled, berserk, wound, petrify, rage, frozen, stop, dance status
        pea     $0311
        txy
        jsr     $5864       ; check if status set
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

UpdateDead:
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
        jsr     $4e91       ; create immediate action
        lda     #$02        ; entrance effects b1 $02 (revive monsters at current hp)
        sta     $b8
        ldx     #$08        ; entrance effects b0 $08 (fade in/out, top to bottom)
        lda     #$24        ; command $24 (monster entrance/exit)
        jsr     $4e91       ; create immediate action
        lda     #$ff
        sta     $33f8
        sta     $33f9
        plx
@07f5:  lda     $336c,x     ; love token target
        bmi     @07fe       ; branch if a monster
        tay
        jsr     $082d       ; clear love token target/attacker
@07fe:  lda     $336d,x     ; love token attacker
        bmi     @080a       ;
        phx
        txy
        tax
        jsr     $082d
        plx
@080a:  lda     $3394,x
        bmi     @0813
        tay
        jsr     $0836
@0813:  lda     $3395,x
        bmi     _081f
        phx
        txy
        tax
        jsr     $0836
        plx

RemoveQuick:
_removequick:
_081f:  cpx     $3404
        bne     @082c
        lda     #$ff
        sta     $3404
        sta     $3402
@082c:  rts

; ------------------------------------------------------------------------------

; [ clear love token status ]

RemoveLoveToken:
removelove:
@082d:  lda     #$ff
        sta     $336c,x     ; clear love token target/attacker
        sta     $336d,y
        rts

; ------------------------------------------------------------------------------

; [ clear charm status ]

RemoveCharm:
removerevolt:
@0836:  lda     #$ff
        sta     $3394,x     ; clear charm target/attacker
        sta     $3395,y
        rts

; ------------------------------------------------------------------------------

; [ update targets after each command ]

AfterAction2:
_afteraction2:
@083f:  ldx     #$12        ; loop through all characters/monsters
@0841:  lda     $3aa0,x
        lsr
        bcc     @08be       ; skip if $3aa0.0 is clear (target is not present)
        asl     $32e0,x
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
        jsr     $5763       ; update enabled spells/espers
@086f:  asl     $3204,x
        bcc     @087c
        jsr     RemoveAllActions
        lda     #$80
        jsr     $5bab       ; set $3aa1.7
@087c:  asl     $3204,x
        bcc     @0884
        jsr     StartCondemned
@0884:  asl     $3204,x
        bcc     @088c
        jsr     StopCondemned
@088c:  asl     $3204,x
        bcc     @0898
        cpx     #$08        ; skip if a monster
        bcs     @0898
        jsr     $527d       ; update enabled commands
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
@08bb:  jsr     CheckNearFatalRelic
@08be:  dex2                ; next character/monster
        jpl     @0841
        ; bmi     _08c5
        ; jmp     @0841
_08c5:  rts

; ------------------------------------------------------------------------------

; [ add pending action to queue ]

_c208c6:
_countercheck:
@08c6:  lda     #$50
        jsr     $11b4       ; set $3aa0.4 and $3aa0.6
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
        jsr     $0792       ; clear $3aa0.4
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
        jsr     $0792       ; clear $3aa0.6
        lda     $3aa1,x
        bpl     _08c5       ; return if $3aa1.7 clear
        and     #$7f
        sta     $3aa1,x     ; clear $3aa1.7
        lda     $32cc,x     ; command list pointer
        inc
        beq     _08c5       ; return if there are no pending actions in the command list
        lda     $3aa1,x
        lsr
        bcc     @091c       ; branch if $3aa1.0 is clear (pending action goes directly to action queue)
        jmp     $4e77       ; add action to queue
@091c:  jmp     $4e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ add pending advance wait action to queue ]

CheckPlayerAction:
_inputcheck:
@091f:  cpx     #$08
        bcs     _08c5                   ; return if a monster
        lda     $3ed8,x
        cmp     #$0d
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
        jsr     $11b4                   ; set bits in $3aa0
        lda     $3018,x
        bit     $2f4c
        bne     CancelAction            ; try to add action to advance wait queue if character can't be targetted (zinger etc.)
        lda     $3359,x
        and     $3395,x
        bpl     CancelAction            ; try to add action to advance wait queue if seize or charm attacker is valid
        pea     $b0c2                   ; wound, petrify, zombie, psyche, muddled, berserk
        pea     $2101                   ; dance, hide, rage
        txy
        jsr     $5864
        bcc     CancelAction            ; try to add action to advance wait queue if status set
        lda     $3aa0,x
        bpl     _09cd                   ; return if $3aa0.7 is clear (battle menu will not open)
        lda     $32cc,x                 ; command list pointer
        bpl     _09cd                   ; return if character/monster has an action pending
        lda     $3aa0,x
        ora     #$08
        sta     $3aa0,x                 ; set $3aa0.3 (stop atb gauge)
        jmp     $11ef                   ; open battle menu

; ------------------------------------------------------------------------------

; [ add pending run/control/psyche/seize action to advance wait queue ]

DisableATB:
_gaugedisable:
@0977:  longa
        lda     #$bfd3
        jsr     $0792       ; clear $3aa0.2, $3aa0.3, $3aa0.5, $3aa1.6
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
        jsr     $4e66       ; add action to advance wait queue
@09a3:  xba
        jsr     $0792       ; clear flags in $3aa0
        cpx     #$08
        bcs     _09cd       ; return if a monster
        txa
        lsr
        sta     $10         ; character index
        lda     #$03
        jmp     $6411       ; do battle graphics command $03 (close battle menu)

; ------------------------------------------------------------------------------

; [ start condemned counter ]

StartCondemned:
@09b4:  lda     $11af       ; attacker level
        jsr     $4b65       ; random number (0..a-1)
        clc
        adc     $11af       ; a = level + (0..level-1)
        sta     $ee
        sec
        lda     #60         ; subtract from 60 (min 0)
        sbc     $ee
        bcs     @09c8
        tdc
@09c8:  adc     #20
        sta     $3b05,x     ; set condemned number
_09cd:  rts

; ------------------------------------------------------------------------------

; [ stop condemned counter ]

StopCondemned:
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
        jsr     $4781       ; b = (speed + 20) * (255 - (battle_speed * 24)) / 255 for monsters
@0a00:  pla                 ; b = (speed + 20) for characters
        jsr     $4781       ; multiply b * (haste/normal/slow constant * 1.5)
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
        jsr     $0792       ; clear $3aa0.2, $3aa0.3, $3aa0.5
@0a38:  cpx     #$08        ; return if not a character
        bcs     _0a49
        lda     #$2c        ; action $2c (set character graphical action to 0)
        jmp     $4e91       ; create immediate action

; ------------------------------------------------------------------------------

; [ clear def. status ]

ClearDef:
_removeprotection:
@0a41:  lda     #$fd
        and     $3aa1,x     ; clear $3aa1.1
        sta     $3aa1,x
_0a49:  rts

; ------------------------------------------------------------------------------

; [ update near-fatal relic effects ]

CheckNearFatalRelic:
_dyingaction:
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
        jsr     $4e91       ; create immediate action
        pla
@0a74:  lsr
        bcc     @0a82       ; branch unless mithril glove or czarina ring equipped (casts safe)
        pha
        lda     #$1c        ; attack $1c (safe)
        sta     $b8
        lda     #$26        ; action $26 (spell with no caster)
        jsr     $4e91       ; create immediate action
        pla
@0a82:  lsr
        bcc     @0a90       ; branch unless ??? equipped (casts rflect)
        pha
        lda     #$24        ; attack $24 (rflect)
        sta     $b8
        lda     #$26        ; action $26 (spell with no caster)
        jsr     $4e91       ; create immediate action
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
        jsr     $11b4       ; set $3aa0.3 and $3aa0.7 (atb gauge full, battle menu can open)
@0ab7:  phx
        lda     $3ef9,x     ; carry = inverse of morph status
        eor     #$08
        lsr4
        php
        tdc
        adc     #$03
        sta     $ee         ; $ee = 3 if morphed, 4 if not morphed
        txa
        xba
        lda     #$06
        jsr     $4781       ; multiply a * b
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
        jsr     $527d       ; update enabled commands
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
        tdc
        longa
        dec
        sta     $3f30       ; morph counter
        ldx     $1cf6       ; sram morph counter
        jsr     $4792       ; divide +a / x
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
        jsr     $4781       ; multiply a * b
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

CalcDmg:
_calcdamage:
@0b83:  php
        shorta
        lda     $11a6
        bne     @0b8e
        jmp     @0c2b       ; return if power = 0
@0b8e:  lda     $11a4
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
        jsr     $362f       ; save previous attacker
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
        cmp     #$2710
        bcc     @0c98       ; branch if less than 10,000
@0c95:  lda     #$270f      ; cap at 9999
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
        bne     @0cb0       ; branch if damage modification is enabled
        jmp     @0d3b
@0cb0:  jsr     $4b5a       ; random number (0..255)
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
        jsr     $370b
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
        jsr     $47b7       ; +a *= $e8 / 256
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
        tdc
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
        tdc
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

; [ +a = $e8 * (+a / 16) ]

.a16

CalcRatio:
@0dcb:  jsr     $47b7       ; +a *= $e8 / 256
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
@0e21:  jsr     $4b5a       ; random number (0..255)
        cmp     #$10
        bcs     @0e2c
        lda     #$04        ; 1/16 chance to cause poison status
        bra     SetStatus0
@0e2c:  cmp     #$20
        bcs     _0e20
        lda     #$01        ; 1/16 chance to cause dark status
; fallthrough

; ------------------------------------------------------------------------------

; [ set bit in status 0 ]

SetStatus0:
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
        jsr     $4781       ; a = (current hp + 1) * level
        ldx     $3c1d,y     ; x = max hp (hi byte) + 1
        inx
        jsr     $4792       ; $e8 = [(current hp + 1) * level] / [max hp (hi byte) + 1]
        sta     $e8
        longa
        lda     $f0         ; original damage
        jsr     $47b7       ; a = original damage * [(current hp + 1) * level] / [max hp (hi byte) + 1] / 256
        lda     #5
        jsr     LsrA
        inc
        sta     $f0         ; set calculated damage
        cmp     #$01f5
        bcc     @0e73       ; branch if less than 501
        ldx     #$5b
        cmp     #$03e9
        bcc     @0e6e       ; branch if less than 1001
        inx
@0e6e:  stx     $b7         ; set atma weapon length ($5b or $5c -> $626a)
        jsr     $35bb
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
        jsr     Mult8
        longi
        tax
        lda     $15db,x                 ; actor number
        xba
        lda     #$16
        jsr     Mult8
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
        and     #$03
        eor     #$03
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
        tdc
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

.a8

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
@0f98:  tdc                 ; no boost
        rts

; ------------------------------------------------------------------------------

; [ update equipped item effects ]

; A: item number

CalcEquipEffect:
@0f9a:  phx
        phy
        xba
        lda     #$1e                    ; multiply by 30 to get pointer to item data
        jsr     Mult8
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
        eor     #$20                    ; toggle imp status
@1029:  bit     #$20
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
@1086:  tdc
        lda     f:ItemProp+27,x         ; block animation
        sta     $11be,y
        bit     #$0c
        beq     @10b0                   ; branch if item can't block
        pha
        and     #$03                    ; block graphic
        tax
        tdc
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
@10b2:  tdc
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

UpdateBattleTime:
@111b:  rtl

; ------------------------------------------------------------------------------

CalcMagicEffect:
@4730:  rtl

; ------------------------------------------------------------------------------

; [ multiply a * b ]

Mult8:
@4781:  php
        longa
        sta     f:hWRMPYA
        nop4
        lda     f:hRDMPYL
        plp
        .a8
        rts

; ------------------------------------------------------------------------------
