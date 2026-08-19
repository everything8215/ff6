; ------------------------------------------------------------------------------

; [ execute ai script ]

ExecAI:
@1a2f:  phx
        php
        lda     zb8
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
        sta     near w7e3a2e
        lda     f:AIScript,x
        sta     near w7e3a2c
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ ai script command $fd: wait until end of turn ]

        array_label AI_CMD, AI_CMD::WAIT
@1a74:  longa
        lda     $f0
        sta     $f2
        rts
        .a8

; ------------------------------------------------------------------------------

; [ ai script command $fe/$ff: end if/end of script ]

        array_label AI_CMD, AI_CMD::END_IF
        array_label AI_CMD, AI_CMD::END_SCRIPT
@1a7b:  lda     #$ff
        sta     $f5
        rts

; ------------------------------------------------------------------------------

; [ choose random ai data byte ]

AIRand3:
@1a80:  lda     #$03
        jsr     RandA
        tax
        lda     near w7e3a2d,x     ; random ai data byte (0..2)
        cmp     #$fe
        bne     _1a42
        pla                 ; return if not nothing
        pla
        bra     DoNextAICmd

; ------------------------------------------------------------------------------

; [ ai script command $fc: conditional ]

        array_label AI_CMD, AI_CMD::AI_COND
@1a91:  lda     near w7e3a2d
        asl
        tax
        jsr     (near AICondTbl,x)
        bcs     DoNextAICmd

AICondFailed:
@1a9b:  longai
        lda     $fe
        sta     $fc
        shorta
        ldx     $f0
        jsr     FindAIScriptEnd
        inc
        beq     array_item AI_CMD, AI_CMD::END_IF
        stx     $f0
        inc     $f5
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

ExecAICmd:
@1aaf:  lda     near w7e3a98                   ; copy "unresponsive" indicator
        sta     $f8
; fallthrough

; ------------------------------------------------------------------------------

; [ next ai command ]

DoNextAICmd:
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
        lda     near w7e3a2c       ; ai script command
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

; conditional fails if the monster is "unresponsive" and the conditional block
; did not include a valid condition: if_self_dead, if_monsters_dead, or if_always
        lda     $f8
        beq     @1af5

; if the next command is not an action, keep checking for a valid condition
        lda     near w7e3a2c
        cmp     #$fc
        bcc     AICondFailed

@1af5:  ldy     $f6         ; y = pointer to character/monster data in ram
        lda     near w7e3a2c
        cmp     #$f0
        bcc     _1b25       ; branch if ai command < $f0 (single attack)
        and     #$0f
        asl
        tax
        jmp     (near AICmdTbl,x)

; ------------------------------------------------------------------------------

; [ ai script command $f6: use/throw item ]

; b0: 0 = use, 1 = throw
; b1: item 1 (2/3 chance)
; b2: item 2 (1/3 chance)

        array_label AI_CMD, AI_CMD::ITEM
@1b05:  lda     #BATTLE_CMD::ITEM
        xba
        lda     near w7e3a2d
        beq     @1b10       ; branch if using item (not throwing)
        lda     #BATTLE_CMD::THROW
        xba
@1b10:  lda     near w7e3a2e       ; copy first item to double its likelihood of being chosen
        sta     near w7e3a2d
        jsr     AIRand3
        xba
        bra     _1b28

; ------------------------------------------------------------------------------

; [ ai script command $f4: do command ]

; b0: command 1 (1/3 chance)
; b1: command 2 (1/3 chance)
; b2: command 3 (1/3 chance)

        array_label AI_CMD, AI_CMD::BATTLE_CMD
