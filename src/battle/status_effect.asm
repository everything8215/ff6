; ------------------------------------------------------------------------------

.enum SET_STATUS
        COUNT = STATUS_ID::COUNT
.endenum

.enum REMOVE_STATUS
        COUNT = STATUS_ID::COUNT
.endenum

; ------------------------------------------------------------------------------

; [ update status ]

UpdateStatus:
@4391:  phx
        php
        longa
        ldy     #$12
@4397:  lda     near wTargetProp2::w7e3aa0,y     ; $3aa0.0 skip if target is not present
        lsr
        bcc     @43ff
        jsr     InitStatusVars
        lda     $fc         ; +$fc = status 1/2 to set
        beq     @43b3
        sta     $f0
        ldx     #$1e
@43a8:  asl     $f0
        bcc     @43af
        jsr     (near SetStatusTbl,x)   ; status 1/2 to set
@43af:  dex2
        bpl     @43a8
@43b3:  lda     $fe         ; +$fe = status 3/4 to set
        beq     @43c6
        sta     $f0
        ldx     #$1e
@43bb:  asl     $f0
        bcc     @43c2
        jsr     (near SetStatusTbl + 32,x)   ; status 3/4 to set
@43c2:  dex2
        bpl     @43bb
@43c6:  lda     $f4         ; +$f4 = status 1/2 to clear
        and     near wTargetProp1::ImmuneStatus1,y
        sta     $f4
        beq     @43de
        sta     $f0
        ldx     #$1e
@43d3:  asl     $f0
        bcc     @43da
        jsr     (near RemoveStatusTbl,x)   ; status 1/2 to clear
@43da:  dex2
        bpl     @43d3
@43de:  lda     $f6         ; +$f6 = status 3/4 to clear
        and     near wTargetProp1::ImmuneStatus3,y
        sta     $f6
        beq     @43f6
        sta     $f0
        ldx     #$1e
@43eb:  asl     $f0
        bcc     @43f2
        jsr     (near RemoveStatusTbl+$20,x)   ; status 3/4 to clear
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
        lda     near wTargetProp3::w7e3ee4,y
        sta     $f8
        lda     near wTargetProp3::w7e3ef8,y
        sta     $fa
        jsr     EquipStatusMod
        shorta
        lda     zb3
        bmi     @4420
        lda     #STATUS1::VANISH
        trb     $f4
@4420:  lda     near wTargetProp2::MonsterFlags,y  ; MONSTER_FLAG::UNDEAD
        bpl     @443d
        lda     #$08
        bit     $11a2
        beq     @443d
        lsr
        bit     $11a4
        beq     @443d
        lda     $11aa
        bitflg  STATUS1, {DEAD, ZOMBIE}
        beq     @443d
        lda     #STATUS1::DEAD
        tsb     $fc
@443d:  longa
        lda     $fc
        jsr     SetStatus1
        lda     $fe
        ora     near wTargetProp2::w7e3de8,y
        sta     near wTargetProp2::w7e3de8,y
        lda     $f4
        ora     near wTargetProp2::w7e3dfc,y
        sta     near wTargetProp2::w7e3dfc,y
        lda     $f6
        ora     near wTargetProp2::w7e3e10,y
        sta     near wTargetProp2::w7e3e10,y
        lda     $11a7
        lsr
        bcc     @447d
        lda     $fc
        ora     $f4
        and     near wTargetProp1::ImmuneStatus1,y
        bne     @447d
        lda     $fe
        ora     $f6
        and     near wTargetProp1::ImmuneStatus3,y
        bne     @447d
        lda     near wTargetMask,y
        sta     near w7e3a48
        tsb     near w7e3a5a
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

EquipStatusMod:
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
        jsr     (near StatusModTbl,x)

; remove invisible status if hit by a physical attack
        lda     $11a2
        lsr
        bcs     @44bb
        lda     #STATUS12::VANISH
        bit     $f8
        beq     @44bb
        bit     $11aa
        bne     @44bb
        tsb     $f4

