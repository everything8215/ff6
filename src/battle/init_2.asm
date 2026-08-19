.import MonsterProp, CondBattle, sizeof_CondBattle

; ------------------------------------------------------------------------------

; [ init monster data ]

; +A: monster index

LoadMonsterProp:
@2c30:  phx
        php
        longai
        sta     near w7e2001 - 8,y     ; set monster index (+$2001)
        sta     near wTargetProp1::w7e33a8,y
        jsr     InitAI
        asl2
        pha
        tax
        lda     f:MonsterItems,x   ; items stolen
        sta     near wTargetProp1::w7e3308,y
        pla
        asl
        pha
        phx
        phy
        tax
        lda     near w7e2001 - 8,y     ; monster index for name display
        sta     near wTargetProp1::w7e3380,y
        clr_ay
@2c56:  lda     f:MonsterName,x   ; monster name
        sta     $f8,y
        inx2
        iny2
        cpy     #8
        bcc     @2c56
        ldy     #$0012
@2c69:  lda     near w7e2001 - 8,y
        bmi     @2c96
        phy
        asl3
        tax
        clr_ay
@2c75:  lda     $f8,y
        cmp     f:MonsterName,x   ; monster name
        clc
        bne     @2c88
        inx2
        iny2
        cpy     #8
        bcc     @2c75
@2c88:  ply
        bcc     @2c96
        lda     1,s
        tax
        lda     near w7e2001 - 8,y
        sta     near wTargetProp1::w7e3380,x
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
        sta     near wTargetProp2::Defense,y
        lda     f:MonsterProp+12,x   ; experience points
        sta     near wTargetProp2::MonsterExp,y
        lda     f:MonsterProp+14,x   ; gold
        sta     near wTargetProp2::MonsterGil,y
        lda     near w7e3a47 - 1
        bmi     @2ce4       ; branch if monsters get returned to full hp/mp ($3a47.7)
        lda     f:MonsterProp+10,x   ; mp
        sta     near wTargetProp2::CurrMP,y
        sta     near wTargetProp2::MaxMP,y
        lda     f:MonsterProp+8,x   ; hp
        sta     near wTargetProp2::CurrHP,y
        sta     near wTargetProp2::MaxHP,y
        lda     near wBattleID
        cmp     #$01cf
        bne     @2ce4       ; branch if not $01cf (doom gaze)
        sty     near wDoomGaze
        lda     near w7e3eb0 + 14       ; get doom gaze's hp
        beq     @2ce4       ; branch if zero
        sta     near wTargetProp2::CurrHP,y     ; set hp
@2ce4:  shorta_sec
        lda     near wTargetProp2::MaxHP_H,y     ; high byte of max hp
        lsr
        cmp     #$19        ; stamina = max hp / 512 + 16 (max 39)
        bcc     @2cf0
        lda     #$17
@2cf0:  adc     #$10
        sta     near wTargetProp2::Stamina,y
        lda     f:MonsterProp+1,x   ; attack power
        sta     near wTargetProp2::RHandAttackPower,y
        lda     f:MonsterProp+26,x   ; attack type (item number for graphics)
        sta     near wTargetProp2::RHandItem,y
        lda     f:MonsterProp+3,x   ; evade %
        jsr     InvertEvade
        sta     near wTargetProp2::Evade,y
        lda     f:MonsterProp+4,x   ; mblock %
        jsr     InvertEvade
        sta     near wTargetProp2::MagicEvade,y
        lda     f:MonsterProp+2,x   ; hit %
        sta     near wTargetProp2::RHandHitRate,y
        lda     f:MonsterProp+16,x   ; level
        sta     near wTargetProp2::Level,y
        lda     f:MonsterProp,x   ; speed
        sta     near wTargetProp2::Speed,y
        lda     f:MonsterProp+7,x   ; mag.pwr
        jsr     AddHalf
        sta     near wTargetProp2::MagicPower,y
        lda     f:MonsterProp+30,x   ; special status 1 (piranha/enemy runic)
        andflg  RETAL_FLAGS, {PIRANHA, MONSTER_RUNIC}
        ora     near wTargetProp2::RetalFlags,y     ; $3e4c.1 and $3e4c.7
        sta     near wTargetProp2::RetalFlags,y
        lda     f:MonsterProp+19,x   ; special status 2
        sta     near wTargetProp2::MonsterStatus,y
        jsr     LoadRageProp
        ldx     near wTargetProp1::w7e33a8,y
        lda     f:MonsterSpecialAnim,x   ; special attack
        sta     near wTargetProp2::MonsterSpecialAnim,y
        shorti
        jsr     InitFirstStrike
        clr_a
        ror
        tsb     zb1
        jsr     Rand
        and     #$07
        clc
        adc     #$38
        sta     near wTargetProp2::Strength,y
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
        lda     f:AIScriptPtrs,x   ; pointer to ai script
        sta     near wTargetProp1::w7e3254,y
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
        sta     near wTargetProp1::w7e3268,y                 ; start of retaliation script
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
        lda     near wTargetProp2::MonsterStatus,x     ; return if monster doesn't have first strike
        bit     #MONSTER_STATUS::FIRST_STRIKE
        beq     @2dc0
        lda     near wTargetProp2::w7e3aa0,x
        bit     #$01
        beq     @2dc0       ; branch if $3aa0.0 is clear (target is not present)
        ora     #$08
        sta     near wTargetProp2::w7e3aa0,x     ; $3aa0.3 stop atb gauge
        stz     near wTargetProp1::w7e3218_H,x     ; fill atb gauge
        lda     #$ff
        sta     near wTargetProp2::w7e3ab4_H,x     ; set advance wait counter to max
        jsr     _c24e66       ; add action to advance wait queue
        sec