@1b1c:  clr_a                           ; clear attack index (this shouldn't be used anyway)
        jsr     AIRand3
        bra     _1b28

; ------------------------------------------------------------------------------

; [ ai script command $f0: use attack ]

; b0: attack 1 (1/3 chance)
; b1: attack 2 (1/3 chance)
; b2: attack 3 (1/3 chance)

        array_label AI_CMD, AI_CMD::ATTACK
@1b22:  jsr     AIRand3
_1b25:  jsr     GetCmdForAI

; use ai attack/command
_1b28:  tyx
        longa
        pha
        lda     $fc
        sta     zb8
        lda     near wTargetProp3::w7e3ee4,x     ; current status 1,2
        bit     #STATUS12::CONFUSE
        beq     @1b3a       ; branch if not muddled
        stz     zb8         ; clear targets
@1b3a:  pla
        jsr     FixRoulette
        jsr     CalcCmdDelay
        jsr     CreateDefaultAction
        jmp     DoNextAICmd

; ------------------------------------------------------------------------------

; [ ai script command $f1: targetting ]

        array_label AI_CMD, AI_CMD::SET_TARGET
@1b47:  lda     near w7e3a2d
        clc
        jsr     CheckAITarget
        longa
        lda     zb8
        sta     $fc
        jmp     DoNextAICmd
        .a8

; ------------------------------------------------------------------------------

; [ ai script command $f5: monster death/entry ]

        array_label AI_CMD, AI_CMD::MONSTER_ENTRY_EXIT
@1b57:  lda     near w7e3a2f
        bne     @1b62
        lda     near wTargetMask + 1,y                 ; target self
        sta     near w7e3a2f
@1b62:  lda     #ACTION_BATTLE_CMD::MONSTER_ENTRY_EXIT
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f3: display short battle dialog ]

        array_label AI_CMD, AI_CMD::MONSTER_DLG
@1b66:  lda     #ACTION_BATTLE_CMD::MONSTER_DLG
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $fb: misc. battle effects ]

        array_label AI_CMD, AI_CMD::MISC_AI_EFFECT
@1b6a:  lda     #ACTION_BATTLE_CMD::MISC_AI_EFFECT
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f2: battle change ]

        array_label AI_CMD, AI_CMD::CHANGE_BATTLE
@1b6e:  lda     #ACTION_BATTLE_CMD::CHANGE_BATTLE
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f8: byte-wise variable manipulation ]

        array_label AI_CMD, AI_CMD::CHANGE_VAR
@1b72:  lda     #ACTION_BATTLE_CMD::CHANGE_VAR
        bra     _1b78

; ------------------------------------------------------------------------------

; [ ai script command $f9: bit-wise variable manipulation ]

        array_label AI_CMD, AI_CMD::CHANGE_SWITCH
@1b76:  lda     #ACTION_BATTLE_CMD::CHANGE_SWITCH
_1b78:  xba
        lda     near w7e3a2d
        xba
        longa
        sta     near w7e3a7a
        lda     near w7e3a2e
        sta     zb8
        tyx
        jsr     CreateDefaultAction
        jmp     DoNextAICmd
        .a8

; ------------------------------------------------------------------------------

; [ ai script command $f7: execute battle event ]

        array_label AI_CMD, AI_CMD::BATTLE_EVENT
@1b8e:  tyx
        lda     #ACTION_BATTLE_CMD::BATTLE_EVENT
        sta     near w7e3a7a
        lda     near w7e3a2d
        sta     near w7e3a7b
        jsr     CreateDefaultAction
        jmp     DoNextAICmd

; ------------------------------------------------------------------------------

; [ ai script command $fa: misc. monster animations ]

        array_label AI_CMD, AI_CMD::MONSTER_ANIM
@1ba0:  tyx
        lda     near w7e3a2d
        xba
        lda     #ACTION_BATTLE_CMD::MONSTER_ANIM
        longa
        sta     near w7e3a7a
        lda     near w7e3a2e
        sta     zb8
        jsr     CreateDefaultAction
        jmp     DoNextAICmd

; ------------------------------------------------------------------------------