; remove frozen status if hit by a fire-elemental attack
@44bb:  lda     $11a1
        lsr
        bcc     @44cf
        lda     #STATUS34::FROZEN
        bit     $fa
        beq     @44cf
        bit     $11ac
        bne     @44cf
        tsb     $f6
@44cf:  plx
        rts

; ------------------------------------------------------------------------------

.enum STATUS_MOD
        SET_STATUS
        REMOVE_STATUS
        TOGGLE_STATUS

        COUNT
.endenum

; status effect jump table
StatusModTbl:
        ptr_tbl STATUS_MOD

; ------------------------------------------------------------------------------

; 0: set status
        array_label STATUS_MOD, STATUS_MOD::SET_STATUS
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
        array_label STATUS_MOD, STATUS_MOD::REMOVE_STATUS
@44ea:  lda     $11aa
        and     $f8
        sta     $f4
        lda     $11ac
        and     $fa
        sta     $f6
        rts

; ------------------------------------------------------------------------------

; 2: toggle status
        array_label STATUS_MOD, STATUS_MOD::TOGGLE_STATUS
@44f9:  jsr     array_item STATUS_MOD, STATUS_MOD::SET_STATUS
        jmp     array_item STATUS_MOD, STATUS_MOD::REMOVE_STATUS

; ------------------------------------------------------------------------------

; [ reset status mod flags ]

ResetStatusMod:
@44ff:  clr_a
        sta     near wTargetProp2::w7e3dd4,y
        sta     near wTargetProp2::w7e3de8,y
        sta     near wTargetProp2::w7e3dfc,y
        sta     near wTargetProp2::w7e3e10,y
        rts

; ------------------------------------------------------------------------------

; [ init status variables ]

InitStatusVars:
; magicstatus_sub:
@450d:  lda     near wTargetProp2::w7e3dfc,y     ; status 1/2 to clear
        sta     $f4
        lda     near wTargetProp2::w7e3e10,y     ; status 3/4 to clear
        sta     $f6
        lda     near wTargetProp2::w7e3dd4,y     ; status 1/2 to set
        and     near wTargetProp1::ImmuneStatus1,y     ; blocked status 1/2
        sta     $fc
        lda     near wTargetProp2::w7e3de8,y     ; status 3/4 to set
        and     near wTargetProp1::ImmuneStatus3,y     ; blocked status 3/4
        sta     $fe
        lda     near wTargetProp3::w7e3ee4,y     ; current status 1/2
        sta     $f8
        and     #STATUS12::PETRIFY
        tsb     $fc         ; set in status to set
        lda     near wTargetProp3::w7e3ef8,y     ; current status 3/4
        sta     $fa
        lda     near wTargetProp2::MaxHP,y     ; max hp / 8
        lsr3
        cmp     near wTargetProp2::CurrHP,y     ; current hp
        lda     #STATUS12::NEAR_FATAL
        bit     $f8         ; branch if character is already near fatal
        bne     @454a
        bcc     @454e
        tsb     $fc         ; add near fatal in status to set
@454a:  bcs     @454e
        tsb     $f4         ; otherwise, add near fatal in status to clear
@454e:  lda     $fb         ; branch if wound is not in status to set ???
        bpl     @4566
        lda     near wTargetProp2::ExtraStatus,y     ; branch if overcast flag is not set ($3e4d.1)
        and     #STATUS1::ZOMBIE
        beq     @4566
        ora     $fc         ; add zombie in status to set
        and     #near ~STATUS12::DEAD
        sta     $fc
        lda     #STATUS12::CONDEMNED
        tsb     $f4
@4566:  lda     near wTargetProp1::w7e32e0 - 1,y     ;
        bpl     @4584
        lda     $fc
        pha
        lda     $fe
        pha
        jsr     CalcStatus
        lda     $fc
        sta     near wTargetProp2::RetalStatus12,y
        lda     $fe
        sta     near wTargetProp2::RetalStatus34,y
        pla
        sta     $fe
        pla
        sta     $fc