@2dc0:  rts

; ------------------------------------------------------------------------------

; [ init monster/rage data ]

LoadRageProp:
@2dc1:  php
        lda     f:MonsterProp+31,x   ; special attack data
        sta     near wTargetProp1::MonsterSpecialProp,y
        lda     f:MonsterProp+25,x   ; weak elements
        ora     near wTargetProp2::ElemWeak,y
        sta     near wTargetProp2::ElemWeak,y
        lda     f:MonsterProp+22,x   ; blocked status 3
        not_a
        and     near wTargetProp1::ImmuneStatus3,y
        sta     near wTargetProp1::ImmuneStatus3,y
        lda     #$ff
        and     near wTargetProp1::ImmuneStatus4,y     ; blocked status 4
        sta     near wTargetProp1::ImmuneStatus4,y
        longa
        lda     f:MonsterProp+27,x   ; status 1 & 2
        sta     near wTargetProp2::w7e3dd4,y
        lda     f:MonsterProp+29,x   ; status 3 & 4
        pha
        and     #STATUS34::FLYING
        lsr
        ror
        ora     1,s

; ignore "character-only" statuses
        clrflg  STATUS34, {DANCE, RAGE, FROZEN, MORPH, CONTROL, HIDE, INTERCEPTOR}
        sta     near wTargetProp2::w7e3de8,y
        pla
        xba
        lsr
        bcc     @2e10
        lda     near wTargetProp2::RelicEffect4,y  ; true knight effect (rage)
        ora     #RELIC_EFFECT4::COVER
        sta     near wTargetProp2::RelicEffect4,y
@2e10:  lda     f:MonsterProp+28,x      ; status 2 & 3
        ora     near wTargetProp2::EquipStatus23,y
        sta     near wTargetProp2::EquipStatus23,y
        lda     f:MonsterProp+20,x      ; blocked status 1 & 2
        not_a
        and     near wTargetProp1::ImmuneStatus1,y
        sta     near wTargetProp1::ImmuneStatus1,y
        lda     f:MonsterProp+23,x      ; absorbed elements
        ora     near wTargetProp2::ElemAbsorb,y
        sta     near wTargetProp2::ElemAbsorb,y
        lda     f:MonsterProp+17,x      ; metamorph info
        sta     near wTargetProp2::MetamorphProp,y
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ choose battle type ]

ChooseBattleType:
@2e3a:  lda     near w7e3a6d       ; relic effects 2 (party)
        lsr2
        lda     near w7e2f48       ; possible battle types
        bcc     @2e50       ; branch if no back guard
        bit     #$b0
        beq     @2e4a
        and     #$b0        ; disable pincer attacks (unless that is the only available option)
@2e4a:  bit     #$d0
        beq     @2e50
        and     #$d0        ; disable back attacks (unless that is the only available option)
@2e50:  pha
        lda     near w7e3a76       ; number of allies that are alive
        cmp     #3
        pla
        bcs     @2e5f       ; branch if 3 or 4
        bit     #$70
        beq     @2e5f
        and     #$70        ; disable side attacks (unless that is the only available option)
@2e5f:  ldx     #$10
        jsr     RandBitWithRate
        stx     near w7e201f       ; set type of battle
        rts

; ------------------------------------------------------------------------------

; [ battle type special effects ]

.enum INIT_BATTLE_TYPE
        COUNT = BATTLE_TYPE::COUNT
.endenum

.proc InitBattleType

@2e68:  ldx     near w7e201f       ; battle type
        cpx     #BATTLE_TYPE::NORMAL
        beq     @2e74       ; branch if normal
        lda     #$01
        trb     $11e4       ; gau can't be obtained