; [ ai conditional $06: if target's hp is below a value ]

        array_label AI_COND, AI_COND::IF_HP
@1bb7:  jsr     array_item AI_COND, AI_COND::IF_TARGET_VALID
        bcc     @1bc7
        clr_a
        lda     near w7e3a2f
        xba
        longa
        lsr
        cmp     near wTargetProp2::CurrHP,y
@1bc7:  rts
        .a8

; ------------------------------------------------------------------------------

; [ ai conditional $07: if target's mp is below a value ]

        array_label AI_COND, AI_COND::IF_MP
@1bc8:  jsr     array_item AI_COND, AI_COND::IF_TARGET_VALID
        bcc     @1bd6
        clr_a
        lda     near w7e3a2f
        longa
        cmp     near wTargetProp2::CurrMP,y
@1bd6:  rts
        .a8

; ------------------------------------------------------------------------------

; [ ai conditional $08: if target has a status ]

        array_label AI_COND, AI_COND::IF_STATUS_SET
costatus:
@1bd7:  jsr     array_item AI_COND, AI_COND::IF_TARGET_VALID
        bcc     @1c25
        lda     near w7e3a2f
        cmp     #$10
        bcc     @1bee
        longa
        lda     near w7e3a74
        and     $fc
        sta     $fc
        shorta
@1bee:  lda     #$10
        trb     near w7e3a2f
        longa
        bne     @1bfc
        lda     #near wTargetProp3::w7e3ee4
        bra     @1bff
@1bfc:  lda     #near wTargetProp3::w7e3ef8
@1bff:  sta     $fa
        ldx     near w7e3a2f
        jsr     AIGetBit
        sta     $ee
        ldy     #$12
@1c0b:  lda     ($fa),y
        bit     $ee
        bne     @1c16
        lda     near wTargetMask,y
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

        array_label AI_COND, AI_COND::IF_STATUS_CLR
@1c26:  jsr     array_item AI_COND, AI_COND::IF_STATUS_SET
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [ ai conditional $1a: if target is weak against element ]

        array_label AI_COND, AI_COND::IF_WEAK_ELEMENT
@1c2c:  jsr     array_item AI_COND, AI_COND::IF_TARGET_VALID
        bcc     @1c3a
        lda     near wTargetProp2::ElemWeak,y     ; weak elements
        bit     near w7e3a2f
        bne     @1c3a
        clc
@1c3a:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $03: if item was used against monster ]

        array_label AI_COND, AI_COND::IF_ITEM
@1c3b:  tya
        adc     #$13
        tay
; fallthrough

; ------------------------------------------------------------------------------

; [ ai conditional $02: if attack was used against monster ]

        array_label AI_COND, AI_COND::IF_ATTACK
@1c3f:  iny
; fallthrough

; ------------------------------------------------------------------------------

; [ ai conditional $01: if command was used against monster ]

        array_label AI_COND, AI_COND::IF_CMD
@1c40:  tyx
        ldy     near wTargetProp1::RetalCmdTarget,x
        bmi     @1c53
        lda     near wTargetProp2::w7e3d48,x
        cmp     near w7e3a2e
        beq     _1c55
        cmp     near w7e3a2f
        beq     _1c55
@1c53:  clc
        rts
_1c55:  longa
        lda     near wTargetMask,y
        sta     $fc
        sec
        rts
        .a8

; ------------------------------------------------------------------------------

; [ ai conditional $04: if element was used against monster ]

        array_label AI_COND, AI_COND::IF_ELEMENT
@1c5e:  tya
        adc     #21                    ; add 21 to attacker data pointer
        tax
        ldy     near wTargetProp1::RetalElemTarget - 21,x  ; $32a5,x (previous attacker)
        bmi     @1c6f
        lda     near wTargetProp2::w7e3d5d - 21,x  ; (previous element used)
        bit     near w7e3a2e
        bne     _1c55
@1c6f:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $05: if any attack was used against monster ]

        array_label AI_COND, AI_COND::IF_HIT
@1c70:  tyx
        ldy     near wTargetProp1::RetalTarget,x
        bmi     @1c7e
        longa
        lda     near wTargetMask,y
        sta     $fc
        sec
@1c7e:  rts

; ------------------------------------------------------------------------------

