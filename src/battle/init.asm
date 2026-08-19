; ------------------------------------------------------------------------------

; [ init battle ram ]

InitBattle:

@23ed:  php
        longai
        ldx     #sizeof_wInitZeroBlock1 / 2 - 2  ; $3a20-$3ed3 = #$00
@23f3:  stz     near wInitZeroBlock1,x
        stz     near wInitZeroBlock1 + sizeof_wInitZeroBlock1 / 2,x
        dex2
        bpl     @23f3
        clr_a
        dec
        ldx     #sizeof_wInitNullBlock1 / 2 - 2  ; $2000-$341f = #$ff
@2402:  sta     near wInitNullBlock1,x
        sta     near wInitNullBlock1 + sizeof_wInitNullBlock1 / 2,x
        dex2
        bpl     @2402
        stz     near w7e2f44       ; clear invisible monsters (clear status)
        stz     near w7e2f4c       ; clear untargettable characters/monsters
        stz     near w7e2f4e       ; clear targettable characters/monsters
        stz     near w7e2f53       ; clear h-flip for controlled targets (relm) and muddled characters
        stz     zb0         ; clear flags
        stz     zb2

; copy target masks and spell list pointers to WRAM
        ldx     #near TargetMaskTbl
        ldy     #near wTargetMask
        lda     #sizeof_TargetMaskTbl - 1
        mvn     TargetMaskTbl,wTargetMask

; check for final battle
        lda     $11e0       ; battle index
        cmp     #$01d7
        shortai
        bne     @2435       ; branch if not first statue of final battle
        stz     near w7e3ee0       ; disable final battle scrolling

; load global battle switches
@2435:  ldx     #$13
@2437:  lda     $1dc9,x
        sta     near w7e3eb0 + 4,x
        dex
        bpl     @2437

; seed random number generator
        lda     $021e       ; low byte of game time (frames)
        asl2
        sta     zbe         ; set random number seed
        jsr     LoadBattleProp
        jsr     InitParty
        lda     #$80        ;
        trb     near w7e3eb0 + 11
        lda     #$91        ; disable zone eater, time up, game over flags
        trb     near w7e3eb0 + 12
        ldx     #$12
@2459:  jsr     Rand
        sta     near wTargetProp2::w7e3af0,x
        lda     #$bc        ; flags to update character (spell list, condemned counter, command list)
        cpx     near w7e3ee2
        bne     @2468       ; branch if character is not morphed
        ora     #$02        ; update command list (morph/revert)
@2468:  sta     near wTargetProp1::w7e3204,x
        dex2                ; next character/monster
        bpl     @2459
        jsr     InitChars
        lda     $1d4d       ; command setting
        bmi     @247a       ; branch if short
        stz     near w7e2f2e       ; window
@247a:  bit     #$08        ; battle mode
        beq     @2481       ; branch if active
        inc     near w7e3a8f       ; enable wait mode
@2481:  and     #$07        ; battle speed
        asl3
        sta     $ee
        asl
        adc     $ee
        not_a
        sta     near w7e3a90       ; set battle speed constant
        lda     $1d4e       ; gauge setting
        bpl     @2498       ; branch if on
        stz     near wGaugeSetting       ; set atb gauge setting
@2498:  stz     near w7e2f41       ; start battle time
        jsr     InitInventory
        jsr     InitSkills
        jsr     InitMonsters
        jsr     UpdateStatus
        jsr     AfterAction1
        lda     #20
        sta     $11af       ; level 20
        jsr     AfterAction2
        jsr     UpdateDead
        jsr     ChooseBattleType
        jsr     InitStatus
        jsr     InitBattleType
        jsr     InitGauge
        ldx     #$00
        lda     near w7e2f4b
        bit     #$04
        bne     @24ea
        lda     near w7e201f
        cmp     #BATTLE_TYPE::BACK
        bne     @24d5
        ldx     #ATTACK_MSG::BACK_ATTACK
        bra     @24ea
@24d5:  cmp     #$02
        bne     @24dd
        ldx     #ATTACK_MSG::PINCER_ATTACK
        bra     @24ea
@24dd:  cmp     #$03
        bne     @24e3
        ldx     #ATTACK_MSG::SIDE_ATTACK
@24e3:  lda     zb0
        asl
        bpl     @24ea
        ldx     #ATTACK_MSG::PREEMPTIVE_ATTACK