@4584:  rts

; ------------------------------------------------------------------------------

; [  ]

_c24585:
; magicstatus_sub2:
@4585:  lda     $fc
        bit     #STATUS12::ZOMBIE
        beq     @458f
        clrflg  STATUS12, {BLIND, POISON, NEAR_FATAL, SLEEP, CONFUSE, BERSERK}
@458f:  sta     near wTargetProp3::w7e3ee4,y
        lda     $fe
        sta     near wTargetProp3::w7e3ef8,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c24598:
; setrstatus0:
@4598:  pha
        lda     $f8
        ora     $fc
        and     1,s
        tsb     $f4         ; status to clear
        pla
        rts

; ------------------------------------------------------------------------------

; [ zombie set ]

        array_label SET_STATUS, STATUS_ID::ZOMBIE
@45a3:  lda     #STATUS12::DEAD
        jsr     _c24598
        jsr     _c246a9       ; set character/monster dead flag
        bra     _45c1

; ------------------------------------------------------------------------------

; [ zombie clear ]

        array_label REMOVE_STATUS, STATUS_ID::ZOMBIE
@45ae:  jsr     _c2469c
        bra     _45c1

; ------------------------------------------------------------------------------

; [ muddled set ]

        array_label SET_STATUS, STATUS_ID::CONFUSE
@45b3:  lda     near wTargetMask,y
        tsb     near w7e2f53
        bra     _45c1

; ------------------------------------------------------------------------------

; [ muddled clear ]

        array_label REMOVE_STATUS, STATUS_ID::CONFUSE
@45bb:  lda     near wTargetMask,y
        trb     near w7e2f53
_45c1:  phx
        ldx     near wTargetMask,y     ; character/monster flag
        txa
        tsb     near w7e3a4a       ; characters/monsters with changed status
        plx
        rts

; ------------------------------------------------------------------------------

; [ clear set ]

        array_label SET_STATUS, STATUS_ID::VANISH
@45cb:  phx
        ldx     near wTargetMask + 1,y
        txa
        tsb     near w7e2f44       ; monsters with clear status (graphics)
        plx
        rts

; ------------------------------------------------------------------------------

; [ remove clear status ]

        array_label REMOVE_STATUS, STATUS_ID::VANISH
@45d5:  phx
        ldx     near wTargetMask + 1,y
        txa
        trb     near w7e2f44       ; monsters with clear status (graphics)
        plx
        rts

; ------------------------------------------------------------------------------

; [ imp set/clear ]

        array_label SET_STATUS, STATUS_ID::IMP
        array_label REMOVE_STATUS, STATUS_ID::IMP
@45df:  lda     #$0088      ; update enabled spells/espers and enabled commands
        jsr     SetCharFlag
; fall through

; ------------------------------------------------------------------------------

; [ rage clear ]

        array_label REMOVE_STATUS, STATUS_ID::RAGE
@45e5:  cpy     #$08
        bcs     @45f1       ; return if a monster
        phx
        tya
        lsr
        tax
        inc     near w7e2f30,x     ; set equipment change flag
        plx
@45f1:  rts

; ------------------------------------------------------------------------------

; [ petrify/wound clear ]

        array_label REMOVE_STATUS, STATUS_ID::PETRIFY
        array_label REMOVE_STATUS, STATUS_ID::DEAD
@45f2:  jsr     _c2469c
        lda     #$4000
        jsr     _c24656
        lda     #$0040      ; remove all advance wait actions
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ wound set ]

        array_label SET_STATUS, STATUS_ID::DEAD
@4600:  ldaflg  STATUS12, {PETRIFY, CONDEMNED}      ; clear petrify/condemned
        jsr     _c24598
        lda     #STATUS12::DEAD      ; don't clear wound
        trb     $f4
; fall through