; [ if battle timer ]

        array_label AI_COND, AI_COND::IF_BATTLE_TIMER
@1c7f:  longa
        lda     near w7e3a44
        bra     _1c8b

; [ if monster timer ]

        array_label AI_COND, AI_COND::IF_MONSTER_TIMER
@1c86:  longa
        lda     near wTargetProp2::MonsterTimer,y
_1c8b:  lsr
        cmp     near w7e3a2e
        rts
        .a8

; ------------------------------------------------------------------------------

; [  ]

        array_label AI_COND, AI_COND::IF_BATTLE_VAR_GREATER
coflagcc:
@1c90:  ldx     near w7e3a2e
        jsr     GetBattleVar
        lda     $ee
        cmp     near w7e3a2f
        rts

; ------------------------------------------------------------------------------

; [  ]

        array_label AI_COND, AI_COND::IF_BATTLE_VAR_LESS
@1c9c:  jsr     array_item AI_COND, AI_COND::IF_BATTLE_VAR_GREATER
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [  ]

        array_label AI_COND, AI_COND::IF_SWITCH_SET
coflagbit:
@1ca2:  ldx     near w7e3a2f
        jsr     AIGetBit
        ldx     near w7e3a2e
        jsr     GetBattleVar
        bit     $ee
        beq     @1cb3
        sec
@1cb3:  rts

; ------------------------------------------------------------------------------

; [  ]

        array_label AI_COND, AI_COND::IF_SWITCH_CLR
@1cb4:  jsr     array_item AI_COND, AI_COND::IF_SWITCH_SET
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [  ]

        array_label AI_COND, AI_COND::IF_LEVEL_GREATER
colevelcc:
@1cba:  jsr     array_item AI_COND, AI_COND::IF_TARGET_VALID
        bcc     @1cc5
        lda     near wTargetProp2::Level,y
        cmp     near w7e3a2f
@1cc5:  rts

; ------------------------------------------------------------------------------

; [  ]

        array_label AI_COND, AI_COND::IF_LEVEL_LESS
@1cc6:  jsr     array_item AI_COND, AI_COND::IF_LEVEL_GREATER
        jmp     InvertCarry

; ------------------------------------------------------------------------------

; [ ai conditional $10: if only one type of monster remaining ]

        array_label AI_COND, AI_COND::IF_ONE_MONSTER_TYPE
@1ccc:  lda     #1
        cmp     near w7e3eb0 + 26
        rts

; ------------------------------------------------------------------------------

; [ ai conditional $19: continue based on this monster's slot ]

        array_label AI_COND, AI_COND::IF_SELF_IN_SLOT
@1cd2:  lda     near wTargetMask + 1,y
        bit     near w7e3a2e
        beq     @1cdb
        sec
@1cdb:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $11:  ]

        array_label AI_COND, AI_COND::IF_ALIVE
@1cdc:  jsr     GetAITargetMask
        lda     near w7e3a74_H
        bra     _1cef

; ------------------------------------------------------------------------------

; [ ai conditional $12: if target is dead ]

        array_label AI_COND, AI_COND::IF_DEAD
@1ce4:  stz     $f8                     ; allowed if unresponsive
        jsr     GetAITargetMask
        lda     near w7e3a73
        eor     near w7e3a74_H
_1cef:  and     near w7e3a2e
        cmp     near w7e3a2e
        clc
        bne     @1cf9
        sec
@1cf9:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $13: continue based on number of characters/monsters remaining ]

        array_label AI_COND, AI_COND::IF_NUM_TARGETS
@1cfa:  lda     near w7e3a2e
        bne     @1d06       ; branch if comparing number of monsters
        lda     near w7e3a76       ; number of characters alive
        cmp     near w7e3a2f
        rts
@1d06:  lda     near w7e3a2f
        cmp     near w7e3a77       ; number of monsters alive
        rts

; ------------------------------------------------------------------------------

; [ ai conditional $18: if gau is present ]

        array_label AI_COND, AI_COND::IF_GAU_PRESENT