@24ea:  txy
        beq     @24f2
        lda     #ACTION_BATTLE_CMD::ATTACK_MSG
        jsr     CreateImmediateAction
@24f2:  jsr     UpdateMonsterGfxBuf
        jsr     UpdateCounterGfxBuf
        stz     zb8_L
        stz     zb8_H
        ldx     #$06
@24fe:  lda     near wTargetMask,x     ; check for jumping characters
        bit     near w7e3f2c
        beq     @251c
        lda     near wTargetProp2::w7e3aa0,x     ; set $3aa0.3 and $3aa0.5
        ora     #$28
        sta     near wTargetProp2::w7e3aa0,x
        stz     near wTargetProp1::w7e3218_H,x       ; fill ATB gauge
        jsr     _c24e77       ; add action to queue
        lda     #BATTLE_CMD::JUMP
        sta     near w7e3a7a
        jsr     CreateNormalAction
@251c:  dex2                ; next character
        bpl     @24fe

; check final battle scrolling
        lda     near w7e3ee1       ; data byte for final battle scrolling ($90 or $8f)
        inc
        beq     @253f       ; branch if not scrolling, do battle graphics command $00 (init battle graphics)
        dec
        sta     near w7e2d6e::_0 + 1
        lda     #GFX_CMD::CHANGE_BATTLE
        sta     near w7e2d6e::_0
        lda     near w7e3a74_H
        sta     near w7e2d6e::_0 + 3
        lda     #$ff
        sta     near w7e2d6e::_0 + 2
        sta     near w7e2d6e::_1
        lda     #BTL_GFX::GFX_SCRIPT
@253f:  jsr     ExecBtlGfx
        plp
        rts

; ------------------------------------------------------------------------------

; [ init characters ]

InitChars:
_loadplayer:
@2544:  jsr     InitSpellList
        ldx     #6