; ------------------------------------------------------------------------------

; [ petrify set ]

        array_label SET_STATUS, STATUS_ID::PETRIFY
@460b:  jsr     _c246a9       ; set character/monster dead flag
        ldaflg  STATUS12, {BLIND, POISON, VANISH, NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        jsr     _c24598
        lda     $fa
        ora     $fe
        clrflg  STATUS34, {RERAISE, HIDE, INTERCEPTOR}
        tsb     $f6
        lda     near wTargetProp2::ExtraStatus - 1,y     ; clear $3e4d.6 (phantasm status)
        and     #near ~STATUS12::SAP
        sta     near wTargetProp2::ExtraStatus - 1,y
_4626:  lda     near wTargetProp2::w7e3aa0,y     ; clear $3aa0.7 (battle menu can't open)
        and     #$ff7f
        sta     near wTargetProp2::w7e3aa0,y
        lda     #$0040      ;
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ psyche set ]

        array_label SET_STATUS, STATUS_ID::SLEEP
@4634:  php
        shorta
        lda     #18
        sta     near wTargetProp2::SleepCounter,y
        plp
        .a16
        bra     _4626       ;

; ------------------------------------------------------------------------------

; [ condemned set ]

        array_label SET_STATUS, STATUS_ID::CONDEMNED
@463f:  lda     #$0020      ; set condemned counter
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ condemned clear ]

        array_label REMOVE_STATUS, STATUS_ID::CONDEMNED
@4644:  lda     #$0010      ; clear condemned counter
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ mute set/clear ]

        array_label SET_STATUS, STATUS_ID::SILENCE
        array_label REMOVE_STATUS, STATUS_ID::SILENCE
@4649:  lda     #$0008      ; update enabled commands
; fall through

; ------------------------------------------------------------------------------

; [ set character update flag(s) ]

SetCharFlag:
@464c:  ora     near wTargetProp1::w7e3204,y
        sta     near wTargetProp1::w7e3204,y
        rts

; ------------------------------------------------------------------------------

; [ psyche clear ]

        array_label REMOVE_STATUS, STATUS_ID::SLEEP
@4653:  lda     #$4000      ; set $3aa1.6 pending psyche action

_c24656:
@4656:  ora     near wTargetProp2::w7e3aa0,y
        sta     near wTargetProp2::w7e3aa0,y
        rts

; ------------------------------------------------------------------------------

; [ seizure set ]

        array_label SET_STATUS, STATUS_ID::SAP
@465d:  lda     #STATUS34::REGEN
        tsb     $f6
        rts

; ------------------------------------------------------------------------------

; [ regen set ]

        array_label SET_STATUS, STATUS_ID::REGEN
@4663:  lda     #STATUS12::SAP
        tsb     $f4
        rts

; ------------------------------------------------------------------------------

; [ slow set ]

        array_label SET_STATUS, STATUS_ID::SLOW
@4669:  lda     #$0008
        bra     _4671

; ------------------------------------------------------------------------------

; [ haste set ]

        array_label SET_STATUS, STATUS_ID::HASTE
@466e:  lda     #STATUS34::SLOW
_4671:  tsb     $f6
; fall through

; ------------------------------------------------------------------------------

; [ slow/haste cleared ]

        array_label REMOVE_STATUS, STATUS_ID::SLOW
        array_label REMOVE_STATUS, STATUS_ID::HASTE
@4673:  lda     #$0004      ; update atb gauge constant
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ morph/revert set/clear ]

        array_label SET_STATUS, STATUS_ID::MORPH
        array_label REMOVE_STATUS, STATUS_ID::MORPH
@4678:  lda     #$0002      ; update character after morph/revert
        bra     SetCharFlag

; ------------------------------------------------------------------------------

; [ stop set ]

        array_label SET_STATUS, STATUS_ID::STOP
@467d:  php
        shorta
        lda     #$12
        sta     near wTargetProp2::w7e3af1,y
        plp
        rts