@1d0d:  lda     $1edf
        bit     #>CHAR_FLAG::GAU
        bne     @1d15
        sec
@1d15:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $1b: if the current battle index matches the specified value ]

        array_label AI_COND, AI_COND::IF_BATTLE_ID
@1d16:  longa
        lda     near w7e3a2e
        cmp     $11e0
        beq     @1d21
        clc
@1d21:  rts

; ------------------------------------------------------------------------------

; [ ai conditional $1c: always continue ]

        array_label AI_COND, AI_COND::IF_ALWAYS
@1d22:  stz     $f8                     ; allowed if unresponsive
        sec
        rts

; ------------------------------------------------------------------------------

; [ invert carry flag ]

InvertCarry:
@1d26:  shorta
        rol
        eor     #1
        lsr
; fallthrough

; ------------------------------------------------------------------------------

; [ ai conditional $00: never continue ]

        array_label AI_COND, AI_COND::IF_NEVER
        array_label AI_COND, AI_COND::AI_COND_10
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

        array_label AI_COND, AI_COND::IF_TARGET_VALID
cotarget:
@1d34:  lda     near w7e3a2e
        pha
        sec
        jsr     CheckAITarget
        bcc     @1d49
        longa
        lda     zb8
        sta     $fc
        jsr     BitToTargetID
        shorta_sec
@1d49:  pla
        php
        cmp     #AI_TARGET::SELF
        bne     @1d53
        stz     $fc
        stz     $fc
@1d53:  plp
        rts

; ------------------------------------------------------------------------------

; ai conditional jump table (ai command $fc)
AICondTbl:
        ptr_tbl AI_COND

; ------------------------------------------------------------------------------

; ai script command jump table
AICmdTbl:
        ptr_tbl AI_CMD

; ------------------------------------------------------------------------------

; number of bytes for each ai script command
AICmdSizeTbl:
        .byte   4,2,4,3,4,4,4,2,3,4,4,3,4,1,1,1

; ------------------------------------------------------------------------------

; [ get command for ai attack ]

GetCmdForAI:
@1dbf:  phx
        pha
        xba
        pla
        ldx     #sizeof_AttackForAITbl - 1
@1dc5:  cmp     f:AttackForAITbl,x   ; compare attack index
        bcc     @1dd1
        lda     f:CmdForAITbl,x   ; get command index
        bra     @1dd6
@1dd1:  dex
        bpl     @1dc5
        lda     #BATTLE_CMD::MAGIC
@1dd6:  plx
        rts

; ------------------------------------------------------------------------------

; first attack index for each command
AttackForAITbl:
        .byte   ATTACK::FIRST_GENJU
        .byte   ATTACK::FIRST_NINJA
        .byte   ATTACK::FIRST_BUSHIDO
        .byte   ATTACK::FIRST_BLITZ
        .byte   ATTACK::FIRST_DANCE
        .byte   ATTACK::FIRST_TOOL
        .byte   ATTACK::SHOCK
        .byte   ATTACK::FIRST_MAGITEK
        .byte   ATTACK::FIRST_LORE
        .byte   ATTACK::BATTLE
        .byte   ATTACK::FIRST_DESPERATION
        calc_size AttackForAITbl

; ------------------------------------------------------------------------------

; corresponding command index
CmdForAITbl:
        .byte   BATTLE_CMD::SUMMON
        .byte   BATTLE_CMD::MAGIC
        .byte   BATTLE_CMD::BUSHIDO
        .byte   BATTLE_CMD::BLITZ
        .byte   BATTLE_CMD::MAGIC
        .byte   BATTLE_CMD::TOOLS
        .byte   BATTLE_CMD::SHOCK
        .byte   BATTLE_CMD::MAGITEK
        .byte   BATTLE_CMD::LORE
        .byte   BATTLE_CMD::FIGHT
        .byte   BATTLE_CMD::MAGIC

; ------------------------------------------------------------------------------

; [  ]