@2549:  lda     near w7e3ed8,x     ; actor number
        bmi     @2570       ; skip if character slot is empty
        cmp     #$10
        bcs     @2557       ; branch if >= $10 (ghost #1)
        tay
        txa
        sta     near w7e3000,y     ; set actor's character slot
@2557:  lda     near wTargetMask,x
        tsb     near w7e3a8d       ; set characters present
        lda     near w7e3ed8 + 1,x     ; character index
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
@257a:  lda     near wTargetProp2::w7e3aa0,y
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

; start of character/monster loop
@2594:  lda     $f0
        jsr     RandBit
        trb     $f0
        jsr     GetBitNum
        shorta
        txa
        asl3
        sta     $f2
        lda     near wTargetProp1::w7e3218_H,y
        inc
        bne     @25fa
        lda     near w7e3ee1
        inc
        bne     @25fa                   ; branch if scrolling final battle
        ldx     near w7e201f
        lda     near wTargetMask,y
        bit     near w7e3a40
        bne     @25d1                   ; branch if enemy character
        cpy     #$08
        bcs     @25d1                   ; branch if a monster
        lda     zb0
        asl
        bmi     @25fa                   ; branch if pre-emptive attack
        dex
        bmi     @25de                   ; branch if BATTLE_TYPE::NORMAL
        dex2
        beq     @25fa                   ; branch if BATTLE_TYPE::SIDE

; pincer or back attack
        lda     $f2
        bra     @25f3

; monster or enemy character
@25d1:  lda     zb0
        asl
        bmi     @25da                   ; branch if pre-emptive attack
        cpx     #BATTLE_TYPE::SIDE
        bne     @25de
@25da:  lda     #$01
        bra     @25f3
@25de:  lda     near wTargetProp2::Speed,y
        jsr     RandA
        adc     near wTargetProp2::Speed,y
        bcs     @25f1
        adc     $f2
        bcs     @25f1
        adc     $f3
        bcc     @25f3
@25f1:  lda     #$ff
@25f3:  inc
        bne     @25f7
        dec
@25f7:  sta     near wTargetProp1::w7e3218_H,y
@25fa:  longa
        dey2
        bpl     @2594
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; character masks
TargetMaskTbl:
        .word   %0000000000000001       ; character target masks
        .word   %0000000000000010
        .word   %0000000000000100
        .word   %0000000000001000
        .word   %0000000100000000       ; monster target masks
        .word   %0000001000000000
        .word   %0000010000000000
        .word   %0000100000000000
        .word   %0001000000000000
        .word   %0010000000000000
        .addr   wSpellList::_0          ; pointers to spell lists
        .addr   wSpellList::_1
        .addr   wSpellList::_2
        .addr   wSpellList::_3
        calc_size TargetMaskTbl

; ------------------------------------------------------------------------------

; [ clear battle data ]

InitRAM:
_initkernel2:
@261e:  clr_a
        ldx     #sizeof_wInitZeroBlock2 - 1
@2621:  sta     near wInitZeroBlock2,x     ; $3ee4-$3f43 = #$00
        dex
        bpl     @2621
        dec
        ldx     #sizeof_wInitNullBlock2 - 1
@262a:  sta     near wInitNullBlock2,x     ; $3ed4-$3ee3 = #$ff
        dex
        bpl     @262a
        lda     #BATTLE_CMD::MIMIC
        sta     near w7e3f28       ; set previous attack to mimic
        sta     near w7e3f24
        rts

; ------------------------------------------------------------------------------

; [ init graphics script ]

InitGfxScript:
_initanima:
@2639:  php
        stz     near w7e3a72       ; clear battle script command queue pointer
        stz     near w7e3a70       ; clear number of attacks (0 = 1 attack)
        longa
        stz     near w7e3a32       ; clear pointer to battle script data
        stz     near w7e3a34       ; clear counter for damage variables
        stz     near w7e3a30       ; clear targets
        stz     near w7e3a4e       ; clear backup targets
        plp
        rts

; ------------------------------------------------------------------------------

; [ update death/poison immunity ]

; change death status immunity into instant death protection
; change poison element resistance into poison status immunity

_initstatus3:
FixImmuneStatus:
        .a8
@2650:  lda     near wTargetProp2::w7e3aa1,x     ; clear $3aa1.2 (instant death protection)
        and     #<~$04
        xba
        lda     near wTargetProp1::ImmuneStatus1,x
        bmi     @2661       ; branch if not immune to dead status
        ora     #STATUS1::DEAD
        xba
        ora     #$04
        xba
@2661:  xba
        sta     near wTargetProp2::w7e3aa1,x     ; set $3aa1.2 (instant death protection)
        lda     near wTargetProp2::ElemNull,x
        bit     #ELEMENT::POISON
        beq     @2670       ; branch if not immune to poison element
        xba
        and     #<~STATUS1::POISON
        xba
@2670:  xba
        sta     near wTargetProp1::ImmuneStatus1,x     ; set immune to poison status
        rts

; ------------------------------------------------------------------------------

; [ update status immunity ]

UpdateImmuneStatus:
_initstatus2:
@2675:  lda     near wTargetProp1::ImmuneStatus4,x                 ; blocked status 4
        xba
        lda     near wTargetProp2::EquipStatus23_H,x
        lsr
        bcc     @2683                   ; branch if no float
        xba
        and     #<~STATUS4::FLOAT
        xba

; check permanent morph
@2683:  lda     near w7e3eb0 + 11                   ; permanent morph
        bit     #$04
        beq     @268e
        xba
        and     #<~STATUS4::MORPH
        xba
@268e:  xba
        sta     near wTargetProp1::ImmuneStatus4,x

; block both regen and sap if immune to either
        lda     near wTargetProp1::ImmuneStatus3,x
        xba
        lda     near wTargetProp1::ImmuneStatus2,x
        longa
        sta     $ee
        lda     near wTargetProp2::EquipStatus23,x
        clrflg  STATUS23, {DANCE, STOP, SLEEP, CONDEMNED, NEAR_FATAL, IMAGE}
        not_a
        and     $ee
        bit     #STATUS23::REGEN
        beq     @26b2
        bit     #STATUS23::SAP
        bne     @26b5
@26b2:  clrflg  STATUS23, {SAP, REGEN}
@26b5:  shorta
        sta     near wTargetProp1::ImmuneStatus2,x

; block both slow and haste if immune to either
        xba
        bit     #STATUS3::SLOW
        beq     @26c3
        bit     #STATUS3::HASTE
        bne     @26c5
@26c3:  clrflg  STATUS3, {SLOW, HASTE}
@26c5:  sta     near wTargetProp1::ImmuneStatus3,x
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