@2e74:  txa
        asl
        tax
        jsr     (near InitBattleTypeTbl,x)
        ldx     #6
@2e7c:  phx
        lda     near wTargetProp2::w7e3aa1,x     ; $3aa1.5 character row
        and     #$20
        pha
        txa
        asl4
        tax
        pla
        sta     near wCharGfxDataBuf::Row,x
        plx
        dex2
        bpl     @2e7c
        rts

.endproc  ; InitBattleType

; ------------------------------------------------------------------------------

; battle type special function jump table
InitBattleTypeTbl:
        ptr_tbl INIT_BATTLE_TYPE

; ------------------------------------------------------------------------------

; normal/side attack
        array_label INIT_BATTLE_TYPE, BATTLE_TYPE::NORMAL
        array_label INIT_BATTLE_TYPE, BATTLE_TYPE::SIDE
@2e9b:  lda     zb1
        bmi     @2ec0       ; return if battle menus are disabled
        lda     near w7e2f4b
        bit     #$04
        bne     @2ec0       ; return if preemptive attacks are disabled
        txa
        asl2
        ora     #$20        ; 1/8 chance to get preemptive strike (7/32 chance for side attack)
        sta     $ee
        lda     near w7e3a6d       ; relic effects 2 (party)
        lsr
        bcc     @2eb5       ; branch if no gale hairpin
        asl     $ee         ; double chance for preemptive attack
@2eb5:  jsr     Rand
        cmp     $ee
        bcs     @2ec0
        lda     #$40        ; set preemptive attack
        tsb     zb0
@2ec0:  rts

; ------------------------------------------------------------------------------

; pincer attack
        array_label INIT_BATTLE_TYPE, BATTLE_TYPE::PINCER
@2ec1:  ldx     #$06
@2ec3:  lda     #$df        ; clear $3aa1.5
        jsr     ClearFlag1       ; put all characters in the front row
        dex2
        bpl     @2ec3
        bra     _2edc

; ------------------------------------------------------------------------------

; back attack
        array_label INIT_BATTLE_TYPE, BATTLE_TYPE::BACK
@2ece:  ldx     #$06
@2ed0:  lda     near wTargetProp2::w7e3aa1,x     ; $3aa1.5 toggle row for all characters
        eor     #$20
        sta     near wTargetProp2::w7e3aa1,x
        dex2
        bpl     @2ed0
_2edc:  lda     #$20
        tsb     zb1         ; set back attack
        rts

; ------------------------------------------------------------------------------

; [ init monsters ]

InitMonsters:
@2ee1:  php
        longi
        lda     near w7e3f44_H
        ldx     #10
        asl2
@2eec:  stz     near wTargetProp2::_4::w7e3aa0,x     ; set monster present flag
        asl
        rol     near wTargetProp2::_4::w7e3aa0,x
        dex2                ; next monster
        bpl     @2eec
        lda     near w7e3f52       ; msb of monster index
        asl2
        sta     $ee
        ldx     #5
        ldy     #$0012
@2f04:  clr_a
        asl     near w7e3a73
        asl     $ee
        rol
        xba
        lda     near w7e3a97       ; colosseum mode
        asl
        lda     near w7e3f46,x     ; monster index
        bcc     @2f1a       ; branch if not in colosseum
        lda     $0206       ; monster number (colosseum)
        bra     @2f1e
@2f1a:  cmp     #$ff
        bne     @2f22       ; branch if monster slot is not empty
@2f1e:  xba
        bne     @2f28       ; branch if monster slot is empty ($01ff)
        xba
@2f22:  jsr     LoadMonsterProp
        inc     near w7e3a73       ; set bit for monster slot
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
        stz     zb8_L
        lda     near w7e3ee0
        bne     @2f75
        ldx     #$0000
@2f3e:  lda     #$ff
        sta     near w7e3ed8 + 1,x
        cmp     near w7e3ed8,x
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
        sta     near w7e3ed8,x
        bra     @2f6c
@2f66:  iny
        cpy     #$000c
        bcc     @2f4b
@2f6c:  inx2
        cpx     #8
        bcc     @2f3e
        bra     @2fd9
@2f75:  ldx     near wBattleID
        cpx     #$023e
        bcc     @2f8c                   ; branch if not a colosseum battle
        lda     $0208
        sta     near w7e3ed8                   ; put colosseum character in slot 1
        lda     #$01
        tsb     zb8_L                     ; make character slot 1 a valid target
        dec     near w7e3a97                   ; enable colosseum mode
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
        sta     near w7e3ed8,x
        ply