; ------------------------------------------------------------------------------

; [ reflect set ]

        array_label SET_STATUS, STATUS_ID::REFLECT
@4687:  php
        shorta
        lda     #26        ; set reflect counter to 26
        sta     near wTargetProp3::ReflectCounter,y
        plp
        rts

; ------------------------------------------------------------------------------

; [ frozen set ]

        array_label SET_STATUS, STATUS_ID::FROZEN
@4691:  php
        shorta
        lda     #34
        sta     near wTargetProp3::FreezeCounter,y
        plp
        rts

; ------------------------------------------------------------------------------

; [ status set/clear: no effect ]

        array_label SET_STATUS, STATUS_ID::BLIND
        array_label SET_STATUS, STATUS_ID::POISON
        array_label SET_STATUS, STATUS_ID::MAGITEK
        array_label SET_STATUS, STATUS_ID::NEAR_FATAL
        array_label SET_STATUS, STATUS_ID::IMAGE
        array_label SET_STATUS, STATUS_ID::BERSERK
        array_label SET_STATUS, STATUS_ID::DANCE
        array_label SET_STATUS, STATUS_ID::SHELL
        array_label SET_STATUS, STATUS_ID::SAFE
        array_label SET_STATUS, STATUS_ID::RAGE
        array_label SET_STATUS, STATUS_ID::RERAISE
        array_label SET_STATUS, STATUS_ID::CONTROL
        array_label SET_STATUS, STATUS_ID::HIDE
        array_label SET_STATUS, STATUS_ID::INTERCEPTOR
        array_label SET_STATUS, STATUS_ID::FLOAT

        array_label REMOVE_STATUS, STATUS_ID::BLIND
        array_label REMOVE_STATUS, STATUS_ID::POISON
        array_label REMOVE_STATUS, STATUS_ID::MAGITEK
        array_label REMOVE_STATUS, STATUS_ID::NEAR_FATAL
        array_label REMOVE_STATUS, STATUS_ID::IMAGE
        array_label REMOVE_STATUS, STATUS_ID::BERSERK
        array_label REMOVE_STATUS, STATUS_ID::SAP
        array_label REMOVE_STATUS, STATUS_ID::DANCE
        array_label REMOVE_STATUS, STATUS_ID::REGEN
        array_label REMOVE_STATUS, STATUS_ID::STOP
        array_label REMOVE_STATUS, STATUS_ID::SHELL
        array_label REMOVE_STATUS, STATUS_ID::SAFE
        array_label REMOVE_STATUS, STATUS_ID::REFLECT
        array_label REMOVE_STATUS, STATUS_ID::FROZEN
        array_label REMOVE_STATUS, STATUS_ID::RERAISE
        array_label REMOVE_STATUS, STATUS_ID::CONTROL
        array_label REMOVE_STATUS, STATUS_ID::HIDE
        array_label REMOVE_STATUS, STATUS_ID::INTERCEPTOR
        array_label REMOVE_STATUS, STATUS_ID::FLOAT

; SetStatusNoEffect:
; RemoveStatusNoEffect:
@469b:  rts

; ------------------------------------------------------------------------------

; [ revive monster ]

_c2469c:
removeerase:
@469c:  phx
        ldx     near wTargetMask + 1,y     ; monster flag
        txa
        tsb     near w7e2f2f       ; monsters that are not dead
        trb     near w7e3a3a       ; monsters that have died
        plx
        rts

; ------------------------------------------------------------------------------

; [ set character/monster dead flag ]

_c246a9:
setnowdead:
@46a9:  lda     near wTargetMask,y     ; character/monster mask
        tsb     near w7e3a56       ; characters/monsters that have died
        rts

; ------------------------------------------------------------------------------

; set status jump table
SetStatusTbl:
        ptr_tbl SET_STATUS

; remove status jump table
RemoveStatusTbl:
        ptr_tbl REMOVE_STATUS

; ------------------------------------------------------------------------------