GetAITargetMask:
@1dee:  lda     near w7e3a2e
        bne     @1df9
        lda     near wTargetMask + 1,y
        sta     near w7e3a2e
@1df9:  rts

; ------------------------------------------------------------------------------

; [ command $2e: load/add/subtract variable (ai command $f8) ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::CHANGE_VAR
@1dfa:  ldx     zb6         ; variable index
        jsr     GetBattleVar
        lda     #$80
        trb     zb8_L
        bne     @1e0a       ; branch if adding or subtracting
        lsr
        trb     zb8_L         ; clear bit 6 (add)
        stz     $ee         ; set the current value to zero
@1e0a:  lda     zb8_L
        bit     #$40
        beq     @1e13       ; branch if adding
        eor     #$bf
        inc
@1e13:  adc     $ee         ; add/subtract
        sta     $ee
        jmp     _1e38

; ------------------------------------------------------------------------------

; [ command $2f: set/clear variable bit (ai command $f9) ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::CHANGE_SWITCH
@1e1a:  ldx     zb8_H
        jsr     _c21e57
        ldx     zb8_L
        jsr     GetBattleVar
        dec     zb6
        bpl     @1e2c
        eor     $ee
        bra     _1e38
@1e2c:  dec     zb6
        bpl     @1e34
        ora     $ee
        bra     _1e38
@1e34:  not_a
        and     $ee

_elstorework:
_1e38:  cpx     #$24        ; store the battle variable
        bcs     @1e41
        sta     near w7e3eb0,x
        bra     @1e44
@1e41:  sta     near wTargetProp2::MonsterVar,y
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
        lda     near w7e3eb0,x
        bra     @1e52
@1e4f:  lda     near wTargetProp2::MonsterVar,y
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

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::MISC_AI_EFFECT
@1e5e:  lda     zb6
        asl
        tax
        lda     zb8_L
        jmp     (near MiscAIEffectTbl,x)

; ------------------------------------------------------------------------------

; subcommand $00: set monster counter to 0
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::RESET_MONSTER_TIMER
@1e67:  clr_a
        sta     near wTargetProp2::MonsterTimer_L,y
        sta     near wTargetProp2::MonsterTimer_H,y
        rts

; ------------------------------------------------------------------------------

; subcommand $09: end battle and do gau event
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::END_VELDT
@1e6f:  lda     #$0a        ; end of battle special event 5 (gau learns rages)
        bra     _1e75

; ------------------------------------------------------------------------------

; subcommand $02: end battle immediately
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::END_BATTLE
@1e73:  lda     #$08        ; end of battle special event 4 (end battle immediately)
_1e75:  sta     near w7e3a6e
        rts

; ------------------------------------------------------------------------------

; subcommand $01: make target invincible
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::INVINCIBLE_ON
@1e79:  php
        sec
        jsr     CheckAITarget
        longa
        lda     zb8
        tsb     near w7e3a3c
        plp
        rts

; ------------------------------------------------------------------------------

; subcommand $05: make target not invincible
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::INVINCIBLE_OFF
@1e87:  php
        sec
        jsr     CheckAITarget
        longa
        lda     zb8
        trb     near w7e3a3c
        plp
        rts
        .a8

; ------------------------------------------------------------------------------

; subcommand $06: target can be targetted
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::TARGET_ON
@1e95:  sec
        jsr     CheckAITarget
        lda     zb8_H
        tsb     near w7e2f46
        rts

; ------------------------------------------------------------------------------

; subcommand $07: target can't be targetted
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::TARGET_OFF
@1e9f:  sec
        jsr     CheckAITarget
        lda     zb8_H
        trb     near w7e2f46
        rts

; ------------------------------------------------------------------------------

; subcommand $03: add gau to the party
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::RECRUIT_GAU
@1ea9:  lda     #>CHAR_FLAG::GAU
        tsb     $1edf
        lda     near w7e3ed8 + 1,y
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
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::RESET_BATTLE_TIMER
@1ec7:  stz     near w7e3a44_L
        stz     near w7e3a44_H
        rts

; ------------------------------------------------------------------------------

; subcommand $08: fill target's atb gauge (use in a counterattack script to immediately queue the normal script)
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::FILL_ATB
@1ece:  sec
        jsr     CheckAITarget
        bcc     @1ed9       ; branch if no targets are valid
        lda     #$ff
        sta     near wTargetProp2::w7e3ac8_H,y     ; fill this monster's atb gauge
@1ed9:  rts

; ------------------------------------------------------------------------------

; subcommand $0c: clear status
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::CLR_STATUS
@1eda:  jsr     _c21eeb
        lda     #$04
        tsb     $11a4
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; subcommand $0b: set status
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::SET_STATUS
@1ee5:  jsr     _c21eeb
        jmp     ExecSelfAttack

; ------------------------------------------------------------------------------

; [  ]

_c21eeb:
gestatussub:
@1eeb:  jsr     _c2298a
        clc
        lda     zb8_L
        jsr     GetBitPtr
        ora     $11aa,x
        sta     $11aa,x
        tyx
        lda     #BATTLE_CMD::MIMIC
        sta     zb5
        rts

; ------------------------------------------------------------------------------

; subcommand $0d: hide target
        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::HIDE_PIRANHA
@1f00:  lda     near wTargetProp3::w7e3ef9,y
        ora     #STATUS4::HIDE
        sta     near wTargetProp3::w7e3ef9,y

        array_label MISC_AI_EFFECT, MISC_AI_EFFECT::MISC_AI_EFFECT_10
@1f08:  rts

; ------------------------------------------------------------------------------

; command $30 jump table (ai command $fb)
MiscAIEffectTbl:
        ptr_tbl MISC_AI_EFFECT

; ------------------------------------------------------------------------------

; [ check if any targets are valid ]

;     A: target
; carry: set = at least one target is valid, clear = no targets are valid (out)

CheckAITarget:
@1f25:  phx
        phy
        pha
        stz     zb8_L         ; clear character targets
        ldx     #$06
@1f2c:  lda     near w7e3ed8,x     ; actor in character slot
        bmi     @1f36       ; branch if not present
        lda     near wTargetMask,x
        tsb     zb8_L         ; set bit for character
@1f36:  dex2
        bpl     @1f2c
        stz     zb8_H         ; clear monster targets
        ldx     #$0a
@1f3e:  lda     near w7e2001 + 1,x     ; monster flag
        bmi     @1f48       ; branch if not present
        lda     near wTargetMask::_4 + 1,x
        tsb     zb8_H         ; set bit for monster
@1f48:  dex2
        bpl     @1f3e
        bcs     @1f54
        jsr     CheckTargetsPresent
        jsr     _c25917
@1f54:  pla
        cmp     #AI_TARGET::MONSTER_1
        bcs     @1f6d       ; branch if not looking for a specific actor
        ldx     #$06
@1f5b:  cmp     near w7e3ed8,x
        bne     @1f67
        lda     near wTargetMask,x
        sta     zb8_L
        bra     AITarget_43
@1f67:  dex2
        bpl     @1f5b
        bra     AITarget_47
@1f6d:  cmp     #AI_TARGET::SELF
        bcs     @1f81       ; branch if not looking for a particular monster slot

; we know the carry is cleared, so subtract 47 instead of 48.
; this is a very confusing way to save one byte (same as sec then sbc #48)
        sbc     #AI_TARGET::MONSTER_1 - 1
        asl
        tax
        lda     near w7e2001 + 1,x
        bmi     AITarget_47
        lda     near wTargetMask::_4 + 1,x
        sta     zb8_H
        bra     AITarget_38
@1f81:  sbc     #AI_TARGET::SELF
        asl
        tax
        jmp     (near AITargetTbl,x)

; ------------------------------------------------------------------------------

; [  ]

AITarget_44:
@1f88:  stz     zb8_H
_1f8a:  longa
        lda     zb8
        jsr     RandBit
        sta     zb8

AITarget_46:
@1f93:  longa
        lda     zb8
        shorta_sec
        bne     @1f9c       ; branch if there are valid targets
        clc
@1f9c:  ply
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

AITarget_47:
@1f9f:  stz     zb8_L

AITarget_43:
@1fa1:  stz     zb8_H
        bra     AITarget_46

; ------------------------------------------------------------------------------

; target $37: all monsters except self
AITarget_37:
@1fa5:  jsr     RemoveSelfAITarget

; ------------------------------------------------------------------------------

; target $38: all monsters
AITarget_38:
@1fa8:  stz     zb8_L
        bra     AITarget_46

AITarget_39:
@1fac:  jsr     RemoveSelfAITarget

AITarget_3a:
@1faf:  stz     zb8_L
        bra     _1f8a

AITarget_3b:
@1fb3:  jsr     GetDeadAITargets
        bra     AITarget_43

AITarget_3c:
@1fb8:  jsr     GetDeadAITargets
        bra     AITarget_44

AITarget_3d:
@1fbd:  jsr     GetDeadAITargets
        bra     AITarget_38

AITarget_3e:
@1fc2:  jsr     GetDeadAITargets
        bra     AITarget_3a

AITarget_3f:
@1fc7:  jsr     GetReflectAITargets
_1fca:  bra     AITarget_43

AITarget_40:
@1fcc:  jsr     GetReflectAITargets
        bra     AITarget_44

AITarget_41:
@1fd1:  jsr     GetReflectAITargets
        bra     AITarget_38

AITarget_42:
@1fd6:  jsr     GetReflectAITargets
        bra     AITarget_3a

AITarget_4c:
@1fdb:  jsr     RemoveSelfAITarget
        jsr     RandCarry
        bcc     _1f8a
        bra     AITarget_46

AITarget_4d:
@1fe5:  ldx     near wTargetProp1::w7e32f5,y
        bmi     AITarget_47
        lda     #$ff
        sta     near wTargetProp1::w7e32f5,y
        longa
        lda     near wTargetMask,x
        sta     zb8
        jsr     CheckTargetsPresent
        bra     AITarget_46
        .a8

AITarget_45:
@1ffb:  stz     zb8_L
        stz     zb8_H
        lda     near wTargetProp1::w7e32e0,y
        cmp     #$0a
        bcs     AITarget_46             ; branch if not attacked by a character
        asl
        tax
        longa
        lda     near wTargetMask,x
        sta     zb8
        bra     AITarget_46
        .a8

; ------------------------------------------------------------------------------

; [ ai target $48 through $4b: specific character slot ]

AITarget_48:
AITarget_49:
AITarget_4a:
AITarget_4b:
@2011:  txa
        sec
        sbc     #$24
        tax
        lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     AITarget_47       ; branch if $3aa0.0 is clear
        lda     near wTargetMask,x
        sta     zb8_L
        bra     _1fca

; ------------------------------------------------------------------------------

; target $36: self
AddSelfAITarget:
AITarget_36:
@2023:  longa
        lda     near wTargetMask,y
        sta     zb8
        jmp     AITarget_46
        .a8

; ------------------------------------------------------------------------------

; remove self as a target
RemoveSelfAITarget:
@202d:  php
        longa
        lda     near wTargetMask,y
        trb     zb8
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ all sleeping targets ]

GetDeadAITargets:
@2037:  php
        longa
        stz     zb8
        ldx     #$12
@203e:  lda     near wTargetProp3::w7e3ee4 - 1,x  ; STATUS1::DEAD
        bpl     @2048
        lda     near wTargetMask,x
        tsb     zb8
@2048:  dex2
        bpl     @203e
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ all targets with reflect ]

GetReflectAITargets:
@204e:  php
        longa
        stz     zb8
        ldx     #$12
@2055:  lda     near wTargetProp3::w7e3ef8 - 1,x  ; STATUS3::REFLECT
        bpl     @205f
        lda     near wTargetMask,x
        tsb     zb8
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