@2fad:  dey
        bpl     @2f8f
        lda     $1edf
        bit     #$08
        bne     @2fc3
        lda     near w7e3f46 + 5             ; monster slot 6
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
        sta     near w7e2f4a
        lda     #$80
        tsb     near w7e2f49                   ; enable character ai
@2fd9:  lda     near w7e2f49
        bpl     @304a
        lda     near w7e2f4a                   ; character ai index
        xba
        lda     #$18
        jsr     MultAB
        tax
        lda     f:CharAI,x
        bpl     @2ffa                   ; branch if party is not hidden
        ldy     #6
@2ff1:  lda     #$ff
        sta     near w7e3ed8,y                 ; clear all for actors
        dey2
        bpl     @2ff1
@2ffa:  ldy     #4
@2ffd:  phy
        lda     f:CharAI+4,x            ; actor index
        cmp     #$ff
        beq     @3041                   ; branch if no character ai
        and     #$3f
        ldy     #$0006
@300b:  cmp     near w7e3ed8,y
        beq     @3023                   ; find matching party character
        dey2
        bpl     @300b

; a.i. character not in party
@3014:  iny2
        lda     near w7e3ed8,y                 ; find an empty slot
        inc
        beq     @3023
        cpy     #$0006
        bcc     @3014
        bra     @3041                   ; use slot 4 if no slots are empty

; a.i. character matches a party character
@3023:  lda     near wTargetMask,y
        tsb     zb8_L
        longa
        lda     f:CharAI+4,x            ; character properties and graphics id
        sta     near w7e3ed8,y
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
@304d:  lda     near w7e3ed8,x                 ; loop through each character slot
        cmp     #$ff
        beq     @30d3                   ; skip if empty slot
        asl
        bcs     @305a                   ; skip if not in the party
        inc     near wTargetProp2::w7e3aa0,x                 ; $3aa0.0 set "target present" flag
@305a:  asl
        bcc     @3065
        pha
        lda     near wTargetMask,x
        tsb     near w7e3a40                   ; toggle enemy character flag
        pla
@3065:  lsr2
        sta     near w7e3ed8,x                 ; set actor number
        ldy     #$000f
@306d:  phy
        pha
        lda     $1850,y                 ; get battle row
        and     #$20
        sta     $fe
        jsr     GetCharID
        cmp     1,s
        bne     @30ce
        phx
        pha
        lda     $fe
        sta     near wTargetProp2::w7e3aa1,x                 ; $3aa1.5 character row (other flags are cleared)
        lda     near w7e3ed8 + 1,x                 ;
        pha
        lda     6,s
        sta     near w7e3ed8 + 1,x
        clr_a
        txa
        asl4
        tax
        pla
        cmp     #$ff
        bne     @309c
        lda     $1601,y                 ; set character graphic index
@309c:  sta     near wCharGfxDataBuf::GfxID,x
        clr_a
        pla
        sta     near wCharGfxDataBuf::CharID,x                 ; set actor index
        cmp     #$0e
        longa
        pha
        lda     $1602,y                 ; copy character name
        sta     near wCharGfxDataBuf::Name,x
        lda     $1604,y
        sta     near wCharGfxDataBuf::Name + 2,x
        lda     $1606,y
        sta     near wCharGfxDataBuf::Name + 4,x
        plx
        bcs     @30c4                   ; branch if actor index >= $0e
        clr_a
        sec
@30c0:  rol
        dex
        bpl     @30c0
@30c4:  plx
        sta     near w7e3a20,x                 ; set actor mask
        tya
        sta     near w7e3010,x                 ; pointer to character data
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
        lda     near w7e3eb0 + 9       ; conditional battle flags
        sta     $ee
        ldx     #sizeof_CondBattle - 4
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
@3127:  lda     near wBattleID
        asl
        lda     $11e0
        bcc     @3133
        sta     near wBattleID
@3133:  asl2
        tax
        lda     f:BattleProp+2,x   ; load auxiliary battle data
        sta     near w7e2f4a
        lda     f:BattleProp,x
        eor     #$00f0      ; toggle battle type flags
        sta     near w7e2f48
        lda     $11e0
        asl4
        sec
        sbc     $11e0
        tax
        clr_ay
@3155:  lda     f:BattleMonsters,x   ; load battle data
        sta     near wBattleMonsters,y
        inx2
        iny2
        cpy     #$0010
        bcc     @3155
        plp
        .a8
        rts

.pushseg

; ------------------------------------------------------------------------------

.export BattleMonsters

.segment "battle_prop"

; cf/5900
BattleProp:
        .incbin "assets/data/battle/battle_prop.bin"

; cf/6200
BattleMonsters:
        fixed_block $2200
        .incbin "assets/data/battle/battle_monsters.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

.popseg
